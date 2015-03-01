//
//  UIColor+Lunr.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "UIColor+Lunr.h"

@implementation UIColor (Lunr)

// Lunr

+ (UIColor*)lunrPurple
{
    return [UIColor colorWithRed:0.396 green:0.325 blue:0.498 alpha:1.000];
}

// event type

+ (UIColor*)eventTypeNormalColor;
{
    return [UIColor colorWithRed:0.695 green:0.646 blue:0.769 alpha:1.000];
}

+ (UIColor*)eventTypeSelectedColor;
{
    return [UIColor whiteColor];
}

// tab bar

+ (UIColor*)tabBarBackgroundColor
{
    return [UIColor colorWithWhite:0.804 alpha:1.000];
}

+ (UIColor*)tabBarNormalColor
{
    return [UIColor colorWithRed:0.320 green:0.248 blue:0.426 alpha:1.000];
}

@end
