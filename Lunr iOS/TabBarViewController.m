//
//  TabBarViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "TabBarViewController.h"

#import "UIColor+Lunr.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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

    //[self performSegueWithIdentifier:@"presentLoginSegue" sender:self];
}

@end
