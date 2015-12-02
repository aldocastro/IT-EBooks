//
//  IBSReachabilityManager.m
//  IT-Ebooks
//
//  Created by Aldo Castro on 05/02/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import "IBSReachabilityManager.h"
#import "IBSServerConfiguration.h"
#import "Reachability.h"


@interface IBSReachabilityManager ()

@property (nonatomic, strong) Reachability *reachabilityInstance;

@end


@implementation IBSReachabilityManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _reachabilityInstance = [Reachability reachabilityWithHostName:[IBSServerConfiguration serverUrl]];
        [_reachabilityInstance startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

+ (IBSReachabilityManager *)sharedInstance
{
    static dispatch_once_t pred;
    static IBSReachabilityManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[IBSReachabilityManager alloc] init];
    });
    return shared;
}

- (IBSReachabilityStatus)reachabilityStatus
{
    NSAssert(self.reachabilityInstance != nil, @"reachability Instance can not be null");
    switch ([self.reachabilityInstance currentReachabilityStatus])
    {
        case NotReachable:
            return IBSReachabilityStatusUnreachable;
        case ReachableViaWiFi: case ReachableViaWWAN:
            return IBSReachabilityStatusReachable;
    }
}


- (void)didReachabilityChanged:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reachabilityDelegateDidChangeStatus:)])
    {
        IBSReachabilityStatus newStatus = [self reachabilityStatus];
        [self.delegate reachabilityDelegateDidChangeStatus:newStatus];
    }
}

@end
