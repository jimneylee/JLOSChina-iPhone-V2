//
//  OSCSearchResultModel.h
//  JLOSChina
//
//  Created by jimneylee on 14-8-1.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//

#import "OSCBaseTableModel.h"

typedef NS_ENUM(NSInteger, OSCSearchCatalogType) {
    OSCSearchCatalogType_News = 0,
    OSCSearchCatalogType_Blog = 1,
    OSCSearchCatalogType_Project = 2,
    OSCSearchCatalogType_Post = 3,
    OSCSearchCatalogType_Unknow
};

@interface OSCSearchResultModel : OSCBaseTableModel

@property (nonatomic, assign) OSCSearchCatalogType catalogType;
@property (nonatomic, copy) NSString* keywords;

@end
