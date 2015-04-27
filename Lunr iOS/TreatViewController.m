//
//  TreatViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/5/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "TreatViewController.h"

#import "NavigationTabController.h"
#import "CoreData+MagicalRecord.h"
#import "LocationManager.h"
#import "UberAPI.h"
#import "AFNetworking.h"

@interface TreatViewController ()
@property (strong, nonatomic) NSString *uberProductID;
@end

@implementation TreatViewController

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

    [self setupUber];
}

- (void)setupView
{
    // treat logo
    NSString* url = self.treat.avatarUrlMedium;
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

    

    // treat description
    [self.descriptionTextView setText:self.treat.descriptionText];

    // name
    [self.titleLabel setText:self.treat.name];

    // place
    [self.placeNameLabel setText:self.treat.place];

    // time
    if(self.treat.startTimeUTC && self.treat.endTimeUTC){
        NSString* timeLabel = [Treat makeTimeLabelStart:self.treat.startTimeUTC end:self.treat.endTimeUTC];
        [self.timeLabel setText:timeLabel];
        [self.timeLabel setTextColor:[Treat colorForTimeString:timeLabel]];
    }

    // address
    [self.locationLabel setText:self.treat.address];

    // miles
    LocationManager* locationManager = [LocationManager sharedInstance];
    CLLocation* here = locationManager.location;
    CLLocation* there = [[CLLocation alloc] initWithLatitude:self.treat.latitudeValue longitude:self.treat.longitudeValue];
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

- (void)setupUber
{
    CLLocation *from = [[LocationManager sharedInstance] location];
    CLLocation *to = [self.treat location];

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

- (IBAction)getTicketButtonPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:self.treat.eventLink];

    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)getDirectionsButtonPressed:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%@",
                           self.treat.latitudeValue, self.treat.longitudeValue,
                           [self.treat.address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSURL *url = [NSURL URLWithString:urlString];

    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"Can't open maps");
    }
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"https://www.lunr.me/treats/%lld", self.treat.idValue];
    NSURL *url = [NSURL URLWithString:urlString];

    NSString* shareText = [NSString stringWithFormat:@"Check out %@ at %@", self.treat.name, urlString];

    NSMutableArray *items = [NSMutableArray new];
    [items addObject:shareText];
    [items addObject:url];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)uberButtonPressed:(id)sender
{
    NSString *uberPlace = self.treat.name;

    CLLocation *from = [[LocationManager sharedInstance] location];
    CLLocation *to = [self.treat location];
    NSURL *uberAppURL = [[UberAPI sharedInstance] uberAppURLForPlace:uberPlace productId:self.uberProductID from:from to:to];

    if ([[UIApplication sharedApplication] canOpenURL:uberAppURL]){
        [[UIApplication sharedApplication] openURL:uberAppURL];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uber Not Installed" message:@"You do not have the Uber app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
