//
//  BookDetailsVC.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 07/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "BookDetailsVC.h"
#import "IBSBooks.h"
#import "IBSAPIClient.h"
#import "UIImageView+Networking.h"

//  TODO: prepare view when there is no data to show.

@implementation BookDetailsVC {
    UITapGestureRecognizer *imageTapGestureRecognizer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IBSAPIClient shareInstance] searchBookId:_bookID onSuccess:^(IBSBookDetails *book) {
        if (book && !book.Error) {
            _book = book;
            [self updateUI];
        }
    } onFailure:^(NSError *error) {
        NSLog(@"error: %@", error.debugDescription);
    }];
}

- (void)updateUI {
    self.title = _book.Title;
    [self.book_title setText:_book.Title];
    [self.book_subtitle setText:_book.SubTitle];
    [self.book_author setText:_book.Author];
    [self.book_description setText:_book.Description];
    [self.book_picture setImageWithURL:_book.Image placeholderImage:[UIImage imageNamed:@"placeholder-medium"]];
    imageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImageViewer:)];
    [self.book_picture addGestureRecognizer:imageTapGestureRecognizer];
    [self.book_picture setUserInteractionEnabled:YES];
}

- (void)openImageViewer:(UITapGestureRecognizer *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"imageViewer"];
    UIImageView *imageView = (UIImageView *)[viewController.view viewWithTag:1];
    viewController.title = _book.Title;
    [imageView setImageWithURL:_book.Image placeholderImage:self.book_picture.image];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)downloadButtonPressed:(id)sender {
    
}

@end
