//
//  LocationManager.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationManagerCallback)(CLLocationManager *manager, id callback, NSArray *locations, BOOL success);

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (readonly, nonatomic) CLLocation *location;

+ (instancetype)sharedInstance;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)registerLocationUpdateCallback:(LocationManagerCallback)callback;
- (void)unregisterLocationUpdateCallback:(LocationManagerCallback)callback;

@end
