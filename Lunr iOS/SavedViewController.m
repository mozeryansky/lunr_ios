//
//  SavedViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "SavedViewController.h"

#import "EventTableViewCell.h"

@interface SavedViewController ()

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
    self.tableView.dataSource = self;

    // register cell from xib
    static NSString* CellIdentifier = @"EventTableViewCell";
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
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

@end
