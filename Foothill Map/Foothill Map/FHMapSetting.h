//
//  FHMarkerType.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 12.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHLocation.h"
#import "FHMapFilter.h"

@class FHMapSetting;

@protocol FHMapSettingDelegate
-(void)showChangedDelegateMethod:(FHMapSetting *)sender;
@end

@interface FHMapSetting : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic) NSString *show;
@property(nonatomic) enum LocationCategory locationCategory;
@property(nonatomic) enum MapFilter filter;

@property(nonatomic, weak) id <FHMapSettingDelegate> delegate;

@end
