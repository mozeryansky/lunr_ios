//
//  NSError+UnknownError.m
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/18/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import "NSError+Extensions.h"

@implementation NSError (Extensions)

+ (NSError*)unknownError
{
    return [self errorWithDescription:@"An unknown error occurred."];
}

+ (NSError*)errorWithDescription:(NSString*)description
{
    NSDictionary* userInfo = @{
        NSLocalizedDescriptionKey : description
    };

    NSError* error = [[NSError alloc] initWithDomain:@""
                                                code:1
                                            userInfo:userInfo];
    return error;
}

@end
