//
//  IT_EbooksWebsiteParserTests.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 17/10/15.
//  Copyright © 2015 Aldo Castro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebsiteIndexParser.h"
#import "IBSBooks.h"


@interface IT_EbooksWebsiteParserTests : XCTestCase
@property (nonatomic, strong) WebsiteIndexParser *parser;
@end


@implementation IT_EbooksWebsiteParserTests

- (void)setUp
{
    [super setUp];
    self.parser = [[WebsiteIndexParser alloc] initWithLocalHTMLFileName:@"it-ebooks-index"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_1_returnsSectionNames
{
    XCTAssertNotNil(self.parser);
    NSArray *sectionNames = [self.parser getSectionNames];
    XCTAssertNotNil(sectionNames);
}

- (void)test_2_sectionNamesAreCorrectlyReturned
{
    XCTAssertNotNil(self.parser);
    NSArray *sectionNames = [self.parser getSectionNames];
    XCTAssertNotNil(sectionNames);
    
    for (NSString *name in sectionNames)
    {
        if ([name isEqualToString:@"Top Download eBooks"] ||
            [name isEqualToString:@"Last Upload eBooks"] ||
            [name isEqualToString:@"New eBooks"])
        {
            XCTAssert(YES, "returned the correct known section names");
        }
        else
        {
            XCTAssert(NO, "returned section names do not match with known sections");
        }
    }
}

- (void)test_3_parseTopDownloads_returnsTheCorrectDictionary
{
    XCTAssertNotNil(self.parser);
    NSArray *topDownloads = [self.parser getTopDownloads];
    XCTAssertNotNil(topDownloads);
    
    IBSBookSimple *firstBook = topDownloads.firstObject;
    XCTAssertNotNil(firstBook.Image);
    XCTAssertNotNil(firstBook.Title);
    XCTAssertNotNil(firstBook.DetailsURL);
}

- (void)test_4_parseLastUpload_returnsTheCorrectDictionary
{
    XCTAssertNotNil(self.parser);
    NSArray *lastUpload = [self.parser getLastUpload];
    XCTAssertNotNil(lastUpload);
    
    IBSBookSimple *firstBook = lastUpload.firstObject;
    XCTAssertNotNil(firstBook.Image);
    XCTAssertNotNil(firstBook.Title);
    XCTAssertNotNil(firstBook.DetailsURL);
}

- (void)test_5_parseNewEbooks_returnsTheCorrectDictionary
{
    XCTAssertNotNil(self.parser);
    NSArray *newEbooks = [self.parser getNewEbooks];
    XCTAssertNotNil(newEbooks);
    
    IBSBookSimple *firstBook = newEbooks.firstObject;
    XCTAssertNotNil(firstBook.Image);
    XCTAssertNotNil(firstBook.Title);
    XCTAssertNotNil(firstBook.DetailsURL);
}

@end
