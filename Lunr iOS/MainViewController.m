//
//  MainViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "MainViewController.h"

#import "TabBarViewController.h"
#import "EventTableViewCell.h"
#import "UIBarButtonItem+Buttons.h"
#import "UIColor+Lunr.h"
#import "LunrAPI.h"
#import "EventViewController.h"
#import "UserDefaults.h"

typedef NS_ENUM(NSInteger, ToolbarMoveDirection) {
    ToolbarMoveDirectionDown = 1,
    ToolbarMoveDirectionUp = -1
};

@interface MainViewController ()
@property (strong, nonatomic) UIBarButtonItem* selectedEventTypeButton;
@property (nonatomic, getter=isToolbarHidden) BOOL toolbarHidden;
@property (nonatomic) dispatch_queue_t toolbarQueue;
@property (nonatomic) CGPoint previousScrollTranslation;
@property (nonatomic) BOOL viewDidAppearFromPop;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup toolbar buttons
    [self setupToolbar];

    // setup table
    [self setupTable];

    self.viewDidAppearFromPop = NO;
}

- (void)setupToolbar
{
    // toolbar show/hide queue
    self.toolbarQueue = dispatch_queue_create("MainViewControllerToolbarQueue", DISPATCH_QUEUE_SERIAL);

    // setup toolbar item
    [self.toolbar setItems:@[
        [UIBarButtonItem flexibleSpace],
        [UIBarButtonItem buttonWithTitle:@"arts+ent" target:self action:@selector(eventTypeButtonPressed:) tag:EventTypeArtsAndEntertainment],
        [UIBarButtonItem flexibleSpace],
        [UIBarButtonItem separator],
        [UIBarButtonItem flexibleSpace],
        [UIBarButtonItem buttonWithTitle:@"food+drink" target:self action:@selector(eventTypeButtonPressed:) tag:EventTypeFoodAndDrink],
        [UIBarButtonItem flexibleSpace],
        [UIBarButtonItem separator],
        [UIBarButtonItem flexibleSpace],
        [UIBarButtonItem buttonWithTitle:@"nightlife" target:self action:@selector(eventTypeButtonPressed:) tag:EventTypeNightLife],
        [UIBarButtonItem flexibleSpace],
        [UIBarButtonItem separator],
        [UIBarButtonItem flexibleSpace],
        [UIBarButtonItem buttonWithTitle:@"other" target:self action:@selector(eventTypeButtonPressed:) tag:EventTypeOther],
        [UIBarButtonItem flexibleSpace],
    ]];

    // select first item
    [self selectEventType];

    // set not hidden
    [self showToolbar];
}

- (void)selectEventType
{
    NSNumber* eventTypeNum = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsHomeSelectedEventTypeKey];
    EventType eventType = [eventTypeNum integerValue];

    UIBarButtonItem* selectedButton;

    switch (eventType) {
    default:
    case EventTypeArtsAndEntertainment:
        selectedButton = self.toolbar.items[1];
        break;

    case EventTypeFoodAndDrink:
        selectedButton = self.toolbar.items[5];
        break;

    case EventTypeNightLife:
        selectedButton = self.toolbar.items[9];
        break;

    case EventTypeOther:
        selectedButton = self.toolbar.items[13];
        break;
    }

    [self setSelectedEventTypeButton:selectedButton];
}

- (void)setupTable
{
    // delegate
    self.tableView.delegate = self;

    // data source
    self.eventsDataSource = [[EventsDataSource alloc] initWithTableView:self.tableView
                                                         cellIdentifier:[EventTableViewCell cellIdentifer]];
    self.eventsDataSource.enabled = NO;
    self.tableView.dataSource = self.eventsDataSource;

    // register cell from xib
    [self.tableView registerNib:[UINib nibWithNibName:[EventTableViewCell cellIdentifer] bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[EventTableViewCell cellIdentifer]];

    // set content inset to acount for the toolbar
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.toolbar.frame), 0);

    // set zero
    self.previousScrollTranslation = CGPointZero;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // deselect any selected rows
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];

    if(!self.viewDidAppearFromPop){
        [self retrieveEvents];
        self.viewDidAppearFromPop = NO;
    }
}

