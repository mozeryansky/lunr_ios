//
//  LunrAPI.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "LunrAPI.h"

#import "LocationManager.h"
#import "CoreData+MagicalRecord.h"
#import "UserDefaults.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"
#import "NSError+Extensions.h"
#import "Event.h"
#import "Treat.h"

#define CREATE_FAILURE_BLOCK(blockName, method)                                                                                                        \
    void (^blockName)(AFHTTPRequestOperation * operation, NSError * error) = ^(AFHTTPRequestOperation * operation, NSError * error) { \
        method \
    }

#define CREATE_SUCCESS_BLOCK(blockName, method)                                                                                                                                                                                                                                                    \
    void (^blockName)(AFHTTPRequestOperation * operation, id responseObject) = ^(AFHTTPRequestOperation * operation, id responseObject) {                                                                                                                                         \
        method \
    }

#define CREATE_VERIFYING_SUCCESS_BLOCK(blockName, failureBlock, method)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  \
    CREATE_SUCCESS_BLOCK(blockName, {\
        if (![self isSuccessful:responseObject]) {                                                                                            \
            failureBlock(nil, [NSError unknownError]);                                                                                                           \
            return;                                                                                                                           \
        }                                                                                                                                     \
        method \
    })

NSString* const kLunrAPIEventsURL = @"https://lunr.herokuapp.com/events.json";
NSString* const kLunrAPIEventURL = @"https://lunr.herokuapp.com/events/%d.json";
NSString* const kLunrAPITreatsURL = @"https://lunr.herokuapp.com/specials.json";
NSString* const kLunrAPITreatURL = @"https://lunr.herokuapp.com/specials/%d.json";
NSString* const kLunrAPICheckURL = @"https://lunr.herokuapp.com/t.json";

NSString* const kLunrAPILoginURL = @"https://lunr.herokuapp.com/login.json";
NSString* const kLunrAPIRegisterURL = @"https://lunr.herokuapp.com/register";
NSString* const kLunrAPICheckSpecialURL = @"https://www.lunr.me/check_special.json";

@interface LunrAPI ()
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;
@property (strong, nonatomic) LocationManager* locationManager;
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

    // add text/html
    /*
    NSMutableSet* set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
     */

    self.manager = manager;
}

- (void)setupLocationManager
{
    self.locationManager = [LocationManager sharedInstance];
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

    // cancel all pending requests
    [[self.manager operationQueue] cancelAllOperations];
}

#pragma mark - Events

- (void)retrieveEventsSuccess:(void (^)())success failure:(void (^)(NSError* error))failure
{
    // wait until a location is ready
    [self waitUntilLocationAvailableCallback:^{

        // get all events
        [self getEventsSuccess:^(NSArray* eventIDs) {
            // success
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext) {
                // make sure an event is created for each event ID
                [self createEventForIDs:eventIDs inContent:localContext];

                // make sure created elements exist
                [localContext MR_saveOnlySelfAndWait];

                // mark all events as invisible
                [self hideAllEventsInContext:localContext];

                // make visible all events retrieved
                [self makeVisibleEventIDs:eventIDs inContent:localContext];

                // update each event's content, and make visible
                [self updateAndMakeVisibleEventIDs:eventIDs inContent:localContext];

            } completion:^(BOOL successfulCompletion, NSError* error){
                // done
                if(!error) {
                    // tell caller we are done to show already downloaded events asap
                    if(success){
                        success();
                    }
                    
                } else {
                    // error during save
                    NSLog(@"retrieveEventsSuccess:failure: could not save records: %@", [error localizedDescription]);
                    if(failure){
                        failure(error);
                    }
                }

            }];// end saveWithBlock

        } failure:^(NSError* error) {
            // get events failure
            NSLog(@"retrieveEventsSuccess:failure: could not get events: %@", [error localizedDescription]);
            if(failure){
                failure(error);
            }
        }];// end getEventsSuccess

    }]; // end waitUntilLocationAvailableCallback
}

