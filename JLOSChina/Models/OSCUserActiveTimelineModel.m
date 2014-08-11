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
    return nil;
    
    NSString* path =
    [OSCAPIClient relativePathForUserActiveListWithUserId:self.userId
                                                orUsername:self.username
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSXMLParserDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
//http://www.raywenderlich.com/zh-hans/36079/afnetworking%E9%80%9F%E6%88%90%E6%95%99%E7%A8%8B%EF%BC%881%EF%BC%89
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
    
    // osc 后台奇葩的user xml结构
    //<user>
    //<name><![CDATA[BigBang]]></name>
    //?? <user>1174259</user>
    // ...
    //</user>
    
    // 因为user内嵌user标签，此处额外判断
    if (!self.detailDictionary && [elementName isEqualToString:self.detailItemElementName]) {
        self.detailDictionary = [NSMutableDictionary dictionary];
        self.superElementName = self.detailItemElementName;
    }
    else if ([self.superElementName isEqualToString:self.detailItemElementName]) {
        self.tmpInnerElementText = [[NSMutableString alloc] init];;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [super parser:parser foundCharacters:string];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([self.superElementName isEqualToString:self.detailItemElementName]) {
        if (self.detailDictionary  && self.tmpInnerElementText) {
            [self.detailDictionary setObject:self.tmpInnerElementText forKey:elementName];
        }
    }
    // super will set nil to self.tmpInnerElementText
    [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // TODO: dirty code: set uid -> authorid, name -> author
    // http://www.oschina.net/action/openapi/user_information?user=0&friend_name=%E7%BA%A2%E8%96%AF&pageIndex=1&pageSize=20&access_token=f0c2fcec-5fc6-4880-90f4-59b04748d912&dataType=xml
    NSMutableDictionary* dic = self.detailDictionary;
    if (dic[@"user"]) {
        [dic setObject:dic[@"user"] forKey:@"authorid"];
    }
    if (dic[@"name"]) {
        [dic setObject:dic[@"name"] forKey:@"author"];
    }
    self.userEntity = [OSCUserFullEntity entityWithDictionary:dic];
    [super parserDidEndDocument:parser];
}

@end
