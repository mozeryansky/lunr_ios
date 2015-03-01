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

@interface MainViewController ()
@property (nonatomic) UIBarButtonItem* selectedEventTypeButton;
@property (nonatomic, getter=isHidden) BOOL toolbarHidden;
@property (nonatomic) dispatch_queue_t toolbarQueue;
@property (nonatomic) CGPoint previousScrollTranslation;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup toolbar buttons
    [self setupToolbar];

    // setup table
    [self setupTable];
}

- (void)setupToolbar
{
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
    [self setSelectedEventTypeButton:self.toolbar.items[1]];

    // set not hidden
    self.toolbarHidden = NO;

    // toolbar show/hide queue
    self.toolbarQueue = dispatch_queue_create("MainViewControllerToolbarQueue", DISPATCH_QUEUE_SERIAL);
}

- (void)setupTable
{
    // delegate
    self.tableView.delegate = self;

    // data source
    self.tableView.dataSource = self;

    // register cell from xib
    static NSString* CellIdentifier = @"EventTableViewCell";
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];

    // set content inset to acount for the toolbar
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.toolbar.frame), 0);

    // set zero
    self.previousScrollTranslation = CGPointZero;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
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

#pragma mark - Search

- (void)beginSearch
{
    // set focus on search controller
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"EventTableViewCell";
    EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    return cell;
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Pan Gesture

- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint velocity = [recognizer velocityInView:recognizer.view];

    // determine direction
    if (velocity.y > 0) {
        [self hideToolbar];

    } else if (velocity.y < 0) {
        [self showToolbar];
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
        [self moveToolbarInDirection:1 completion:^(BOOL finished) {
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
        [self moveToolbarInDirection:-1 completion:^(BOOL finished) {
            self.toolbarHidden = NO;
            showing = NO;
        }];
    });
}

- (void)moveToolbarInDirection:(NSInteger)direction completion:(void (^)(BOOL finished))completion
{
    // move views
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        // hide all the attached views by moving them down
        CGRect frame = self.toolbar.frame;
        frame.origin.y += direction * CGRectGetHeight(self.toolbar.frame);
        self.toolbar.frame = frame;

    } completion:completion];
}

#pragma mark - Actions

- (void)eventTypeButtonPressed:(UIBarButtonItem*)button
{
    [self setSelectedEventTypeButton:button];
}

@end
