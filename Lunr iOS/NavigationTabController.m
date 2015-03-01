//
//  NavigationController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "NavigationTabController.h"

#import "MainViewController.h"

@interface NavigationTabController ()
@property (strong, nonatomic) UIImageView* navigationIcon;
@property (strong, nonatomic) UIButton* navigationSearchButton;
@end

@implementation NavigationTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // set delegate
    self.delegate = self;

    // setup header
    [self setupHeader];

    // setup back button
    self.topViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.tabBarItem.title style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)setupHeader
{
    CGRect frame = self.navigationBar.frame;

    // logo
    self.navigationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lunr_icon"]];
    [self.navigationIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationIcon setFrame:CGRectMake(8, frame.size.height - 32 - 8, 32, 32)];

    // search
    self.navigationSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 32 - 8, frame.size.height - 32 - 8, 32, 32)];
    [self.navigationSearchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.navigationSearchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // add view
    [self.navigationBar addSubview:self.navigationIcon];
    [self.navigationBar addSubview:self.navigationSearchButton];
}

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:self.viewControllers[0]]) {
        // show
        [self setRootNavigationItemsHidden:NO];
    } else {
        // hide
        [self setRootNavigationItemsHidden:YES];
    }
}

- (void)setRootNavigationItemsHidden:(BOOL)hidden
{
    self.navigationIcon.hidden = hidden;
    self.navigationSearchButton.hidden = hidden;
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
