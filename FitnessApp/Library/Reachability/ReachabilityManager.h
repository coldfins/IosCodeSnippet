//
//  ReachabilityManager.h
//  NearBy
//
//  Created by Coldfin Lab on 07/01/16.
//  Copyright (c) 2016 ved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (ReachabilityManager *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
