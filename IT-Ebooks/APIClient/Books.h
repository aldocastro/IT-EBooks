//
// Created by Aldo Castro on 06/12/14.
// Copyright (c) 2014 Aldo Castro. All rights reserved.
//

@import UIKit;
#import <JSONModel/JSONModel.h>

/*
 Error	Error code / description (Note: request success code = 0)
 Time	Request query execution time (seconds)
 ID	The ID of the book
 Title	The title of the book
 SubTitle	The subtitle of the book
 Description	The description of the book
 Author	The author(s) name of the book
 ISBN	The International Standard Book Number (ISBN) of the book
 Page	The number of pages of the book
 Year	The publication date (year) of the book
 Publisher	The publisher of the book
 Image	The image URL of the book
 Download	The download URL of the book
 */

@protocol Book @end
@interface Book : JSONModel
@property (nonatomic, strong) NSString *mDescription;
@property (nonatomic, strong) NSString *mBookId;
@property (nonatomic, strong) NSURL *mImage;
@property (nonatomic, strong) NSString <Optional> *mSubTitle;
@property (nonatomic, strong) NSString *mTitle;
@property (nonatomic, strong) NSString *mIsbn;
-(UIImage *)getImage;
@end

@interface Books : JSONModel
@property (nonatomic, strong) NSArray<Optional, Book> *books;
@property (nonatomic, assign) NSString <Optional> *error;
@property (nonatomic, assign) NSString <Optional> *total;
@property (nonatomic, assign) NSString <Optional> *page;
@end