//
//  OSCUserInfoModel.m
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCUserInfoModel.h"
#import "OSCAPIClient.h"

@interface OSCUserInfoModel()

@property (nonatomic, copy) NSString* detailItemElementName;
@property (nonatomic, strong) NSMutableDictionary* detailDictionary;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCUserInfoModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - LifeCycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        self.itemElementNamesArray = @[XML_USER];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadUserInfoWithUserId:(long long)uid
                    orUsername:(NSString*)username
                         block:(void(^)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity))block
{
    self.userId = uid;
    self.username = username;
    self.returnBlock = block;
    
    [self getParams:nil errorBlock:^(OSCErrorEntity *errorEntity) {
        if (ERROR_CODE_SUCCESS == errorEntity.errorCode) {
            block(self.userEntity, errorEntity);
        }
        else {
            block(nil, errorEntity);
        }
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    NSString* path =
    [OSCAPIClient relativePathForUserInfoWithUserId:self.userId
                                         orUsername:self.username];
    return path;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)parseDataDictionary
//{
//    NSMutableDictionary* dic = self.dataDictionary[XML_USER];
//    // TODO: dirty code: set uid -> authorid, name -> author
//    if (dic[@"uid"]) {
//        [dic setObject:dic[@"uid"] forKey:@"authorid"];
//    }
//    if (dic[@"name"]) {
//        [dic setObject:dic[@"name"] forKey:@"author"];
//    }
//    self.userEntity = [OSCUserFullEntity entityWithDictionary:dic];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad
{
    if (!self.errorEntity || ERROR_CODE_SUCCESS == self.errorEntity.errorCode) {
        self.returnBlock(self.userEntity, self.errorEntity);
    }
    else {
        self.returnBlock(nil, self.errorEntity);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoad
{
    self.returnBlock(nil, self.errorEntity);
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
