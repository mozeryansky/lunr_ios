//
//  SavedDataSource.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 4/26/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "SavedDataSource.h"

#import "Event.h"

@implementation SavedDataSource

- (NSFetchedResultsController*)fetchedResultsController
{
    if (!self.enabled) {
        return nil;
    }

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(saved == YES)"];

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
