//
//  FHSchedule.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 05.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHClass.h"

@class FHClassSchedule;

@protocol FHClassScheduleDelegate
-(void)classRemovedDelegateMethod:(FHClassSchedule *)sender removedClass:(FHClass *)removedClass;

-(void)classAddedDelegateMethod:(FHClassSchedule *)sender addedClass:(FHClass *)addedClass;

-(void)classChangedDelegateMethod:(FHClassSchedule *)sender changedClass:(FHClass *)changedClass;

@end

@interface FHClassSchedule : NSObject <FHClassInfoDelegate>

@property(nonatomic, weak) id <FHClassScheduleDelegate> delegate;

+(FHClassSchedule *)sharedSchedule;

-(NSMutableDictionary *)allItems;

-(void)addItem:(FHClass *)item;

-(void)removeItem:(FHClass *)item;

-(NSString *)itemArchivePath;

-(BOOL)saveChanges;

-(FHClass *)getClassByID:(NSString *)key;
@end
