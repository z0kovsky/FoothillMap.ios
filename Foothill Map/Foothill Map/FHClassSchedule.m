//
//  FHSchedule.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 05.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHClassSchedule.h"

@implementation FHClassSchedule {
    NSMutableDictionary *allItems;
}

-(id)init {
    if (self = [super init]) {
        NSString *path = [self itemArchivePath];
        @try {
            allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

            for (NSString *key in allItems) {
                for (FHClass *item in [allItems objectForKey:key]) {
                    item.delegate = self;
                    item.ID = [FHClass GetUUID];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception:FHClassSchedule.init ");
        }

        if (!allItems) {
            allItems = [[NSMutableDictionary alloc] init];
        }


    }

    return self;
}

+(FHClassSchedule *)sharedSchedule {
    static FHClassSchedule *sharedSchedule = nil;
    if (!sharedSchedule)
        sharedSchedule = [[super allocWithZone:nil] init];

    return sharedSchedule;
}

+(id)allocWithZone:(NSZone *)zone {
    return [self sharedSchedule];
}

-(NSMutableDictionary *)allItems {
    return allItems;
}

-(void)addItem:(FHClass *)item {
    NSString *key = [NSString stringWithFormat:@"%d", [item weekday]];

    if (![allItems objectForKey:key]) {
        [allItems setObject:[[NSMutableArray alloc] init] forKey:key];
    }
    item.delegate = self;

    Boolean isInserted = NO;
    NSMutableArray *array = [allItems objectForKey:key];
    for (int i = 0; i < [array count]; i++) {
        if ([[array objectAtIndex:i] compareTime:item] == NSOrderedDescending) {
            [array insertObject:item atIndex:i];
            isInserted = YES;
            break;
        }
    }
    if (!isInserted) {
        [[allItems objectForKey:key] addObject:item];
    }

    [self saveChanges];
    [self.delegate classAddedDelegateMethod:self addedClass:item];
}

-(void)removeItem:(FHClass *)item {
    NSString *key = [NSString stringWithFormat:@"%d", [item weekday]];

    [(NSMutableArray *)[allItems objectForKey:key] removeObject:item];
    item.delegate = nil;

    if ([[allItems objectForKey:key] count] == 0) {
        [allItems removeObjectForKey:key];
    }

    [self saveChanges];
    [self.delegate classRemovedDelegateMethod:self removedClass:item];

}

-(void)dealloc {
    allItems = nil;
}

-(void)weekdayChangedDelegateMethod:(FHClass *)item oldWeekday:(NSInteger)oldWeekday {
    item.delegate = nil;
    [self addItem:item];

    NSString *key = [NSString stringWithFormat:@"%d", oldWeekday];
    [(NSMutableArray *)[allItems objectForKey:key] removeObject:item];
    if ([[allItems objectForKey:key] count] == 0) {
        [allItems removeObjectForKey:key];
    }

    [self saveChanges];
    [self.delegate classChangedDelegateMethod:self changedClass:item];
}

-(void)timeChangedDelegateMethod:(FHClass *)item oldTime:(NSDate *)oldTime {
    [self removeItem:item];
    [self addItem:item];

    [self saveChanges];
    [self.delegate classChangedDelegateMethod:self changedClass:item];

}

-(void)titleChangedDelegateMethod:(FHClass *)item oldTitle:(NSString *)oldTitle {
    [self saveChanges];
    [self.delegate classChangedDelegateMethod:self changedClass:item];
}

-(void)locationChangedDelegateMethod:(FHClass *)item oldLocation:(NSString *)oldLocation {
    [self saveChanges];
    [self.delegate classChangedDelegateMethod:self changedClass:item];
}

-(NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentDirectory = [documentDirectories objectAtIndex:0];

    return [documentDirectory stringByAppendingPathComponent:@"FHSchedule.archive"];
}

-(BOOL)saveChanges {
    NSString *path = [self itemArchivePath];

    BOOL success = [NSKeyedArchiver archiveRootObject:allItems toFile:path];
    if (success) {
        NSLog(@"Saved the schedule");
    } else {
        NSLog(@"Could not save the schedule");
    }
    return success;
}

-(FHClass *)getClassByID:(NSString *)keyID {
    for (NSString *key in allItems.allKeys) {
        for (FHClass *item in [allItems objectForKey:key]) {
            if ([item.ID isEqualToString:keyID]) {
                return item;
            }
        }
    }

    return nil;
}

@end
