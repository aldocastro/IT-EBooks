//
//  UIImageView+Networking.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 10/01/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import "UIImageView+Networking.h"
#import "CacheManager.h"

@implementation UIImageView (Networking)
- (instancetype)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    self.image = placeholder;
    //  identifier of the picture for cache
    NSString *identifier = [NSString stringWithFormat:@"%@", [url lastPathComponent]];
    dispatch_queue_t imageFetchQueue = dispatch_queue_create("Image Fetcher", NULL);
    dispatch_async(imageFetchQueue, ^{
        UIImage *image;
        NSData *cachedImageData = [[CacheManager sharedInstance] cachedImageDataWithIdentifier:identifier];
        if(cachedImageData) {
            //  get image from cache data.
            image = [[UIImage alloc] initWithData:cachedImageData];
        } else {
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
            //  save data into cache
            [[CacheManager sharedInstance] cacheImageData:imageData withIdentifier:identifier];
            image = [[UIImage alloc] initWithData:imageData];
        }
        if (image) {
            //  push image into main queue to be displayed.
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
        }
    });
    return self;
}
@end
