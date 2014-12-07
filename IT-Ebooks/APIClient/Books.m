//
// Created by Aldo Castro on 06/12/14.
// Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "Books.h"

@implementation Book
+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
            @"Description": @"mDescription",
            @"ID": @"mBookId",
            @"Image": @"mImage",
            @"SubTitle":@"mSubTitle",
            @"Title":@"mTitle",
            @"isbn":@"mIsbn"
    }];
}

- (void)setMImage:(NSURL *)mImage {
    NSLog(@"mImage: %@", mImage);
    _mImage = mImage;
}

-(UIImage *)getImage {
    return self.mImage ? [UIImage imageWithData:[NSData dataWithContentsOfURL:self.mImage]] : nil;
}

@end

@implementation Books
+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
            @"Books": @"books"
    }];
}
@end