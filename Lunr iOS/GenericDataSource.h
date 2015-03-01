//
//  GenericDataSource.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id event);

@interface GenericDataSource : NSObject <UITableViewDataSource>

- (id)initWithCellIdentifier:(NSString*)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

@end