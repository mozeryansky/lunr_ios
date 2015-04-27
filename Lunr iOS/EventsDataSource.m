//
//  EventsDataSource.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "EventsDataSource.h"

#import "UserDefaults.h"
#import "EventTableViewCell.h"
#import "Event.h"
#import "LocationManager.h"
#import "AFNetworking.h"

@implementation EventsDataSource

- (void)configureCell:(UITableViewCell*)cell withItem:(id)item
{
    Event* event = (Event*)item;
    EventTableViewCell* eventCell = (EventTableViewCell*)cell;

    NSString *url = event.avatarUrlThumb;
    if (url) {

        static AFHTTPRequestOperationManager* manager;
        if(!manager){
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
        }
        [eventCell.logoImageView setImage:nil];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // success
            [eventCell.logoImageView setImage:responseObject];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //
            NSLog(@"event configureCell error, %@", [error localizedDescription]);
            [eventCell.logoImageView setImage:[UIImage imageNamed:@"logolunr"]];
        }];
    }

    [eventCell.eventNameLabel setText:event.name];
    [eventCell.placeNameLabel setText:event.place];

    // time
    if(event.startTimeUTC && event.endTimeUTC){
        NSString* timeLabel = [Event makeTimeLabelStart:event.startTimeUTC end:event.endTimeUTC];
        [eventCell.timeLabel setText:timeLabel];

        [eventCell.timeLabel setTextColor:[Event colorForTimeString:timeLabel]];
    }

    // miles
    LocationManager* locationManager = [LocationManager sharedInstance];
    CLLocation* here = locationManager.location;
    CLLocation* there = [[CLLocation alloc] initWithLatitude:event.latitudeValue longitude:event.longitudeValue];
    CLLocationDistance distance = [here distanceFromLocation:there]; // distance in meters
    double miles = distance / 1609.34; // meters / (meters/mile)
    [eventCell.drivingDistanceLabel setText:[NSString stringWithFormat:@"%0.1f miles", miles]];

    // money
    NSString* price = event.priceRange;
    NSArray* priceArr = [price componentsSeparatedByString:@" "];
    [eventCell.moneyLabel setText:priceArr[0]];

    // category
    [eventCell.categoryLabel setText:event.categoryText];
}

- (NSFetchedResultsController*)fetchedResultsController
{
    if (!self.enabled) {
        return nil;
    }

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(visible == YES)"];

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];

    self.fetchedResultsController = [Event MR_fetchAllSortedBy:@"id"
                                                     ascending:YES
                                                 withPredicate:predicate
                                                       groupBy:nil
                                                      delegate:self
                                                     inContext:[NSManagedObjectContext MR_defaultContext]];
    return _fetchedResultsController;
}

@end
