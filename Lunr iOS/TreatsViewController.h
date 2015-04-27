//
//  TreatsViewController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TreatsDataSource.h"

@interface TreatsViewController : UIViewController <UITableViewDelegate>

@property (strong, nonatomic) TreatsDataSource* treatsDataSource;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;

- (void)retrieveTreats;

@end
