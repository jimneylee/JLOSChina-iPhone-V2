//
//  OSCMyFavoriteTimelineModel.m
//  JLOSChinaV2
//
//  Created by jimneylee on 8/28/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import "OSCMyFavoriteTimelineModel.h"
#import "OSCFavoriteCell.h"
#import "OSCFavoriteEntity.h"

@interface OSCMyFavoriteTimelineModel()

@end

@implementation OSCMyFavoriteTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"favorites";
        self.itemElementName = @"favorite";
        
        // 定义此结构，不用担心以后随时调整顺序
        self.segmentedDataArray = @[
                                    @{@"title" : @"新闻", @"type" : @"4"},
                                    @{@"title" : @"软件", @"type" : @"1"},
                                    @{@"title" : @"话题", @"type" : @"2"},
                                    @{@"title" : @"博客", @"type" : @"3"},
                                    @{@"title" : @"代码", @"type" : @"5"},
                                    @{@"title" : @"翻译", @"type" : @"7"},
                                    ];
        [self setTypeForSegmentedIndex:0];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path = [OSCAPIClient relativePathForFavoriteListWithCatalogType:self.favoriteType
                                                                    pageIndex:self.pageIndex
                                                                     pageSize:self.pageSize];
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    return [OSCFavoriteEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCFavoriteCell class];
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
        self.favoriteType = [typeStr integerValue];
    }
}

@end
