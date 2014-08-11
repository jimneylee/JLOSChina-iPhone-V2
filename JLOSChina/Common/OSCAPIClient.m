//
//  OSCAPIClient.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCAPIClient.h"

NSString *const kAPIBaseURLString = @"http://www.oschina.net/action/openapi/";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation OSCAPIClient

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (OSCAPIClient*)sharedClient
{
    static OSCAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OSCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    });
    
    return _sharedClient;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    return self;
}

#pragma mark - Sign in
// 登录
+ (NSString*)relativePathForSignIn
{
    return [NSString stringWithFormat:@"login_validate"];
}

#pragma mark - Topics
// 活跃帖子、优质帖子、无人问津、最近创建
// TODO: add topic type:
// http://www.oschina.net/openapi/docs/news_list
+ (NSString*)relativePathForLatestNewsListWithPageIndex:(unsigned int)pageIndex
                                               pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"news_list?catalog=1&pageIndex=%u&pageSize=%u",
            pageIndex, pageSize];
}

+ (NSString*)relativePathForLatestBlogsListWithPageIndex:(unsigned int)pageIndex
                                                pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"blog_list?pageIndex=%u&pageSize=%u",
            pageIndex, pageSize];
}

+ (NSString*)relativePathForRecommendBlogsListWithPageIndex:(unsigned int)pageIndex
                                                   pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"blog_recommend_list?pageIndex=%u&pageSize=%u",
            pageIndex, pageSize];
}

+ (NSString*)relativePathForNewsDetailWithId:(unsigned long)newsId
{
    return [NSString stringWithFormat:@"news_detail?id=%ld", newsId];
}

+ (NSString*)relativePathForBlogDetailWithId:(unsigned long)blogId
{
    return [NSString stringWithFormat:@"blog_detail?id=%ld", blogId];
}

+ (NSString*)relativePathForTopicDetailWithId:(unsigned long)blogId
{
    return [NSString stringWithFormat:@"post_detail?id=%ld", blogId];
}

+ (NSString*)relativePathForRepliesListWithCatalogType:(unsigned int)catalogType
                                             contentId:(unsigned long)contentId
                                             pageIndex:(unsigned int)pageIndex
                                              pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"comment_list?catalog=%u&id=%ld&pageIndex=%u&pageSize=%u",
            catalogType, contentId, pageIndex, pageSize];
}

+ (NSString*)relativePathForRepliesListWithBlogId:(unsigned long)blogId
                                        pageIndex:(unsigned int)pageIndex
                                         pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"blog_comment_list?id=%ld&pageIndex=%u&pageSize=%u",
            blogId, pageIndex, pageSize];
}

+ (NSString*)relativePathForForumListWithCatalogId:(NSString *)catalogId
                                         pageIndex:(unsigned int)pageIndex
                                          pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"post_list?catalog=%@&pageIndex=%u&pageSize=%u",
            catalogId, pageIndex, pageSize];
}

//用户ID [ 0：最新动弹，-1：热门动弹，其他：我的动弹 ]
+ (NSString*)relativePathForTweetListWithUserId:(NSString*)uid
                                      pageIndex:(unsigned int)pageIndex
                                       pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"tweet_list?user=%@&pageIndex=%u&pageSize=%u",
            uid, pageIndex, pageSize];
}

// 活动状态：所有、@我、评论、我的
// catalog : 类别ID [ 0、1所有动态,2提到我的,3评论,4我自己 ]
+ (NSString*)relativePathForActiveListWithLoginedUserId:(long long)uid
                                      activeCatalogType:(OSCMyActiveCatalogType)activeCatalogType
                                              pageIndex:(unsigned int)pageIndex
                                               pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"active_list?user=%lld&catalog=%u&pageIndex=%u&pageSize=%u",
            uid, activeCatalogType, pageIndex, pageSize];
}

+ (NSString*)relativePathForUserActiveListWithUserId:(long long)uid
                                          orUsername:(NSString*)username
                                           pageIndex:(unsigned int)pageIndex
                                            pageSize:(unsigned int)pageSize
{
    if (username.length) {
        return [NSString stringWithFormat:@"active_list?friend_name=%@&pageIndex=%u&pageSize=%u",
                [username urlEncoded], pageIndex, pageSize];
    }
    else {
        return [NSString stringWithFormat:@"active_list?friend=%lld&pageIndex=%u&pageSize=%u",
                uid, pageIndex, pageSize];
    }
}

+ (NSString*)relativePathForMyInfo
{
    return [NSString stringWithFormat:@"my_information"];
}

+ (NSString*)relativePathForUserInfoWithUserId:(long long)uid
                                    orUsername:(NSString*)username
{
    if (username.length) {
        return [NSString stringWithFormat:@"user_information?friend_name=%@",
                [username urlEncoded]];
    }
    else {
        return [NSString stringWithFormat:@"user_information?friend=%lld",
                uid];
    }
}

+ (NSString*)relativePathForUpdateUserRelationship
{
    return [NSString stringWithFormat:@"update_user_relation"];
}

//================================================================================
// topic write
//================================================================================

#pragma mark - Post

+ (NSString*)relativePathForPostNewTweet
{
    return [NSString stringWithFormat:@"tweet_pub"];
}

+ (NSString*)relativePathForReplyComment
{
    return [NSString stringWithFormat:@"comment_reply"];
}

+ (NSString*)relativePathForPostComment
{
    return [NSString stringWithFormat:@"comment_pub"];
}

+ (NSString*)relativePathForPostBlogComment
{
    return [NSString stringWithFormat:@"blogcomment_pub"];
}

//================================================================================
// my info
//================================================================================

+ (NSString*)relativePathForFriendsList
{
    return [NSString stringWithFormat:@"friends_list"];
}

+ (NSString*)relativePathForFriendsListWithUserId:(unsigned long)uid
                                        pageIndex:(unsigned int)pageIndex
                                         pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"friends_list?uid=%ld&pageIndex=%u&pageSize=%u",
            uid, pageIndex, pageSize];
}

//================================================================================
// search
//================================================================================

+ (NSString*)relativePathForSearchWithCatalogName:(NSString *)catalogName
                                         keywords:(NSString *)keywords
                                        pageIndex:(unsigned int)pageIndex
                                         pageSize:(unsigned int)pageSize
{
    return [NSString stringWithFormat:@"search_list?catalog=%@&q=%@&pageIndex=%u&pageSize=%u",
            catalogName, keywords, pageIndex, pageSize];
}

@end
