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
    JGProgressHUD *progressHUD;
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
        [progressHUD showInView:self.view animated:YES];
    } else {
        [progressHUD dismissAnimated:YES];
        progressHUD = nil;
    }
}

- (void)doSearchFor:(NSString *)query {
    [self toogleHUD];
    [[APIClient shareInstance] searchByQuery:query onSuccess:^(Books *result) {
        [self toogleHUD];
        [books addObjectsFromArray:result.books];
        [self.collectionView reloadData];
    } onFailure:^(NSError *error) {
        [self toogleHUD];
        NSLog(@"error: %@", error.description);
    }];
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
        alertController = [UIAlertController alertControllerWithTitle:@"Search" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            inputTextField = textField;
            textField.placeholder = @"search query";
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf doSearchFor:inputTextField.text];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:NULL]];
    }
    [self presentViewController:alertController animated:YES completion:NULL];
}

@end
