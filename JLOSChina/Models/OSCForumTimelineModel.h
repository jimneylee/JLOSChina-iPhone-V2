//
//  RCForumTopicsModel.h
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"

@interface OSCForumTimelineModel : OSCBaseTableModel

@property (nonatomic, strong) NSArray* segmentedDataArray;

- (NSString *)getTitleForSegmentedIndex:(NSInteger)index;
- (void)setTypeForSegmentedIndex:(NSInteger)index;

@end
