//
//  EventViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/1/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "EventViewController.h"

#import "NavigationTabController.h"
#import "CoreData+MagicalRecord.h"
#import "LocationManager.h"
#import "UberAPI.h"
#import "AFNetworking.h"

@interface EventViewController ()
@property (strong, nonatomic) NSString *uberProductID;
@end

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // set deceleration to a fast speed
    [self.scrollView setDecelerationRate:UIScrollViewDecelerationRateFast];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[(NavigationTabController*)self.navigationController searchTextField] setHidden:YES];

    [self setupView];

    [self updateSaveButton];

    [self setupUber];
}

- (void)setupView
{
    // event logo
    NSString* url = self.event.avatarUrlMedium;
    if (url) {
        static AFHTTPRequestOperationManager* manager;
        if(!manager){
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
        }
        [self.blurredLogoImageView setImage:nil];
        [self.logoImageView setImage:nil];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // success
            [self.blurredLogoImageView setImage:responseObject];
            [self.logoImageView setImage:responseObject];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //
            NSLog(@"event setupView error, %@", [error localizedDescription]);
            [self.blurredLogoImageView setImage:[UIImage imageNamed:@"logolunr"]];
            [self.logoImageView setImage:[UIImage imageNamed:@"logolunr"]];
        }];
    }

    // event description
    [self.descriptionTextView setText:self.event.descriptionText];

    // name
    [self.titleLabel setText:self.event.name];

    // place
    [self.placeNameLabel setText:self.event.place];

    // time
    if(self.event.startTimeUTC && self.event.endTimeUTC){
        NSString* timeLabel = [Event makeTimeLabelStart:self.event.startTimeUTC end:self.event.endTimeUTC];
        [self.timeLabel setText:timeLabel];
        [self.timeLabel setTextColor:[Event colorForTimeString:timeLabel]];
    }

    // address
    [self.locationLabel setText:self.event.address];

    // miles
    LocationManager* locationManager = [LocationManager sharedInstance];
    CLLocation* here = locationManager.location;
    CLLocation* there = [[CLLocation alloc] initWithLatitude:self.event.latitudeValue longitude:self.event.longitudeValue];
    CLLocationDistance distance = [here distanceFromLocation:there]; // distance in meters
    double miles = distance / 1609.34; // meters / (meters/mile)
    [self.drivingDistanceLabel setText:[self drivingLabelFromMiles:miles]];
    [self.walkingDistanceLabel setText:[self walkingLabelFromMiles:miles]];
}

- (NSString *)drivingLabelFromMiles:(double)miles
{
    double minutes = miles * (1/20.0) * (60); // mile * (1hr/20mi) * (60min/1hr)

    return [self labelFromMinutes:minutes];
}

- (NSString *)walkingLabelFromMiles:(double)miles
{
    double minutes = miles * 20;

    return [self labelFromMinutes:minutes];
}

- (NSString *)labelFromMinutes:(double)minutes
{
    NSString *label;

    if (minutes < 60) {
        label = [NSString stringWithFormat:@"%d min", (int)minutes];

    } else {
        int hours = minutes / 60;
        minutes = (int)minutes % 60;

        if(hours == 1){
            label = [NSString stringWithFormat:@"1 hour %d min", (int)minutes];
        } else {
            label = [NSString stringWithFormat:@"%d hours %d min", hours, (int)minutes];
        }
    }
    
    return label;
}

- (void)updateSaveButton
{
    if(self.event.savedValue){
        [self.saveEventButton setTitle:@"Saved" forState:UIControlStateNormal];
    } else {
        [self.saveEventButton setTitle:@"Save Event" forState:UIControlStateNormal];
    }
}

- (void)setupUber
{
    CLLocation *from = [[LocationManager sharedInstance] location];
    CLLocation *to = [self.event location];

    // times
    [[UberAPI sharedInstance] getTimesFromLocation:from success:^(NSArray *times) {
        // update time label
        NSDictionary *time = times[0];// first
        int seconds = [(NSNumber *)time[@"estimate"] intValue];
        int minutes = (int)round(seconds / 60.0);
        [self.uberTimeLabel setText:[NSString stringWithFormat:@"IN %d MIN", minutes]];

    } failure:^(NSError *error) {
        // failure, do nothing
    }];

    // price
    [[UberAPI sharedInstance] getPricesFromLocation:from toLocation:to success:^(NSArray *prices) {
        // update price label
        NSDictionary *price = prices[0];// first
        NSString *priceEstimate = price[@"estimate"];
        [self.uberPriceLabel setText:priceEstimate];

        // store product id
        self.uberProductID = price[@"product_id"];

    } failure:^(NSError *error) {
        // failure, do nothing
    }];
}

#pragma mark - Actions

- (IBAction)saveEventButtonPressed:(id)sender
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        // toggle the save
        Event *event = [Event MR_findFirstByAttribute:@"id" withValue:self.event.id inContext:localContext];
        event.savedValue = !self.event.savedValue;

    } completion:^(BOOL success, NSError *error) {
        if (error) {
            // error
            NSLog(@"saveEventButtonPressed, could not save error: %@", [error localizedDescription]);

        }

        // update the button
        [self updateSaveButton];
    }];
}

- (IBAction)getDirectionsButtonPressed:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%@",
                           self.event.latitudeValue, self.event.longitudeValue,
                           [self.event.address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSURL *url = [NSURL URLWithString:urlString];

    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"Can't open maps");
    }
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"https://www.lunr.me/events/%lld", self.event.idValue];
    NSURL *url = [NSURL URLWithString:urlString];

    NSString* shareText = [NSString stringWithFormat:@"Check out %@ at %@", self.event.name, urlString];

    NSMutableArray *items = [NSMutableArray new];
    [items addObject:shareText];
    [items addObject:url];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)uberButtonPressed:(id)sender
{
    NSString *uberPlace = self.event.name;

    CLLocation *from = [[LocationManager sharedInstance] location];
    CLLocation *to = [self.event location];
    NSURL *uberAppURL = [[UberAPI sharedInstance] uberAppURLForPlace:uberPlace productId:self.uberProductID from:from to:to];

    if ([[UIApplication sharedApplication] canOpenURL:uberAppURL]){
        [[UIApplication sharedApplication] openURL:uberAppURL];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uber Not Installed" message:@"You do not have the Uber app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
