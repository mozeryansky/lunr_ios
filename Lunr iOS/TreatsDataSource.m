//
//  TreatsDataSource.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/19/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "TreatsDataSource.h"

#import "Treat.h"
#import "TreatTableViewCell.h"
#import "LocationManager.h"
#import "AFNetworking.h"

@implementation TreatsDataSource

- (void)configureCell:(UITableViewCell*)cell withItem:(id)item
{
    Treat* event = (Treat*)item;
    TreatTableViewCell* treatCell = (TreatTableViewCell*)cell;

    NSString* url = event.avatarUrlThumb;
    if (url) {
        static AFHTTPRequestOperationManager* manager;
        if(!manager){
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFImageResponseSerializer serializer];
        }
        [treatCell.logoImageView setImage:nil];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // success
            [treatCell.logoImageView setImage:responseObject];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //
            NSLog(@"event configureCell error, %@", [error localizedDescription]);
            [treatCell.logoImageView setImage:[UIImage imageNamed:@"logolunr"]];
        }];
    }

    [treatCell.eventNameLabel setText:event.name];
    [treatCell.placeNameLabel setText:event.place];

    // time
    if (event.startTimeUTC && event.endTimeUTC) {
        NSString* timeLabel = [Treat makeTimeLabelStart:event.startTimeUTC end:event.endTimeUTC];
        [treatCell.timeLabel setText:timeLabel];

        [treatCell.timeLabel setTextColor:[Treat colorForTimeString:timeLabel]];
    }

    // miles
    LocationManager* locationManager = [LocationManager sharedInstance];
    CLLocation* here = locationManager.location;
    CLLocation* there = [[CLLocation alloc] initWithLatitude:event.latitudeValue longitude:event.longitudeValue];
    CLLocationDistance distance = [here distanceFromLocation:there]; // distance in meters
    double miles = distance / 1609.34; // meters / (meters/mile)
    [treatCell.drivingDistanceLabel setText:[NSString stringWithFormat:@"%0.1f miles", miles]];

    // category
    [treatCell.categoryLabel setText:event.categoryText];
}

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(visible == YES)"];

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];

    self.fetchedResultsController = [Treat MR_fetchAllSortedBy:@"id"
                                                     ascending:YES
                                                 withPredicate:nil
                                                       groupBy:nil
                                                      delegate:self
                                                     inContext:[NSManagedObjectContext MR_defaultContext]];
    return _fetchedResultsController;
}

@end