// this function expects the location property of the location manager is already set
// use [self waitUntilLocationAvailableCallback:] to ensure we wait until  the location is ready
- (void)getEventsSuccess:(void (^)(NSArray* eventIDs))success failure:(void (^)(NSError* error))failure
{
    CLLocation* location = [self.locationManager location];

    CLLocationDegrees latitude = kCLLocationCoordinate2DInvalid.latitude;
    CLLocationDegrees longitude = kCLLocationCoordinate2DInvalid.longitude;
    if (location != nil) {
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
    }

    // create params
    NSDictionary* params = @{
        @"remember_token" : [self token],
        @"concerts_festivals" : [self concertsFestivals],
        @"day" : [self day],
        @"food_drinks" : [self foodDrinks],
        @"nightlife" : [self nightlife],
        @"lat" : @(latitude),
        @"long" : @(longitude),
        @"dist" : [self distance],
        @"days" : [self days],
        @"time" : [self time],
        @"s" : [self searchText],
        @"offset" : [self offset],
        @"type" : [self type]
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
        // get string of event IDs
        NSString *eventIDsString = responseObject[@"data"];

        NSMutableArray *eventIDs = [[NSMutableArray alloc] init];

        if (![eventIDsString isEqualToString:@""]) {
            // split IDs into array
            NSArray *eventIDsStrings = [eventIDsString componentsSeparatedByString:@","];

            // make array of event IDs of integers
            for (NSString *eventIDString in eventIDsStrings) {
                [eventIDs addObject:[NSNumber numberWithInteger:[eventIDString integerValue]]];
            }
        }

        // call success block
        if (success) {
            success(eventIDs);
        }
    });

    // check if the token is valid
    [self.manager GET:kLunrAPIEventsURL parameters:params success:successBlock failure:failureBlock];
}

// does not save
- (void)hideAllEventsInContext:(NSManagedObjectContext*)localContext
{
    NSArray* events = [Event MR_findAllInContext:localContext];
    for (Event* event in events) {
        // set invisible
        [event setVisibleValue:NO];
    }
}

- (void)createEventForIDs:(NSArray*)eventIDs inContent:(NSManagedObjectContext*)localContext
{
    for (NSNumber* eventID in eventIDs) {
        // if the record exists
        Event* event = [Event MR_findFirstByAttribute:@"id" withValue:eventID inContext:localContext];
        if (!event) {
            // event doesn't exist
            // create empty event for the event id
            event = [Event MR_createInContext:localContext];
            event.id = eventID;
            //NSLog(@"Created Event: %@", eventID);
        }
    }
}

// does not save
- (void)makeVisibleEventIDs:(NSArray*)eventIDs inContent:(NSManagedObjectContext*)localContext
{
    for (NSNumber* eventID in eventIDs) {
        // if the record exists
        Event* event = [Event MR_findFirstByAttribute:@"id" withValue:eventID inContext:localContext];
        if (event) {
            // event exists, make visible
            event.visibleValue = YES;

        } else {
            // event not found
            NSLog(@"makeVisibleEventIDs error, could not find event %@", eventID);
        }
    }
}

- (void)updateAndMakeVisibleEventIDs:(NSArray*)eventIDs inContent:(NSManagedObjectContext*)localContext
{
    // download events
    for (NSNumber* eventID in eventIDs) {
        // wait if never been downloaded
        Event* event = [Event MR_findFirstByAttribute:@"id" withValue:eventID inContext:localContext];
        BOOL wait = YES;
        if(event && event.name){
            wait = NO;
        }
        // never wait
        wait = NO;

        // download event info
        [self getEventWithID:eventID waitUntilFinished:wait success:^(NSDictionary* eventInfo) {
            // update event info
            [self updateAndMakeVisibleEventID:eventID withInfo:eventInfo];

        } failure:^(NSError* error) {
            // failure
            NSLog(@"updateAndMakeVisibleEventIDs, could not get event with ID = '%@', %@", eventID, error);
            // hide event
            [self hideEventWithID:eventID];
        }];
    }
}

