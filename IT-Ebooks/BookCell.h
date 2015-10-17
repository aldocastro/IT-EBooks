//
//  BookCell.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 06/01/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IBSBooks;
@interface BookCell : UICollectionViewCell
@property (nonatomic, strong) IBSBooks *book;
@property (nonatomic, weak) IBOutlet UIImageView *picture;
- (void)setCellWithBook:(IBSBooks *)book;
@end
