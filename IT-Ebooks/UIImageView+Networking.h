//
//  UIImageView+Networking.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 10/01/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Networking)
- (instancetype)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
