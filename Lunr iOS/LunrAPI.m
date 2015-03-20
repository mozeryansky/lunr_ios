//
//  LunrAPI.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "LunrAPI.h"

#import "CoreData+MagicalRecord.h"
#import "UserDefaults.h"
#import "AFNetworking.h"
#import "NSError+Extensions.h"
#import "Event.h"
#import "Treat.h"

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

@interface LunrAPI ()
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@end

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

- (id)init
{
    self = [super init];
    if (self) {
        [self setupManager];
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

    // add text/html
    /*
    NSMutableSet* set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
     */

    self.manager = manager;
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
    [self.manager POST:kLunrAPILoginURL parameters:params success:successBlock failure:failureBlock];
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
        // get the error from the response
        NSDictionary *responseObject = [self responseObjectForError:error];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            // if there's an info key
            NSString *description = responseObject[@"info"][0];
            if(description){
                error = [NSError errorWithDescription:description];
            }
        }

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
    [self.manager POST:kLunrAPIRegisterURL parameters:params success:successBlock failure:failureBlock];
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
    [self.manager GET:kLunrAPICheckURL parameters:params success:successBlock failure:failureBlock];
}

- (void)logout
{
    // clear the remember token
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:UserDefaultsRememberTokenKey];
}

#pragma mark - Events

- (void)retrieveEvents
{
    [self getEventsSuccess:^{

    } failure:^(NSError* error){

    }];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext) {
        //
        [Event MR_truncateAllInContext:localContext];

    } completion:^(BOOL success, NSError* error){

    }];
}

- (void)getEventsSuccess:(void (^)())success failure:(void (^)(NSError* error))failure
{
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:UserDefaultsRememberTokenKey];
    BOOL concerts_festivals = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsShowMeConcertsAndFestivalsKey];
    BOOL food_drinks = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsShowMeFoodAndDrinksKey];
    BOOL nightlife = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsShowMeNightlifeKey];
    NSInteger dist = [[NSUserDefaults standardUserDefaults] integerForKey:UserDefaultsSearchWithinKey];

    // create params
    NSDictionary* params = @{
        @"remember_token" : token,
        @"concerts_festivals" : @(concerts_festivals),
        @"day" : @"4",
        @"food_drinks" : @(food_drinks),
        @"nightlife" : @(nightlife),
        @"lat" : @"33.7691832",
        @"long" : @"-84.3819832",
        @"dist" : @(dist),
        @"days" : @"3",
        @"time" : @"2015-03-19 23:19:29",
        @"s" : @"",
        @"offset" : @"-4"
    };

    // create failure block
    CREATE_FAILURE_BLOCK(failureBlock, {
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
    [self.manager GET:kLunrAPIEventsURL parameters:params success:successBlock failure:failureBlock];
}

#pragma mark - Treats

- (void)retrieveTreats
{
}

#pragma mark - Helpers

- (BOOL)isSuccessful:(NSDictionary*)response
{
    BOOL success = [((NSDictionary*)response)[@"success"] boolValue];

    return success;
}

- (id)responseObjectForError:(NSError*)error
{
    NSURLResponse* response = [error userInfo][AFNetworkingOperationFailingURLResponseErrorKey];
    NSData* data = [error userInfo][AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSError* serializationError;
    id responseObject = [self.manager.responseSerializer responseObjectForResponse:response data:data error:&serializationError];
    if (serializationError) {
        NSLog(@"getResponseObjectFromError could not get response object: \n%@", serializationError);
    }

    return responseObject;
}

@end
