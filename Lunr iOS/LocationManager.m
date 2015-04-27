//
//  LocationManager.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()
@property (strong, nonatomic) CLLocationManager* manager;
@property (strong, atomic) NSMutableArray *locationObserverCallbacks;
@end

@implementation LocationManager

+ (instancetype)sharedInstance
{
    static LocationManager* _sharedInstance = nil;

    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LocationManager alloc] init];
    });

    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self){
        // init
        self.locationObserverCallbacks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerLocationUpdateCallback:(LocationManagerCallback)callback
{
    [self.locationObserverCallbacks addObject:callback];
}

- (void)unregisterLocationUpdateCallback:(LocationManagerCallback)callback
{
    [self.locationObserverCallbacks removeObject:callback];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![self isAuthorizedStatus:status]) {
        // not authorized
        NSLog(@"Location Manager unauthorized");
        return;
    }
    // authorized

    [self startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (LocationManagerCallback callback in self.locationObserverCallbacks) {
        callback(manager, callback, locations, YES);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location Manager didFailWithError: %@", [error localizedDescription]);

    for (LocationManagerCallback callback in self.locationObserverCallbacks) {
        callback(manager, callback, nil, NO);
    }
}

#pragma mark - Location Manager

- (CLLocation*)location
{
    return self.manager.location;
}

- (void)startUpdatingLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Location services not enabled");
        return;
    }

    // check if we need to request authorization
    if([self isRequireRequestStatus:status]){
        [self.manager requestWhenInUseAuthorization];
        return;
    }

    // check if the current auth status is yes
    if (![self isAuthorizedStatus:status]) {
        return;
    }

    // locationManager update as location
    [self.manager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.manager stopUpdatingLocation];
}

- (BOOL)isAuthorizedStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            // authorization needs to be requested
            // [self.manager requestWhenInUseAuthorization];
            return NO;

        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            // not authorized
            return NO;
            break;

        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            // authorized
            return YES;
    }
}

- (BOOL)isRequireRequestStatus:(CLAuthorizationStatus)status
{
    return (status == kCLAuthorizationStatusNotDetermined);
}

- (CLLocationManager*)manager
{
    if (_manager) {
        return _manager;
    }

    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;

    // we don't need to be perfectly accurate, this will help with battery life
    self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.manager.distanceFilter = 1609.34; // 1 mile in meters


    return _manager;
}

@end
