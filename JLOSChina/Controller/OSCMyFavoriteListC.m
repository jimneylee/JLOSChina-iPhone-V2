//
//  OSCMyFavoriteListC.h
//  JLOSChina
//
//  Created by jimneylee on 14-8-28.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//

#import "OSCMyFavoriteListC.h"
#import "SDSegmentedControl.h"
#import "OSCMyFavoriteTimelineModel.h"
#import "OSCCommonEntity.h"
#import "OSCCommonDetailC.h"

@interface OSCMyFavoriteListC ()

@property (nonatomic, strong) SDSegmentedControl *segmentedControl;

@end

@implementation OSCMyFavoriteListC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"我的收藏";
        self.hidesBottomBarWhenPushed = YES;
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
    
    [self initSegmentedControl];
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
- (void)initSegmentedControl
{
    if (!_segmentedControl) {
        // TODO: pull request to author fix this bug: initWithFrame can not call [self commonInit]
        _segmentedControl = [[SDSegmentedControl alloc] init];
        _segmentedControl.frame = CGRectMake(0.f, 0.f, self.view.width, _segmentedControl.height);
        _segmentedControl.interItemSpace = 0.f;
        [_segmentedControl addTarget:self action:@selector(segmentedDidChange)
                    forControlEvents:UIControlEventValueChanged];
    }

    NSString *title = nil;
    for (int i = 0; i < ((OSCMyFavoriteTimelineModel *)self.model).segmentedDataArray.count; i++) {
        title =  [((OSCMyFavoriteTimelineModel *)self.model) getTitleForSegmentedIndex:i];
        [_segmentedControl insertSegmentWithTitle:title
                                          atIndex:i
                                         animated:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)segmentedDidChange
{
    // first cancel request operation
    [self.model cancelRequstOperation];
    
    [((OSCMyFavoriteTimelineModel *)self.model) setTypeForSegmentedIndex:self.segmentedControl.selectedSegmentIndex];
    // remove all, sometime crash, fix later on
    // if (self.model.sections.count > 0) {
    //    [self.model removeSectionAtIndex:0];
    // }
    
    // after scrollToTopAnimated then pull down to refresh, performce perfect
    [self scrollToTopAnimated:NO];
    [self performSelector:@selector(autoPullDownRefreshActionAnimation) withObject:self afterDelay:0.1f];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollToTopAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:CGRectMake(0.f, 0.f, self.tableView.width, self.tableView.height)
                               animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [OSCMyFavoriteTimelineModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath* indexPath) {
        if ([object isKindOfClass:[OSCCommonEntity class]]) {
            OSCCommonEntity* entity = (OSCCommonEntity*)object;
            if (entity.newsId > 0) {
                OSCCommonDetailC* c = [[OSCCommonDetailC alloc] initWithTopicId:entity.newsId
                                                                  topicType:self.segmentedControl.selectedSegmentIndex];
                [self.navigationController pushViewController:c animated:YES];
            }
            else {
                [OSCGlobalConfig HUDShowMessage:@"帖子不存在或已被删除！" addedToView:self.view];
            }
        }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.model];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segmentedControl;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    static CGFloat kDefaultSegemetedControlHeight = 43.f;// see: SDSegmentedControl commonInit
    return kDefaultSegemetedControlHeight;
}

#pragma mark - DID_LOGIN_NOTIFICATION

- (void)didLoginNotification
{
    [self autoPullDownRefreshActionAnimation];
}

@end
