//
//  TreatsViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "TreatsViewController.h"

#import "EventTableViewCell.h"

@interface TreatsViewController ()

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
    self.tableView.dataSource = self;

    // register cell from xib
    static NSString* CellIdentifier = @"TreatTableViewCell";
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
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
    static NSString* CellIdentifier = @"TreatTableViewCell";
    EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self performSegueWithIdentifier:@"showTreatSegue" sender:self];
}

@end
