//
//  UITextField+Validation.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/18/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Validation)

- (void)notEmpty_info:(NSDictionary*)info error:(NSError**)error;

- (void)validEmail_info:(NSDictionary*)info error:(NSError**)error;

- (void)equalsField_info:(NSDictionary*)info error:(NSError**)error;

@end
