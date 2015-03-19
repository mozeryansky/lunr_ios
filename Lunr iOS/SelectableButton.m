
//
//  SelectableButton.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/27/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "SelectableButton.h"

@interface SelectableButton ()
@property (strong, nonatomic) UIColor* normalTextColor;
@property (strong, nonatomic) UIColor* normalBackgroundColor;
@end

@implementation SelectableButton

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // save colors
        self.normalTextColor = [self titleColorForState:UIControlStateNormal];
        self.normalBackgroundColor = self.backgroundColor;

        // set highlight text color
    }
    return self;
}

- (void)awakeFromNib
{
    [self addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];

    if (!self.holdHighlight) {
        [self addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if(self.holdHighlight){
        [self setSelectedBackgroundColor:[self isSelected]];
    }
}

#pragma mark - Actions

- (void)buttonTouchDown:(id)sender
{
    [self setSelectedBackgroundColor:YES];
}

- (void)buttonTouchUp:(id)sender
{
    [self setSelectedBackgroundColor:NO];
}

#pragma mark - Helper Functions

- (void)setSelectedBackgroundColor:(BOOL)setSelectedColor
{
    if (setSelectedColor) {
        // set selected colors
        [self setTitleColor:self.normalBackgroundColor forState:UIControlStateNormal];
        [self setBackgroundColor:self.normalTextColor];

    } else {
        // set normal colors
        [self setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        [self setBackgroundColor:self.normalBackgroundColor];
    }
}

@end
