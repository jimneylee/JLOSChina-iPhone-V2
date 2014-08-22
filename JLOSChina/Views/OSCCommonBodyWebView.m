//
//  RCTopicDetailHeaderView.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCCommonBodyWebView.h"
#import "NIWebController.h"
#import "UIView+findViewController.h"

@interface OSCCommonBodyWebView()<UIWebViewDelegate>

@property (nonatomic, strong) OSCCommonDetailEntity* topicDetailEntity;
@property (nonatomic, strong) UIWebView* bodyWebView;

@end

@implementation OSCCommonBodyWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        // body
        self.bodyWebView = [[UIWebView alloc] initWithFrame:self.bounds];
        self.bodyWebView.delegate = self;
        [self addSubview:self.bodyWebView];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateViewWithTopicDetailEntity:(OSCCommonDetailEntity*)topicDetailEntity
{
    self.topicDetailEntity = topicDetailEntity;
    
#if 1
    NSString *authorStr =
    [NSString stringWithFormat:@"<a href='http://my.oschina.net/u/%lld'>%@</a>&nbsp;发表于&nbsp;%@",
     self.topicDetailEntity.user.authorId, self.topicDetailEntity.user.authorName, self.topicDetailEntity.createdAtDate];
    
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oschina_title'>%@</div><div id='oschina_outline'>%@</div><hr/><div id='oschina_body'>%@</div>%@</body>",
                      HTML_STYLE, self.topicDetailEntity.title,
                      authorStr, self.topicDetailEntity.body, HTML_BOTTOM];
#else
    NSString *html = [NSString stringWithFormat:@"<body style='background-color:#FFFFFF'>%@<div id='oschina_body'>%@</div>%@</body>",
                      HTML_STYLE, self.topicDetailEntity.body, HTML_BOTTOM];
#endif
    
    [self.bodyWebView loadHTMLString:html baseURL:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIWebViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // TODO:hud show
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return YES;
    }
    else {
        // TODO: check if is valid url
        NIWebController* webC = [[NIWebController alloc] initWithURL:[request URL]];
        [self.viewController.navigationController pushViewController:webC animated:YES];
        return NO;
    }
}

@end
