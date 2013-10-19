//
//  ViewController.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 04.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "FHMapSetting.h"
#import "FHClass.h"
#import "SlidingViewController.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate, CenterViewControllerDelegate>

-(void)updateBySetting:(FHMapSetting *)setting;

-(void)allTodayClasses:(NSMutableArray *)classes updateView:(Boolean)show;

-(void)currentClass:(FHClass *)classInfo updateView:(Boolean)show;

-(void)nextClass:(FHClass *)classInfo updateView:(Boolean)show;
@end
