//
//  SavedViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "SavedViewController.h"

#import "EventTableViewCell.h"
#import "SavedDataSource.h"
#import "EventViewController.h"
#import "Event.h"

@interface SavedViewController ()
@property (strong, nonatomic) SavedDataSource *savedDataSource;
@end

@implementation SavedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup table
    [self setupTable];
}

- (void)setupTable
{
    // delegate
    self.tableView.delegate = self;

    // data source
    self.savedDataSource = [[SavedDataSource alloc] initWithTableView:self.tableView cellIdentifier:[EventTableViewCell cellIdentifer]];
    self.savedDataSource.enabled = YES;
    self.tableView.dataSource = self.savedDataSource;

    // register cell from xib
    static NSString* CellIdentifier = @"EventTableViewCell";
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
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
    if([[segue identifier] isEqualToString:@"showEventSegue"]){
        // prepare to show event
        // get event
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Event *event = [self.savedDataSource itemAtIndexPath:indexPath];

        // set event
        EventViewController *eventVC = [segue destinationViewController];
        [eventVC setEvent:event];
    }
}

@end
