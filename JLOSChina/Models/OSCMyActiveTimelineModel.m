//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCMyActiveTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCActivityEntity.h"
#import "OSCActivityCell.h"

@interface OSCMyActiveTimelineModel()
@end

@implementation OSCMyActiveTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"activies";
        self.itemElementName = @"active";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path =
    [OSCAPIClient relativePathForActiveListWithLoginedUserId:[[OSCGlobalConfig getAuthUserID] integerValue]
                                           activeCatalogType:self.activeCatalogType
                                                 pageIndex:self.pageIndex
                                                pageSize:self.pageSize];
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    return [OSCActivityEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCActivityCell class];
}

@end
