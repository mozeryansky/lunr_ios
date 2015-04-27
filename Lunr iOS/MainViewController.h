//
//  SavedViewController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventsDataSource.h"

@interface MainViewController : UIViewController <UITableViewDelegate>

@property (strong, nonatomic) EventsDataSource* eventsDataSource;
@property (weak, nonatomic) IBOutlet UIToolbar* toolbar;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;

- (void)retrieveEvents;
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;

@end
