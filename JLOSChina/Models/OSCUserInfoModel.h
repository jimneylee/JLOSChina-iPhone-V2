//
//  OSCUserInfoModel.h
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBaseModel.h"
#import "OSCUserFullEntity.h"

typedef void (^ReturnBlock)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity);

@interface OSCUserInfoModel : OSCBaseModel<NSXMLParserDelegate>

@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, copy)   NSString* username;
@property (nonatomic, strong) OSCUserFullEntity* userEntity;
@property (nonatomic, strong) ReturnBlock returnBlock;

- (void)loadUserInfoWithUserId:(NSString *)uid
                    orUsername:(NSString*)username
                         block:(void(^)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity))block;

@end
