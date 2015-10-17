//
// Created by Aldo Castro on 06/12/14.
// Copyright (c) 2014 Aldo Castro. All rights reserved.
//

@import Foundation;

@interface BookDetails : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *ISBN;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *SubTitle;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSURL *Image;
@property (nonatomic, strong) NSString *Author;
@property (nonatomic, strong) NSString *Page;
@property (nonatomic, strong) NSString *Year;
@property (nonatomic, strong) NSString *Publisher;
@property (nonatomic, strong) NSString *Download;
@property (nonatomic, strong) NSError *Error;
@property (nonatomic, strong) NSNumber *Time;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;
@end

@interface Books : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *ISBN; // optional
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *SubTitle; // optional
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSURL *Image;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;
@end

@interface BookSearch : NSObject
@property (nonatomic, strong) NSSet *Books;
@property (nonatomic, strong) NSError *Error;
@property (nonatomic, strong) NSString *Total;
@property (nonatomic, strong) NSNumber *Page;
@property (nonatomic, strong) NSNumber *Time;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;
@end