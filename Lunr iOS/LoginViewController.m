//
//  LoginViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "LoginViewController.h"

#import "UIViewController+Alerts.h"
#import "UIViewController+FormValidation.h"
#import "LunrAPI.h"

@interface LoginViewController ()
@property (nonatomic) BOOL keyboardIsHidden;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // set keyboard is hidden
    self.keyboardIsHidden = YES;

    // set no text for disabled state
    [self.logInButton setTitle:@"" forState:UIControlStateDisabled];

    // TODO: remove
    [self.emailTextField setText:@"mozer624@gmail.com"];
    [self.passwordTextField setText:@"password"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // setup notifications for keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // stop activity indicator
    [self stopActivityIndicator];
}

#pragma mark - Login

- (void)attempLogin
{
    // hide keyboard
    [self.view endEditing:YES];

    // turn on spinner
    [self startActivityIndicator];

    // setup validation
    NSDictionary* fields = @{
        @"Email" : @{
            @"textField" : self.emailTextField,
            @"validate" : @[ @"notEmpty", @"validEmail" ]
        },
        @"Password" : @{
            @"textField" : self.passwordTextField,
            @"validate" : @[ @"notEmpty" ]
        }
    };

    // verify all fields are not empty
    [self validateTextField:fields success:^{
        // valid form

        // get field values
        NSString* email = self.emailTextField.text;
        NSString* password = self.passwordTextField.text;

        // attempt login
        [self loginWithEmail:email password:password];

    } failure:^(NSError* error) {
        // invalid form

        // stop spinner
        [self stopActivityIndicator];

        // alert message
        [self alertWithTitle:@"Could Not Login" message:[error localizedDescription]];
    }];
}

- (void)loginWithEmail:(NSString*)email password:(NSString*)password
{
    // attempt login
    [[LunrAPI sharedInstance] loginWithEmail:email password:password success:^{
        // stop spinner
        [self stopActivityIndicator];

        // user is logged in, dismiss
        [self dismissViewControllerAnimated:YES completion:nil];

    } failure:^(NSError* error) {
        // stop spinner
        [self stopActivityIndicator];

        // alert failure
        [self alertWithTitle:@"Could Not Login"
                     message:@"Invalid username or password.\nPlease try again."];

    }];
}

#pragma mark - Activity Indicator

- (void)startActivityIndicator
{
    // disable login button
    [self.logInButton setEnabled:NO];

    // start spinngin
    [self.activityIndicator startAnimating];
}

- (void)stopActivityIndicator
{
    // stop spinngin
    [self.activityIndicator stopAnimating];

    // enable login button
    [self.logInButton setEnabled:YES];
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenHeight = screenSize.height;

    CGFloat buffer = 32;
    screenHeight -= buffer;

    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;

    CGFloat maxY = CGRectGetMaxY(self.signUpButton.frame);

    CGFloat newSize = (150 - (maxY - (screenHeight - keyboardHeight)));

    if (newSize < 0) {
        newSize = 0;
    } else if (newSize > 150) {
        newSize = 150;
    }

    if (self.keyboardIsHidden) {
        [self animateLunrLogoSizeConstant:newSize];
    }

    self.keyboardIsHidden = NO;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    if (!self.keyboardIsHidden) {
        [self animateLunrLogoSizeConstant:150];
    }

    self.keyboardIsHidden = YES;
}

- (void)animateLunrLogoSizeConstant:(CGFloat)constant
{
    [self.view layoutIfNeeded];

    self.lunrLogoHeightContraint.constant = constant;

    // animate contraint changes
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark - Actions

- (IBAction)loginButtonPressed:(id)sender
{
    [self attempLogin];
}

#pragma mark - Segues

- (IBAction)unwindToLoginViewController:(UIStoryboardSegue*)unwindSegue
{
}

@end
