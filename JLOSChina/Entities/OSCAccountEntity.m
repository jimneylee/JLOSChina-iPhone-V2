//
//  OSCAccountEntity.m
//  JLOSChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCAccountEntity.h"
#import "SSKeychain.h"

NSString* kDefaultForumService = @"DefaultForumService";

static NSString* kAccessTokenKey = @"AccessTokenKey";
static NSString* kExpiresInKey = @"ExpiresInKey";
static NSString* kRefreshTokenKey = @"RefreshTokenKey";

@implementation OSCAccountEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCAccountEntity*)loadStoredUserAccount
{
    NSString* accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessTokenKey];
    NSDate* expiresIn = [[NSUserDefaults standardUserDefaults] objectForKey:kExpiresInKey];
    NSString* refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:kRefreshTokenKey];

    if (accessToken && expiresIn && refreshToken) {
        OSCAccountEntity* account = [[OSCAccountEntity alloc] init];
        account.accessToken = accessToken;
        account.expiresIn = expiresIn;
        account.refreshToken = refreshToken;
        return account;
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)storeAccessToken:(NSString *)accessToken expiresIn:(NSDate *)expiresIn refreshToken:(NSString *)refreshToken
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:expiresIn forKey:kExpiresInKey];
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:kRefreshTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deleteStoredUserAccount
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kExpiresInKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kRefreshTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Store & read password
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)storePassword:(NSString*)password forUsername:(NSString*)username
{
    NSError *error = nil;
    BOOL success = [SSKeychain setPassword:password
                                forService:kDefaultForumService
                                   account:username error:&error];
    if (!success || error) {
        NSLog(@"can NOT store account");
    }
    else {
        //[OSCAccountEntity storeUsername:username];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)readPassword
{
    NSString* loginedUserName = nil;//[OSCAccountEntity readUsername];
    NSString* password = [SSKeychain passwordForService:kDefaultForumService
                                                account:loginedUserName];
    return password;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)deletePassword
{
    NSString* loginedUserName = nil;//[OSCAccountEntity readUsername];
    [SSKeychain deletePasswordForService:kDefaultForumService account:loginedUserName];
}

@end
