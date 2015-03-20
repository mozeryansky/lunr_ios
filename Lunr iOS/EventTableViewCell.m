//
//  EventTableViewCell.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/28/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "EventTableViewCell.h"

@interface EventTableViewCell ()

@end

@implementation EventTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    // round corners
    self.containerView.layer.cornerRadius = 2.0;
    self.borderView.layer.cornerRadius = 2.0;
}

+ (NSString*)cellIdentifer
{
    static NSString* CellIdentifier = @"EventTableViewCell";

    return CellIdentifier;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        // set container view selected color
        self.containerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];

    } else {
        // set container view not selected color
        self.containerView.backgroundColor = [UIColor whiteColor];
    }
}

@end
