//
//  GenericDataSource.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "CoreData+MagicalRecord.h"

typedef void (^TableViewCellConfigureBlock)(id cell, id event);

@interface GenericDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController* _fetchedResultsController;
}

@property (strong, nonatomic) UITableView* tableView;
@property (nonatomic, copy) NSString* cellIdentifier;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic) BOOL enabled;

- (id)initWithTableView:(UITableView*)tableView cellIdentifier:(NSString*)cellIdentifier;
- (id)itemAtIndexPath:(NSIndexPath*)indexPath;
- (void)resetFetchedResultsController;

@end