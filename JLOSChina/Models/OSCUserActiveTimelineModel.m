//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCUserActiveTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCActivityEntity.h"
#import "OSCActivityCell.h"

@interface OSCUserActiveTimelineModel()
@property (nonatomic, copy) NSString* detailItemElementName;
@property (nonatomic, strong) NSMutableDictionary* detailDictionary;
@end

@implementation OSCUserActiveTimelineModel

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
        self.detailItemElementName = @"user";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{    
    NSString* path =
    [OSCAPIClient relativePathForUserActiveListWithUserId:self.userId
                                        activeCatalogType:OSCMyActiveCatalogType_All
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
