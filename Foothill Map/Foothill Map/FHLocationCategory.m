//
//  FHLocationCategory.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 27.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHLocationCategory.h"

@implementation FHLocationCategory

+(UIImage *)getIconForCategory:(LocationCategory)category {
    UIImage *icon = nil;

    switch (category) {
        case FHLocationCategory_Restroom:
            icon = [UIImage imageNamed:@"ic-restroom"];
            break;
        case FHLocationCategory_FoodAndDrinks:
            icon = [UIImage imageNamed:@"ic-food"];
            break;
        case FHLocationCategory_SmokingArea:
            icon = [UIImage imageNamed:@"ic-smoking"];
            break;
        case FHLocationCategory_Parking:
            icon = [UIImage imageNamed:@"ic-parking"];
            break;
        case FHLocationCategory_AccessibleParking:
            icon = [UIImage imageNamed:@"ic-AccessibleParking"];
            break;
        case FHLocationCategory_Other:
            icon = [UIImage imageNamed:@"ic-pin_blue"];
            break;
        default:
            icon = [UIImage imageNamed:@"ic-pin_red"];
            break;
    }
    return icon;
}

+(LocationCategory)categoryByString:(NSString *)title {
    LocationCategory category = FHLocationCategory_Other;
    if ([title isEqualToString:@"Restroom"]) {
        category = FHLocationCategory_Restroom;
    } else if ([title isEqualToString:@"FoodAndDrinks"]) {
        category = FHLocationCategory_FoodAndDrinks;
    } else if ([title isEqualToString:@"SmokingArea"]) {
        category = FHLocationCategory_SmokingArea;
    } else if ([title isEqualToString:@"Parking"]) {
        category = FHLocationCategory_Parking;
    } else if ([title isEqualToString:@"AccessibleParking"]) {
        category = FHLocationCategory_AccessibleParking;
    }

    return category;
}

+(Boolean)isKnownCategory:(LocationCategory)category {
    return
            category == FHLocationCategory_Restroom ||
                    category == FHLocationCategory_FoodAndDrinks ||
                    category == FHLocationCategory_SmokingArea ||
                    category == FHLocationCategory_Parking;
}

@end
