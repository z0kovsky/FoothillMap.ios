//
//  FHClassInfo.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 05.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHClass.h"

@implementation FHClass

@synthesize time = _time;
@synthesize title = _title;
@synthesize location = _location;
@synthesize weekday = _weekday;
@synthesize delegate = _delegate;

+(NSString *)GetUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+(id)empty {
    return [[FHClass alloc] initWithTitle:@"" andTime:[NSDate date] weekday:2 location:@""];
}

+(id)classInfoWithTitle:(NSString *)title andTime:(NSDate *)time weekday:(NSInteger)weekday location:(NSString *)location {
    return [[FHClass alloc] initWithTitle:title andTime:time weekday:weekday location:location];
}

-(id)initWithTitle:(NSString *)title andTime:(NSDate *)time weekday:(NSInteger)weekday location:(NSString *)location {
    if (self = [super init]) {
        _time = time;
        _title = title;
        _location = location;
        _weekday = weekday;
        _ID = [FHClass GetUUID];
    }
    return self;
}

-(NSString *)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    NSString *dateString = [dateFormatter stringFromDate:_time];
    return dateString;
}

-(void)dealloc {
    _time = nil;
    _title = nil;
    _location = nil;
}

-(void)setWeekday:(NSInteger)weekday {
    NSInteger oldweekday = _weekday;
    _weekday = weekday;
    [self.delegate weekdayChangedDelegateMethod:self oldWeekday:oldweekday];

}

-(NSInteger)weekday {
    return _weekday;
}

-(void)setTime:(NSDate *)time {
    NSDate *oldTime = _time;
    _time = time;
    [self.delegate timeChangedDelegateMethod:self oldTime:oldTime];
}

-(NSDate *)time {
    return _time;
}

-(void)setLocation:(NSString *)location {
    NSString *oldlocation = _location;
    _location = location;
    [self.delegate locationChangedDelegateMethod:self oldLocation:oldlocation];
}

-(NSString *)location {
    return _location;
}

-(void)setTitle:(NSString *)title {
    NSString *oldTitle = _title;
    _title = title;
    [self.delegate titleChangedDelegateMethod:self oldTitle:oldTitle];
}

-(NSString *)title {
    return _title;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:_location forKey:@"location"];

    [aCoder encodeInt:_weekday forKey:@"weekday"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setTime:[aDecoder decodeObjectForKey:@"time"]];
        [self setLocation:[aDecoder decodeObjectForKey:@"location"]];

        [self setWeekday:[aDecoder decodeIntForKey:@"weekday"]];
    }
    return self;
}

-(NSInteger)classDuration {
    return 60;
}

-(NSComparisonResult)compareTime:(FHClass *)item {
    NSComparisonResult result = NSOrderedSame;

    NSString *timeStr = [[self timeString] lowercaseString];
    NSString *item_timeStr = [[item timeString] lowercaseString];

    if ([timeStr rangeOfString:@"pm"].location != NSNotFound) {
        [timeStr stringByReplacingOccurrencesOfString:@"pm" withString:@""];
        timeStr = [NSString stringWithFormat:@"9%@", timeStr];
    }
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"am" withString:@""];

    if ([item_timeStr rangeOfString:@"pm"].location != NSNotFound) {
        [item_timeStr stringByReplacingOccurrencesOfString:@"pm" withString:@""];
        item_timeStr = [NSString stringWithFormat:@"9%@", item_timeStr];
    }
    item_timeStr = [item_timeStr stringByReplacingOccurrencesOfString:@"am" withString:@""];


    int timeInt = [timeStr stringByReplacingOccurrencesOfString:@":" withString:@""].intValue;
    int item_timeInt = [item_timeStr stringByReplacingOccurrencesOfString:@":" withString:@""].intValue;

    result = timeInt == item_timeInt ?
            NSOrderedSame :
            timeInt > item_timeInt ? NSOrderedDescending : NSOrderedAscending;
    return result;
}

@end
