//
//  OSCFavoriteEntity.m
//  JLOSChina
//
//  Created by jimneylee on 14-8-28.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//
#import "OSCFavoriteEntity.h"
#import "NSDate+OSChina.h"
#import "NSString+stringFromValue.h"
#import "NSString+TypeScan.h"

@implementation OSCFavoriteEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.objectId = dic[@"objid"];
        self.type = [dic[@"type"] integerValue];
     }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCFavoriteEntity* entity = [[OSCFavoriteEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
