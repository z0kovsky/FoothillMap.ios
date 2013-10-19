//
//  FHClassInfo.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 05.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>

@class FHClass;

@protocol FHClassInfoDelegate
-(void)timeChangedDelegateMethod:(FHClass *)sender oldTime:(NSDate *)oldTime;

-(void)weekdayChangedDelegateMethod:(FHClass *)sender oldWeekday:(NSInteger)oldWeekday;

-(void)titleChangedDelegateMethod:(FHClass *)sender oldTitle:(NSString *)oldTitle;

-(void)locationChangedDelegateMethod:(FHClass *)sender oldLocation:(NSString *)oldLocation;

@end

@interface FHClass : NSObject

@property NSString *ID;
@property NSDate *time;
@property NSInteger weekday;
@property NSString *title;
@property NSString *location;

@property(nonatomic, weak) id <FHClassInfoDelegate> delegate;

+(NSString *)GetUUID;

+(id)empty;

+(id)classInfoWithTitle:(NSString *)title andTime:(NSDate *)time weekday:(NSInteger)weekday location:(NSString *)location;

-(id)initWithTitle:(NSString *)title andTime:(NSDate *)time weekday:(NSInteger)weekday location:(NSString *)location;

-(NSString *)timeString;

-(NSInteger)classDuration;

-(NSComparisonResult)compareTime:(FHClass *)item;
@end
