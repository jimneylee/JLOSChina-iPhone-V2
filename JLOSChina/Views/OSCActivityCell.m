//
//  SMTrendCell.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-8-15.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCActivityCell.h"
#import "OSCActivityEntity.h"
#import "NimbusNetworkImage.h"
#import "NIAttributedLabel.h"
#import "NIWebController.h"
#import "UIView+findViewController.h"
#import "UIImage+nimbusImageNamed.h"
#import "OSCTweetEntity.h"
#import "RCKeywordEntity.h"
#import "JLFullScreenPhotoBrowseView.h"
#import "OSCCommonRepliesListC.h"
#import "OSCTweetC.h"
#import "OSCUserHomeC.h"
#import "OSCTweetBodyView.h"

// 布局字体
#define TITLE_FONT_SIZE [UIFont systemFontOfSize:14.f]
#define SUBTITLE_FONT_SIZE [UIFont systemFontOfSize:11.f]
#define BUTTON_FONT_SIZE [UIFont systemFontOfSize:13.f]

// 本微博：字体 行高 文本色设置
#define CONTENT_FONT_SIZE [UIFont fontWithName:@"STHeitiSC-Light" size:16.f]
#define CONTENT_LINE_HEIGHT 22.f
#define CONTENT_TEXT_COLOR RGBCOLOR(30, 30, 30)

// 布局固定参数值
#define HEAD_IAMGE_HEIGHT 34
#define CONTENT_IMAGE_HEIGHT 160
#define BUTTON_SIZE CGSizeMake(65.f, 25.f)

@interface OSCActivityCell()<NIAttributedLabelDelegate>
// data entity
@property (nonatomic, strong) OSCActivityEntity* tweetEntity;
// content
@property (nonatomic, strong) NINetworkImageView* headView;
@property (nonatomic, strong) NIAttributedLabel* contentLabel;
@property (nonatomic, strong) NINetworkImageView* contentImageView;
// action buttons
@property (nonatomic, strong) UIButton* commentBtn;
@end

