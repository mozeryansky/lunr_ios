#import "Treat.h"

@interface Treat ()

// Private interface goes here.

@end

@implementation Treat

- (CLLocation *)location
{
    CLLocationDegrees lat = self.latitudeValue;
    CLLocationDegrees lon = self.longitudeValue;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];

    return location;
}

+ (UIColor*)colorForTimeString:(NSString*)timeString
{
    if([timeString rangeOfString:@"Ongoing |"].location != NSNotFound ||
       [timeString rangeOfString:@"Yesterday(Ongoing"].location != NSNotFound ||
       [timeString rangeOfString:@"Opening soon"].location != NSNotFound)
    {
        // #E18A07
        return [UIColor colorWithRed:0.847 green:0.466 blue:0.045 alpha:1.000];

    }

    if([timeString rangeOfString:@"Ending soon |"].location != NSNotFound ||
       [timeString rangeOfString:@"Yesterday(Ending soon"].location != NSNotFound ||
       [timeString rangeOfString:@"Closing soon |"].location != NSNotFound)
    {
        // #990000
        return [UIColor colorWithRed:0.522 green:0.000 blue:0.009 alpha:1.000];

    }

    if([timeString rangeOfString:@"Starting soon |"].location != NSNotFound ||
       [timeString rangeOfString:@"Open |"].location != NSNotFound)
    {
        // #009900
        return [UIColor colorWithRed:0.072 green:0.545 blue:0.008 alpha:1.000];
    }

    // #3C2841
    return [UIColor colorWithRed:0.177 green:0.113 blue:0.195 alpha:1.000];
}

+ (NSString*)makeTimeLabelStart:(NSDate*)start end:(NSDate*)end
{
    NSDate* now = [NSDate date];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    now = [now dateByAddingTimeInterval:timeZoneSeconds];

    NSString* prefix_time;

    NSDateComponents* nowFromStart = [self dateComponentsBetween:now and:start];
    NSDateComponents* nowFromEnd = [self dateComponentsBetween:now and:end];
    NSInteger daysDiff = [nowFromStart day];


    NSInteger minDiff;
    switch (daysDiff) {
        case -1:
            prefix_time = @"Yesterday(Ongoing)";
            minDiff = [nowFromEnd minute];
            if (minDiff < 90 && minDiff > 0) {
                prefix_time = @"Yesterday(Ending soon)";
            }
            break;
        case 0:
            prefix_time = @"Today";
            minDiff = [nowFromStart minute];
            if (minDiff < 0) {
                prefix_time = @"Open";

                if (minDiff < 90 && minDiff > 0) {
                    prefix_time = @"Closing soon";
                }
            }
            minDiff = [nowFromStart minute];
            if (minDiff < 0 && minDiff > -90) {
                prefix_time = @"Opening soon";
            }
            break;

        case 1:
            prefix_time = @"Tomorrow";
            break;

        default:
            if (daysDiff <= 6) {
                prefix_time = @"";
                if (daysDiff < 0) {
                    prefix_time = @"Last ";
                }

                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"EEE"];
                NSString* dayName = [dateFormatter stringFromDate:now];

                prefix_time = [NSString stringWithFormat:@"%@%@", prefix_time, dayName];

            } else {
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"EEE, MMM d"];
                NSString* dayFormat = [dateFormatter stringFromDate:now];

                prefix_time = dayFormat;
            }
            break;
    }

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString* startTime = [dateFormatter stringFromDate:start];
    NSString* endTime = [dateFormatter stringFromDate:end];

    prefix_time = [NSString stringWithFormat:@"%@ | %@ - %@", prefix_time, startTime, endTime];

    return prefix_time;
}

+ (NSDateComponents*)dateComponentsBetween:(NSDate*)dt1 and:(NSDate*)dt2
{
    NSUInteger unitFlags = NSCalendarUnitDay | kCFCalendarUnitMinute;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    
    return components;
}

@end
