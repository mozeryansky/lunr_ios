//
//  NSError+UnknownError.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/18/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Extensions)

+ (NSError*)unknownError;

+ (NSError*)errorWithDescription:(NSString*)description;

@end
