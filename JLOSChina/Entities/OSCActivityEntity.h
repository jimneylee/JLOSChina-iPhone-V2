//
//  RCUserEntity.h
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

// 我的活动类型
// TODO:跟oscfox确认，职位评论是20还是32，或者我自己评论一个测试下
//1-开源软件、2-帖子、3-博客、4-新闻、5-代码、6-职位、7-翻译文章、
//8-翻译段落、16-新闻评论、17-讨论区答案、18-博客评论、19-代码评论、
//20-职位评论、21-翻译评论、32-职位评论、100-动弹、101-动弹回复

typedef NS_ENUM(NSInteger, OSCActiveObjectType) {
    OSCActiveObjectType_Project                 = 1,    // 开源软件
    OSCActiveObjectType_Forum                   = 2,    // 帖子
    OSCActiveObjectType_Blog                    = 3,    // 博客
    OSCActiveObjectType_News                    = 4,    // 新闻
    OSCActiveObjectType_Code                    = 5,    // 代码
    OSCActiveObjectType_Job                     = 6,    // 职位
    OSCActiveObjectType_ArticleTranslation      = 7,    // 翻译文章
    OSCActiveObjectType_ParagraphTranslation    = 8,    // 翻译段落
    OSCActiveObjectType_NewsComment             = 16,   // 新闻评论
    OSCActiveObjectType_ForumComment            = 17,   // 讨论区答案
    OSCActiveObjectType_BlogComment             = 18,   // 博客评论
    OSCActiveObjectType_CodeComment             = 19,   // 代码评论
    OSCActiveObjectType_JobComment              = 20,   // 职位评论
    OSCActiveObjectType_TranslationComment      = 21,   // 翻译评论
    OSCActiveObjectType_Tweet                   = 100,  // 动弹
    OSCActiveObjectType_TweetComment            = 101,  // 动弹回复
};

//<active>
//<id>3908244</id>
//<portrait>http://static.oschina.net/uploads/user/698/1397445_50.jpg?t=1384224479000</portrait>
//<author><![CDATA[oscfox]]></author>
//<authorid>1397445</authorid>
//<catalog>3</catalog>
//<objecttype>101</objecttype>
//<objectcatalog>0</objectcatalog>
//<objecttitle><![CDATA[]]></objecttitle>
//<appclient>3</appclient>

//<objectreply>
//<objectname><![CDATA[oscfox]]></objectname>
//<objectbody><![CDATA[使人烦恼的不是事物本身，而是人们对这事物的意见。]]></objectbody>
//</objectreply>

//<url></url>
//<objectID>3902954</objectID>
//<message><![CDATA[@jimney 看在你夸我的份上，答应你了]]></message>
//<commentCount>0</commentCount>
//<pubDate>2014-08-16 13:11:01</pubDate>
//<tweetimage></tweetimage>
//</active>

@interface OSCActivityEntity : JLNimbusEntity

@property (nonatomic, strong) OSCUserEntity* user;
@property (nonatomic, copy)   NSString *activityId;
@property (nonatomic, assign) OSCCatalogType catalogType;
@property (nonatomic, copy)   NSString *objectId;
@property (nonatomic, assign) OSCActiveObjectType objectType;
@property (nonatomic, copy)   NSString *objectTitle;
@property (nonatomic, copy)   NSString *objectContent;
@property (nonatomic, copy)   NSDate   *pubDate;
@property (nonatomic, copy)   NSString *objectReplyAuthorName;
@property (nonatomic, copy)   NSString *objectReplyBody;
@property (nonatomic, copy)   NSString *tweetImageUrl;
@property (nonatomic, copy)   NSString *commentCount;
@property (nonatomic, copy)   NSString *appClientName;
@property (nonatomic, copy)   NSString *fullTitle;
@property (nonatomic, strong)   NSAttributedString *fullTitleAttributedString;

@property (nonatomic, strong) NSArray* atPersonRanges;
@property (nonatomic, strong) NSArray* sharpSoftwareRanges;
@property (nonatomic, strong) NSArray* emotionRanges;
@property (nonatomic, strong) NSArray* emotionImageNames;

@end
