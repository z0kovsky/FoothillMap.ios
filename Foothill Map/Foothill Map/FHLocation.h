//
//  FoothillLocation.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 04.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHLocationCategory.h"

@interface FHLocation : NSObject

@property float longitude;
@property float latitude;
@property float id;
@property NSString *title;
@property NSString *bldg;
@property NSString *room;
@property NSString *category;
@property enum LocationCategory locationCategory;

@end
