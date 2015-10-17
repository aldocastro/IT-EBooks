//
// Created by Aldo Castro on 06/12/14.
// Copyright (c) 2014 Aldo Castro. All rights reserved.
//

#import "IBSBooks.h"

@implementation IBSBookDetails
- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    if (dictionary) {
        if (dictionary[@"ID"] && [dictionary[@"ID"] isKindOfClass:[NSNumber class]]) {
            _ID = [NSString stringWithFormat:@"%@", dictionary[@"ID"]];
        }
        if (dictionary[@"ISBN"] && [dictionary[@"ISBN"] isKindOfClass:[NSString class]]) {
            _ISBN = dictionary[@"ISBN"];
        }
        if (dictionary[@"Title"] && [dictionary[@"Title"] isKindOfClass:[NSString class]]) {
            _Title = dictionary[@"Title"];
        }
        if (dictionary[@"SubTitle"] && [dictionary[@"SubTitle"] isKindOfClass:[NSString class]]) {
            _SubTitle = dictionary[@"SubTitle"];
        }
        if (dictionary[@"Description"] && [dictionary[@"Description"] isKindOfClass:[NSString class]]) {
            _Description = dictionary[@"Description"];
        }
        if (dictionary[@"Image"] && [dictionary[@"Image"] isKindOfClass:[NSString class]]) {
            _Image = [NSURL URLWithString:dictionary[@"Image"]];
        }
        if (dictionary[@"Author"] && [dictionary[@"Author"] isKindOfClass:[NSString class]]) {
            _Author = dictionary[@"Author"];
        }
        if (dictionary[@"Page"] && [dictionary[@"Page"] isKindOfClass:[NSString class]]) {
            _Page = dictionary[@"Page"];
        }
        if (dictionary[@"Year"] && [dictionary[@"Year"] isKindOfClass:[NSString class]]) {
            _Year = dictionary[@"Year"];
        }
        if (dictionary[@"Publisher"] && [dictionary[@"Publisher"] isKindOfClass:[NSString class]]) {
            _Publisher = dictionary[@"Publisher"];
        }
        if (dictionary[@"Download"] && [dictionary[@"Download"] isKindOfClass:[NSString class]]) {
            _Download = dictionary[@"Download"];
        }
        if (dictionary[@"Error"] && [dictionary[@"Error"] isKindOfClass:[NSString class]] && ![dictionary[@"Error"] isEqualToString:@"0"]) {
            _Error = [NSError errorWithDomain:@"Error from response" code:400 userInfo:@{@"Error details:":dictionary[@"Error"]}];
        }
        if (dictionary[@"Time"] && [dictionary[@"Time"] isKindOfClass:[NSNumber class]]) {
            _Time = dictionary[@"Time"];
        }
    } else {
        *error = [NSError errorWithDomain:@"JSON Parse Faild" code:500 userInfo:@{@"Error details:":@"JSON format missing."}];
    }
    return self;
}
@end

@implementation IBSBookSearch
- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    if (dictionary) {
        if (dictionary[@"Books"] && [dictionary[@"Books"] isKindOfClass:[NSArray class]]) {
            _Books = [self createBooksWithArray:dictionary[@"Books"]];
        }
        if (dictionary[@"Error"] && [dictionary[@"Error"] isKindOfClass:[NSString class]] && ![dictionary[@"Error"] isEqualToString:@"0"]) {
            _Error = [NSError errorWithDomain:@"Error from response" code:400 userInfo:@{@"Error details:":dictionary[@"Error"]}];
        }
        if (dictionary[@"Total"] && [dictionary[@"Total"] isKindOfClass:[NSString class]]) {
            _Total = dictionary[@"Total"];
        }
        if (dictionary[@"Page"] && [dictionary[@"Page"] isKindOfClass:[NSNumber class]]) {
            _Page = dictionary[@"Page"];
        }
        if (dictionary[@"Time"] && [dictionary[@"Time"] isKindOfClass:[NSNumber class]]) {
            _Time = dictionary[@"Time"];
        }
    } else {
        *error = [NSError errorWithDomain:@"JSON Parse Faild" code:500 userInfo:@{@"Error details:":@"JSON format missing."}];
    }
    return self;
}

- (NSSet *)createBooksWithArray:(NSArray *)array {
    if (array && [array count] > 0) {
        NSMutableSet *bookSet = [NSMutableSet set];
        for (NSDictionary *bookDict in array) {
            IBSBooks *book = [[IBSBooks alloc] initWithDictionary:bookDict error:NULL];
            if (book) {
                [bookSet addObject:book];
            }
        }
        return bookSet;
    }
    return nil;
}
@end

@implementation IBSBooks
- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    if (dictionary) {
        if (dictionary[@"ID"] && [dictionary[@"ID"] isKindOfClass:[NSNumber class]]) {
            _ID = [NSString stringWithFormat:@"%@", dictionary[@"ID"]];
        }
        if (dictionary[@"isbn"] && [dictionary[@"isbn"] isKindOfClass:[NSString class]]) {
            _ISBN = dictionary[@"isbn"];
        }
        if (dictionary[@"Title"] && [dictionary[@"Title"] isKindOfClass:[NSString class]]) {
            _Title = dictionary[@"Title"];
        }
        if (dictionary[@"SubTitle"] && [dictionary[@"SubTitle"] isKindOfClass:[NSString class]]) {
            _SubTitle = dictionary[@"SubTitle"];
        }
        if (dictionary[@"_Description"] && [dictionary[@"_Description"] isKindOfClass:[NSString class]]) {
            _Description = dictionary[@"Total"];
        }
        if (dictionary[@"Image"] && [dictionary[@"Image"] isKindOfClass:[NSString class]]) {
            _Image = [NSURL URLWithString:dictionary[@"Image"]];
        }
    } else {
        *error = [NSError errorWithDomain:@"JSON Parse Faild" code:500 userInfo:@{@"Error details:":@"JSON format missing."}];
    }
    return self;
}

- (NSUInteger)hash {
    NSUInteger idHashed = [_ID hash];
    NSUInteger isbnHashed = [_ISBN hash];
    NSUInteger titleHashed = [_Title hash];
    return idHashed ^ isbnHashed ^ titleHashed;
}

- (BOOL)isEqual:(IBSBooks *)object {
    if (self == object) {
        return  YES;
    }
    
    if ([self hash] == [object hash]) {
        return YES;
    }
    
    if (object && [object isKindOfClass:[IBSBooks class]]) {
        return [self.ID isEqual:object.ID] && [self.ISBN isEqual:object.ISBN] && [self.Title isEqual:object.Title];
    }
    
    return NO;
}

@end