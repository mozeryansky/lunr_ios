//
//  UIBarButtonItem+Buttons.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Buttons)

+ (UIBarButtonItem*)buttonWithTitle:(NSString*)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem*)buttonWithTitle:(NSString*)title target:(id)target action:(SEL)action tag:(NSInteger)tag;

+ (UIBarButtonItem*)separator;

+ (UIBarButtonItem*)flexibleSpace;

@end
