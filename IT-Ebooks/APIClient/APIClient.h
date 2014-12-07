//
//  APIClient.h
//  IT-Ebook
//
//  Created by Aldo Castro on 05/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Books;
@class Book;
@interface APIClient : NSObject
+ (APIClient *)shareInstance;
- (void)searchByQuery:(NSString *)query onSuccess:(void (^)(Books *results))success onFailure:(void (^)(NSError *error))failure;
- (void)searchByQuery:(NSString *)query onPage:(int)page onSuccess:(void (^)(Books *books))success onFailure:(void (^)(NSError *error))failure;
- (void)searchBookId:(NSString *)book_id onSuccess:(void(^)(Book *book))success onFailure:(void(^)(NSError *error))failure;
@end
