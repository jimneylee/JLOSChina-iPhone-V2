//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCForumTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCCommonCell.h"
#import "OSCTopicEntity.h"

@interface OSCForumTimelineModel()

@property (nonatomic, assign) OSCForumTopicType type;

@end

@implementation OSCForumTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"posts";
        self.itemElementName = @"post";
        
        // 定义此结构，不用担心以后随时调整顺序
        self.segmentedDataArray = @[
                                    @{@"title" : @"所有", @"type" : @"0"},
                                    @{@"title" : @"技术", @"type" : @"1"},
                                    @{@"title" : @"分享", @"type" : @"2"},
                                    @{@"title" : @"灌水", @"type" : @"3"},
                                    @{@"title" : @"站务", @"type" : @"4"},
                                    @{@"title" : @"职业", @"type" : @"100"},
                                    ];
        [self setTypeForSegmentedIndex:0];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)relativePath
{
    NSString* path = nil;
    path = [OSCAPIClient relativePathForForumListWithType:self.type
                                                pageIndex:self.pageIndex
                                                 pageSize:self.pageSize];
    return path;

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    return [OSCTopicEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCCommonCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)getTitleForSegmentedIndex:(NSInteger)index
{
    NSString *title = @"";
    
    if (self.segmentedDataArray.count > index) {
        NSDictionary *dic = self.segmentedDataArray[index];
        title = dic[@"title"];
    }
    
    return title;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTypeForSegmentedIndex:(NSInteger)index
{
    if (self.segmentedDataArray.count > index) {
        NSDictionary *dic = self.segmentedDataArray[index];
        NSString *typeStr = dic[@"type"];
        self.type = [typeStr integerValue];
    }
}

@end
