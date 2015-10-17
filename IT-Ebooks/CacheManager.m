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

- (BOOL)isImageDataInCacheWithIdentifier:(NSString *)identifier {
    @try {
        NSData *cachedImageData = [_cache objectForKey:identifier];
        return cachedImageData && [cachedImageData isKindOfClass:[NSData class]];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}

- (void)cacheImageData:(NSData *)imageData withIdentifier:(NSString *)identifier {
    if (!imageData && identifier && identifier.length<1 && ![self isImageDataInCacheWithIdentifier:identifier]) return;
    @try {
        [_cache setObject:imageData forKey:identifier];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
}

- (NSData *)cachedImageDataWithIdentifier:(NSString *)identifier {
    if (!identifier && identifier.length<1) return nil;
    @try {
        NSData *cachedImageData = [_cache objectForKey:identifier];
        return cachedImageData;
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    return nil;
}

@end
