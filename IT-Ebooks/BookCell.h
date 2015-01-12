//
//  BookCell.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 06/01/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Books;
@interface BookCell : UICollectionViewCell
@property (nonatomic, strong) Books *book;
@property (nonatomic, weak) IBOutlet UIImageView *picture;
- (void)setCellWithBook:(Books *)book;
@end