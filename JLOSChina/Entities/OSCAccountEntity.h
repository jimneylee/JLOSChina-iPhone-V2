//
//  RCUserEntity.h
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface OSCAccountEntity : NSObject

@property (nonatomic, copy) NSString* accessToken;
@property (nonatomic, copy) NSDate* expiresIn;
@property (nonatomic, copy) NSString* refreshToken;

+ (OSCAccountEntity*)loadStoredUserAccount;
+ (void)storeAccessToken:(NSString *)accessToken expiresIn:(NSDate *)expiresIn refreshToken:(NSString *)refreshToken;
+ (void)deleteStoredUserAccount;

@end

extern NSString *kDefaultForumService;

