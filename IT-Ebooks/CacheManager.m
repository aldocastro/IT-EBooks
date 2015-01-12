//
//  CacheManager.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 11/01/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import "CacheManager.h"

@interface CacheManager ()
@property (nonatomic, strong) NSCache *cache;
@end

@implementation CacheManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static CacheManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[CacheManager alloc] init];
    });
    return shared;
}

- (void)cacheImageData:(NSData *)imageData withIdentifier:(NSString *)identifier {
    if (!imageData && identifier && identifier.length<1) return;
    [_cache setObject:imageData forKey:identifier];
}

- (NSData *)cachedImageDataWithIdentifier:(NSString *)identifier {
    if (!identifier && identifier.length<1) return nil;
    NSData *cachedImageData = [_cache objectForKey:identifier];
    return cachedImageData;
}

@end
