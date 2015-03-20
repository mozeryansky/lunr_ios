//
//  TreatsDataSource.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/19/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "TreatsDataSource.h"

#import "Treat.h"

@implementation TreatsDataSource

- (void)configureCell:(UITableViewCell*)cell withItem:(id)item
{
    Treat* treat = item;
}

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    self.fetchedResultsController = [Treat MR_fetchAllSortedBy:@"id"
                                                     ascending:YES
                                                 withPredicate:nil
                                                       groupBy:nil
                                                      delegate:self
                                                     inContext:[NSManagedObjectContext MR_defaultContext]];
    return _fetchedResultsController;
}

@end
