//
//  UIViewController+FormValidation.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/18/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "UIViewController+FormValidation.h"

#import "UITextField+Validation.h"
#import "NSError+Extensions.h"

@implementation UIViewController (FormValidation)

- (void)validateTextField:(NSDictionary*)fields success:(void (^)())success failure:(void (^)(NSError* error))failure
{
    for (NSString* fieldName in fields) {
        // get info
        NSDictionary* info = fields[fieldName];

        NSString* invalidValidatorErrorDescription = [NSString stringWithFormat:@"Invalid validator error on '%@' field", fieldName];
        NSError* invalidValidatorError = [NSError errorWithDescription:invalidValidatorErrorDescription];

        // get text field
        UITextField* textField = info[@"textField"];
        if (!textField) {
            NSLog(@"validateTextField error: text field named '%@' doesn't have a 'textField' info key", fieldName);
            if (failure) {
                failure(invalidValidatorError);
            }
            return;
        }

        // get validations
        NSArray* validations = info[@"validate"];
        if (!validations) {
            NSLog(@"validateTextField error: text field named '%@' doesn't have a 'validate' info key", fieldName);
            if (failure) {
                failure(invalidValidatorError);
            }
            return;
        }

        // validate
        for (id validation in validations) {
            //
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            [params setObject:fieldName forKey:@"fieldName"];

            NSString* selectorName;

            // package selector into a dictionary
            if ([validation isKindOfClass:[NSString class]]) {
                // user selectorName as the selectorName
                selectorName = validation;

            } else if ([validation isKindOfClass:[NSDictionary class]]) {
                // use validation as the info dictionary
                selectorName = [(NSDictionary*)validation allKeys][0]; // first key is the selector name
                if (!selectorName) {
                    NSLog(@"validateTextField error: text field named '%@' doesn't have a selector name for a dictionary validator", fieldName);
                    if (failure) {
                        failure(invalidValidatorError);
                    }
                    return;
                }

                // add other values to the info dictionary
                NSArray* extra = ((NSDictionary*)validation)[selectorName];
                [params setObject:extra forKey:@"extra"];

            } else {
                NSLog(@"validateTextField error: text field named '%@' has an invalid validator", fieldName);
                if (failure) {
                    failure(invalidValidatorError);
                }
                return;
            }

            // create selector
            NSString* fullSelectorName = [NSString stringWithFormat:@"%@_info:error:", selectorName];
            SEL selector = NSSelectorFromString(fullSelectorName);

            // check if validation selector exists
            if (![textField canPerformAction:selector withSender:self]) {
                NSLog(@"validateTextField, no validator with selector '%@'", fullSelectorName);
                if (failure) {
                    failure(invalidValidatorError);
                }
                return;
            }

            // perform selector to check if the field is valid
            IMP imp = [textField methodForSelector:selector];
            void (*func)(id, SEL, NSDictionary*, NSError**) = (void*)imp;
            NSError* error = nil;
            func(textField, selector, params, &error);

            // check error
            if (error) {
                if (failure) {
                    // failure
                    failure(error);
                }
                return;
            }
        }
    }

    // all validations passed
    if (success) {
        success();
    }
}

@end
