//
//  NavigationController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "NavigationController.h"

#import "MainViewController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // setup header
    [self setupHeader];
}

- (void)setupHeader
{
    CGRect frame = self.navigationBar.frame;

    // logo
    UIImageView* icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lunr_icon"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setFrame:CGRectMake(8, frame.size.height - 32 - 8, 32, 32)];

    // search
    UIButton* search = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 32 - 8, frame.size.height - 32 - 8, 32, 32)];
    [search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // add view
    [self.navigationBar addSubview:icon];
    [self.navigationBar addSubview:search];
}

#pragma mark - Actions

- (void)searchButtonPressed:(id)sender
{
    // go to the home tab
    UITabBarController* tbc = (UITabBarController*)[self topViewController];
    [tbc setSelectedIndex:0];

    // set focus on the search controller
    UINavigationController* nc = tbc.viewControllers[0];
    MainViewController* vc = (MainViewController*)[nc topViewController];
    [vc beginSearch];
}

@end
