//
//  RCUserEntity.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCActivityEntity.h"
#import "NSString+stringFromValue.h"
#import "NSDate+OSChina.h"
#import "RCRegularParser.h"
#import "RCKeywordEntity.h"
#import "OSCEmotionEntity.h"

@implementation OSCActivityEntity

//<active>
//<id>3926635</id>
//<portrait>http://static.oschina.net/uploads/user/512/1024297_50.jpg?t=1406766561000</portrait>
//<author><![CDATA[Android1989]]></author>
//<authorid>1024297</authorid>

//<catalog>4</catalog>
//<objecttype>3</objecttype>
//<objectcatalog>0</objectcatalog>
//<objecttitle><![CDATA[禁止ecshop杂志编辑器自动修改路径]]></objecttitle>
//<appclient>0</appclient>                <url></url>
//<objectID>304881</objectID>
//<message><![CDATA[ECSHOP杂志管理发送促销邮件功能十分强大，但每次编辑内容保存时，均会将HTML邮件内容的“src=”替换为’src=http://.$_SERVER["HTTP_HOST"]‘，即每次保存均在“src”引用的内容中增加站点路径，例如： 第一次保...]]></message>
//<commentCount>0</commentCount>
//<pubDate>2014-08-20 19:40:04</pubDate>
//<tweetimage></tweetimage>
//</active>

//<objectreply>
//<objectname><![CDATA[oscfox]]></objectname>
//<objectbody><![CDATA[使人烦恼的不是事物本身，而是人们对这事物的意见。]]></objectbody>
//</objectreply>

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        self.user = [OSCUserEntity entityWithDictionary:
                     @{@"author"   : [NSString stringFromValue:dic[@"author"]],
                       @"authorid" : [NSString stringFromValue:dic[@"authorid"]],
                       @"portrait" : [NSString stringFromValue:dic[@"portrait"]]}];
        self.activityId = dic[@"id"];
        self.catalogType = [dic[@"author"] intValue];

        self.objectId = dic[@"objectID"];
        self.objectType = [dic[@"objecttype"] intValue];
        self.objectTitle = dic[@"objecttitle"];
        self.objectContent = dic[@"message"];
        self.pubDate = [NSDate normalFormatDateFromString:dic[@"pubDate"]];
        
        // 二维直接被底层解析为一维，更方便
        self.objectReplyAuthorName = dic[@"objectname"];
        self.objectReplyBody = dic[@"objectbody"];
        
        self.tweetImageUrl = dic[@"tweetimage"];
        
        [self parseAllKeywords];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    OSCActivityEntity* entity = [[OSCActivityEntity alloc] initWithDictionary:dic];
    return entity;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// 识别出 表情 at某人 share软件(TODO:) 标签
- (void)parseAllKeywords
{
    if (self.objectContent.length) {
        if (!self.atPersonRanges) {
            self.atPersonRanges = [RCRegularParser keywordRangesOfAtPersonInString:self.objectContent];
        }
        if (!self.sharpSoftwareRanges) {
            self.sharpSoftwareRanges = [RCRegularParser keywordRangesOfSharpSoftwareInString:self.objectContent];
        }
        if (!self.emotionRanges) {
            NSString* trimedString = self.objectContent;
            self.emotionRanges = [RCRegularParser keywordRangesOfEmotionInString:self.objectContent trimedString:&trimedString];
            self.objectContent = trimedString;
            NSMutableArray* emotionImageNames = [NSMutableArray arrayWithCapacity:self.emotionRanges.count];
            for (RCKeywordEntity* keyworkEntity in self.emotionRanges) {
                NSString* keyword = keyworkEntity.keyword;
                for (OSCEmotionEntity* emotionEntity in [OSCGlobalConfig emotionsArray]) {
                    if ([keyword isEqualToString:emotionEntity.name]) {
                        [emotionImageNames addObject:emotionEntity.imageName];
                        break;
                    }
                }
            }
            self.emotionImageNames = emotionImageNames;
        }
        
        // if body's keywords are all emotion and get empty string, just set a space
        // for nil return in NIAttributedLabel: - (CGSize)sizeThatFits:(CGSize)size
        if (!self.objectContent.length) {
            self.objectContent = @" ";
        }
    }
}

@end
