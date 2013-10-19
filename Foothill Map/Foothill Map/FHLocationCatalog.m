//
//  FHCatalog.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 14.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHLocationCatalog.h"

@implementation FHLocationCatalog {
    NSMutableArray *allItems;
    NSMutableArray *locationTitles;
}

-(id)init {
    if (self = [super init]) {
        allItems = [[NSMutableArray alloc] init];

        NSString *defaultSettingsPath = [[NSBundle mainBundle] pathForResource:@"college" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:defaultSettingsPath];

        NSError *myError = nil;

        NSArray *items = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&myError];

        for (NSDictionary *item in items) {
            int idItem = [[item objectForKey:@"id"] intValue];
            NSString *name = [item objectForKey:@"name"];
            NSString *bldg = [item objectForKey:@"bldg"];
            NSString *room = [item objectForKey:@"bldg"];
            NSString *categoryTitle = [item objectForKey:@"category"];
            LocationCategory category = [FHLocationCategory categoryByString:categoryTitle];

            float longitude = [[item objectForKey:@"lon"] floatValue];
            float latitude = [[item objectForKey:@"lat"] floatValue];

            FHLocation *location = [[FHLocation alloc] init];
            [location setLongitude:longitude];
            [location setLatitude:latitude];
            [location setId:idItem];
            [location setTitle:name];
            [location setBldg:bldg];
            [location setRoom:room];
            [location setLocationCategory:category];
            [allItems addObject:location];
        }

        locationTitles = [[NSMutableArray alloc] init];
        for (FHLocation *loc in allItems) {
            if (loc.room) {[locationTitles addObject:loc.room];}

            if (loc.bldg) {[locationTitles addObject:loc.bldg];}
            if (loc.title) {[locationTitles addObject:loc.title];}
        }
    }

    return self;
}

+(FHLocationCatalog *)sharedCatalog {
    static FHLocationCatalog *sharedCatalog = nil;
    if (!sharedCatalog)
        sharedCatalog = [[super allocWithZone:nil] init];

    return sharedCatalog;
}

+(id)allocWithZone:(NSZone *)zone {
    return [self sharedCatalog];
}

-(NSMutableArray *)allItems {
    return allItems;
}

-(void)dealloc {
    allItems = nil;
}

-(FHLocation *)locationForClass:(FHClass *)item {
    FHLocation *location = nil;
    NSString *target = [[item.location lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];

    for (FHLocation *loc in allItems) {
        if ([[[loc.bldg lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:target]) {
            location = loc;
            break;
        }
        if ([[[loc.room lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:target]) {
            location = loc;
            break;
        }
        if ([[[loc.title lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:target]) {
            location = loc;
            break;
        }
    }
    return location;
}

-(NSArray *)locationTitlesList {
    return locationTitles;
}

@end
