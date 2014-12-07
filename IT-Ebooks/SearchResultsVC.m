//
//  ViewController.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 06/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "SearchResultsVC.h"
#import "APIClient.h"
#import "Books.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <JGProgressHUD/JGProgressHUD.h>

static NSString *CellIdentifier = @"BookCell";

@implementation SearchResultsVC
{
    NSMutableArray *books;
    UIAlertController *alertController;
    JGProgressHUD *progressHUD, *noResultsHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    books = [@[] mutableCopy];
    self.title = @"IT Ebooks";
    self.collectionView.dataSource = self;
}

- (void)toogleHUD {
    if (!progressHUD) {
        progressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
        progressHUD.textLabel.text = @"Searching...";
        progressHUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
        [progressHUD showInView:self.view animated:YES];
    } else {
        [progressHUD dismissAnimated:YES];
        progressHUD = nil;
    }
}

- (void)showNoResultsFoundHUD {
    noResultsHUD = nil;
    noResultsHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    noResultsHUD.textLabel.text = @"No results found.";
    [noResultsHUD dismissAfterDelay:1.5 animated:YES];
    [noResultsHUD showInView:self.view];
}

- (void)doSearchFor:(NSString *)query {
    if (query && query.length>0) {
        [self toogleHUD];
        [[APIClient shareInstance] searchByQuery:query onSuccess:^(Books *result) {
            [self toogleHUD];
            if ([result.total isEqualToString:@"0"]) {
                [self showNoResultsFoundHUD];
                NSLog(@"No results found.");
            } else {
                [books addObjectsFromArray:result.books];
                [self.collectionView reloadData];
            }
        } onFailure:^(NSError *error) {
            [self toogleHUD];
            NSLog(@"error: %@", error.description);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Book *book = (Book*)books[indexPath.row];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    [imageView setImageWithURL:book.mImage placeholderImage:nil];
    return cell;
}

- (void)searchButtonPressed:(id)sender {
    if (!alertController) {
        __block UITextField *inputTextField;
        __weak typeof(self)weakSelf = self;
        alertController = [UIAlertController alertControllerWithTitle:@"Search E-book" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            inputTextField = textField;
            textField.placeholder = @"Enter query";
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf doSearchFor:inputTextField.text];
        }]];
    }
    [self presentViewController:alertController animated:YES completion:NULL];
}

@end
