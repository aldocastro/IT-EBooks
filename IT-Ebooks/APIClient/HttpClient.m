//
//  HttpClient.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 07/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>

@implementation HttpClient

//- (void)GET:(NSString *)path withSuccess:(void(^)(NSDictionary *json))success onFailure:(void(^)(NSError *error))failure {
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (!error) {
//            NSError *jsonError = nil;
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
//            if (!jsonError) {
//                success(json);
//            } else {
//                failure(jsonError);
//            }
//        } else {
//            failure(error);
//        }
//    }] resume];
//}

- (void)GET:(NSString *)path withSuccess:(void(^)(NSDictionary *json))success onFailure:(void(^)(NSError *error))failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:path]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (!operation.error) {
            NSString *jsonError = ((NSDictionary *)responseObject)[@"Error"];
            if (!jsonError && jsonError.length==0) {
                success(responseObject);
            } else {
                failure([NSError errorWithDomain:@"Bad Request?" code:400 userInfo:@{@"Error Response:":jsonError}]);
            }
        } else {
            failure(operation.error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error);
    }];
    [operation start];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
@end
