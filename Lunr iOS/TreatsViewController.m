//
//  TreatsViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "TreatsViewController.h"

#import "TreatViewController.h"
#import "TreatTableViewCell.h"
#import "LunrAPI.h"
#import "Treat.h"

@interface TreatsViewController ()
@property (nonatomic) BOOL viewDidAppearFromPop;
@end

@implementation TreatsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupTable];

    self.viewDidAppearFromPop = NO;
    [self.backgroundLabel setHidden:YES];
}

- (void)setupTable
{
    // delegate
    self.tableView.delegate = self;

    // data source
    self.treatsDataSource = [[TreatsDataSource alloc] initWithTableView:self.tableView cellIdentifier:[TreatTableViewCell cellIdentifer]];

    self.treatsDataSource.enabled = NO;
    self.tableView.dataSource = self.treatsDataSource;

    // register cell from xib
    [self.tableView registerNib:[UINib nibWithNibName:[TreatTableViewCell cellIdentifer] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[TreatTableViewCell cellIdentifer]];

    // set content inset to acount for the tabbar
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // deselect any selected rows
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];

    if(!self.viewDidAppearFromPop){
        [self retrieveTreats];
        self.viewDidAppearFromPop = NO;
    }
}

- (void)retrieveTreats
{
    // make sure all retrive changes happen at the same time
    [self.treatsDataSource setEnabled:NO];
    [self.tableView reloadData];

    [self.backgroundLabel setText:@"Loading Treats..."];
    [self.backgroundLabel setHidden:NO];

    // fetch data
    [[LunrAPI sharedInstance] retrieveTreatsSuccess:^{
        // success
        // NSLog(@"retrieveEventsSuccess: retrieved");

        [self.treatsDataSource setEnabled:YES];
        [self.treatsDataSource resetFetchedResultsController];
        [self.tableView reloadData];

        [self.backgroundLabel setHidden:YES];

    } failure:^(NSError* error) {
        // error
        NSLog(@"retrieveTreatsSuccess: failure!");
        [self.backgroundLabel setText:@"Could Not Load Treats"];
    }];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self performSegueWithIdentifier:@"showTreatSegue" sender:self];
}

#pragma mark - Segues

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTreatSegue"]) {
        // prepare to show event
        // get event
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        Treat* treat = [self.treatsDataSource itemAtIndexPath:indexPath];

        // set event
        TreatViewController* treatVC = [segue destinationViewController];
        [treatVC setTreat:treat];

        self.viewDidAppearFromPop = YES;
    }
}

@end
