//
//  AppDelegate.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/5/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "AppDelegate.h"

#import "CoreData+MagicalRecord.h"
#import "AFNetworkActivityLogger.h"
#import "UIColor+Lunr.h"
#import "UserDefaults.h"
#import "LunrAPI.h"
#import "Event.h"
#import "Treat.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // Setup MagicalRecord
    [MagicalRecord setupCoreDataStack];

    /*
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext* localContext) {
        [Event MR_truncateAll];
        [Treat MR_truncateAll];
    }];
    */

    // AFNetworking Logging
    //[[AFNetworkActivityLogger sharedLogger] startLogging];
    //[[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];

    // Appearance

    // set default bar button tint
    [[UIBarButtonItem appearance] setTintColor:[UIColor eventTypeNormalColor]];

    // UITabBar Appearance
    [[UITabBar appearance] setTintColor:[UIColor tabBarNormalColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor tabBarBackgroundColor]];

    // UINavigationController Appearance
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor lunrPurple]];

    // user defaults
    [self registerDefaults];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

#pragma mark - User Defaults

- (void)registerDefaults
{
    NSDictionary* defaults = @{
        // Search Within
        UserDefaultsSearchWithinKey : @50,
        // When
        UserDefaultsWhenKey : @(UserDefaultsWhenWeekend),
        // Show Me
        UserDefaultsShowMeConcertsAndFestivalsKey : @YES,
        UserDefaultsShowMeFoodAndDrinksKey : @YES,
        UserDefaultsShowMeNightlifeKey : @YES,
        // Login
        UserDefaultsRememberTokenKey : @"",
        // Home
        UserDefaultsSearchKeywordKey : @"",
        UserDefaultsHomeSelectedEventTypeKey : @(EventTypeArtsAndEntertainment)
    };

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end
