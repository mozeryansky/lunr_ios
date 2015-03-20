//
//  RegisterViewController.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 2/20/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "RegisterViewController.h"

#import "UIViewController+Alerts.h"
#import "UIViewController+FormValidation.h"
#import "LunrAPI.h"

@interface RegisterViewController ()
@property (nonatomic) BOOL keyboardIsHidden;
@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.keyboardIsHidden = YES;

    // set no text for disabled state
    [self.registerButton setTitle:@"" forState:UIControlStateDisabled];

    // TODO: remove
    [self.emailTextField setText:@"mozer624@gmail.com"];
    [self.nameTextField setText:@"Michael"];
    [self.passwordTextField setText:@"password"];
    [self.passwordConfirmationTextField setText:@"password"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // stop activity indicator
    [self.activityIndicator stopAnimating];
}

#pragma mark - Register

- (void)attempRegister
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
        @"Name" : @{
            @"textField" : self.nameTextField,
            @"validate" : @[ @"notEmpty" ]
        },
        @"Password" : @{
            @"textField" : self.passwordTextField,
            @"validate" : @[ @"notEmpty" ]
        },
        @"Password Confirmation" : @{
            @"textField" : self.passwordConfirmationTextField,
            @"validate" : @[ @"notEmpty", @{ @"equalsField" : @[ @"Password", self.passwordTextField ] } ]
        }
    };

    // verify all fields are not empty
    [self validateTextField:fields success:^{
        // valid form

        // get field values
        NSString* email = self.emailTextField.text;
        NSString *name = self.nameTextField.text;
        NSString* password = self.passwordTextField.text;

        // attempt login
        [self registerWithEmail:email name:name password:password];

    } failure:^(NSError* error) {
        // invalid form

        // stop spinner
        [self stopActivityIndicator];

        // alert message
        [self alertWithTitle:@"Could Not Register" message:[error localizedDescription]];
    }];
}

- (void)registerWithEmail:(NSString*)email name:(NSString*)name password:(NSString*)password
{
    // attempt login
    [[LunrAPI sharedInstance] registerWithEmail:email name:name password:password success:^{
        // stop spinner
        [self stopActivityIndicator];

        // user is registered in, dismiss
        [self dismissViewControllerAnimated:YES completion:nil];

    } failure:^(NSError* error) {
        // stop spinner
        [self stopActivityIndicator];

        // alert failure
        [self alertWithTitle:@"Could Not Register"
                     message:[error localizedDescription]];

    }];
}

#pragma mark - Activity Indicator

- (void)startActivityIndicator
{
    // disable button
    [self.registerButton setEnabled:NO];

    // start spinning
    [self.activityIndicator startAnimating];
}

- (void)stopActivityIndicator
{
    // stop spinning
    [self.activityIndicator stopAnimating];

    // enable button
    [self.registerButton setEnabled:YES];
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenHeight = screenSize.height;

    CGFloat buffer = 30;
    screenHeight -= buffer;

    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;

    CGFloat maxY = CGRectGetMaxY(self.signInButton.frame);

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

- (IBAction)registerButtonPressed:(id)sender
{
    [self attempRegister];
}

@end
