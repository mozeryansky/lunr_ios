//
//  SavedViewController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EventType) {
    EventTypeArtsAndEntertainment = 1,
    EventTypeFoodAndDrink,
    EventTypeNightLife,
    EventTypeOther
};

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIToolbar* toolbar;
@property (weak, nonatomic) IBOutlet UITableView* tableView;

- (void)beginSearch;

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;

@end
