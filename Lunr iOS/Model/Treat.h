#import "_Treat.h"

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Treat : _Treat {}
// Custom logic goes here.

- (CLLocation *)location;

+ (UIColor*)colorForTimeString:(NSString*)timeString;
+ (NSString*)makeTimeLabelStart:(NSDate*)start end:(NSDate*)end;
+ (NSDateComponents*)dateComponentsBetween:(NSDate*)dt1 and:(NSDate*)dt2;


@end
