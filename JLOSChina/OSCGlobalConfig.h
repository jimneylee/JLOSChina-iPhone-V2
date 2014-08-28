//
//  RCGlobalConfig.h
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCUserFullEntity.h"

// 首页分栏类型
typedef NS_ENUM(NSInteger, OSCHomeType) {
    OSCHomeType_LatestNews,      //最新资讯
    OSCHomeType_LatestBlog,      //最新博客
    OSCHomeType_RecommendBlog,   //推荐博客
};

// 社区活动类型
typedef NS_ENUM(NSInteger, OSCForumTopicType) {
    OSCForumTopicType_All,      //所有->0
    OSCForumTopicType_QA,       //问答->1
    OSCForumTopicType_Share,    //分享->2
    OSCForumTopicType_Watering, //灌水->3
    OSCForumTopicType_Feedback, //站务->4
    OSCForumTopicType_Career,   //职业->100
};

// 动弹类型
typedef NS_ENUM(NSInteger, OSCTweetType) {
    OSCTweetType_Latest,    //最新 uid=0
    OSCTweetType_Hot,       //热门 uid=-1
    OSCTweetType_Mine,      //我的 uid=id
};

// 分类类型
typedef NS_ENUM(NSInteger, OSCCatalogType) {
    OSCCatalogType_News  = 1,
    OSCCatalogType_Forum = 2,
    OSCCatalogType_Tweet = 3,
    OSCCatalogType_Blog  = 4,
    OSCCatalogType_Other = 0
};

// 我的活动类型
typedef NS_ENUM(NSInteger, OSCMyActiveCatalogType) {
    OSCMyActiveCatalogType_All = 1,
    OSCMyActiveCatalogType_AtMe = 2,
    OSCMyActiveCatalogType_Comment = 3,
    OSCMyActiveCatalogType_Mine = 4
};

// 我的收藏类型
typedef NS_ENUM(NSInteger, OSCMyFavoriteCatalogType) {
    OSCMyFavoriteCatalogType_All = 0,
    OSCMyFavoriteCatalogType_Software = 1,
    OSCMyFavoriteCatalogType_Topic = 2,
    OSCMyFavoriteCatalogType_Blog = 3,
    OSCMyFavoriteCatalogType_News = 4,
    OSCMyFavoriteCatalogType_Code = 5,
    OSCMyFavoriteCatalogType_Translation = 7,
};

// 客户端类型：1-WEB、2-WAP、3-Android、4-IOS、5-WP
typedef NS_ENUM(NSInteger, OSCAppClientType) {
    OSCAppClientType_WEB        = 1,
    OSCAppClientType_WAP        = 2,
    OSCAppClientType_Android    = 3,
    OSCAppClientType_IOS        = 4,
    OSCAppClientType_WP         = 5
};

@interface OSCGlobalConfig : NSObject

//Global Data
+ (NSString *)getAuthAccessToken;
+ (void)setAuthAccessToken:(NSString *)accessToken;

+ (NSString *)getAuthUserID;
+ (void)setAuthUserID:(NSString *)userID;

//+ (OSCUserFullEntity*)loginedUserEntity;
//+ (void)setLoginedUserEntity:(OSCUserFullEntity*)userEntity;

+ (BOOL)checkAuthValid;
+ (void)clearAccountDataWhenLogout;

// App Info
//+ (OSCCatalogType)catalogTypeForContentType:(OSCContentType)contentType;
+ (NSString *)getNameFromAppClientType:(OSCAppClientType)appClientType;

// Global UI
+ (MBProgressHUD*)HUDShowMessage:(NSString*)msg addedToView:(UIView*)view;
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createMenuBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem*)createRefreshBarButtonItemWithTarget:(id)target action:(SEL)action;
+ (void)showLoginControllerFromNavigationController:(UINavigationController*)navigationController;

// Emotion
+ (NSArray* )emotionsArray;
+ (NSString*)imageNameForEmotionCode:(NSString*)code;
+ (NSString*)imageNameForEmotionName:(NSString*)name;

@end
