//
//  RCTopicDetailModel.m
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCRepliesTimelineModel.h"
#import "OSCReplyCell.h"
#import "OSCCommentEntity.h"

@implementation OSCRepliesTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Init

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"comments";
        self.itemElementName = @"comment";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
// http://www.oschina.net/action/api/blogcomment_list?id=187132
- (NSString*)relativePath
{
    NSString* path = nil;
    
    switch (self.type) {
        case OSCCatalogType_News:
        case OSCCatalogType_Forum:
        case OSCCatalogType_Tweet:
            path = [OSCAPIClient relativePathForRepliesListWithCatalogType:self.type
                                                                 contentId:self.topicId
                                                                 pageIndex:self.pageIndex
                                                                  pageSize:self.pageSize];
            break;
            
        case OSCCatalogType_Blog:
            path = [OSCAPIClient relativePathForRepliesListWithBlogId:self.topicId
                                                            pageIndex:self.pageIndex
                                                             pageSize:self.pageSize];
            break;
            
        default:
            break;
    }
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
	return [OSCCommentEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCReplyCell class];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad
{
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoad
{
    
}

@end
