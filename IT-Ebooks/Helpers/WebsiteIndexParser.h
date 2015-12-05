//
//  WebsiteIndexParser.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 17/10/15.
//  Copyright © 2015 Aldo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebsiteIndexParser : NSObject

- (instancetype)initWithWebsiteURL:(NSURL *)url;
- (instancetype)initWithLocalHTMLFileData:(NSData *)data;

- (NSArray *)getSectionNames;
- (NSArray *)getTopDownloads;
- (NSArray *)getLastUpload;
- (NSArray *)getNewEbooks;

@end
