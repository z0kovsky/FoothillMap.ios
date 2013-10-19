//
//  FHMapFilter.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 27.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>

// It is enum of types
typedef enum MapFilter : NSInteger MapFilter;
enum MapFilter : NSInteger {
    FHMapFilter_CurrentClass,
    FHMapFilter_NextClass,
    FHMapFilter_AllTodayClasses,
    FHMapFilter_None
};

@interface FHMapFilter : NSObject
+(MapFilter)filterByString:(NSString *)title;

@end