//
//  LoginViewController.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField* emailTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton* logInButton;
@property (weak, nonatomic) IBOutlet UIButton* signUpButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* lunrLogoHeightContraint;

- (IBAction)loginButtonPressed:(id)sender;

- (IBAction)unwindToLoginViewController:(UIStoryboardSegue*)unwindSegue;

@end