- (void)hideEventWithID:(NSNumber*)eventID
{
    // make event invisible
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext) {
        // get event
        Event* event = [Event MR_findFirstByAttribute:@"id" withValue:eventID inContext:localContext];

        // make invisible
        event.visibleValue = NO;

    } completion:^(BOOL success, NSError* error) {
        // done
        if (error){
            // error during save
            NSLog(@"hideEventWithID: could not save records: %@", [error localizedDescription]);
            // ignore
        }
    }];
}

- (void)updateAndMakeVisibleEventID:(NSNumber*)eventID withInfo:(NSDictionary*)eventInfo
{
    // download and save
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext) {
        // get event
        Event* event = [Event MR_findFirstByAttribute:@"id" withValue:eventID inContext:localContext];
        if (!event) {
            // event not found, should never happen at this point
            NSLog(@"updateAndMakeVisibleEventIDs could not find event with ID = '%@'", eventID);

            // continue with next event ID
            return;
        }

        // set
        event.name            = eventInfo[@"name"];
        event.descriptionText = eventInfo[@"description"];
        event.categoryText    = eventInfo[@"cat"];
        event.priceRange      = eventInfo[@"price_range"];
        event.longitudeValue  = [eventInfo[@"longitude"] doubleValue];
        event.latitudeValue   = [eventInfo[@"latitude"] doubleValue];
        event.address         = eventInfo[@"address"];
        event.avatarUrlThumb  = eventInfo[@"avatar_url_thumb"];
        event.avatarUrlSquare = eventInfo[@"avatar_url_square"];
        event.avatarUrlMedium = eventInfo[@"avatar_url_medium"];
        event.tags            = eventInfo[@"tgz"];
        event.place           = eventInfo[@"place"];
        event.reviews         = eventInfo[@"reviews"];

        // optional event link
        if([eventInfo[@"event_link"] isKindOfClass:[NSNull class]]){
            event.eventLink = @"";
        } else {
            event.eventLink = eventInfo[@"event_link"];
        }

        // UTC times
        event.endTimeUTC   = [self dateFromString:eventInfo[@"end_time_utc"]];
        event.startTimeUTC = [self dateFromString:eventInfo[@"start_time_utc"]];

        // make it visible
        event.visibleValue = YES;

    } completion:^(BOOL successfulCompletion, NSError* error) {
        // done
        if (!successfulCompletion || error){
            if(error){
                // error during save
                NSLog(@"updateAndMakeVisibleEventID: could not save records: %@", [error localizedDescription]);
            }
            // ignore
        }
    }];
}

- (void)getEventWithID:(NSNumber*)eventID waitUntilFinished:(BOOL)wait success:(void (^)(NSDictionary* eventInfo))success failure:(void (^)(NSError* error))failure
{
    // create params
    NSDictionary* params = @{
        @"remember_token" : [self token],
        @"day" : [self day],
        @"offset" : [self offset]
    };

    // create failure block
    CREATE_FAILURE_BLOCK(failureBlock, {
        // call failure block
        if (failure) {
            failure(error);
        }
    });

    // create success block
    CREATE_SUCCESS_BLOCK(successBlock, {
        // get string of event IDs
        NSDictionary *eventInfo = responseObject;

        // call success block
        if (success) {
            success(eventInfo);
        }
    });

    // build url
    NSString* eventURL = [NSString stringWithFormat:kLunrAPIEventURL, [eventID intValue]];

    // if wait until finished
    if (wait) {
        // perform requestion syncronously
        NSError* error = nil;
        AFHTTPRequestOperation* operation;
        id responseObject = [self.manager syncGET:eventURL parameters:params operation:&operation error:&error];
        if (error) {
            failureBlock(operation, error);
        } else {
            successBlock(operation, responseObject);
        }

    } else {
        // perform request asynchronously
        [self.manager GET:eventURL parameters:params success:successBlock failure:failureBlock];
    }
}

#pragma mark - Treats

