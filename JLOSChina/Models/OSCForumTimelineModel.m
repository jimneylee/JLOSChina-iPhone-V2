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
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)relativePath
{
    NSString* path = nil;
    path = [OSCAPIClient relativePathForForumListWithCatalogId:[self getCatalogIdFromType:self.topicType]
                                                     pageIndex:self.pageIndex
                                                      pageSize:self.pageSize];
    return path;

}

- (NSString *)getCatalogIdFromType:(OSCForumTopicType)type
{
    NSString *catalogId = nil;
    switch (type) {
        case OSCForumTopicType_All:// = 0,      //所有
        case OSCForumTopicType_QA:// = 1,       //问答
        case OSCForumTopicType_Share:// = 2,    //分享
        case OSCForumTopicType_Watering:// = 3, //综合灌水
        case OSCForumTopicType_Feedback:// = 4:   //站务
            catalogId = [NSString stringWithFormat:@"%d", type];
            break;
            
        case OSCForumTopicType_Career:// = 100,   //职业
            catalogId = @"100";
            break;
            
        default:
            break;
    }
    
    return catalogId;
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
