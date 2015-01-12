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

@interface APIClient() {
    HttpClient *httpClient;
}
@end

@implementation APIClient

- (instancetype)init {
    if (self = [super init]) {
        httpClient = [[HttpClient alloc] initWithBaseURL:@"http://it-ebooks-api.info/v1"];
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

- (void)parseBooks:(NSDictionary *)json onSuccess:(void (^)(BookSearch *results))success onFailure:(void(^)(NSError *error))failure {
    NSError *jsonError = nil;
    BookSearch *results = [[BookSearch alloc] initWithDictionary:json error:&jsonError];
    if (!jsonError) {
        if (!results.Error) {
            success(results);
        } else {
          failure([NSError errorWithDomain:@"Response succeed with error." code:400 userInfo:@{@"Error Response:":results.Error}]);
        }
    } else {
        failure(jsonError);
    }
}

- (void)searchByQuery:(NSString *)query onSuccess:(void (^)(BookSearch *results))success onFailure:(void (^)(NSError *error))failure {
    NSString *urlPath = [NSString stringWithFormat:@"/search/%@", query];
    [httpClient GET:urlPath withSuccess:^(NSDictionary *json) {
        [self parseBooks:json onSuccess:success onFailure:failure];
    } onFailure:failure];
}

- (void)searchByQuery:(NSString *)query onPage:(int)page onSuccess:(void (^)(BookSearch *books))success onFailure:(void (^)(NSError *error))failure {
    NSString *urlPath = [NSString stringWithFormat:@"/search/%@/page/%i", query, page];
    [httpClient GET:urlPath withSuccess:^(NSDictionary *json) {
        [self parseBooks:json onSuccess:success onFailure:failure];
    } onFailure:failure];
}

- (void)searchBookId:(NSString *)book_id onSuccess:(void(^)(BookDetails *book))success onFailure:(void(^)(NSError *error))failure {
    NSString *urlPath = [NSString stringWithFormat:@"/book/%@", book_id];
    [httpClient GET:urlPath withSuccess:^(NSDictionary *json) {
        success([[BookDetails alloc] initWithDictionary:json error:NULL]);
    } onFailure:failure];
}

#pragma mark - Debug utils methods

- (void)getExampleJSONNamed:(NSString *)jsonName withSuccess:(void(^)(BookSearch *books))success failure:(void(^)(NSError *error))failure {
    NSDictionary *json = [self loadLocalJSON:jsonName];
    if (!json) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure([NSError errorWithDomain:@"Response succeed with error." code:400 userInfo:@{@"Error Response:":@"JSON parsing failed"}]);
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseBooks:json onSuccess:success onFailure:failure];
        });
    }
}

-(NSDictionary *)loadLocalJSON:(NSString *)jsonName{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        return jsonParsed;
    } else {
        return nil;
    }
}

@end
