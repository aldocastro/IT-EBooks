//
//  HttpClient.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 07/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "IBSHttpClient.h"
#import "IBSReachabilityManager.h"

@interface IBSHttpClient()

@property(nonatomic, strong) NSString *baseURL;
@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic, strong) IBSReachabilityManager *reachabilityManager;

@end

@implementation IBSHttpClient
@synthesize baseURL = _baseURL;

- (instancetype)initWithBaseURL:(NSString *)baseUrl {
    self = [super init];
    if (self) {
        _baseURL = baseUrl;
        _reachabilityManager = [IBSReachabilityManager sharedInstance];
        NSURLSessionConfiguration *_configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [_configuration setRequestCachePolicy:NSURLRequestReloadIgnoringCacheData];
        _configuration.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
                                                 @"Accept-Language": @"en-US",
                                                 @"User-Agent": [[self class] userAgent]};
        _configuration.timeoutIntervalForRequest = 30;
        _session = [NSURLSession sessionWithConfiguration:_configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

+ (NSString *)userAgent {
    return [NSString stringWithFormat:@"IT-Ebooks/com.acastro.it-ebooks (%@; %@ %@)", [[UIDevice currentDevice] name], [[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
}

- (NSURL *)escapedTaskURLWithPath:(NSString *)path {
    NSString *escapedString = [[NSString stringWithFormat:@"%@%@",self.baseURL, path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:escapedString];
}

- (void)GET:(NSString *)path withSuccess:(void(^)(NSDictionary *json))success onFailure:(void(^)(NSError *error))failure {
    if ([self.reachabilityManager reachabilityStatus] == IBSReachabilityStatusReachable)
    {
        NSURL *escapedURL = [self escapedTaskURLWithPath:path];
        NSLog(@"escaped path: %@", escapedURL);
        [[self.session dataTaskWithURL:escapedURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (!error) {
                NSError *jsonError = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                if (json && !jsonError) {
                    NSLog(@"json: %@", json);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(json);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(jsonError);
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
        }] resume];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        failure([NSError errorWithDomain:@"UnreachableNetwork" code:10000 userInfo:@{@"":@""}]);
    }
}

@end
