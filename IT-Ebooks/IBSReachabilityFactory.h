//
//  IBSReachabilityFactory.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 05/02/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface IBSReachabilityFactory : NSObject

+ (IBSReachabilityFactory *)sharedInstance;
- (Reachability *)reachability;

@end
