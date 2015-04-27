//
//  UberAPI.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 4/26/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocationManager.h"

@interface UberAPI : NSObject

+ (instancetype)sharedInstance;

- (NSURL*)uberAppURLForPlace:(NSString*)place productId:(NSString*)productId from:(CLLocation*)from to:(CLLocation*)to;
- (void)getTimesFromLocation:(CLLocation *)from success:(void (^)(NSArray* times))success failure:(void (^)(NSError* error))failure;
- (void)getPricesFromLocation:(CLLocation*)from toLocation:(CLLocation*)to success:(void (^)(NSArray* prices))success failure:(void (^)(NSError* error))failure;

@end
