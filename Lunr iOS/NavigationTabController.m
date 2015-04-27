//
//  NavigationController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "NavigationTabController.h"

#import "UserDefaults.h"
#import "MainViewController.h"
#import "TreatsViewController.h"
#import "UIColor+Lunr.h"
#import "SettingsViewController.h"

@interface NavigationTabController ()
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setupSearchField];
}

- (void)setupSearchField
{
    NSString *search = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSearchKeywordKey];
    self.searchTextField.text = search;
    if([search isEqualToString:@""]){
        [self.searchTextField setHidden:YES];
    } else {
        [self.searchTextField setHidden:NO];
    }
}

- (void)setupHeader
{
    CGRect frame = self.navigationBar.frame;

    // logo
    self.navigationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lunr_icon"]];
    [self.navigationIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationIcon setFrame:CGRectMake(8, frame.size.height - 32 - 8, 32, 32)];

    // search text field
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(48, frame.size.height - 32 - 8, frame.size.width - 96, 32)];
    self.searchTextField.delegate = self;
    self.searchTextField.backgroundColor = [UIColor lunrLighterPurple];
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.searchTextField setPlaceholder:[self pickHint]];
    [self.searchTextField setText:@""];

    // search
    self.navigationSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 32 - 8, frame.size.height - 32 - 8, 32, 32)];
    [self.navigationSearchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.navigationSearchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    // add view
    [self.navigationBar addSubview:self.navigationIcon];
    [self.navigationBar addSubview:self.searchTextField];
    [self.navigationBar addSubview:self.navigationSearchButton];
}

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:self.viewControllers[0]] && ![viewController isKindOfClass:[SettingsViewController class]]) {
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

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextField resignFirstResponder];

    // set search keyword
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:UserDefaultsSearchKeywordKey];

    // re-setup the search field
    [self setupSearchField];

    // reset fetched search results
    UIViewController *vc = self.viewControllers[0];
    if ([vc isKindOfClass:[MainViewController class]]) {
        [[(MainViewController*)vc eventsDataSource] resetFetchedResultsController];
        [(MainViewController*)vc retrieveEvents];

    } else if([vc isKindOfClass:[TreatsViewController class]]){
        [[(TreatsViewController*)vc treatsDataSource] resetFetchedResultsController];
        [(TreatsViewController*)vc retrieveTreats];

    } else {
        NSLog(@"textFieldShouldReturn search error, Unknown view controller!");
    }

    return YES;
}

#pragma mark - Actions

- (void)searchButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];

    [self.searchTextField setPlaceholder:[self pickHint]];
    [self.searchTextField setText:@""];

    [self.searchTextField setHidden:NO];

    [self.searchTextField becomeFirstResponder];
}

#pragma mark - Helpers

- (NSString*)pickHint
{
    NSArray* hints = @[
                       @"Try 'Dive bars'",
                       @"Try 'Latin restaurants'",
                       @"Try 'Dancehall clubs'",
                       @"Try 'Hookah bars'		",
                       @"Try 'Beer gardens'",
                       @"Try 'Brazilian restaurants'",
                       @"Try 'EDM clubs'",
                       @"Try 'Jazz Clubs'",
                       @"Try 'Sport bar'		",
                       @"Try 'Live music'",
                       @"Try 'Breakfast & Brunch'",
                       @"Try 'Salsa Clubs'",
                       @"Try 'Vip clubs'",
                       @"Try 'Tapas bars'",
                       @"Try 'Steakhouses'",
                       @"Try 'Buffets'",
                       @"Try 'Desserts'",
                       @"Try 'Brazilian restaurants'",
                       @"Try 'Chill bars'",
                       @"Try 'Neighborhood bar'",
                       @"Try 'Hiphop clubs'",
                       @"Try 'Reggae Clubs'",
                       @"Try 'Happy hour'"
                       ];
    
    NSUInteger randomIndex = arc4random() % [hints count];
    
    return hints[randomIndex];
}

@end
