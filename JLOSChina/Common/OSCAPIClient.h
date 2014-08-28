//
//  OSCAPIClient.h
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLAFAPIBaseClient.h"

@interface OSCAPIClient : JLAFAPIBaseClient

+ (OSCAPIClient*)sharedClient;

//================================================================================
// account sing in
//================================================================================
// 登录
+ (NSString*)relativePathForSignIn;

//================================================================================
// topic read
//================================================================================

// 资讯、博客、推荐阅读
+ (NSString*)relativePathForLatestNewsListWithPageIndex:(unsigned int)pageIndex
                                               pageSize:(unsigned int)pageSize;

+ (NSString*)relativePathForLatestBlogsListWithPageIndex:(unsigned int)pageIndex
                                                pageSize:(unsigned int)pageSize;

+ (NSString*)relativePathForRecommendBlogsListWithPageIndex:(unsigned int)pageIndex
                                                   pageSize:(unsigned int)pageSize;

// 内容详细接口
+ (NSString*)relativePathForNewsDetailWithId:(NSString *)newsId;

+ (NSString*)relativePathForBlogDetailWithId:(NSString *)blogId;

+ (NSString*)relativePathForTopicDetailWithId:(NSString *)blogId;

// 回复列表接口
+ (NSString*)relativePathForRepliesListWithCatalogType:(OSCCatalogType)catalogType
                                             contentId:(NSString *)contentId
                                             pageIndex:(unsigned int)pageIndex
                                              pageSize:(unsigned int)pageSize;

+ (NSString*)relativePathForRepliesListWithBlogId:(NSString *)blogId
                                        pageIndex:(unsigned int)pageIndex
                                         pageSize:(unsigned int)pageSize;

// 社区分类列表
+ (NSString*)relativePathForForumListWithType:(OSCForumTopicType)type
                                    pageIndex:(unsigned int)pageIndex
                                     pageSize:(unsigned int)pageSize;

// 最新动弹
+ (NSString*)relativePathForTweetListWithUserId:(NSString*)uid
                                      pageIndex:(unsigned int)pageIndex
                                       pageSize:(unsigned int)pageSize;

// 活动状态：所有、@我、评论、我的
+ (NSString*)relativePathForActiveListWithLoginedUserId:(NSString *)uid
                                      activeCatalogType:(OSCMyActiveCatalogType)activeCatalogType
                                              pageIndex:(unsigned int)pageIndex
                                               pageSize:(unsigned int)pageSize;

+ (NSString*)relativePathForUserActiveListWithUserId:(NSString *)uid
                                   activeCatalogType:(OSCMyActiveCatalogType)activeCatalogType
                                           pageIndex:(unsigned int)pageIndex
                                            pageSize:(unsigned int)pageSize;

+ (NSString*)relativePathForMyInfo;

+ (NSString*)relativePathForUserInfoWithUserId:(NSString *)uid
                                    orUsername:(NSString*)username;

+ (NSString*)relativePathForUpdateUserRelationship;

// 收藏列表 0-全部|1-软件|2-话题|3-博客|4-新闻|5代码|7-翻译
+ (NSString*)relativePathForFavoriteListWithCatalogType:(OSCMyFavoriteCatalogType)catalogType
                                              pageIndex:(unsigned int)pageIndex
                                               pageSize:(unsigned int)pageSize;

//================================================================================
// topic write
//================================================================================
+ (NSString*)relativePathForPostNewTweet;
+ (NSString*)relativePathForReplyComment;
+ (NSString*)relativePathForPostComment;
+ (NSString*)relativePathForPostBlogComment;

//================================================================================
// my info
//================================================================================

+ (NSString*)relativePathForFriendsListWithUserId:(NSString *)uid
                                        pageIndex:(unsigned int)pageIndex
                                         pageSize:(unsigned int)pageSize;

//================================================================================
// search
//================================================================================

+ (NSString*)relativePathForSearchWithCatalogName:(NSString *)catalogName
                                         keywords:(NSString *)keywords
                                        pageIndex:(unsigned int)pageIndex
                                         pageSize:(unsigned int)pageSize;

@end

NSString *const kAPIBaseURLString;