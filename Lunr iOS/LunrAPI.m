//
//  LunrAPI.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "LunrAPI.h"

#import "UserDefaults.h"
#import "AFNetworking.h"
#import "NSError+Extensions.h"

#define CREATE_FAILURE_BLOCK(blockName, method)                                                                                                        \
    void (^blockName)(AFHTTPRequestOperation * operation, NSError * error) = ^(AFHTTPRequestOperation * operation, NSError * error) { \
        method \
    }

#define CREATE_VERIFYING_SUCCESS_BLOCK(blockName, failureBlock, method)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               \
    void (^blockName)(AFHTTPRequestOperation * operation, id responseObject) = ^(AFHTTPRequestOperation * operation, id responseObject) {                                                                                                                                         \
        if (![self isSuccessful:responseObject]) {                                                                                            \
            failureBlock(nil, [NSError unknownError]);                                                                                                           \
            return;                                                                                                                           \
        }                                                                                                                                     \
        method \
    }

NSString* const kLunrAPIEventsURL = @"https://lunr.herokuapp.com/events.json";
NSString* const kLunrAPIEeventURL = @"https://lunr.herokuapp.com/events";
NSString* const kLunrAPISpecialsURL = @"https://lunr.herokuapp.com/specials.json";
NSString* const kLunrAPISpecialURL = @"https://lunr.herokuapp.com/specials";
NSString* const kLunrAPICheckURL = @"https://lunr.herokuapp.com/t.json";

NSString* const kLunrAPILoginURL = @"https://lunr.herokuapp.com/login.json";
NSString* const kLunrAPIRegisterURL = @"https://lunr.herokuapp.com/register";
NSString* const kLunrAPICheckSpecialURL = @"https://www.lunr.me/check_special.json";

@implementation LunrAPI

+ (instancetype)sharedInstance
{
    static LunrAPI* _sharedInstance = nil;

    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LunrAPI alloc] init];
    });

    return _sharedInstance;
}

#pragma mark - Authentication

- (void)loginWithEmail:(NSString*)email password:(NSString*)password success:(void (^)())success failure:(void (^)(NSError* error))failure
{
    // create params
    NSDictionary* params = @{
        @"user" : @{
            @"email" : email,
            @"password" : password
        }
    };

    // create failure block
    CREATE_FAILURE_BLOCK(failureBlock, {
        // call block
        if (failure) {
            failure(error);
        }
    });

    CREATE_VERIFYING_SUCCESS_BLOCK(successBlock, failureBlock, {
        // store the response token
        NSString* token = ((NSDictionary*)responseObject)[@"data"][@"remember_token"];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:UserDefaultsRememberTokenKey];

        // call success block
        if (success) {
            success();
        }
    });

    // check if the token is valid
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:kLunrAPILoginURL parameters:params success:successBlock failure:failureBlock];
}

- (void)registerWithEmail:(NSString*)email name:(NSString*)name password:(NSString*)password success:(void (^)())success failure:(void (^)(NSError* error))failure
{
    // create params
    NSDictionary* params = @{
        @"user" : @{
            @"email" : email,
            @"name" : name,
            @"password" : password,
            @"password_confirmation" : password // validation is expected to be done before
        }
    };

    // create failure block
    CREATE_FAILURE_BLOCK(failureBlock, {
        // call block
        if (failure) {
            failure(error);
        }
    });

    CREATE_VERIFYING_SUCCESS_BLOCK(successBlock, failureBlock, {
        // store the response token
        NSString* token = ((NSDictionary*)responseObject)[@"data"][@"remember_token"];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:UserDefaultsRememberTokenKey];

        // call success block
        if (success) {
            success();
        }
    });

    // check if the token is valid
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:kLunrAPIRegisterURL parameters:params success:successBlock failure:failureBlock];
}

- (void)verifyTokenSuccess:(void (^)())success failure:(void (^)(NSError* error))failure
{
    // check if there is no token
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:UserDefaultsRememberTokenKey];
    if (!token || [token isEqualToString:@""]) {
        // not logged in
        if (failure) {
            failure(nil);
        }
        return;
    }

    // create params
    NSDictionary* params = @{
        @"t" : token
    };

    // create failure block
    CREATE_FAILURE_BLOCK(failureBlock, {
        // logout
        [self logout];

        // call failure block
        if (failure) {
            failure(error);
        }
    });

    // create success block
    CREATE_VERIFYING_SUCCESS_BLOCK(successBlock, failureBlock, {
        // call success block
        if (success) {
            success();
        }
    });

    // check if the token is valid
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:kLunrAPICheckURL parameters:params success:successBlock failure:failureBlock];
}

- (void)logout
{
    // clear the remember token
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:UserDefaultsRememberTokenKey];
}

#pragma mark - API

- (NSArray*)allEventIDs
{
    NSMutableArray* eventIDs = [[NSMutableArray alloc] init];

    return [eventIDs copy];
}

#pragma mark - Helpers

- (BOOL)isSuccessful:(NSDictionary*)response
{
    BOOL success = [((NSDictionary*)response)[@"success"] boolValue];

    return success;
}

/*
concerts_festivals = "bars"
day = wk_day
food_drinks = "clubs"
nightlife = "restaurants"
lat = latitude
long = longitude
dist = "distance"
days = "days" or "time"
time = getCurrentTime()
offset = offsetFromUtc
type = "event_type" ("all")

day = (now_utc.getDayOfWeek()) % 7;
offset = offsetFromUtc = tz.getOffset(now.getTime()) / (60 * 60 * 1000);
*/

@end
