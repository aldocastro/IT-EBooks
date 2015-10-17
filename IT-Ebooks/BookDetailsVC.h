//
//  BookDetailsVC.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 07/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IBSBookDetails;
@interface BookDetailsVC : UIViewController {
    IBSBookDetails *_book;
}
@property (nonatomic, weak) UIImage *placeholder;
@property (nonatomic, weak) IBOutlet UIImageView *book_picture;
@property (nonatomic, weak) IBOutlet UILabel *book_title;
@property (nonatomic, weak) IBOutlet UILabel *book_subtitle;
@property (nonatomic, weak) IBOutlet UILabel *book_author;
@property (nonatomic, weak) IBOutlet UITextView *book_description;
@property (nonatomic, strong) NSString *bookID;
- (IBAction)downloadButtonPressed:(id)sender;
@end
