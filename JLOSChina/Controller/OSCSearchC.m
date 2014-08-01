//
//  OSCSearchC.m
//  JLOSChinaV2
//
//  Created by jimneylee on 14-8-1.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//

#import "OSCSearchC.h"
#import "OSCSearchResultModel.h"
#import "OSCSearchDisplayController.h"

@interface OSCSearchC ()<OSCSearchDisplayDelegate>

@property (nonatomic, strong) OSCSearchDisplayController *searchController;

@end

@implementation OSCSearchC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"搜索";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                           self.view.width, TT_TOOLBAR_HEIGHT)];
    searchBar.showsScopeBar = YES;
    searchBar.scopeButtonTitles = @[@"新闻", @"博客", @"软件", @"帖子"];
    OSCSearchDisplayController *searchDisplayController = [[OSCSearchDisplayController alloc] initWithSearchBar:searchBar
                                                                                             contentsController:self];
    searchDisplayController.delegate = self;
    self.searchController = searchDisplayController;
    self.tableView.tableHeaderView = searchBar;
    
    [searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [OSCSearchResultModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath* indexPath) {
                return YES;
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForEmpty
{
    NSString* msg = @"信息为空";
    [OSCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMessageForError
{
    // TODO: 这边初始进入，网络获取数据发生错误，此处处理不是太妥当。
    if (((OSCSearchResultModel*)self.model).catalogType != OSCSearchCatalogType_Unknow
        && ((OSCSearchResultModel*)self.model).keywords.length > 0) {
        NSString* msg = @"抱歉，无法获取信息！";
        [OSCGlobalConfig HUDShowMessage:msg addedToView:self.view];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMssageForLastPage
{
    NSString* msg = @"已是最后一页";
    [OSCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

- (void)searchWithKeywords:(NSString *)keywords selectedScopeButtonIndex:(NSInteger)selectedScope
{
    // TODO: 软件Cell http://www.oschina.net/action/openapi/search_list?catalog=project&q=facebook&pageIndex=1&pageSize=20&access_token=4738091d-003c-4030-8176-4612e7c73879&dataType=xml
    ((OSCSearchResultModel*)self.model).keywords = keywords;
    ((OSCSearchResultModel*)self.model).catalogType = selectedScope;
    
    [self autoPullDownRefreshActionAnimation];
}

@end
