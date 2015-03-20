//
//  TreatsViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "TreatsViewController.h"

#import "TreatTableViewCell.h"
#import "TreatsDataSource.h"
#import "LunrAPI.h"

@interface TreatsViewController ()

@property (strong, nonatomic) TreatsDataSource* treatsDataSource;
@end

@implementation TreatsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupTable];
}

- (void)setupTable
{
    // delegate
    self.tableView.delegate = self;

    // data source
    self.treatsDataSource = [[TreatsDataSource alloc] initWithTableView:self.tableView cellIdentifier:[TreatTableViewCell cellIdentifer]];
    self.tableView.dataSource = self.treatsDataSource;

    // register cell from xib
    [self.tableView registerNib:[UINib nibWithNibName:[TreatTableViewCell cellIdentifer] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[TreatTableViewCell cellIdentifer]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // deselect any selected rows
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];

    // fetch data
    [[LunrAPI sharedInstance] retrieveTreats];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self performSegueWithIdentifier:@"showTreatSegue" sender:self];
}

@end
