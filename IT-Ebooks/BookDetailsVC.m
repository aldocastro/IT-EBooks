//
//  BookDetailsVC.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 07/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "BookDetailsVC.h"
#import "Books.h"

@interface BookDetailsVC()
@property (nonatomic) Book *book;
@end

@implementation BookDetailsVC

-(void)setBook:(Book *)book {
    if (book != nil) {
        self.book = book;
    }
}

@end
