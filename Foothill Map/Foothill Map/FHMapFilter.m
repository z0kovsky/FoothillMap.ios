//
//  FHMapFilter.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 27.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHMapFilter.h"

@implementation FHMapFilter
+(MapFilter)filterByString:(NSString *)title {
    MapFilter filter = FHMapFilter_None;

    if ([title isEqualToString:@"CurrentClass"]) {
        filter = FHMapFilter_CurrentClass;
    } else if ([title isEqualToString:@"NextClass"]) {
        filter = FHMapFilter_NextClass;
    } else if ([title isEqualToString:@"AllTodayClasses"]) {
        filter = FHMapFilter_AllTodayClasses;
    }

    return filter;
}
@end
