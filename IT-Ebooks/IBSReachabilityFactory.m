//
//  IBSReachabilityFactory.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 05/02/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import "IBSReachabilityFactory.h"
#import "Reachability.h"


@interface IBSReachabilityFactory ()

@property (nonatomic, strong) Reachability *reachabilityInstance;

@end


@implementation IBSReachabilityFactory

- (instancetype)init
{
    self = [super init];
    if (self) {
        _reachabilityInstance = [[Reachability alloc] init];
        [_reachabilityInstance startNotifier];
    }
    return self;
}

+ (IBSReachabilityFactory *)sharedInstance
{
    static dispatch_once_t pred;
    static IBSReachabilityFactory *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[IBSReachabilityFactory alloc] init];
    });
    return shared;
}

- (Reachability *)reachability
{
    return self.reachabilityInstance;
}


@end
