//
//  OSCSearchResultModel.h
//  JLOSChina
//
//  Created by jimneylee on 14-8-1.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//

#import "OSCSearchResultModel.h"
#import "OSCAPIClient.h"
#import "OSCCommonCell.h"
#import "OSCCommonEntity.h"

@interface OSCSearchResultModel()

@end

@implementation OSCSearchResultModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDelegate:(id<NITableViewModelDelegate>)delegate
{
	self = [super initWithDelegate:delegate];
	if (self) {
        self.listElementName = @"results";
        self.itemElementName = @"result";
        self.catalogType = OSCSearchCatalogType_Unknow;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    if (self.catalogType != OSCSearchCatalogType_Unknow && self.keywords.length > 0) {
        NSString* path = [OSCAPIClient relativePathForSearchWithCatalogName:[self getCatalogNameFromType:self.catalogType]
                                                                   keywords:self.keywords
                                                                  pageIndex:self.pageIndex
                                                                   pageSize:self.pageSize];
        return path;
    }
    
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)objectClass
{
    return [OSCCommonEntity class];
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

- (NSString *)getCatalogNameFromType:(OSCSearchCatalogType)type
{
    NSString *catalogName = @"news";
    switch (type) {
        case OSCSearchCatalogType_News:
            catalogName = @"news";
            break;
            
        case OSCSearchCatalogType_Blog:
            catalogName = @"blog";
            break;
            
        case OSCSearchCatalogType_Project:
            catalogName = @"project";
            break;
            
        case OSCSearchCatalogType_Post:
            catalogName = @"post";
            break;
            
        default:
            catalogName = @"news";
            break;
    }
    
    return catalogName;
}

@end
