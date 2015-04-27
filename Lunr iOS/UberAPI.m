//
//  UberAPI.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 4/26/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "UberAPI.h"

#import "AFNetworking.h"

#define CREATE_FAILURE_BLOCK(blockName, method)                                                                                                \
    void (^blockName)(AFHTTPRequestOperation * operation, NSError * error) = ^(AFHTTPRequestOperation * operation, NSError * error) { \
method \
    }

#define CREATE_SUCCESS_BLOCK(blockName, method)                                                                                                                                                                                                                                            \
    void (^blockName)(AFHTTPRequestOperation * operation, id responseObject) = ^(AFHTTPRequestOperation * operation, id responseObject) {                                                                                                                                         \
method \
    }

NSString* const UberToken = @"BYvR1xXWFldbDBGGBcf6B0zCwCmDU_qkUA-IImxG";
NSString* const UberClientID = @"r1tUpIY-sYkAYtEOcautVRp9HHAP-VTW";

NSString* const UberTimeURL = @"https://api.uber.com/v1/estimates/time";
NSString* const UberPriceURL = @"https://api.uber.com/v1/estimates/price";

@interface UberAPI ()
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@property (strong, nonatomic) LocationManager* locationManager;

@end

@implementation UberAPI

+ (instancetype)sharedInstance
{
    static UberAPI* _sharedInstance = nil;

    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UberAPI alloc] init];
    });

    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupManager];
        [self setupLocationManager];
    }

    return self;
}

- (void)setupManager
{
    // JSON serializer manager
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    // accept json during the request
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    self.manager = manager;
}

- (void)setupLocationManager
{
    self.locationManager = [LocationManager sharedInstance];
}

#pragma mark - App URL

- (NSURL*)uberAppURLForPlace:(NSString*)place productId:(NSString*)productId from:(CLLocation*)from to:(CLLocation*)to
{
    NSString* urlString = [NSString stringWithFormat:@"uber://?client_id=%@&action=setPickup&pickup[latitude]=%f&pickup[longitude]=%f&dropoff[latitude]=%f&dropoff[longitude]=%f&dropoff[nickname]=%@&product_id=%@",
                                    UberClientID,
                                    from.coordinate.latitude, from.coordinate.longitude,
                                    to.coordinate.latitude, to.coordinate.longitude,
                                    [place stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                    productId];

    return [NSURL URLWithString:urlString];
}

#pragma mark - API methods

- (void)getTimesFromLocation:(CLLocation*)from success:(void (^)(NSArray* times))success failure:(void (^)(NSError* error))failure
{
    // create params
    NSDictionary* params = @{
        @"server_token" : UberToken,
        @"start_latitude" : @(from.coordinate.latitude),
        @"start_longitude" : @(from.coordinate.longitude)
    };

    // create failure block
    CREATE_FAILURE_BLOCK(failureBlock, {
        // call block
        if (failure) {
            failure(error);
        }
    });

    CREATE_SUCCESS_BLOCK(successBlock, {
        // store the response token
        NSArray* times = ((NSDictionary*)responseObject)[@"times"];

        // call success block
        if (success) {
            success(times);
        }
    });

    [self.manager GET:UberTimeURL parameters:params success:successBlock failure:failureBlock];
}

- (void)getPricesFromLocation:(CLLocation*)from toLocation:(CLLocation*)to success:(void (^)(NSArray* prices))success failure:(void (^)(NSError* error))failure
{
    // create params
    NSDictionary* params = @{
        @"server_token" : UberToken,
        @"start_latitude" : @(from.coordinate.latitude),
        @"start_longitude" : @(from.coordinate.longitude),
        @"end_latitude" : @(to.coordinate.latitude),
        @"end_longitude" : @(to.coordinate.longitude)
    };

    // create failure block
    CREATE_FAILURE_BLOCK(failureBlock, {
        // call block
        if (failure) {
            failure(error);
        }
    });

    CREATE_SUCCESS_BLOCK(successBlock, {
        // store the response token
        NSArray* times = ((NSDictionary*)responseObject)[@"prices"];

        // call success block
        if (success) {
            success(times);
        }
    });

    [self.manager GET:UberPriceURL parameters:params success:successBlock failure:failureBlock];
}

@end
