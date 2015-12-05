//
//  BookCell.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 06/01/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import "BookCell.h"
#import "IBSBooks.h"
#import "UIImageView+Networking.h"

@implementation BookCell

- (void)setCellWithBook:(IBSBooks *)book {
    if (book) {
        self.book = book;
        [self.picture setImageWithURL:self.book.Image placeholderImage:[UIImage imageNamed:@"placeholder-small"]];
    }
}

@end
