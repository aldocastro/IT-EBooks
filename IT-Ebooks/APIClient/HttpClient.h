//
//  HttpClient.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 07/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

@import Foundation;

@interface HttpClient : NSObject
- (void)GET:(NSString *)path withSuccess:(void(^)(NSDictionary *json))success onFailure:(void(^)(NSError *error))failure;
@end