@implementation OSCActivityCell

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)addAllLinksForAtSomeoneInContentLabel:(NIAttributedLabel*)contentLabel
                                   withStatus:(OSCActivityEntity*)o
                                 fromLocation:(NSInteger)location
{
    RCKeywordEntity* keyworkEntity = nil;
    NSString* url = nil;
    if (o.atPersonRanges.count) {
        for (int i = 0; i < o.atPersonRanges.count; i++) {
            keyworkEntity = (RCKeywordEntity*)o.atPersonRanges[i];
            url =[NSString stringWithFormat:@"%@%@", PROTOCOL_AT_SOMEONE, [keyworkEntity.keyword urlEncoded]];
            [contentLabel addLink:[NSURL URLWithString:url]
                            range:NSMakeRange(keyworkEntity.range.location + location, keyworkEntity.range.length)];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)addAllLinksForSharpSoftwareInContentLabel:(NIAttributedLabel*)contentLabel
                                       withStatus:(OSCActivityEntity*)o
                                     fromLocation:(NSInteger)location
{
    RCKeywordEntity* keyworkEntity = nil;
    NSString* url = nil;
    if (o.sharpSoftwareRanges.count) {
        for (int i = 0; i < o.sharpSoftwareRanges.count; i++) {
            keyworkEntity = (RCKeywordEntity*)o.sharpSoftwareRanges[i];
            url =[NSString stringWithFormat:@"%@%@", PROTOCOL_SHARP_SOFTWARE, [keyworkEntity.keyword urlEncoded]];
            [contentLabel addLink:[NSURL URLWithString:url]
                            range:NSMakeRange(keyworkEntity.range.location + location, keyworkEntity.range.length)];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)insertAllEmotionsInContentLabel:(NIAttributedLabel*)contentLabel
                             withStatus:(OSCActivityEntity*)o
{
    RCKeywordEntity* keyworkEntity = nil;
    if (o.emotionRanges.count) {
        NSString* emotionImageName = nil;
        NSData *imageData = nil;
        
        // replace emotion from nail to head, so range's location is right. it's very important, good idea!
        for (NSInteger i = o.emotionRanges.count - 1; i >= 0; i--) {
            keyworkEntity = (RCKeywordEntity*)o.emotionRanges[i];
            if (i < o.emotionImageNames.count) {
                emotionImageName = o.emotionImageNames[i];
                if (emotionImageName.length) {
                    imageData = UIImagePNGRepresentation([UIImage imageNamed:emotionImageName]);
                    [contentLabel insertImage:[UIImage imageWithData:imageData scale:2.5f]
                                      atIndex:keyworkEntity.range.location];
                }
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)attributeHeightForEntity:(OSCActivityEntity*)o withWidth:(CGFloat)width
{
    // only alloc one time,reuse it, optimize best
    static NIAttributedLabel* contentLabel = nil;
    
    if (!contentLabel) {
        contentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.font = CONTENT_FONT_SIZE;
        contentLabel.lineHeight = CONTENT_LINE_HEIGHT;
        contentLabel.width = width;
    }
    else {
        // reuse contentLabel and reset frame, it's great idea from my mind
        contentLabel.frame = CGRectZero;
        contentLabel.width = width;
    }
    
    contentLabel.text = o.objectContent;
    [OSCActivityCell insertAllEmotionsInContentLabel:contentLabel withStatus:o];
    //[contentLabel sizeToFit];
    CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    if (contentSize.height < CONTENT_LINE_HEIGHT) {
        contentSize.height = CONTENT_LINE_HEIGHT;
    }
    return contentSize.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[OSCActivityEntity class]]) {
        CGFloat cellMargin = CELL_PADDING_4;
        CGFloat contentViewMarin = CELL_PADDING_6;
        CGFloat sideMargin = cellMargin + contentViewMarin;
        
        CGFloat height = sideMargin;
        
        // head image
        height = height + HEAD_IAMGE_HEIGHT;
        height = height + CELL_PADDING_4;
        
        // content
        OSCActivityEntity* o = (OSCActivityEntity*)object;
        CGFloat kContentLength = tableView.width - sideMargin * 2;
        
#if 0// sizeWithFont
        CGSize contentSize = [o.text sizeWithFont:CONTENT_FONT_SIZE
                                constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        height = height + contentSize.height;
#else// sizeToFit
        height = height + [self attributeHeightForEntity:o withWidth:kContentLength];
#endif
        
        // content image
        if (o.tweetImageUrl.length) {
            height = height + CELL_PADDING_10;
            height = height + CONTENT_IMAGE_HEIGHT;
        }
        
        // from date
        height = height + CELL_PADDING_10;
        height = height + SUBTITLE_FONT_SIZE.lineHeight;

        height = height + sideMargin;
        
        return height;
    }
    
    return 0.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // head image
        self.headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT,
                                                                             HEAD_IAMGE_HEIGHT)];
        [self.contentView addSubview:self.headView];
        
        // name
        self.textLabel.font = TITLE_FONT_SIZE;
        self.textLabel.numberOfLines = 2;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        
        // source from & date
        self.detailTextLabel.font = SUBTITLE_FONT_SIZE;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        
        // status content
        self.contentLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = CONTENT_FONT_SIZE;
        self.contentLabel.lineHeight = CONTENT_LINE_HEIGHT;
        self.contentLabel.textColor = CONTENT_TEXT_COLOR;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLabel.autoDetectLinks = YES;
        self.contentLabel.delegate = self;
        self.contentLabel.attributesForLinks =@{(NSString *)kCTForegroundColorAttributeName:(id)APP_THEME_BLUE_COLOR.CGColor};
        self.contentLabel.highlightedLinkBackgroundColor = APP_THEME_BLUE_COLOR;
        [self.contentView addSubview:self.contentLabel];
        
        // content image
        self.contentImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                     CONTENT_IMAGE_HEIGHT,
                                                                                     CONTENT_IMAGE_HEIGHT)];
        [self.contentView addSubview:self.contentImageView];
        
        // content image gesture
        self.contentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapContentImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(showContentOriginImage)];
        [self.contentImageView addGestureRecognizer:tapContentImageGesture];
        
        // border style
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        // bg color
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = CELL_CONTENT_VIEW_BG_COLOR;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (self.headView.image) {
        [self.headView setImage:nil];
    }
    if (self.contentImageView.image) {
        [self.contentImageView setImage:nil];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IOS_IS_AT_LEAST_7) {
    }
    else {
        // set here compatible with ios6.x
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    
    // layout
    CGFloat cellMargin = CELL_PADDING_4;
    CGFloat contentViewMarin = CELL_PADDING_6;
    CGFloat sideMargin = cellMargin + contentViewMarin;
    
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2,
                                        self.height - cellMargin * 2);
    
    
    self.headView.left = contentViewMarin;
    self.headView.top = contentViewMarin;
    
    // name
    self.textLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_10, self.headView.top,
                                      self.width - sideMargin * 2 - (self.headView.right + CELL_PADDING_10),
                                      TITLE_FONT_SIZE.lineHeight * 2);
    
    // source from & date
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom,
                                            self.width - sideMargin * 2 - self.textLabel.left,
                                            self.detailTextLabel.font.lineHeight);
    
    // status content
    CGFloat kContentLength = self.contentView.width - contentViewMarin * 2;
    self.contentLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_4,
                                         kContentLength, 0.f);
    [self.contentLabel sizeToFit];
    
