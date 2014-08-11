//
//  RCReplyCell.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCUserInfoHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+nimbusImageNamed.h"
#import "UIView+findViewController.h"
#import "OSCUserFullEntity.h"
#import "OSCUserActiveTimelineModel.h"

#define NAME_FONT_SIZE [UIFont boldSystemFontOfSize:18.f]
#define LOGIN_ID_FONT_SIZE [UIFont systemFontOfSize:16.f]
#define TAG_LINE_ID_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define BUTTON_FONT_SIZE [UIFont boldSystemFontOfSize:15.f]

#define HEAD_IAMGE_HEIGHT 60
#define BUTTON_SIZE CGSizeMake(78.f, 30.f)

@interface OSCUserInfoHeaderView()
@property (nonatomic, strong) OSCUserFullEntity* user;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* locationLabel;
@property (nonatomic, strong) UILabel* platformsLabel;
@property (nonatomic, strong) UILabel* expertiseLabel;
@property (nonatomic, strong) NINetworkImageView* headView;

@property (nonatomic, strong) UIButton* relationBtn;

@end

@implementation OSCUserInfoHeaderView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // content
        UIView* contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        self.contentView = contentView;

        // head
        self.headView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, HEAD_IAMGE_HEIGHT,
                                                                                    HEAD_IAMGE_HEIGHT)];
        self.headView.initialImage = [UIImage nimbusImageNamed:@"head_s.png"];
        [self.contentView addSubview:self.headView];
        
        // username
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = NAME_FONT_SIZE;
        nameLabel.textColor = [UIColor blackColor];
        [contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // login id
        UILabel* locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        locationLabel.font = LOGIN_ID_FONT_SIZE;
        locationLabel.textColor = [UIColor blackColor];
        [contentView addSubview:locationLabel];
        self.locationLabel = locationLabel;
        
        // introduce
        UILabel* platformsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        platformsLabel.font = TAG_LINE_ID_FONT_SIZE;
        platformsLabel.textColor = [UIColor blackColor];
        [contentView addSubview:platformsLabel];
        self.platformsLabel = platformsLabel;
        
        // expertise
        UILabel* expertiseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        expertiseLabel.font = TAG_LINE_ID_FONT_SIZE;
        expertiseLabel.textColor = [UIColor blackColor];
        [contentView addSubview:expertiseLabel];
        self.expertiseLabel = expertiseLabel;
        
        self.contentView.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];//CELL_CONTENT_VIEW_BG_COLOR;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.locationLabel.backgroundColor = [UIColor clearColor];
        self.platformsLabel.backgroundColor = [UIColor clearColor];
        self.expertiseLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cellMargin = CELL_PADDING_4;
    CGFloat contentViewMarin = CELL_PADDING_10;
    CGFloat sideMargin = cellMargin + contentViewMarin;
    CGFloat kContentMaxWidth = self.width - sideMargin * 2;
    
    CGFloat height = sideMargin;
    self.contentView.frame = CGRectMake(cellMargin, cellMargin,
                                        self.width - cellMargin * 2, 0.f);
    
    self.headView.left = contentViewMarin;
    self.headView.top = contentViewMarin;
    
    // head image
    height = height + HEAD_IAMGE_HEIGHT;
    
    // name
    CGFloat topWidth = self.contentView.width - contentViewMarin * 2 - (self.headView.right + CELL_PADDING_10);
    self.nameLabel.frame = CGRectMake(self.headView.right + CELL_PADDING_10, self.headView.top,
                                      topWidth, self.nameLabel.font.lineHeight);
    
    // login id
    self.locationLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom + CELL_PADDING_4,
                                         topWidth, self.locationLabel.font.lineHeight);
    
    // introduce
    self.platformsLabel.frame = CGRectMake(self.headView.left, self.headView.bottom + CELL_PADDING_4,
                                         kContentMaxWidth, self.platformsLabel.font.lineHeight);
    height = height + self.platformsLabel.height + CELL_PADDING_4;
    
    // expertise
    self.expertiseLabel.frame = CGRectMake(self.platformsLabel.left, self.platformsLabel.bottom + CELL_PADDING_4,
                                         kContentMaxWidth, self.expertiseLabel.font.lineHeight);
    height = height + self.expertiseLabel.height + CELL_PADDING_4;
    
    // bottom margin
    height = height + sideMargin;
    
    // content view
    self.contentView.height = height - cellMargin * 2;
    
    // self height
    self.height = height;
    
    // detail btn
    self.relationBtn.right = self.contentView.width;
    self.relationBtn.centerY = self.contentView.height / 3;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateViewForUser:(OSCUserFullEntity*)user
{
    if (user) {
        self.user = user;
        if (user.avatarUrl.length) {
            [self.headView setPathToNetworkImage:user.avatarUrl];
        }
        else {
            [self.headView setPathToNetworkImage:nil];
        }
        self.nameLabel.text = user.authorName;
        self.locationLabel.text = user.location;
        self.platformsLabel.text = [NSString stringWithFormat:@"开发平台：%@", user.platforms];
        self.expertiseLabel.text = [NSString stringWithFormat:@"专长领域：%@", user.expertise];
        
        if (user.relationshipType == OSCRelationshipType_NotAttation) {
            [self.relationBtn setTitle:@"加关注" forState:UIControlStateNormal];
        }
        else {
            [self.relationBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIButton Action

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)doRelationAction
{
    if (self.user.relationshipType == OSCRelationshipType_NotAttation) {
        [self.relationBtn setTitle:@"加关注" forState:UIControlStateNormal];
        
    }
    else {
        [self.relationBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }

    [OSCGlobalConfig HUDShowMessage:[self.relationBtn titleForState:UIControlStateNormal]
                        addedToView:[UIApplication sharedApplication].keyWindow];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View init

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton*)relationBtn
{
    if (!_relationBtn) {
        _relationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                  BUTTON_SIZE.width, BUTTON_SIZE.height)];
        [_relationBtn.titleLabel setFont:BUTTON_FONT_SIZE];
        [_relationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_relationBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_relationBtn setBackgroundColor:TABLE_VIEW_BG_COLOR];
        [_relationBtn addTarget:self action:@selector(doRelationAction)
               forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_relationBtn];
        _relationBtn.layer.borderColor = CELL_CONTENT_VIEW_BORDER_COLOR.CGColor;
        _relationBtn.layer.borderWidth = 1.0f;
    }
    return _relationBtn;
}

@end
