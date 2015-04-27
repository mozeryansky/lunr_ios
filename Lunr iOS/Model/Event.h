#import "_Event.h"

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, EventType) {
    EventTypeArtsAndEntertainment = 1,
    EventTypeFoodAndDrink,
    EventTypeNightLife,
    EventTypeOther
};

@interface Event : _Event {
}

- (CLLocation *)location;

+ (EventType)eventTypeFromString:(NSString*)eventTypeString;
+ (NSString*)stringFromEventType:(EventType)eventType;

+ (UIColor*)colorForTimeString:(NSString*)timeString;
+ (NSString*)makeTimeLabelStart:(NSDate*)start end:(NSDate*)end;
+ (NSDateComponents*)dateComponentsBetween:(NSDate*)dt1 and:(NSDate*)dt2;

@end
