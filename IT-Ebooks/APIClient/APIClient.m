//
//  APIClient.m
//  IT-Ebook
//
//  Created by Aldo Castro on 05/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "APIClient.h"
#import "HttpClient.h"
#import "Books.h"

static const NSString *BASE_URL = @"http://it-ebooks-api.info/v1";

@interface APIClient() {
    HttpClient *httpClient;
}
@end

@implementation APIClient

- (instancetype)init
{
    if (self = [super init]) {
        httpClient = [[HttpClient alloc] init];
    }
    return self;
}

+ (APIClient *)shareInstance {
    static APIClient *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIClient alloc] init];
    });
    return _sharedInstance;
}

- (void)parseBooks:(NSDictionary *)json onSuccess:(void (^)(Books *results))success onFailure:(void(^)(NSError *error))failure {
    NSError *jsonError = nil;
    Books *results = [[Books alloc] initWithDictionary:json error:&jsonError];
    if (!jsonError) {
        if ([results.error isEqualToString:@"0"]) {
            success(results);
        } else {
          failure([NSError errorWithDomain:@"Response succeed with error." code:400 userInfo:@{@"Error Response:":results.error}]);
        }
    } else {
        failure(jsonError);
    }
}

- (void)searchByQuery:(NSString *)query onSuccess:(void (^)(Books *results))success onFailure:(void (^)(NSError *error))failure {
    NSString *urlPath = [NSString stringWithFormat:@"%@/search/%@", BASE_URL, query];
    [httpClient GET:urlPath withSuccess:^(NSDictionary *json) {
        [self parseBooks:json onSuccess:success onFailure:failure];
    } onFailure:failure];
}

- (void)searchByQuery:(NSString *)query onPage:(int)page onSuccess:(void (^)(Books *books))success onFailure:(void (^)(NSError *error))failure {
    NSString *urlPath = [NSString stringWithFormat:@"%@/search/%@/page/%i", BASE_URL, query, page];
    [httpClient GET:urlPath withSuccess:^(NSDictionary *json) {
        [self parseBooks:json onSuccess:success onFailure:failure];
    } onFailure:failure];
}

- (void)searchBookId:(NSString *)book_id onSuccess:(void(^)(Book *book))success onFailure:(void(^)(NSError *error))failure {
    NSString *urlPath = [NSString stringWithFormat:@"%@/book/%@", BASE_URL, book_id];
    [httpClient GET:urlPath withSuccess:^(NSDictionary *json) {
        success([[Book alloc] initWithDictionary:json error:NULL]);
    } onFailure:failure];
}

@end
