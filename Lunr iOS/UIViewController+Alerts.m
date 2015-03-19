//
//  UIViewController+Alerts.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/18/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "UIViewController+Alerts.h"

@implementation UIViewController (Alerts)

- (void)alertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
