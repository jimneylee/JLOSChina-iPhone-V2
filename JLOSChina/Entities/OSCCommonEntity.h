//
//  RCTopicEntity.h
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"
#import "OSCUserEntity.h"

@interface OSCCommonEntity : JLNimbusEntity

@property (nonatomic, strong) OSCUserEntity *user;
@property (nonatomic, copy)   NSString *newsId;
@property (nonatomic, strong) NSDate *createdAtDate;
@property (nonatomic, assign) long long repliesCount;

@end
