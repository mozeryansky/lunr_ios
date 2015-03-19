//
//  TabBarViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "TabBarViewController.h"

#import "UIColor+Lunr.h"
#import "LunrAPI.h"

@interface TabBarViewController ()
@property (weak, nonatomic) UIPopoverController* popover;
@end

@implementation TabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup tab bar
    self.delegate = self;

    // set tab font size
    [self setupTabFont];
}

- (void)setupTabFont
{
    for (UIViewController* tab in self.viewControllers) {
        [tab.tabBarItem setTitleTextAttributes:@{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:12]
        } forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // verify token
    [[LunrAPI sharedInstance] verifyTokenSuccess:^{
        // do nothing, continue

    } failure:^(NSError* error) {
        // goto login view
        [self performSegueWithIdentifier:@"presentLoginSegue" sender:self];
    }];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)viewController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - Segues
/*
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"presentLoginSegue"]) {
        //
    }
}
*/

@end
