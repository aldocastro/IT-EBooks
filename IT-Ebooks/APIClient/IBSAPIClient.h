//
//  APIClient.h
//  IT-Ebook
//
//  Created by Aldo Castro on 05/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IBSBookSearch;
@class IBSBookDetails;
@interface IBSAPIClient : NSObject
+ (IBSAPIClient *)shareInstance;
- (void)searchByQuery:(NSString *)query onSuccess:(void (^)(IBSBookSearch *results))success onFailure:(void (^)(NSError *error))failure;
- (void)searchByQuery:(NSString *)query onPage:(int)page onSuccess:(void (^)(IBSBookSearch *books))success onFailure:(void (^)(NSError *error))failure;
- (void)searchBookId:(NSString *)book_id onSuccess:(void(^)(IBSBookDetails *book))success onFailure:(void(^)(NSError *error))failure;
@end
