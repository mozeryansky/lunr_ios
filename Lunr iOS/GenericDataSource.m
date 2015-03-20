//
//  GenericDataSource.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "GenericDataSource.h"

@interface GenericDataSource ()
@property (nonatomic) CGPoint tableOffset;
@end

@implementation GenericDataSource

- (id)initWithTableView:(UITableView*)tableView cellIdentifier:(NSString*)cellIdentifier
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.cellIdentifier = cellIdentifier;

        // clear cache on init
        [self clearCache];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    id item = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [self configureCell:cell withItem:item];
}

- (void)configureCell:(UITableViewCell*)cell withItem:(id)item
{
    // overload
}

#pragma mark - NSFetchedResultsController

- (void)clearCache
{
    // Delete cache first, if a cache is used
    [NSFetchedResultsController deleteCacheWithName:[[self fetchedResultsController] cacheName]];

    NSError* error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (NSFetchedResultsController*)fetchedResultsController
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller
    didChangeSection:(id)sectionInfo
             atIndex:(NSUInteger)sectionIndex
       forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
    case NSFetchedResultsChangeInsert:
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationNone];
        break;

    case NSFetchedResultsChangeDelete:
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationNone];
        break;
    case NSFetchedResultsChangeMove:
    case NSFetchedResultsChangeUpdate:
        break;
    }
}

- (void)controller:(NSFetchedResultsController*)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath*)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath*)newIndexPath
{
    UITableView* tableView = self.tableView;

    switch (type) {
    case NSFetchedResultsChangeInsert:
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
        break;

    case NSFetchedResultsChangeDelete:
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
        break;

    case NSFetchedResultsChangeUpdate:
        [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                atIndexPath:indexPath];
        break;

    case NSFetchedResultsChangeMove:
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
        break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

@end