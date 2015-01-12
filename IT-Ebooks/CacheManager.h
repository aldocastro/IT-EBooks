//
//  CacheManager.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 11/01/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject
+ (instancetype)sharedInstance;
- (void)cacheImageData:(NSData *)imageData withIdentifier:(NSString *)identifier;
- (NSData *)cachedImageDataWithIdentifier:(NSString *)identifier;
@end
