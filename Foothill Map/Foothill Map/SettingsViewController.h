//
//  SettingsViewController.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 31.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
-(IBAction)buttonTouched:(id)button;

@property(weak, nonatomic) IBOutlet UIButton *foodButton;
@property(weak, nonatomic) IBOutlet UIButton *parkingButton;
@property(weak, nonatomic) IBOutlet UIButton *smokingButton;
@property(weak, nonatomic) IBOutlet UIButton *restroomButton;
@property(weak, nonatomic) IBOutlet UIButton *currentClassButton;
@property(weak, nonatomic) IBOutlet UIButton *nextClassButton;
@property(weak, nonatomic) IBOutlet UIButton *allTodayClassesButton;

@end
