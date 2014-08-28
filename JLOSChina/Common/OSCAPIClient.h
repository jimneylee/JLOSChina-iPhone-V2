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
+ (NSString*)relativePathForNewsDetailWithId:(unsigned long)newsId;

+ (NSString*)relativePathForBlogDetailWithId:(unsigned long)blogId;

+ (NSString*)relativePathForTopicDetailWithId:(unsigned long)blogId;

// 回复列表接口
+ (NSString*)relativePathForRepliesListWithCatalogType:(unsigned int)catalogType
                                             contentId:(unsigned long)contentId
                                             pageIndex:(unsigned int)pageIndex
                                              pageSize:(unsigned int)pageSize;

+ (NSString*)relativePathForRepliesListWithBlogId:(unsigned long)blogId
                                        pageIndex:(unsigned int)pageIndex
                                         pageSize:(unsigned int)pageSize;

// 社区分类列表
+ (NSString*)relativePathForForumListWithCatalogId:(NSString *)catalogId
                                         pageIndex:(unsigned int)pageIndex
                                          pageSize:(unsigned int)pageSize;

// 最新动弹
+ (NSString*)relativePathForTweetListWithUserId:(NSString*)uid
                                      pageIndex:(unsigned int)pageIndex
                                       pageSize:(unsigned int)pageSize;

// 活动状态：所有、@我、评论、我的
+ (NSString*)relativePathForActiveListWithLoginedUserId:(long long)uid
                                      activeCatalogType:(OSCMyActiveCatalogType)activeCatalogType
                                              pageIndex:(unsigned int)pageIndex
                                               pageSize:(unsigned int)pageSize;

+ (NSString*)relativePathForUserActiveListWithUserId:(long long)uid
                                   activeCatalogType:(OSCMyActiveCatalogType)activeCatalogType
                                           pageIndex:(unsigned int)pageIndex
                                            pageSize:(unsigned int)pageSize;

+ (NSString*)relativePathForMyInfo;

+ (NSString*)relativePathForUserInfoWithUserId:(long long)uid
                                    orUsername:(NSString*)username;

+ (NSString*)relativePathForUpdateUserRelationship;

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

+ (NSString*)relativePathForFriendsListWithUserId:(unsigned long)uid
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