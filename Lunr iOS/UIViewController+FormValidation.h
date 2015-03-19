//
//  UIViewController+FormValidation.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/18/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FormValidation)

- (void)validateTextField:(NSDictionary*)fields success:(void (^)())success failure:(void (^)(NSError* error))failure;

@end
