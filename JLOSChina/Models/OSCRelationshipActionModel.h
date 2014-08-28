//
//  RCSignModel.h
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCBaseModel.h"
#import "OSCUserFullEntity.h"

typedef void (^ReturnBlock)(OSCErrorEntity* errorEntity);

@interface OSCRelationshipActionModel : OSCBaseModel<NSXMLParserDelegate>

@property (nonatomic, strong) OSCUserFullEntity* userEntity;
@property (nonatomic, strong) ReturnBlock returnBlock;

+ (OSCRelationshipActionModel *)sharedModel;

- (void)followUserId:(NSString *)uid block:(void(^)(OSCErrorEntity* errorEntity))block;
- (void)unfollowUserId:(NSString *)uid block:(void(^)(OSCErrorEntity* errorEntity))block;

@end
