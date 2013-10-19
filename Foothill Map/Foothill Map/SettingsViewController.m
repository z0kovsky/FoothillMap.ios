//
//  SettingsViewController.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 31.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "SettingsViewController.h"
#import "FHMapSettingList.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController {
    NSMutableDictionary *dic;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.foodButton forKey:self.foodButton.titleLabel.text];
    [dic setObject:self.restroomButton forKey:self.restroomButton.titleLabel.text];
    [dic setObject:self.parkingButton forKey:self.parkingButton.titleLabel.text];
    [dic setObject:self.smokingButton forKey:self.smokingButton.titleLabel.text];
    [dic setObject:self.currentClassButton forKey:self.currentClassButton.titleLabel.text];
    [dic setObject:self.nextClassButton forKey:self.nextClassButton.titleLabel.text];

    for (NSString *settingTitle in [[[FHMapSettingList sharedSettings] allItems] allKeys]) {
        UIButton *btn = [dic objectForKey:settingTitle];
        if (btn) {
            FHMapSetting *setting = [[[FHMapSettingList sharedSettings] allItems] objectForKey:settingTitle];
            [btn setSelected:[setting.show isEqualToString:@"YES"]];
        }
    }
}

-(IBAction)buttonTouched:(id)button {
    ((UIButton *)button).selected = !((UIButton *)button).selected;

    NSString *settingTitle = [[dic allKeysForObject:button] objectAtIndex:0];

    FHMapSetting *setting = [[[FHMapSettingList sharedSettings] allItems] objectForKey:settingTitle];
    if (!setting) {
        setting = [[FHMapSetting alloc] init];
        [setting setTitle:((UIButton *)button).titleLabel.text];
        [setting setFilter:FHMapFilter_None];
        [setting setLocationCategory:FHLocationCategory_Other];
        [[FHMapSettingList sharedSettings] addSetting:setting];
    }
    [setting setShow:((UIButton *)button).selected ? @"YES" : @"NO"];

    [[FHMapSettingList sharedSettings] saveChanges];
}

@end
