//
//  OSCAPIClient.m
//  SinaMBlogNimbus
//
//  Created by jimneylee on 13-7-25.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCAPIClient.h"

NSString *const kAPIBaseURLString = @"http://www.oschina.net/action/api/";

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
+ (NSString*)relativePathForLatestNewsListWithPageCounter:(unsigned int)pageCounter
                                             perpageCount:(unsigned int)perpageCount
{

    return [NSString stringWithFormat:@"/action/openapi/news_list?catalog=1&pageIndex=%u&pageSize=%u",
                                        pageCounter, perpageCount];
}

+ (NSString*)relativePathForLatestBlogsListWithPageCounter:(unsigned int)pageCounter
                                              perpageCount:(unsigned int)perpageCount
{
    
    return [NSString stringWithFormat:@"blog_list?type=latest&pageIndex=%u&pageSize=%u",
                                        pageCounter, perpageCount];
}

+ (NSString*)relativePathForRecommendBlogsListWithPageCounter:(unsigned int)pageCounter
                                                 perpageCount:(unsigned int)perpageCount
{
    
    return [NSString stringWithFormat:@"blog_list?type=recommend&pageIndex=%u&pageSize=%u",
            pageCounter, perpageCount];
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
                                         pageCounter:(unsigned int)pageCounter
                                        perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"comment_list?catalog=%u&id=%ld&pageIndex=%u&pageSize=%u",
                                        catalogType, contentId, pageCounter, perpageCount];
}

+ (NSString*)relativePathForRepliesListWithBlogId:(unsigned long)blogId
                                      pageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"blogcomment_list?id=%ld&pageIndex=%u&pageSize=%u",
                                        blogId, pageCounter, perpageCount];
}

+ (NSString*)relativePathForForumListWithForumType:(OSCForumTopicType)type
                                       pageCounter:(unsigned int)pageCounter
                                      perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"post_list?catalog=%u&pageIndex=%u&pageSize=%u",
                                        type+1, pageCounter, perpageCount];
}

+ (NSString*)relativePathForTweetListWithUserId:(NSString*)uid
                                    pageCounter:(unsigned int)pageCounter
                                   perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"tweet_list?uid=%@&pageIndex=%u&pageSize=%u",
                                        uid, pageCounter, perpageCount];
}

// 活动状态：所有、@我、评论、我的
+ (NSString*)relativePathForActiveListWithLoginedUserId:(unsigned long)loginUserId
                                      activeCatalogType:(OSCMyActiveCatalogType)activeCatalogType
                                            pageCounter:(unsigned int)pageCounter
                                           perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"active_list?uid=%ld&catalog=%u&pageIndex=%u&pageSize=%u",
            loginUserId, activeCatalogType, pageCounter, perpageCount];
}

+ (NSString*)relativePathForMyInfoWithLoginedUserId:(unsigned long)loginUserId
{
    return [NSString stringWithFormat:@"my_information?uid=%ld", loginUserId];
}

+ (NSString*)relativePathForUserActiveListWithUserId:(unsigned long)uid
                                          orUsername:(NSString*)username
                                       loginedUserId:(unsigned long)loginUserId
                                         pageCounter:(unsigned int)pageCounter
                                        perpageCount:(unsigned int)perpageCount
{
    if (username.length) {
        // 这个借口貌似无用
        return [NSString stringWithFormat:@"user_information?uid=%ld&hisname=%@&pageIndex=%u&pageSize=%u",
                loginUserId, [username urlEncoded], pageCounter, perpageCount];
    }
    else {
        return [NSString stringWithFormat:@"user_information?uid=%ld&hisuid=%ld&pageIndex=%u&pageSize=%u",
                loginUserId, uid, pageCounter, perpageCount];
    }
}

//================================================================================
// topic write
//================================================================================


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
                                      pageCounter:(unsigned int)pageCounter
                                     perpageCount:(unsigned int)perpageCount
{
    return [NSString stringWithFormat:@"friends_list?uid=%ld&pageIndex=%u&pageSize=%u",
            uid, pageCounter, perpageCount];
}

@end
