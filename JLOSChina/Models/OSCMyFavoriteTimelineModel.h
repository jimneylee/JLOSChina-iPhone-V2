//
//  OSCMyFavoriteTimelineModel.h
//  JLOSChinaV2
//
//  Created by jimneylee on 8/28/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"

@interface OSCMyFavoriteTimelineModel : OSCBaseTableModel

@property (nonatomic, strong) NSArray* segmentedDataArray;
@property (nonatomic, assign) OSCMyFavoriteCatalogType favoriteType;

- (NSString *)getTitleForSegmentedIndex:(NSInteger)index;
- (void)setTypeForSegmentedIndex:(NSInteger)index;

@end