- (void)retrieveTreatsSuccess:(void (^)())success failure:(void (^)(NSError* error))failure
{
    // wait until a location is ready
    [self waitUntilLocationAvailableCallback:^{

        // get all treats
        [self getTreatsSuccess:^(NSArray* treatIDs) {
            // success
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext) {
                // make sure an treat is created for each treat ID
                [self createTreatForIDs:treatIDs inContent:localContext];

                // make sure created elements exist
                [localContext MR_saveOnlySelfAndWait];

                // mark all treats as invisible
                [self hideAllTreatsInContext:localContext];

                // make visible all treats retrieved
                [self makeVisibleTreatIDs:treatIDs inContent:localContext];

                // update each treat's content, and make visible
                [self updateAndMakeVisibleTreatIDs:treatIDs inContent:localContext];

            } completion:^(BOOL successfulCompletion, NSError* error){
                // done
                if(!error) {
                    // tell caller we are done to show already downloaded treats asap
                    if(success){
                        success();
                    }

                } else {
                    // error during save
                    NSLog(@"retrieveTreatsSuccess:failure: could not save records: %@", [error localizedDescription]);
                    if(failure){
                        failure(error);
                    }
                }

            }];// end saveWithBlock

        } failure:^(NSError* error) {
            // get treats failure
            NSLog(@"retrieveTreatsSuccess:failure: could not get treats: %@", [error localizedDescription]);
            if(failure){
                failure(error);
            }
        }];// end getTreatsSuccess

    }]; // end waitUntilLocationAvailableCallback
}

// this function expects the location property of the location manager is already set
// use [self waitUntilLocationAvailableCallback:] to ensure we wait until  the location is ready
- (void)getTreatsSuccess:(void (^)(NSArray* treatIDs))success failure:(void (^)(NSError* error))failure
{
    CLLocation* location = [self.locationManager location];

    CLLocationDegrees latitude = kCLLocationCoordinate2DInvalid.latitude;
    CLLocationDegrees longitude = kCLLocationCoordinate2DInvalid.longitude;
    if (location != nil) {
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
    }

    // create params
    NSDictionary* params = @{
        @"remember_token" : [self token],
        @"concerts_festivals" : [self concertsFestivals],
        @"day" : [self day],
        @"food_drinks" : [self foodDrinks],
        @"nightlife" : [self nightlife],
        @"lat" : @(latitude),
        @"long" : @(longitude),
        @"dist" : [self distance],
        @"days" : [self days],
        @"time" : [self time],
        @"s" : [self searchText],
        @"offset" : [self offset]
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
        // get string of treat IDs
        NSString *treatIDsString = responseObject[@"data"];

        NSMutableArray *treatIDs = [[NSMutableArray alloc] init];
        
        if (![treatIDsString isEqualToString:@""]) {
            // split IDs into array
            NSArray *treatIDsStrings = [treatIDsString componentsSeparatedByString:@","];

            // make array of treat IDs of integers
            for (NSString *treatIDString in treatIDsStrings) {
                [treatIDs addObject:[NSNumber numberWithInteger:[treatIDString integerValue]]];
            }
        }

        // call success block
        if (success) {
            success(treatIDs);
        }
    });

    // check if the token is valid
    [self.manager GET:kLunrAPITreatsURL parameters:params success:successBlock failure:failureBlock];
}

// does not save
- (void)hideAllTreatsInContext:(NSManagedObjectContext*)localContext
{
    NSArray* treats = [Treat MR_findAllInContext:localContext];
    for (Treat* treat in treats) {
        // set invisible
        [treat setVisibleValue:NO];
    }
}

- (void)createTreatForIDs:(NSArray*)treatIDs inContent:(NSManagedObjectContext*)localContext
{
    for (NSNumber* treatID in treatIDs) {
        // if the record exists
        Treat* treat = [Treat MR_findFirstByAttribute:@"id" withValue:treatID inContext:localContext];
        if (!treat) {
            // treat doesn't exist
            // create empty treat for the treat id
            treat = [Treat MR_createInContext:localContext];
            treat.id = treatID;
            //NSLog(@"Created Treat: %@", treatID);
        }
    }
}

// does not save
- (void)makeVisibleTreatIDs:(NSArray*)treatIDs inContent:(NSManagedObjectContext*)localContext
{
    for (NSNumber* treatID in treatIDs) {
        // if the record exists
        Treat* treat = [Treat MR_findFirstByAttribute:@"id" withValue:treatID inContext:localContext];
        if (treat) {
            // treat exists, make visible
            treat.visibleValue = YES;

        } else {
            // treat not found
            NSLog(@"makeVisibleTreatIDs error, could not find treat %@", treatID);
        }
    }
}

