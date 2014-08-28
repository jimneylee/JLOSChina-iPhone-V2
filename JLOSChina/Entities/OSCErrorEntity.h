//
//  RCUserEntity.h
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#define ERROR_CODE_SUCCESS_200 200
#define ERROR_CODE_DEFAULT_FAILURE 0

@interface OSCErrorEntity : NSObject
@property (nonatomic, assign) NSUInteger errorCode;
@property (nonatomic, copy) NSString* errorMessage;

+ (id)entityWithDictionary:(NSDictionary*)dic;
- (id)initWithDictionary:(NSDictionary*)dic;

@end
