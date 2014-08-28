//
//  RCReplyModel.m
//  JLOSChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCReplyModel.h"
#import "OSCAPIClient.h"
#import "AFHTTPRequestOperation.h"

@interface OSCReplyModel()
@property (nonatomic, assign) OSCCatalogType catalogType;
@end

@implementation OSCReplyModel

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - LifeCycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        self.itemElementNamesArray = @[XML_COMMENT];
        self.isReplyComment = NO;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

///////////////////////////////////////////////////////////////////////////////////////////////////
//TODO: repost
- (void)replyContentId:(NSString *)topicId
         catalogType:(OSCCatalogType)catalogType
                body:(NSString*)body
             success:(void(^)(OSCCommentEntity* replyEntity))success
             failure:(void(^)(OSCErrorEntity* errorEntity))failure
{
    self.successBlock = success;
    self.failureBlock = failure;
    self.catalogType = catalogType;
    if (topicId > 0 &&body.length) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithInt:catalogType]
                   forKey:@"catalog"];
        [params setObject:[OSCGlobalConfig getAuthUserID]
                   forKey:@"uid"];
        [params setObject:body forKey:@"content"];
        
        // api is so dirty, make me crazy! hold on...
        if (OSCCatalogType_Blog == self.catalogType) {
            [params setObject:topicId
                       forKey:@"blog"];
        }
        else {
            [params setObject:topicId
                       forKey:@"id"];
            //TODO: repost
            [params setObject:@"0"
                       forKey:@"isPostToMyZone"];
        }
        
        [self postParams:params errorBlock:^(OSCErrorEntity *errorEntity) {
            if (!errorEntity || ERROR_CODE_SUCCESS_200 == errorEntity.errorCode) {
                success(self.replyEntity);
            }
            else {
                failure(nil);
            }
        }];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//TODO: repost
- (void)replyCommentId:(NSString *)commentId
             contentId:(NSString *)topicId
           catalogType:(OSCCatalogType)catalogType
                  body:(NSString*)body
               success:(void(^)(OSCCommentEntity* replyEntity))success
               failure:(void(^)(OSCErrorEntity* error))failure;
{
    self.successBlock = success;
    self.failureBlock = failure;
    self.catalogType = catalogType;
    self.isReplyComment = YES;
    if (topicId > 0 &&body.length) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:[NSNumber numberWithInt:catalogType]
                   forKey:@"catalog"];
        [params setObject:[OSCGlobalConfig getAuthUserID]
                   forKey:@"uid"];
        [params setObject:topicId
                   forKey:@"id"];
        [params setObject:commentId
                   forKey:@"replyid"];
        [params setObject:body forKey:@"content"];
        //TODO: repost
        [params setObject:@"0" forKey:@"isPostToMyZone"];
        [self postParams:params errorBlock:^(OSCErrorEntity *errorEntity) {
            if (!errorEntity || ERROR_CODE_SUCCESS_200 == errorEntity.errorCode) {
                success(self.replyEntity);
            }
            else {
                failure(nil);
            }
        }];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    if (self.isReplyComment) {
        return [OSCAPIClient relativePathForReplyComment];
    }
    else {
        if (OSCCatalogType_Blog == self.catalogType) {
            return [OSCAPIClient relativePathForPostBlogComment];
        }
        else {
            return [OSCAPIClient relativePathForPostComment];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseDataDictionary
{
    NSMutableDictionary* dic = self.dataDictionary[XML_COMMENT];
    self.replyEntity = [OSCCommentEntity entityWithDictionary:dic];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad
{
    if (ERROR_CODE_SUCCESS_200 == self.errorEntity.errorCode) {
        self.successBlock(self.replyEntity);
    }
    else {
        self.failureBlock(self.errorEntity);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoad
{
    self.failureBlock(self.errorEntity);
}

@end
