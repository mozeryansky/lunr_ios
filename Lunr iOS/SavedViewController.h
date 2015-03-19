//
//  SavedViewController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end
