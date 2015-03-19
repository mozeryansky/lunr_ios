//
//  SettingsViewController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectableButton.h"

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider* withinSlider;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet SelectableButton* todayButton;
@property (weak, nonatomic) IBOutlet SelectableButton* tomorrowButton;
@property (weak, nonatomic) IBOutlet SelectableButton* weekendButton;
@property (weak, nonatomic) IBOutlet UISwitch *concertsAndFestivalsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *foodAndDrinksSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *nightlifeSwitch;

- (IBAction)withinSliderValueChanged:(id)sender;

- (IBAction)todayButtonPressed:(id)sender;
- (IBAction)tomorrowButtonPressed:(id)sender;
- (IBAction)weekendButtonPressed:(id)sender;

- (IBAction)concertsAndFestivalsSwitched:(id)sender;
- (IBAction)foodAndDrinkSwitched:(id)sender;
- (IBAction)nightlifeSwitched:(id)sender;

- (IBAction)contactUsButtonPressed:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@end
