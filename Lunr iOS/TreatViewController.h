//
//  TreatViewController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/5/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Treat.h"

@interface TreatViewController : UIViewController

@property (strong, nonatomic) Treat *treat;

@property (weak, nonatomic) IBOutlet UIImageView* blurredLogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView* logoImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* timeLabel;
@property (weak, nonatomic) IBOutlet UILabel* locationLabel;
@property (weak, nonatomic) IBOutlet UILabel* drivingDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel* walkingDistanceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIButton* getTicketButton;
@property (weak, nonatomic) IBOutlet UILabel *uberTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uberPriceLabel;

- (IBAction)getTicketButtonPressed:(id)sender;
- (IBAction)getDirectionsButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)uberButtonPressed:(id)sender;


@end
