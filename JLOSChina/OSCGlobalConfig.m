//
//  RCGlobalConfig.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCGlobalConfig.h"
#import "OSCEmotionEntity.h"
#import "OSCAuthModel.h"

// emotion
static NSArray* emotionsArray = nil;
static NSString  *s_accessToken = nil;
static NSString  *s_userID = nil;
static OSCUserFullEntity* loginedUserEntity = nil;

@implementation OSCGlobalConfig

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global Data

+ (NSString *)getAuthAccessToken
{
    return s_accessToken;
}

+ (void)setAuthAccessToken:(NSString *)accessToken
{
    s_accessToken = [accessToken copy];
}

+ (NSString *)getAuthUserID
{
    return s_userID;
}

+ (void)setAuthUserID:(NSString *)userID
{
    s_userID = [userID copy];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCUserFullEntity*)loginedUserEntity
{
    return loginedUserEntity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setLoginedUserEntity:(OSCUserFullEntity*)userEntity
{
    loginedUserEntity = userEntity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)checkAuthValid
{
    if (![[OSCAuthModel sharedAuthModel] checkAuthValid]) {
        [OSCGlobalConfig HUDShowMessage:@"请先登录" addedToView:KEY_WINDOW];
        return NO;
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)clearAccountDataWhenLogout
{
    [OSCAccountEntity deleteStoredUserAccount];
    [OSCGlobalConfig setLoginedUserEntity:nil];
    [OSCGlobalConfig setAuthUserID:nil];
    [OSCGlobalConfig setAuthAccessToken:nil];
    [OSCAuthModel releaseSharedAuthModel];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - App Info

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCCatalogType)catalogTypeForContentType:(OSCContentType)contentType
{
    OSCCatalogType catalogType = OSCCatalogType_News;
    switch (contentType) {
        case OSCContentType_LatestNews:
            catalogType = OSCCatalogType_News;
            break;
            
        case OSCContentType_LatestBlog:
        case OSCContentType_RecommendBlog:
            catalogType = OSCCatalogType_Blog;
            break;
            
        case OSCContentType_Forum:
            catalogType = OSCCatalogType_Forum;
            
            break;
            
        case OSCContentType_Tweet:
            catalogType = OSCCatalogType_Tweet;
            break;
            
        default:
            break;
    }
    return catalogType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Global UI

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view
{
    static MBProgressHUD* hud = nil;
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.hidden = NO;
    hud.alpha = 1.0f;
    [hud hide:YES afterDelay:1.0f];
    return hud;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle target:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createMenuBarButtonItemWithTarget:(id)target action:(SEL)action
{
    if (IOS_IS_AT_LEAST_7) {
        return [[UIBarButtonItem alloc] initWithImage:[UIImage nimbusImageNamed:@"icon_menu.png"]
                                                style:UIBarButtonItemStylePlain
                                               target:target action:action];
    }
    else {
        return [OSCGlobalConfig createBarButtonItemWithTitle:@"菜单" target:target action:action];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                         target:target action:action];
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)showLoginControllerFromNavigationController:(UINavigationController*)navigationController
{
    //OSCLoginC* loginC = [[OSCLoginC alloc] initWithStyle:UITableViewStyleGrouped];
    //[navigationController pushViewController:loginC animated:YES];
}

#pragma mark -
#pragma mark Emotion
+ (NSArray* )emotionsArray
{
    if (!emotionsArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:EMOTION_PLIST ofType:nil];
        NSArray* array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray* entities = [NSMutableArray arrayWithCapacity:array.count];
        OSCEmotionEntity* entity = nil;
        NSDictionary* dic = nil;
        for (int i = 0; i < array.count; i++) {
            dic = array[i];
            entity = [OSCEmotionEntity entityWithDictionary:dic atIndex:i];
            [entities addObject:entity];
        }
        emotionsArray = entities;
    }
    return emotionsArray;
}

+ (NSString*)imageNameForEmotionCode:(NSString*)code
{
    for (OSCEmotionEntity* e in [OSCGlobalConfig emotionsArray]) {
        if ([e.code isEqualToString:code]) {
            return e.imageName;
        }
    }
    return nil;
}

+ (NSString*)imageNameForEmotionName:(NSString*)name
{
    for (OSCEmotionEntity* e in [OSCGlobalConfig emotionsArray]) {
        if ([e.name isEqualToString:name]) {
            return e.imageName;
        }
    }
    return nil;
}

@end
