//
//  RCLoginModel.m
//  RubyChina
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCAuthModel.h"
#import "OSCAPIClient.h"
#import "NSDataAdditions.h"
#import "SinaWeibo.h"

@interface OSCAuthModel()<SinaWeiboDelegate>

@property (nonatomic, strong) SinaWeibo *sinaWeibo;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation OSCAuthModel

static OSCAuthModel* _sharedAuthModel = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCAuthModel*)sharedAuthModel
{
#if 0// 因为此处单例会被多次创建，故不用dispatch_once_t，后面再深入考虑
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAuthModel = [[OSCAuthModel alloc] init];
    });
#else
    _sharedAuthModel = [[OSCAuthModel alloc] init];
    return _sharedAuthModel;
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)releaseSharedAuthModel
{
    if (_sharedAuthModel) {
        _sharedAuthModel = nil;
    }
}

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
- (BOOL)checkAuthValid
{
    BOOL authValid = self.sinaWeibo.isAuthValid;
    
    if (!authValid) {
        [self.sinaWeibo logIn];
    }
    else {
        // 已登录过，不用再次登录
        [OSCGlobalConfig setOAuthAccessToken:self.sinaWeibo.accessToken];
        //[[NSNotificationCenter defaultCenter] postNotificationName:DID_LOGIN_NOTIFICATION object:nil];
    }
    return authValid;
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
