//
//  UITextField+Validation.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/18/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "UITextField+Validation.h"

#import "NSError+Extensions.h"

@implementation UITextField (Validation)

- (void)notEmpty_info:(NSDictionary*)info error:(NSError**)error
{
    if (self.text.length == 0) {
        // invalid
        // set error
        NSString* name = info[@"fieldName"];
        NSString* description = [NSString stringWithFormat:@"%@ field can not be empty", name];
        *error = [NSError errorWithDescription:description];
        return;
    }

    // valid
}

- (void)validEmail_info:(NSDictionary*)info error:(NSError**)error
{
}

- (void)equalsField_info:(NSDictionary*)info error:(NSError**)error
{
    NSString* fieldName = info[@"fieldName"];

    NSString* invalidValidatorErrorDescription = [NSString stringWithFormat:@"Invalid validator error on '%@' field", fieldName];
    NSError* invalidValidatorError = [NSError errorWithDescription:invalidValidatorErrorDescription];

    // get extra array
    NSArray* extra = info[@"extra"];
    if (!extra) {
        NSLog(@"equalsField validator error, expected extra array was not passed");
        *error = invalidValidatorError;
        return;
    }

    // get compared field name
    NSString* originalFieldName = extra[0];
    if (!originalFieldName || ![originalFieldName isKindOfClass:[NSString class]]) {
        NSLog(@"equalsField validator error, extra array does contain the required original field name as the first parameter");
        *error = invalidValidatorError;
        return;
    }

    UITextField* originalTextField = extra[1];
    if (!originalTextField || ![originalTextField isKindOfClass:[UITextField class]]) {
        NSLog(@"equalsField validator error, extra array does contain the required text field as the second parameter");
        *error = invalidValidatorError;
        return;
    }

    NSString* compareText = originalTextField.text;
    if (![compareText isEqualToString:self.text]) {
        // not equal
        NSString* description = [NSString stringWithFormat:@"%@ field must match the %@ field", fieldName, originalFieldName];
        *error = [NSError errorWithDescription:description];
        return;
    }

    // valid
}

@end
