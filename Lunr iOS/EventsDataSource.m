//
//  EventsDataSource.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "EventsDataSource.h"

#import "EventTableViewCell.h"
#import "Event.h"

@implementation EventsDataSource

- (void)configureCell:(UITableViewCell*)cell withItem:(id)item
{
    Event* event = (Event*)item;
    EventTableViewCell *eventCell = (EventTableViewCell*)cell;

    [eventCell.eventNameLabel setText:[[event id] stringValue]];
}

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    self.fetchedResultsController = [Event MR_fetchAllSortedBy:@"saved"
                                                     ascending:YES
                                                 withPredicate:nil
                                                       groupBy:nil
                                                      delegate:self
                                                     inContext:[NSManagedObjectContext MR_defaultContext]];
    return _fetchedResultsController;
}

@end
