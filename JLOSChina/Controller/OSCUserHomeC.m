//
//  RCForumTopicsC.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCUserHomeC.h"

#import "OSCUserActiveTimelineModel.h"
#import "OSCCommonEntity.h"
#import "OSCCommonDetailC.h"
#import "OSCUserInfoHeaderView.h"
#import "OSCUserInfoModel.h"

@interface OSCUserHomeC ()

@property (nonatomic, assign) OSCContentType contentType;
@property (nonatomic, strong) OSCUserInfoHeaderView* homepageHeaderView;

@property (nonatomic, strong) OSCUserInfoModel *infoModel;
@property (nonatomic, assign) long long userId;
@property (nonatomic, copy)   NSString* username;

@end

@implementation OSCUserHomeC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUserId:(long long)userId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.userId = userId;
        ((OSCUserActiveTimelineModel*)self.model).userId = userId;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithUsername:(NSString*)username
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.username = username;
        ((OSCUserActiveTimelineModel*)self.model).userId = NSNotFound;
        self.userId = NSNotFound;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"他(她)的主页";
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.rightBarButtonItem = [OSCGlobalConfig createBarButtonItemWithTitle:@"详细信息"
                                                                                        target:self
                                                                                        action:@selector(showUserDetailInfo)];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = TABLE_VIEW_BG_COLOR;
    self.tableView.backgroundView = nil;
    
    self.infoModel = [[OSCUserInfoModel alloc] init];
    [self.infoModel loadUserInfoWithUserId:self.userId orUsername:self.username
                                     block:^(OSCUserFullEntity *entity, OSCErrorEntity *errorEntity) {
                                             [self updateHeaderViewWithUserEntity:entity];
                                                 ((OSCUserActiveTimelineModel *)self.model).userId = entity.authorId;
                                                 [self refreshData:YES];
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateHeaderViewWithUserEntity:(OSCUserFullEntity*)userEntity
{
    if (!_homepageHeaderView) {
        _homepageHeaderView = [[OSCUserInfoHeaderView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, 0.f)];
    }
    [self.homepageHeaderView updateViewForUser:userEntity];
    
    // call layoutSubviews at first to calculte view's height, dif from setNeedsLayout
    [self.homepageHeaderView layoutIfNeeded];
    if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = self.homepageHeaderView;
    }
}

- (void)showUserDetailInfo
{

}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [OSCUserActiveTimelineModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath* indexPath) {
        if ([object isKindOfClass:[OSCCommonEntity class]]) {
            OSCCommonEntity* entity = (OSCCommonEntity*)object;
            if (entity.newsId > 0) {
                [OSCGlobalConfig HUDShowMessage:@"TODO it!" addedToView:self.view];
//                OSCCommonDetailC* c = [[OSCCommonDetailC alloc] initWithTopicId:entity.newsId
//                                                                  topicType:self.segmentedControl.selectedSegmentIndex];
//                [self.navigationController pushViewController:c animated:YES];
            }
            else {
                [OSCGlobalConfig HUDShowMessage:@"帖子不存在或已被删除！" addedToView:self.view];
            }
        }
        return YES;
    };
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoadData
{
    [super didFinishLoadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadData
{
    [super didFailLoadData];
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
    NSString* msg = @"抱歉，无法获取信息！";
    [OSCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showMssageForLastPage
{
    NSString* msg = @"已是最后一页";
    [OSCGlobalConfig HUDShowMessage:msg addedToView:self.view];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat tableHeaderHeight = 20.f;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, tableHeaderHeight)];
    label.backgroundColor = TABLE_VIEW_BG_COLOR;
    label.textColor = [UIColor darkGrayColor];
    label.text = @"  最新活动";
    return label;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat tableHeaderHeight = 20.f;
    return tableHeaderHeight;
}

@end
