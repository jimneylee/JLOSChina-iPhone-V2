//
//  RCReplyModel.m
//  JLRubyChina
//
//  Created by Lee jimney on 12/11/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "OSCTweetPostModel.h"
#import "OSCAPIClient.h"
#import "AFHTTPRequestOperation.h"

@implementation OSCTweetPostModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        self.itemElementNamesArray = @[];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postNewTweetWithBody:(NSString*)body
                     success:(void(^)())success
                     failure:(void(^)(OSCErrorEntity *error))failure
{
    self.successBlock = success;
    self.failureBlock = failure;
    if (body.length) {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:body forKey:@"msg"];
        [params setObject:[OSCGlobalConfig getAuthUserID]
                   forKey:@"uid"];
        [self postParams:params errorBlock:^(OSCErrorEntity *errorEntity) {
            if (ERROR_CODE_SUCCESS == errorEntity.errorCode) {
                success();
            }
            else {
                failure(nil);
            }
        }];
    }
    else {
        if (failure) {
            OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
            errorEntity.errorMessage = @"啥动弹也没写";
            failure(errorEntity);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postNewTweetWithBody:(NSString*)body
                       image:(UIImage*)image
                     success:(void(^)())success
                     failure:(void(^)(OSCErrorEntity *error))failure
{
    self.successBlock = success;
    self.failureBlock = failure;
    if (!image) {
        [self postNewTweetWithBody:body success:success failure:failure];
    }
    else if (body.length) {
        NSString* path = [self relativePath];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:body forKey:@"msg"];
        [params setObject:[OSCGlobalConfig getAuthUserID]
                   forKey:@"uid"];
        
        NSDictionary *baseParams = [self generateParameters];
        NSMutableDictionary *fullParams = [NSMutableDictionary dictionaryWithDictionary:baseParams];
        if (params.count > 0) {
            [fullParams addEntriesFromDictionary:params];
        }
        
        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
        
        AFHTTPRequestOperation *operation = [[OSCAPIClient sharedClient] POST:path parameters:fullParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"img" fileName:@"image.jpg" mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSXMLParser class]]) {
                NSXMLParser* parser = (NSXMLParser*)responseObject;
                [parser setShouldProcessNamespaces:YES];
                parser.delegate = self;
                [parser parse];
            }
            else {
                if (failure) {
                    OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
                    failure(errorEntity);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
                failure(errorEntity);
            }
        }];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
    }
    else {
        if (failure) {
            OSCErrorEntity* errorEntity = [[OSCErrorEntity alloc] init];
            errorEntity.errorMessage = @"啥动弹也没写";
            failure(errorEntity);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)relativePath
{
    return [OSCAPIClient relativePathForPostNewTweet];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseDataDictionary
{

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad
{
    if (ERROR_CODE_SUCCESS_200 == self.errorEntity.errorCode) {
        self.successBlock();
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
