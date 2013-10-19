//
//  FHCatalog.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 14.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHClass.h"
#import "FHLocation.h"

@interface FHLocationCatalog : NSObject

+(FHLocationCatalog *)sharedCatalog;

-(NSMutableArray *)allItems;

-(FHLocation *)locationForClass:(FHClass *)item;

-(NSArray *)locationTitlesList;
@end
