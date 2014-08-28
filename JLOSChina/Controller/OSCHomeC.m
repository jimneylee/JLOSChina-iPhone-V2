//
//  RCForumTopicsC.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCHomeC.h"
#import "SDSegmentedControl.h"
#import "OSCHomeTimelineModel.h"
#import "OSCCommonEntity.h"
#import "OSCCommonDetailC.h"
#import "OSCSearchC.h"

@interface OSCHomeC ()

@property (nonatomic, strong) SDSegmentedControl *segmentedControl;

@end

@implementation OSCHomeC

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"综合资讯";
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                      target:self action:@selector(showSearchView)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginNotification)
                                                     name:DID_LOGIN_NOTIFICATION object:nil];
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
    ((OSCHomeTimelineModel*)self.model).type = self.segmentedControl.selectedSegmentIndex;
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
    
    NSArray* sectionNames = @[@"最新资讯", @"最新博客", @"推荐博客"];
    for (int i = 0; i < sectionNames.count; i++) {
        [_segmentedControl insertSegmentWithTitle:sectionNames[i]
                                          atIndex:i
                                         animated:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)segmentedDidChange
{
    // first cancel request operation
    [self.model cancelRequstOperation];
    
    ((OSCHomeTimelineModel*)self.model).type = self.segmentedControl.selectedSegmentIndex;
    
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
- (void)showSearchView
{
    OSCSearchC *searchC = [[OSCSearchC alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:searchC animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableModelClass
{
    return [OSCHomeTimelineModel class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NIActionBlock)tapAction
{
    return ^BOOL(id object, id target, NSIndexPath* indexPath) {
        if ([object isKindOfClass:[OSCCommonEntity class]]) {
            OSCCommonEntity* entity = (OSCCommonEntity*)object;
            if (entity.newsId > 0) {
                
                OSCCatalogType type = OSCCatalogType_News;
                switch (((OSCHomeTimelineModel*)self.model).type) {
                    case OSCHomeType_LatestNews:
                        type = OSCCatalogType_News;
                        break;
                        
                    case OSCHomeType_LatestBlog:
                    case OSCHomeType_RecommendBlog:
                        type = OSCCatalogType_Blog;
                        break;
                        
                    default:
                        break;
                }

                OSCCommonDetailC* c = [[OSCCommonDetailC alloc] initWithTopicId:entity.newsId
                                                                  topicType:type];
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
