//
//  EventViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/1/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // set deceleration to a fast speed
    [self.scrollView setDecelerationRate:UIScrollViewDecelerationRateFast];
}

#pragma mark - Actions

- (IBAction)saveEventButtonPressed:(id)sender
{
}

- (IBAction)getDirectionsButtonPressed:(id)sender
{
}

- (IBAction)shareButtonPressed:(id)sender
{
}

@end
