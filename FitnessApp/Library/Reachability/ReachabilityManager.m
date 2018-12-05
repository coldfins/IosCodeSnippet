//
//  ReachabilityManager.m
//  NearBy
//
//  Created by Coldfin Lab on 07/01/16.
//  Copyright (c) 2016 ved. All rights reserved.
//

#import "ReachabilityManager.h"

@implementation ReachabilityManager

#pragma mark -
#pragma mark Default Manager

+ (ReachabilityManager *)sharedManager {
	static ReachabilityManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
 
	return _sharedManager;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
	// Stop Notifier
	if (_reachability) {
		[_reachability stopNotifier];
	}
}

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable {
	return [[[ReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isUnreachable {
	return ![[[ReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
	return [[[ReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
	return [[[ReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
	self = [super init];
 
	if (self) {
		// Initialize Reachability
		self.reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
		
		// Start Monitoring
		[self.reachability startNotifier];
	}
 
	return self;
}

@end
