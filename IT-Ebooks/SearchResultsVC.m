//
//  ViewController.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 06/12/14.
//  Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "SearchResultsVC.h"
#import "IBSAPIClient.h"
#import "IBSBooks.h"
#import "BookCell.h"
#import "BookDetailsVC.h"
#import <JGProgressHUD/JGProgressHUD.h>

static NSString *CellIdentifier = @"BookCell";

@interface SearchResultsVC() <UICollectionViewDataSource, UISearchBarDelegate>
{
    int currentPage;
    NSString *query;
    NSMutableArray *books;
    JGProgressHUD *progressHUD, *noResultsHUD;
    UITapGestureRecognizer *tapGestureRecognizer;
    UISearchBar *_searchBar;
}
@end

@implementation SearchResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    books = [@[] mutableCopy];
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareSearchBar];
}

- (void)prepareSearchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _searchBar.searchBarStyle       = UISearchBarStyleDefault;
        _searchBar.tintColor            = [UIColor grayColor];
        _searchBar.barTintColor         = [UIColor blueColor];
        _searchBar.delegate             = self;
        _searchBar.placeholder          = @"Search here";
        _searchBar.returnKeyType        = UIReturnKeySearch;
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor grayColor]];
        [self.navigationItem setTitleView:_searchBar];
    }
}

- (void)addTapGestureRecognizerToView {
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setAlpha:0.4];
    }];
    tapGestureRecognizer = [UITapGestureRecognizer new];
    [tapGestureRecognizer addTarget:self action:@selector(didTapViewWithGestureRecognizer:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didTapViewWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setAlpha:1.0];
    }];
    [_searchBar resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer = nil;
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

- (void)showHUDWithMessage:(NSString *)message {
    noResultsHUD = nil;
    noResultsHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    noResultsHUD.textLabel.text = message;
    [noResultsHUD dismissAfterDelay:1.5 animated:YES];
    [noResultsHUD showInView:self.view];
}

- (void)doSearch {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (query && query.length>0) {
        [self toogleHUD];
        [[IBSAPIClient shareInstance] searchByQuery:query onPage:currentPage onSuccess:^(IBSBookSearch *result) {
            [self toogleHUD];
            if ([result.Total isEqualToString:@"0"]) {
                [self showHUDWithMessage:@"No results found."];
                NSLog(@"No results found.");
            } else {
                [self addBooksFromSet:result.Books];
                [self.collectionView reloadData];
            }
        } onFailure:^(NSError *error) {
            currentPage--;
            [self toogleHUD];
            [self showHUDWithMessage:error.debugDescription];
            NSLog(@"error: %@", error.description);
        }];
    }
}

- (void)addBooksFromSet:(NSSet *)bookSet {
    if (bookSet && bookSet.count>0) {
        NSLog(@"bookSet count: %li", (long)bookSet.count);
        for (IBSBooks *cBook in bookSet) {
            if (![books containsObject:cBook]) {
                [books addObject:cBook];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openDetails"]) {
        // prepare Book oject to display
        IBSBooks *book = ((BookCell*)sender).book;
        BookDetailsVC *detailVC = (BookDetailsVC *)segue.destinationViewController;
        detailVC.bookID = book.ID;
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return books.count;
}

- (BookCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setCellWithBook:[books objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - SearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar becomeFirstResponder];
    [self addTapGestureRecognizerToView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if (query && [query isEqualToString:searchBar.text]) {
        currentPage++;
    } else {
        currentPage = 1;
        query = searchBar.text;
        [books removeAllObjects];
    }
    [self.view removeGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setAlpha:1.0];
    }];
    [self doSearch];
}

@end
