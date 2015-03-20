//
//  LunrAPI.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kLunrAPIEventsURL;
extern NSString* const kLunrAPIEeventURL;
extern NSString* const kLunrAPIPPlacesURL;
extern NSString* const kLunrAPIPlaceURL;
extern NSString* const kLunrAPISpecialsURL;
extern NSString* const kLunrAPISpecialURL;
extern NSString* const kLunrAPICheckURL;

@interface LunrAPI : NSObject

+ (instancetype)sharedInstance;

- (void)loginWithEmail:(NSString*)email password:(NSString*)password success:(void (^)())success failure:(void (^)(NSError* error))failure;
- (void)registerWithEmail:(NSString*)email name:(NSString*)name password:(NSString*)password success:(void (^)())success failure:(void (^)(NSError* error))failure;
- (void)verifyTokenSuccess:(void (^)())success failure:(void (^)(NSError* error))failure;
- (void)logout;

- (void)retrieveEvents;
- (void)retrieveTreats;

@end
