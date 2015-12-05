//
//  IBSReachabilityManager.h
//  IT-Ebooks
//
//  Created by Aldo Castro on 05/02/15.
//  Copyright (c) 2015 Aldo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

typedef NS_ENUM(NSUInteger, IBSReachabilityStatus)
{
    IBSReachabilityStatusReachable,
    IBSReachabilityStatusUnreachable
};

@protocol IBSReachabilityManagerDelegate <NSObject>
- (void)reachabilityDelegateDidChangeStatus:(IBSReachabilityStatus)status;
@end

@interface IBSReachabilityManager : NSObject

+ (IBSReachabilityManager *)sharedInstance;
- (IBSReachabilityStatus)reachabilityStatus;

@property (nonatomic, weak) id<IBSReachabilityManagerDelegate> delegate;

@end