- (void)updateAndMakeVisibleTreatIDs:(NSArray*)treatIDs inContent:(NSManagedObjectContext*)localContext
{
    // download treats
    for (NSNumber* treatID in treatIDs) {
        // wait if never been downloaded
        Treat* treat = [Treat MR_findFirstByAttribute:@"id" withValue:treatID inContext:localContext];
        BOOL wait = YES;
        if(treat && treat.name){
            wait = NO;
        }
        // download treat info
        [self getTreatWithID:treatID waitUntilFinished:wait success:^(NSDictionary* treatInfo) {
            // update treat info
            [self updateAndMakeVisibleTreatID:treatID withInfo:treatInfo];

        } failure:^(NSError* error) {
            // failure
            NSLog(@"updateAndMakeVisibleTreatIDs, could not get treat with ID = '%@', %@", treatID, error);
            // hide treat
            [self hideTreatWithID:treatID];
        }];
    }
}

- (void)hideTreatWithID:(NSNumber*)treatID
{
    // make treat invisible
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext) {
        // get treat
        Treat* treat = [Treat MR_findFirstByAttribute:@"id" withValue:treatID inContext:localContext];

        // make invisible
        treat.visibleValue = NO;

    } completion:^(BOOL success, NSError* error) {
        // done
        if (error){
            // error during save
            NSLog(@"hideTreatWithID: could not save records: %@", [error localizedDescription]);
            // ignore
        }
    }];
}

- (void)updateAndMakeVisibleTreatID:(NSNumber*)treatID withInfo:(NSDictionary*)treatInfo
{
    // download and save
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext) {
        // get treat
        Treat* treat = [Treat MR_findFirstByAttribute:@"id" withValue:treatID inContext:localContext];
        if (!treat) {
            // treat not found, should never happen at this point
            NSLog(@"updateAndMakeVisibleTreatIDs could not find treat with ID = '%@'", treatID);

            // continue with next treat ID
            return;
        }

        // update
        treat.name            = treatInfo[@"full_name"];
        treat.descriptionText = treatInfo[@"description"];
        treat.categoryText    = treatInfo[@"cat"];
        treat.longitudeValue  = [treatInfo[@"longitude"] doubleValue];
        treat.latitudeValue   = [treatInfo[@"latitude"] doubleValue];
        treat.address         = treatInfo[@"address"];
        treat.avatarUrlThumb  = treatInfo[@"avatar_url_thumb"];
        treat.avatarUrlSquare = treatInfo[@"avatar_url_square"];
        treat.avatarUrlMedium = treatInfo[@"avatar_url_medium"];
        treat.place           = treatInfo[@"place"];
        
        // optional treat link
        if([treatInfo[@"event_link"] isKindOfClass:[NSNull class]]){
            treat.eventLink = @"";
        } else {
            treat.eventLink = treatInfo[@"event_link"];
        }

        // UTC times
        treat.endTimeUTC   = [self dateFromString:treatInfo[@"end_time_utc"]];
        treat.startTimeUTC = [self dateFromString:treatInfo[@"start_time_utc"]];

        // make it visible
        treat.visibleValue = YES;

    } completion:^(BOOL successfulCompletion, NSError* error) {
        // done
        if (!successfulCompletion || error){
            if(error){
                // error during save
                NSLog(@"updateAndMakeVisibleTreatID: could not save records: %@", [error localizedDescription]);
            }
            // ignore
        }
    }];
}

