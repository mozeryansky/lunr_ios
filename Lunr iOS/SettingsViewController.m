//
//  SettingsViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//


#import "SettingsViewController.h"
#import "UserDefaults.h"
#import "LunrAPI.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // setup the when buttons
    [self setupSettings];
}

#pragma mark - Settings

- (void)setupSettings
{
    // search within
    NSInteger within = [[NSUserDefaults standardUserDefaults] integerForKey:UserDefaultsSearchWithinKey];
    [self.withinSlider setValue:within];
    [self updateMilesLabel];

    // when
    UserDefaultsWhen when = [[NSUserDefaults standardUserDefaults] integerForKey:UserDefaultsWhenKey];
    switch (when) {
    case UserDefaultsWhenToday:
        [self.todayButton setSelected:YES];
        break;
    case UserDefaultsWhenTomorrow:
        [self.tomorrowButton setSelected:YES];
        break;
    case UserDefaultsWhenWeekend:
        [self.weekendButton setSelected:YES];
        break;
    }

    // show me
    // concerts and festivals
    BOOL concertsAndFestivalsSelected = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsShowMeConcertsAndFestivalsKey];
    [self.concertsAndFestivalsSwitch setOn:concertsAndFestivalsSelected];
    // food and drinks
    BOOL foodAndDrinksSelected = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsShowMeFoodAndDrinksKey];
    [self.foodAndDrinksSwitch setOn:foodAndDrinksSelected];
    // nightlife
    BOOL nightlightSelected = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsShowMeNightlifeKey];
    [self.nightlifeSwitch setOn:nightlightSelected];
}

#pragma mark - Search within

- (void)updateMilesLabel
{
    int miles = self.withinSlider.value;

    [self.milesLabel setText:[NSString stringWithFormat:@"%dmi", miles]];
}

#pragma mark - Actions

#pragma mark Within Slider

- (IBAction)withinSliderValueChanged:(id)sender
{
    NSInteger within = self.withinSlider.value;
    [[NSUserDefaults standardUserDefaults] setInteger:within forKey:UserDefaultsSearchWithinKey];

    [self updateMilesLabel];
}

#pragma mark When Buttons

- (IBAction)todayButtonPressed:(id)sender
{
    // select this button
    [self.todayButton setSelected:YES];

    // deselect the other buttons
    [self.tomorrowButton setSelected:NO];
    [self.weekendButton setSelected:NO];

    // set the when
    [[NSUserDefaults standardUserDefaults] setInteger:UserDefaultsWhenToday forKey:UserDefaultsWhenKey];
}

- (IBAction)tomorrowButtonPressed:(id)sender
{
    // select this button
    [self.tomorrowButton setSelected:YES];

    // deselect the other buttons
    [self.todayButton setSelected:NO];
    [self.weekendButton setSelected:NO];

    // set the when
    [[NSUserDefaults standardUserDefaults] setInteger:UserDefaultsWhenTomorrow forKey:UserDefaultsWhenKey];
}

- (IBAction)weekendButtonPressed:(id)sender
{
    // select this button
    [self.weekendButton setSelected:YES];

    // deselect the other buttons
    [self.todayButton setSelected:NO];
    [self.tomorrowButton setSelected:NO];

    // set the when
    [[NSUserDefaults standardUserDefaults] setInteger:UserDefaultsWhenWeekend forKey:UserDefaultsWhenKey];
}

#pragma mark Switches

- (IBAction)concertsAndFestivalsSwitched:(id)sender
{
    BOOL value = [self.concertsAndFestivalsSwitch isOn];

    [[NSUserDefaults standardUserDefaults] setBool:value forKey:UserDefaultsShowMeConcertsAndFestivalsKey];
}

- (IBAction)foodAndDrinkSwitched:(id)sender
{
    BOOL value = [self.foodAndDrinksSwitch isOn];

    [[NSUserDefaults standardUserDefaults] setBool:value forKey:UserDefaultsShowMeFoodAndDrinksKey];
}

- (IBAction)nightlifeSwitched:(id)sender
{
    BOOL value = [self.nightlifeSwitch isOn];

    [[NSUserDefaults standardUserDefaults] setBool:value forKey:UserDefaultsShowMeNightlifeKey];
}

#pragma mark Buttom Buttons

- (IBAction)contactUsButtonPressed:(id)sender
{
    NSString *email = @"support@lunr.me";

    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[email]];
    [controller setSubject:@"Hello Lunr!"];
    if (controller){
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutButtonPressed:(id)sender
{
    // logout
    [[LunrAPI sharedInstance] logout];

    // present login view controller
    [self.tabBarController performSegueWithIdentifier:@"presentLoginSegue" sender:self];
}

@end
