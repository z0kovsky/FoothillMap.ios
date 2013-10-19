//
//  FHController.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 27.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHController.h"
#import "ScheduleViewController.h"
#import "MapViewController.h"
#import "FHMapSettingList.h"

// This controller is responsible for Current&Next classes
// and their appearance on a map. It uses timer and
// It is listening to Map and Schedule for events
@implementation FHController {
    ScheduleViewController *_schedule;
    MapViewController *_map;
    NSTimer *timer;


    FHClass *currentClass;
    FHClass *nextClass;
    NSMutableArray *todayClassList;

    Boolean filter_current;
    Boolean filter_next;
    Boolean filter_today;
}

-(id)initWithMap:(MapViewController *)map Schedule:(ScheduleViewController *)schedule {
    NSLog(@"FHController init");

    if (self = [super init]) {
        _schedule = schedule;
        _map = map;

        todayClassList = [[NSMutableArray alloc] init];
        currentClass = nil;
        nextClass = nil;

        [FHMapSettingList sharedSettings].delegate = self;
        [FHClassSchedule sharedSchedule].delegate = self;

        for (FHMapSetting *setting in [[FHMapSettingList sharedSettings] allItems].allValues) {
            if ([setting.show isEqualToString:@"YES"]) {
                [_map updateBySetting:setting];

                switch (setting.filter) {
                    case FHMapFilter_NextClass:
                        filter_next = true;
                        break;
                    case FHMapFilter_CurrentClass:
                        filter_current = true;
                        break;
                    case FHMapFilter_AllTodayClasses:
                        filter_today = true;
                        break;
                    default:
                        break;
                }
            }
        }

        [self onTick:nil];
        timer = [NSTimer scheduledTimerWithTimeInterval:60.0f
                                                 target:self
                                               selector:@selector(onTick:)
                                               userInfo:nil
                                                repeats:YES];
    }

    return self;
}

-(void)onTick:(NSTimer *)timer {
    NSLog(@"FHController onTick");
    NSDate *currentDate = [NSDate date];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSWeekdayCalendarUnit) fromDate:currentDate];
    NSInteger weekday = [components weekday];

    // today's classes
    NSString *key = [NSString stringWithFormat:@"%d", weekday];
    todayClassList = [NSMutableArray arrayWithArray:[[[FHClassSchedule sharedSchedule] allItems] objectForKey:key]];

    [_map allTodayClasses:todayClassList updateView:filter_today];

    // current class
    FHClass *newCurrentClass = [self currentClassForTime:currentDate];
    if (![self isClass:currentClass equalToNew:newCurrentClass]) {
        if (newCurrentClass == nil) {currentClass = nil;}
        else {
            currentClass = [[FHClass alloc] initWithTitle:newCurrentClass.title
                                                  andTime:newCurrentClass.time
                                                  weekday:newCurrentClass.weekday
                                                 location:newCurrentClass.location];
        }
        [_map currentClass:newCurrentClass updateView:filter_current];
    }

    //next class
    FHClass *newNextClass = [self nextClassForTime:currentDate];
    if (![self isClass:nextClass equalToNew:newNextClass]) {
        if (newNextClass == nil) {nextClass = nil;}
        else {
            nextClass = [[FHClass alloc] initWithTitle:newNextClass.title
                                               andTime:newNextClass.time
                                               weekday:newNextClass.weekday
                                              location:newNextClass.location];
        }
        [_map nextClass:newNextClass updateView:filter_next];
    }

}

-(Boolean)isClass:(FHClass *)oldClass equalToNew:(FHClass *)newClass {
    return ([oldClass.location isEqualToString:newClass.location]) &&
            ([oldClass.title isEqualToString:newClass.title]) &&
            ([oldClass.timeString isEqualToString:newClass.timeString]) &&
            (oldClass.weekday == newClass.weekday);
}

-(FHClass *)currentClassForTime:(NSDate *)time {
    FHClass *classInfo = nil;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                               fromDate:time];
    NSInteger weekday = [components weekday];

    NSString *key = [NSString stringWithFormat:@"%d", weekday];

    NSMutableArray *list = [[[FHClassSchedule sharedSchedule] allItems] objectForKey:key];

    for (int i = 0; i < list.count; i++) {
        FHClass *item = [list objectAtIndex:i];

        NSDateComponents *scheduleComponents = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                                           fromDate:item.time];
        scheduleComponents.day = components.day;
        scheduleComponents.month = components.month;

        NSDate *scheduleTime = [calendar dateFromComponents:scheduleComponents];


        NSTimeInterval interval = [scheduleTime timeIntervalSinceDate:time];
        int dhours = (int)interval / 3600;
        int dminutes = (interval - (dhours * 3600)) / 60;


        if (dminutes <= 0 && dhours == 0 && dminutes > (-1) * item.classDuration) {
            classInfo = item;
            NSLog(@"currentClass interval:%.2d:%.2d", dhours, dminutes);

        }

        if (dminutes > 0) {
            break;
        }
    }

    return classInfo;
}

-(FHClass *)nextClassForTime:(NSDate *)time {
    FHClass *classInfo = nil;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                               fromDate:time];
    NSInteger weekday = [components weekday];

    NSString *key = [NSString stringWithFormat:@"%d", weekday];

    NSMutableArray *list = [[[FHClassSchedule sharedSchedule] allItems] objectForKey:key];

    for (int i = 0; i < list.count; i++) {
        FHClass *item = [list objectAtIndex:i];
        NSDateComponents *scheduleComponents = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                                           fromDate:item.time];
        scheduleComponents.day = components.day;
        scheduleComponents.month = components.month;

        NSDate *scheduleTime = [calendar dateFromComponents:scheduleComponents];

        NSTimeInterval interval = [scheduleTime timeIntervalSinceDate:time];
        int dhours = (int)interval / 3600;
        int dminutes = (interval - (dhours * 3600)) / 60;

        if (dminutes > 0) {
            classInfo = item;
            NSLog(@"nextClass interval:%.2d:%.2d", dhours, dminutes);

            break;
        }
    }

    return classInfo;
}

-(void)classAddedDelegateMethod:(FHClassSchedule *)sender addedClass:(FHClass *)addedClass {
    [self onTick:nil];
}

-(void)classChangedDelegateMethod:(FHClassSchedule *)sender changedClass:(FHClass *)changedClass {
    [self onTick:nil];
}

-(void)classRemovedDelegateMethod:(FHClassSchedule *)sender removedClass:(FHClass *)removedClass {
    [self onTick:nil];
}

-(void)showChangedDelegateMethod:(FHMapSetting *)setting {
    if (setting.locationCategory != FHLocationCategory_Other) {
        [_map updateBySetting:setting];
    } else {
        Boolean show = [setting.show isEqualToString:@"YES"] ? true : false;
        NSMutableArray *classes = [[NSMutableArray alloc] init];

        switch (setting.filter) {
            case FHMapFilter_AllTodayClasses:
                filter_today = show;
                [_map allTodayClasses:classes updateView:show];
                break;
            case FHMapFilter_CurrentClass:
                filter_current = show;
                [_map currentClass:currentClass updateView:show];
                break;
            case FHMapFilter_NextClass:
                filter_next = show;
                [_map nextClass:nextClass updateView:show];
                break;
            default:
                break;
        }
    }
}
@end