- (void)getTreatWithID:(NSNumber*)treatID waitUntilFinished:(BOOL)wait success:(void (^)(NSDictionary* treatInfo))success failure:(void (^)(NSError* error))failure
{
    // create params
    NSDictionary* params = @{
        @"remember_token" : [self token],
        @"day" : [self day],
        @"offset" : [self offset]
    };

    // create failure block
    CREATE_FAILURE_BLOCK(failureBlock, {
        // call failure block
        if (failure) {
            failure(error);
        }
    });

    // create success block
    CREATE_SUCCESS_BLOCK(successBlock, {
        // get string of treat IDs
        NSDictionary *treatInfo = responseObject;
        
        // call success block
        if (success) {
            success(treatInfo);
        }
    });

    // build url
    NSString* treatURL = [NSString stringWithFormat:kLunrAPITreatURL, [treatID intValue]];

    // if wait until finished
    if (wait) {
        // perform requestion syncronously
        NSError* error = nil;
        AFHTTPRequestOperation* operation;
        id responseObject = [self.manager syncGET:treatURL parameters:params operation:&operation error:&error];
        if (error) {
            failureBlock(operation, error);
        } else {
            successBlock(operation, responseObject);
        }

    } else {
        // perform request asynchronously
        [self.manager GET:treatURL parameters:params success:successBlock failure:failureBlock];
    }
}

#pragma mark - Parameters

- (NSString*)token
{
    NSString* token = [[NSUserDefaults standardUserDefaults] stringForKey:UserDefaultsRememberTokenKey];

    return token;
}

- (NSNumber*)concertsFestivals
{
    // boolean
    NSNumber* concertsFestivals = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsShowMeConcertsAndFestivalsKey];

    return concertsFestivals;
}

- (NSNumber*)foodDrinks
{
    // boolean
    NSNumber* foodDrinks = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsShowMeFoodAndDrinksKey];

    return foodDrinks;
}

- (NSNumber*)nightlife
{
    // boolean
    NSNumber* nightlife = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsShowMeNightlifeKey];

    return nightlife;
}

- (NSNumber*)distance
{
    NSNumber* distance = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSearchWithinKey];

    return distance;
}

- (NSString*)day
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday] - 1;

    return [NSString stringWithFormat:@"%ld", (long)weekday];
}

// UTC time
- (NSString*)time
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString* datetime = [dateFormatter stringFromDate:[NSDate date]];

    return @"2014-04-26 19:06:12";

    return datetime;
}

- (NSString*)days
{
    NSNumber* whenNumber = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsWhenKey];
    UserDefaultsWhen when = [whenNumber integerValue];
    switch (when) {
    default:
    case UserDefaultsWhenToday:
        return @"1";
        break;
    case UserDefaultsWhenTomorrow:
        return @"2";
        break;
    case UserDefaultsWhenWeekend:
        return @"3";
        break;
    }
}

- (NSString*)offset
{
    NSInteger offset = [[NSTimeZone systemTimeZone] secondsFromGMT];

    // seconds to hrs
    offset = offset / (60 * 60);

    return [NSString stringWithFormat:@"%ld", (long)offset];
}

- (NSString*)type
{
    NSNumber* eventType = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsHomeSelectedEventTypeKey];
    return [Event stringFromEventType:[eventType integerValue]];
}

- (NSString*)searchText
{
    NSString *search = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSearchKeywordKey];
    if(search == nil){
        search = @"";
    }

    return search;
}

#pragma mark - Helpers

- (void)waitUntilLocationAvailableCallback:(void (^)())locationAvailableCallback
{
    // if the location is set
    if (self.locationManager.location != nil) {
        // we're already ready
        // call callback
        locationAvailableCallback();

        return;
    }

    // we don't have a location
    // wait until an update is ready

    // wait until the API is ready (location data is available) before calling methods
    // this process may be instant, but it's not guaranteed
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{

        // create location call back
        LocationManagerCallback callback = ^(CLLocationManager *manager, id called_callback, NSArray *locations, BOOL success) {
            // unregister our callback
            [self.locationManager unregisterLocationUpdateCallback:called_callback];

            // call callback
            if (success) {
                locationAvailableCallback();
            }
        };

        // set callback
        [self.locationManager registerLocationUpdateCallback:callback];

        // toggle location manager to initiate callback
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];

    }); // end dispatch_async
}

- (NSDate*)dateFromString:(NSString*)dateString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];

    NSDate* date = [dateFormatter dateFromString:dateString];

    return date;
}

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