- (void)retrieveEvents
{
    // make sure all retrive changes happen at the same time
    [self.eventsDataSource setEnabled:NO];
    [self.tableView reloadData];

    [self.backgroundLabel setText:@"Loading Events..."];
    [self.backgroundLabel setHidden:NO];

    // fetch data
    [[LunrAPI sharedInstance] retrieveEventsSuccess:^{
        // success
        // NSLog(@"retrieveEventsSuccess: retrieved");

        [self.eventsDataSource setEnabled:YES];
        [self.eventsDataSource resetFetchedResultsController];
        [self.tableView reloadData];

        [self.backgroundLabel setHidden:YES];

    } failure:^(NSError* error) {
        // error
        NSLog(@"retrieveEventsSuccess: failure!");
        [self.backgroundLabel setText:@"Could Not Load Events"];
    }];
}

#pragma mark - Properties

- (void)setSelectedEventTypeButton:(UIBarButtonItem*)selectedEventTypeButton
{
    // set previous button to normal color
    [self.selectedEventTypeButton setTintColor:[UIColor eventTypeNormalColor]];

    // set selected button
    _selectedEventTypeButton = selectedEventTypeButton;

    // set selected button's color
    [self.selectedEventTypeButton setTintColor:[UIColor eventTypeSelectedColor]];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self performSegueWithIdentifier:@"showEventSegue" sender:self];
}

#pragma mark - Segues

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEventSegue"]) {
        // prepare to show event
        // get event
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        Event* event = [self.eventsDataSource itemAtIndexPath:indexPath];

        // set event
        EventViewController* eventVC = [segue destinationViewController];
        [eventVC setEvent:event];

        self.viewDidAppearFromPop = YES;
    }
}

#pragma mark - Pan Gesture

- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint velocity = [recognizer velocityInView:recognizer.view];

    // determine direction
    if (velocity.y > 0) {
        [self showToolbar];

    } else if (velocity.y < 0) {
        [self hideToolbar];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Hide/Show Toolbar

- (void)hideToolbar
{
    dispatch_sync(self.toolbarQueue, ^{
        static BOOL hidding = NO;

        // prevent hide animation from being called multiple times
        if(self.toolbarHidden || hidding){
            return;
        }
        hidding = YES;

        // move the tab bar and attached view in a positive/down direction
        [self moveToolbarInDirection:ToolbarMoveDirectionDown completion:^(BOOL finished) {
            self.toolbarHidden = YES;
            hidding = NO;
        }];
    });
}

- (void)showToolbar
{
    dispatch_sync(self.toolbarQueue, ^{
        static BOOL showing = NO;

        // prevent hide animation from being called multiple times
        if(!self.toolbarHidden || showing){
            return;
        }
        showing = YES;

        // move the tab bar and attached view in a positive/down direction
        [self moveToolbarInDirection:ToolbarMoveDirectionUp completion:^(BOOL finished) {
            self.toolbarHidden = NO;
            showing = NO;
        }];
    });
}

- (void)moveToolbarInDirection:(ToolbarMoveDirection)direction completion:(void (^)(BOOL finished))completion
{
    // move views
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        // hide all the attached views by moving them down
        CGRect frame = self.toolbar.frame;
        if(direction == ToolbarMoveDirectionUp){
            frame.origin.y = CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(self.toolbar.frame);
        } else {
            frame.origin.y = CGRectGetHeight(self.tableView.frame);
        }
        self.toolbar.frame = frame;

    } completion:completion];
}

#pragma mark - Actions

- (void)eventTypeButtonPressed:(UIBarButtonItem*)button
{
    // save the choice
    EventType eventType = button.tag;
    [[NSUserDefaults standardUserDefaults] setObject:@(eventType) forKey:UserDefaultsHomeSelectedEventTypeKey];

    // reset the data source
    [self.eventsDataSource resetFetchedResultsController];
    [self retrieveEvents];

    // change the selection
    [self setSelectedEventTypeButton:button];
}

@end
