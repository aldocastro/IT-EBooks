//
//  WebsiteIndexParser.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 17/10/15.
//  Copyright © 2015 Aldo Castro. All rights reserved.
//

#import "WebsiteIndexParser.h"
#import "TFHpple.h"
#import "IBSBooks.h"

NSString * const kSectionNamesQueryStr = @"//table[@class='main']/tr/td[@class='top']/h2";
NSString * const kBaseURL = @"it-ebooks.info";

@interface WebsiteIndexParser ()

@property (nonatomic, strong) TFHpple *parser;
- (NSData *)loadDataFromHTMLFileName:(NSString *)name;

@end

@implementation WebsiteIndexParser

- (instancetype)initWithLocalHTMLFileData:(NSData *)data
{
    self = [super init];
    if (self) {
        _parser = [TFHpple hppleWithHTMLData:data];
    }
    return self;
}

- (instancetype)initWithWebsiteURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        _parser = [TFHpple hppleWithHTMLData:data];
    }
    return self;
}

- (NSMutableArray *)doParsingForSectionName:(NSString *)sectionName
{
    NSArray *foundNodes = [self.parser searchWithXPathQuery:@"//td[@class='top']/child::node()"];
    
    NSMutableArray *elements = [[NSMutableArray alloc] initWithCapacity:0];
    
    BOOL isWishedSection = NO;
    
    for (TFHppleElement *element in foundNodes)
    {
        if ([element.tagName isEqualToString:@"h2"])
        {
            isWishedSection = [element.text isEqualToString:sectionName];
        }
        else if (isWishedSection)
        {
            if ([element.tagName isEqualToString:@"div"] && [[element.attributes objectForKey:@"class"] isEqualToString:@"top_box"])
            {                
                NSMutableDictionary *sectionInfo = [[NSMutableDictionary alloc] init];
                
                for (TFHppleElement *child in element.children)
                {
                    NSString *styleAttributeContent = [child.attributes objectForKey:@"style"];
                    if (styleAttributeContent)
                    {
                        NSString *coverImageUrl = [self getUrlStringFromContent:styleAttributeContent];
                        [sectionInfo setObject:coverImageUrl forKey:@"Image"];
                    }
                    
                    if ([child.tagName isEqualToString:@"a"])
                    {
                        NSString *hrefAttributeContent = [child.attributes objectForKey:@"href"];
                        if (hrefAttributeContent)
                        {
                            NSString *bookUrl = [NSString stringWithFormat:@"%@%@", kBaseURL, hrefAttributeContent];
                            [sectionInfo setObject:bookUrl forKey:@"DetailsURL"];
                        }
                        
                        NSString *titleValue = child.text;
                        if (titleValue)
                        {
                            [sectionInfo setObject:titleValue forKey:@"Title"];
                        }
                    }
                }
                
                NSError *error = nil;
                IBSBookSimple *simpleBook = [[IBSBookSimple alloc] initWithDictionary:sectionInfo error:&error];
                if (error)
                {
                    NSLog(@"catched Error: %@", error.debugDescription);
                }
                else
                {
                    [elements addObject:simpleBook];
                }
            }
        }
    }
    
    return elements;
}

- (NSArray *)getSectionNames
{
    NSArray *foundNodes = [self.parser searchWithXPathQuery:@"//h2"];
    
    NSMutableArray *elements = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in foundNodes)
    {
        NSString *sectionTitle = [[element firstChild] content];
        [elements addObject:sectionTitle];
    }

    return elements;
}

- (NSArray *)getTopDownloads
{
    return [self doParsingForSectionName:@"Top Download eBooks"];
}

- (NSArray *)getLastUpload
{
    NSArray *foundNodes = [self.parser searchWithXPathQuery:@"//table [@width='100%']/tr/td"];
    
    NSMutableArray *elements = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in foundNodes)
    {
        if ([element.tagName isEqualToString:@"td"] && [[element.attributes objectForKey:@"width"] isEqualToString:@"120"])
        {
            NSMutableDictionary *sectionInfo = [[NSMutableDictionary alloc] init];
            
            for (TFHppleElement *child in element.children)
            {
                if ([child.tagName isEqualToString:@"a"])
                {
                    NSString *hrefAttributeContent = [child.attributes objectForKey:@"href"];
                    if (hrefAttributeContent)
                    {
                        NSString *bookUrl = [NSString stringWithFormat:@"%@%@", kBaseURL, hrefAttributeContent];
                        [sectionInfo setObject:bookUrl forKey:@"DetailsURL"];
                    }
                    
                    NSString *titleValue = [child.attributes objectForKey:@"title"];
                    if (titleValue)
                    {
                        [sectionInfo setObject:titleValue forKey:@"Title"];
                    }
                    
                    TFHppleElement *firstChildren = child.children.firstObject;
                    if (firstChildren && [firstChildren.tagName isEqualToString:@"img"])
                    {
                        NSString *imageURL = [firstChildren.attributes objectForKey:@"src"];
                        if (imageURL)
                        {
                            [sectionInfo setObject:imageURL forKey:@"Image"];
                        }
                    }
                }
            }
            
            NSError *error = nil;
            IBSBookSimple *simpleBook = [[IBSBookSimple alloc] initWithDictionary:sectionInfo error:&error];
            if (error)
            {
                NSLog(@"catched Error: %@", error.debugDescription);
            }
            else
            {
                [elements addObject:simpleBook];
            }
        }
        
    }
    
    return elements;
}

- (NSArray *)getNewEbooks
{
    return [self doParsingForSectionName:@"New eBooks"];
}

- (NSString *)getUrlStringFromContent:(NSString *)content
{
    //  obtain array of strings separated by semicolons
    NSArray *stringsSeparatedBySemicolon = [content componentsSeparatedByString:@";"];
    //  obtain array of strings separated by blank space
    NSArray *stringsSeparatedByBlankSpace = [stringsSeparatedBySemicolon[2] componentsSeparatedByString:@" "];
    //  obtain the value of url:('')
    NSString *url = stringsSeparatedByBlankSpace[2];
    //  get the real path of the image
    NSRange urlValueRange = NSMakeRange(@"url('".length, url.length - @"url('".length - @"')".length);
    NSString *urlValue = [NSString stringWithFormat:@"%@%@", kBaseURL, [url substringWithRange:urlValueRange]];
    return urlValue;
}

//- (void)writeToFile:(id)content withName:(NSString *)name
//{
//    NSString *jsonString = [NSString stringWithFormat:@"%@", content];
//    //get the documents directory:
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt", documentsDirectory, name];
//    NSError *error;
//    //save content to the documents directory
//    [jsonString writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:&error];
//    if (error)
//    {
//        NSLog(@"Got an error: %@\non saving to file path: %@", error, fileName);
//    }
//}

@end
