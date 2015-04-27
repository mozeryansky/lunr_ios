//
//  NavigationController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/22/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationTabController : UINavigationController <UITextFieldDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImageView* navigationIcon;
@property (strong, nonatomic) UIButton* navigationSearchButton;
@property (strong, nonatomic) UITextField* searchTextField;

@end
