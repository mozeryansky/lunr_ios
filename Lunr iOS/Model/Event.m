#import "Event.h"


@interface Event ()

// Private interface goes here.

@end

@implementation Event

- (CLLocation *)location
{
    CLLocationDegrees lat = self.latitudeValue;
    CLLocationDegrees lon = self.longitudeValue;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];

    return location;
}

+ (EventType)eventTypeFromString:(NSString*)eventTypeString
{
    NSDictionary* typeMap = @{
        // arts and entertainment
        @"arts_ent" : @(EventTypeArtsAndEntertainment),

        // food and drink
        @"food_drink" : @(EventTypeFoodAndDrink),

        // nightlife
        @"nightlife" : @(EventTypeNightLife),

        // other
        @"other" : @(EventTypeOther)
    };

    NSNumber* eventTypeNum = typeMap[eventTypeString];
    if (!eventTypeNum) {
        // not found, use default
        NSLog(@"eventTypeString has no key named: '%@'", eventTypeString);
        eventTypeNum = @(EventTypeNightLife);
    }

    return [eventTypeNum integerValue];
}

+ (NSString*)stringFromEventType:(EventType)eventType
{
    switch (eventType) {
        case EventTypeArtsAndEntertainment:
            return @"arts_ent";
            break;

        case EventTypeFoodAndDrink:
            return @"food_drink";
            break;

        default:
        case EventTypeNightLife:
            return @"nightlife";
            break;

        case EventTypeOther:
            return @"other";
            break;
    }
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
    /*
     DateTime time = dtf.withZone(DateTimeZone.UTC).parseDateTime(date);
     DateTime end_time = dtf.withZone(DateTimeZone.UTC).parseDateTime(end_date);

     DateTime local_time = time.withZone(DateTimeZone.getDefault());
     DateTime local_end_time = end_time.withZone(DateTimeZone.getDefault());
     DateTime now = DateTime.now(DateTimeZone.getDefault());
     */

    NSDate* now = [NSDate date];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    now = [now dateByAddingTimeInterval:timeZoneSeconds];

    /*
     if (type.equals("place")) {
     Log.i("xxx", "rch");
     local_time = new DateTime(now.getYear(), now.getMonthOfYear(), now.getDayOfMonth(), time.getHourOfDay(), time.getMinuteOfHour(), DateTimeZone.getDefault());
     DateTime finish;
     if (time.getHourOfDay() > end_time.getHourOfDay()) {
     finish = now.plusDays(1);
     } else {
     finish = now;
     }
     local_end_time = new DateTime(finish.getYear(), finish.getMonthOfYear(), finish.getDayOfMonth(), end_time.getHourOfDay(), end_time.getMinuteOfHour(), DateTimeZone.getDefault());

     }
     */

    NSString* prefix_time;

    NSDateComponents* nowFromStart = [self dateComponentsBetween:now and:start];
    NSDateComponents* nowFromEnd = [self dateComponentsBetween:now and:end];
    NSInteger daysDiff = [nowFromStart day];

    /*
     if (type.equals("place")) {
     Log.i("time", local_time + "");
     }
     */
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
                prefix_time = @"Ongoing";
                /*
                 if (type != null && type.equals("place")) {
                 prefix_time = @"Open";
                 }
                 */

                if (minDiff < 90 && minDiff > 0) {
                    /*
                     if (type != null && type.equals("place")) {
                     prefix_time = "Closing soon";
                     } else {
                     prefix_time = "Ending soon";
                     }
                     */
                    prefix_time = @"Ending soon";
                }
            }
            minDiff = [nowFromStart minute];
            if (minDiff < 0 && minDiff > -90) {
                prefix_time = @"Starting soon";
                /*
                 if (type != null && type.equals("place")) {
                 prefix_time = "Opening soon";
                 }
                 */
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
    /*
     DateTimeFormatter builder = DateTimeFormat.forPattern("h:mm a");
     String append = "";
     for (int i = 0; i < start_timeList.size(); i++) {
     DateTime x = dtf.withZone(DateTimeZone.UTC).parseDateTime(start_timeList.get(i));
     DateTime y = dtf.withZone(DateTimeZone.UTC).parseDateTime(end_timeList.get(i));
     append += "," + builder.print(x) + "-" + builder.print(y);
     }
     prefix_time += " | " + builder.print(local_time) + "-" + builder.print(local_end_time) + append;
     */

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
