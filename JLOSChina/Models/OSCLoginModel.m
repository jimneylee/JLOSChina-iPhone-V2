//
//  RCLoginModel.m
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCLoginModel.h"
#import "OSCAPIClient.h"
#import "NSDataAdditions.h"
#import "SinaWeibo.h"

#define kAppKey             @"pMGiaTIsGseV4hoL7Qgb"
#define kAppSecret          @"qYlSXyRf0DjY3uLyQ5Fd4m3QBOUjbGVy"
#define kAppRedirectURL     @"http://www.oschina.net/default.html"

@interface OSCLoginModel()<SinaWeiboDelegate>

@property (nonatomic, strong) SinaWeibo *sinaWeibo;
@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCLoginModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - LifeCycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        SinaWeibo *sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey
                                                       appSecret:kAppSecret
                                                  appRedirectURI:kAppRedirectURL
                                                     andDelegate:self];
        OSCAccountEntity *account = [OSCAccountEntity loadStoredUserAccount];
        if (account) {
            sinaWeibo.accessToken = account.accessToken;
            sinaWeibo.expirationDate = account.expiresIn;
            sinaWeibo.refreshToken = account.refreshToken;
        }

        self.sinaWeibo = sinaWeibo;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loginWithBlock:(void(^)(OSCUserFullEntity* entity, OSCErrorEntity* errorEntity))block
{

    BOOL authValid = self.sinaWeibo.isAuthValid;
    
    if (!authValid) {
        [self.sinaWeibo logIn];
    }
    else {
        // 已登录过，不用再次登录
        [OSCGlobalConfig setOAuthAccessToken:self.sinaWeibo.accessToken];
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_LOGIN_NOTIFICATION object:nil];
    }
}

#pragma mark - SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"accessToken = %@\expirationDate = %@\refreshToken = %@\n",
          sinaweibo.accessToken, sinaweibo.expirationDate, sinaweibo.refreshToken);
    
    if (sinaweibo.accessToken.length && sinaweibo.expirationDate && sinaweibo.refreshToken.length) {
        [OSCAccountEntity storeAccessToken:sinaweibo.accessToken
                                 expiresIn:sinaweibo.expirationDate
                              refreshToken:sinaweibo.refreshToken];
        
        
        // 登录成功
        [OSCGlobalConfig setOAuthAccessToken:sinaweibo.accessToken];
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_LOGIN_NOTIFICATION object:nil];
    }
    else {
        [OSCGlobalConfig HUDShowMessage:@"登录授权失败" addedToView:KEY_WINDOW];
    }
}

@end
