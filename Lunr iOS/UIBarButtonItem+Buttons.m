//
//  UIBarButtonItem+Buttons.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "UIBarButtonItem+Buttons.h"

@implementation UIBarButtonItem (Buttons)

+ (UIBarButtonItem*)buttonWithTitle:(NSString*)title target:(id)target action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

+ (UIBarButtonItem*)buttonWithTitle:(NSString*)title target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIBarButtonItem* button = [UIBarButtonItem buttonWithTitle:title target:target action:action];

    [button setTag:tag];

    return button;
}

+ (UIBarButtonItem*)separator
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 20)];
    [view setBackgroundColor:[UIColor whiteColor]];

    UIBarButtonItem* separator = [[UIBarButtonItem alloc] initWithCustomView:view];

    return separator;
}

+ (UIBarButtonItem*)flexibleSpace
{
    UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    return flexibleSpace;
}

@end
