//
//  RCForumTopicsModel.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCTweetTimelineModel.h"
#import "OSCAPIClient.h"
#import "OSCTweetCell.h"
#import "OSCTweetEntity.h"

@interface OSCTweetTimelineModel()

@end

@implementation OSCTweetTimelineModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"tweets";
        self.itemElementName = @"tweet";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    // 用户ID [ 0：最新动弹，-1：热门动弹，其他：我的动弹 ]
    
    NSString* path = nil;
    switch (self.tweetType) {
        case OSCTweetType_Latest:
            path = [OSCAPIClient relativePathForTweetListWithUserId:@"0"
                                                          pageIndex:self.pageIndex
                                                           pageSize:self.pageSize];
            break;
            
        case OSCTweetType_Hot:
            path = [OSCAPIClient relativePathForTweetListWithUserId:@"-1"
                                                          pageIndex:self.pageIndex
                                                           pageSize:self.pageSize];
            break;
            
        case OSCTweetType_Mine:
        {
            path = [OSCAPIClient relativePathForTweetListWithUserId:[OSCGlobalConfig getAuthUserID]
                                                          pageIndex:self.pageIndex
                                                           pageSize:self.pageSize];

            break;
        }
            
        default:
            break;
    }

    return path;

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    return [OSCTweetEntity class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass
{
    return [OSCTweetCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParserDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"catalog"]) {
        self.catalogType = [self.tmpInnerElementText integerValue];
    }
    // super will set nil to self.tmpInnerElementText
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
}

@end