#if 0// close debug log
    CGSize contentSize = [self.contentLabel.text sizeWithFont:CONTENT_FONT_SIZE
                                            constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                                lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"sizeWithFont height = %f", contentSize.height);
    NSLog(@"sizeToFit height    = %f", self.contentLabel.height);
#endif
    
    // content image
    self.contentImageView.left = self.contentLabel.left;
    self.contentImageView.top = self.contentLabel.bottom + CELL_PADDING_10;
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    // layout buttons
    self.commentBtn.right = self.contentView.width;// - contentViewMarin * 2;
    self.commentBtn.bottom = self.height - sideMargin;//contentViewMarin * 2;
    
    self.detailTextLabel.left = self.contentLabel.left;
    self.detailTextLabel.bottom = self.height - sideMargin - CELL_PADDING_6;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[OSCActivityEntity class]]) {
        OSCActivityEntity* o = (OSCActivityEntity*)object;

        self.tweetEntity = o;
        if (o.user.avatarUrl.length) {
            [self.headView setPathToNetworkImage:o.user.avatarUrl];
        }
        else {
            [self.headView setPathToNetworkImage:nil];
        }
        
        //self.textLabel.text = o.fullTitle;//o.user.authorName;
        self.textLabel.attributedText = o.fullTitleAttributedString;
        
        self.detailTextLabel.text = [NSString stringWithFormat:@"%@   来自 %@",
                                     [o.pubDate formatRelativeTime], o.appClientName];// 解决动态计算时间
        if (o.commentCount > 0) {
            [self.commentBtn setTitle:[NSString stringWithFormat:@"%@回复", o.commentCount]
                             forState:UIControlStateNormal];
        }
        else {
            [self.commentBtn setTitle:[NSString stringWithFormat:@"回复"]
                             forState:UIControlStateNormal];
        }
        
        self.contentLabel.text = o.objectContent;
        
        [OSCActivityCell addAllLinksForAtSomeoneInContentLabel:self.contentLabel withStatus:o fromLocation:0];
        [OSCActivityCell addAllLinksForSharpSoftwareInContentLabel:self.contentLabel withStatus:object fromLocation:0];
        [OSCActivityCell insertAllEmotionsInContentLabel:self.contentLabel withStatus:o];
        
        if (o.tweetImageUrl.length) {
            self.contentImageView.hidden = NO;
            self.contentImageView.scaleOptions |= NINetworkImageViewScaleToFitCropsExcess;
            [self.contentImageView setPathToNetworkImage:o.tweetImageUrl contentMode:UIViewContentModeScaleAspectFit];
            self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else {
            self.contentImageView.hidden = YES;
            [self.contentImageView setPathToNetworkImage:nil];
        }
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)visitUserHomepage
{
    UIViewController* superviewC = self.viewController;
    [OSCGlobalConfig HUDShowMessage:self.tweetEntity.user.authorName
                        addedToView:[UIApplication sharedApplication].keyWindow];
    if (superviewC) {
        OSCUserHomeC* c = [[OSCUserHomeC alloc] initWithUserId:self.tweetEntity.user.authorId];
        [superviewC.navigationController pushViewController:c animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIButton Action

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)commentAction
{
//#if 1
//    UIViewController* superviewC = self.viewController;
//    
//    if ([OSCGlobalConfig getAuthUserID]) {
//        if ([superviewC isKindOfClass:[OSCTweetC class]]) {
//            
//            OSCTweetC* tweetC = (OSCTweetC*)superviewC;
//            [tweetC showReplyAsInputAccessoryViewWithTweetId:self.tweetEntity.tweetId];
//        }
//    }
//    else {
//        [OSCGlobalConfig showLoginControllerFromNavigationController:superviewC.navigationController];
//    }
//#else
//    [self showRepliesListView];
//#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showRepliesListView
{
//    UIViewController* superviewC = self.viewController;
//    OSCCommonRepliesListC* c = [[OSCCommonRepliesListC alloc] initWithTopicId:self.tweetEntity.tweetId
//                                                                    topicType:OSCContentType_Tweet
//                                                                 repliesCount:self.tweetEntity.repliesCount];
//    [superviewC.navigationController pushViewController:c animated:YES];
//    
//    // table header view with body
//    OSCTweetBodyView* bodyView = [[OSCTweetBodyView alloc] initWithFrame:self.bounds];
//    bodyView.height = [OSCTweetBodyView heightForObject:self.tweetEntity withViewWidth:self.width];
//    [bodyView shouldUpdateCellWithObject:self.tweetEntity];
//    c.tableView.tableHeaderView = bodyView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showContentOriginImage
{
    if (self.viewController) {
        if ([self.viewController isKindOfClass:[UITableViewController class]]) {
            UITableView* tableView = ((UITableViewController*)self.viewController).tableView;
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            
            // convert rect to self(cell)
            CGRect rectInCell = [self.contentView convertRect:self.contentImageView.frame toView:self];
            
            // convert rect to tableview
            CGRect rectInTableView = [self convertRect:rectInCell toView:tableView];//self.superview
            
            // convert rect to window
            CGRect rectInWindow = [tableView convertRect:rectInTableView toView:window];
            
            // show photo full screen
            UIImage* image = self.contentImageView.image;
            if (image) {
                rectInWindow = CGRectMake(rectInWindow.origin.x + (rectInWindow.size.width - image.size.width) / 2.f,
                                          rectInWindow.origin.y + (rectInWindow.size.height - image.size.height) / 2.f,
                                          image.size.width, image.size.height);
            }
            JLFullScreenPhotoBrowseView* browseView =
            [[JLFullScreenPhotoBrowseView alloc] initWithUrlPath:nil//self.tweetEntity.bigImageUrl
                                                       thumbnail:self.contentImageView.image
                                                        fromRect:rectInWindow];
            [window addSubview:browseView];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UI

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)commentBtn
{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_commentBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [_commentBtn setBackgroundColor:TABLE_VIEW_BG_COLOR];
//        [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentBtn];
        _commentBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _commentBtn.layer.borderWidth = 1.0f;
    }
    return _commentBtn;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NIAttributedLabelDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)attributedLabel:(NIAttributedLabel*)attributedLabel
didSelectTextCheckingResult:(NSTextCheckingResult *)result
                atPoint:(CGPoint)point {
    NSURL* url = nil;
    if (NSTextCheckingTypePhoneNumber == result.resultType) {
        url = [NSURL URLWithString:[@"tel://" stringByAppendingString:result.phoneNumber]];
        
    } else if (NSTextCheckingTypeLink == result.resultType) {
        url = result.URL;
    }
    
    if (nil != url) {
        UIViewController* superviewC = self.viewController;
        if ([url.absoluteString hasPrefix:PROTOCOL_AT_SOMEONE]) {
            NSString* someone = [url.absoluteString substringFromIndex:PROTOCOL_AT_SOMEONE.length];
            someone = [someone stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [OSCGlobalConfig HUDShowMessage:someone
                                addedToView:[UIApplication sharedApplication].keyWindow];
            if (superviewC) {
                OSCUserHomeC* c = [[OSCUserHomeC alloc] initWithUsername:someone];
                [superviewC.navigationController pushViewController:c animated:YES];
            }
        }
        else if ([url.absoluteString hasPrefix:PROTOCOL_SHARP_SOFTWARE]) {
            NSString* somesoftware = [url.absoluteString substringFromIndex:PROTOCOL_SHARP_SOFTWARE.length];
            // TODO: show some mblogs about this trend
            somesoftware = [somesoftware stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [OSCGlobalConfig HUDShowMessage:somesoftware
                                addedToView:[UIApplication sharedApplication].keyWindow];
        }
        else {
            if (superviewC) {
                NIWebController* webC = [[NIWebController alloc] initWithURL:url];
                [superviewC.navigationController pushViewController:webC animated:YES];
            }
        }
    }
    else {
        [OSCGlobalConfig HUDShowMessage:@"抱歉，这是无效的链接" addedToView:self.viewController.view];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)attributedLabel:(NIAttributedLabel *)attributedLabel
shouldPresentActionSheet:(UIActionSheet *)actionSheet
 withTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point
{
    return NO;
}

@end