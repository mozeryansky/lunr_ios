//
//  SelectableButton.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/27/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectableButton : UIButton

@property (nonatomic, getter=isMomentary) IBInspectable BOOL momentary;

@end