//
//  RCUserEntity.h
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCUserEntity.h"

//view-source:http://www.oschina.net/action/api/my_information?uid=121801
//<user>
//    <name><![CDATA[jimney]]></name>
//    <portrait><![CDATA[http://static.oschina.net/uploads/user/60/121801_100.jpg?t=1389938746000]]></portrait>
//    <jointime>2011-02-22 17:27:05</jointime>
//    <gender>1</gender>
//    <from><![CDATA[江苏 常州]]></from>
//    <devplatform><![CDATA[Android,iOS/Objective-C,C/C++,Linux/Unix]]></devplatform>
//    <expertise><![CDATA[手机软件开发]]></expertise>
//    <favoritecount>0</favoritecount>
//    <fanscount>8</fanscount>
//    <followerscount>0</followerscount>
//</user>

// 好友关系 关注情况：1-已关注（对方未关注我）2-相互关注 3-未关注
typedef NS_ENUM(NSInteger, OSCRelationshipType) {
    OSCRelationshipType_AttationFromMe = 1, //1-已关注（对方未关注我）
    OSCRelationshipType_AttationEachOther = 2,//2-相互关注
    OSCRelationshipType_NotAttation = 3,      //3-未关注
    OSCRelationshipType_Unknown
};

@interface OSCUserFullEntity : OSCUserEntity

@property (nonatomic, copy) NSString* location;
@property (nonatomic, copy) NSString* joinTime;
@property (nonatomic, copy) NSString* gender;
@property (nonatomic, copy) NSString* platforms;
@property (nonatomic, copy) NSString* expertise;
@property (nonatomic, assign) OSCRelationshipType relationshipType;

@property (nonatomic, assign) long long followersCount;
@property (nonatomic, assign) long long fansCount;
@property (nonatomic, assign) long long favoriteCount;

@end
