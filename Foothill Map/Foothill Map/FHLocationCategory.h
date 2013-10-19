//
//  FHLocationCategory.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 27.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>

/// It is enum of place types at Foothill
typedef enum LocationCategory : NSInteger LocationCategory;
enum LocationCategory : NSInteger {
    FHLocationCategory_FoodAndDrinks,
    FHLocationCategory_Restroom,
    FHLocationCategory_SmokingArea,
    FHLocationCategory_Parking,
    FHLocationCategory_AccessibleParking,
    FHLocationCategory_Other
};

@interface FHLocationCategory : NSObject

+(UIImage *)getIconForCategory:(LocationCategory)category;

+(LocationCategory)categoryByString:(NSString *)title;

+(Boolean)isKnownCategory:(LocationCategory)category;

@end
