//
//  RCTopicDetailC.m
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCCommonDetailWebC.h"
#import "NIWebController.h"
#import "OSCCommonDetailModel.h"
#import "OSCCommentEntity.h"
#import "OSCCommonBodyView.h"
#import "OSCReplyModel.h"
#import "OSCQuickReplyC.h"
#import "OSCCommonRepliesListC.h"

@interface OSCCommonDetailWebC ()<RCQuickReplyDelegate, OSCCommonBodyViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) OSCCommonDetailEntity* topicDetailEntity;
@property (nonatomic, strong) OSCCommonBodyView* topicBodyView;
@property (nonatomic, strong) OSCQuickReplyC* quickReplyC;
@property (nonatomic, strong) UIWebView* bodyWebView;

@end

@implementation OSCCommonDetailWebC


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"详细";
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:
         [OSCGlobalConfig createBarButtonItemWithTitle:@"查看回复" target:self
                                                action:@selector(showRepliesListView)],
         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                       target:self action:@selector(replyTopicAction)],
         nil];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // body
    self.bodyWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.bodyWebView.delegate = self;
    [self.view addSubview:self.bodyWebView];
    
#if 1
    NSString *authorStr =
    [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%lld'>%@</a>&nbsp;发表于&nbsp;%@",
     self.topicDetailEntity.user.authorId, self.topicDetailEntity.user.authorName, self.topicDetailEntity.createdAtDate];
    
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@</body>",
                      HTML_Style, self.topicDetailEntity.title,
                      authorStr, self.topicDetailEntity.body, HTML_Bottom];
#else
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#FFFFFF'>%@<div id='oschina_body'>%@</div>%@</body>",
                      HTML_Style, self.topicDetailEntity.body, HTML_Bottom];
#endif
    
    [self.bodyWebView loadHTMLString:html baseURL:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.quickReplyC.textView isFirstResponder]) {
        [self.quickReplyC.textView resignFirstResponder];
    }
    if (self.quickReplyC.view.superview) {
        [self.quickReplyC.view removeFromSuperview];
    }
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showRepliesListView
{
//    OSCCommonRepliesListC* c = [[OSCCommonRepliesListC alloc] initWithTopicId:((OSCCommonDetailModel*)self.model).topicId
//                                                                    topicType:((OSCCommonDetailModel*)self.model).contentType
//                                                                 repliesCount:((OSCCommonDetailModel*)self.model).topicDetailEntity.repliesCount];
//    [self.navigationController pushViewController:c animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)replyTopicAction
{
    if ([OSCGlobalConfig loginedUserEntity]) {
        [self showReplyAsInputAccessoryView];
        if (!self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    else {
        [OSCGlobalConfig showLoginControllerFromNavigationController:self.navigationController];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showReplyAsInputAccessoryView
{
    if (![self.quickReplyC.textView.internalTextView isFirstResponder]) {
        // each time addSubview to keyWidow, otherwise keyborad is not showed, sorry, so dirty!
        [[UIApplication sharedApplication].keyWindow addSubview:_quickReplyC.view];
        self.quickReplyC.textView.internalTextView.inputAccessoryView = self.quickReplyC.view;
        
        // call becomeFirstResponder twice, I donot know why, feel so bad!
        // maybe because textview is in superview(self.quickReplyC.view)
        [self.quickReplyC.textView.internalTextView becomeFirstResponder];
        [self.quickReplyC.textView.internalTextView becomeFirstResponder];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (OSCQuickReplyC*)quickReplyC
{
//    if (!_quickReplyC) {
//        OSCCatalogType catalogType = [OSCGlobalConfig catalogTypeForContentType:((OSCCommonDetailModel*)self.model).contentType];
//        _quickReplyC = [[OSCQuickReplyC alloc] initWithTopicId:((OSCCommonDetailModel*)self.model).topicId
//                                                     catalogType:catalogType];
//        _quickReplyC.replyDelegate = self;
//    }
//    return _quickReplyC;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RCQuickReplyDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplySuccessWithMyReply:(OSCCommentEntity*)replyEntity
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (replyEntity) {
        // nothing to do
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplyFailure
{
    // nothing to do
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReplyCancel
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIWebViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // TODO:hud show
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return YES;
    }
    else {
        // TODO: check if is valid url
        NIWebController* webC = [[NIWebController alloc] initWithURL:[request URL]];
        [self.navigationController pushViewController:webC animated:YES];
        return NO;
    }
}

@end
