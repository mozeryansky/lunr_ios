//
//  RegisterViewController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField* emailTextField;
@property (weak, nonatomic) IBOutlet UITextField* nameTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordConfirmationTextField;
@property (weak, nonatomic) IBOutlet UIButton* registerButton;
@property (weak, nonatomic) IBOutlet UIButton* signInButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lunrLogoWidthContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lunrLogoHeightContraint;

- (IBAction)registerButtonPressed:(id)sender;

@end
