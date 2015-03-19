//
//  UserDefaults.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/8/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserDefaultsWhen) {
    UserDefaultsWhenToday = 1,
    UserDefaultsWhenTomorrow = 2,
    UserDefaultsWhenWeekend = 3
};

//
//  Settings
//

extern NSString* const UserDefaultsSearchWithinKey;
extern NSString* const UserDefaultsWhenKey;
extern NSString* const UserDefaultsShowMeConcertsAndFestivalsKey;
extern NSString* const UserDefaultsShowMeFoodAndDrinksKey;
extern NSString* const UserDefaultsShowMeNightlifeKey;

//
//  Login
//

extern NSString* const UserDefaultsRememberTokenKey;
