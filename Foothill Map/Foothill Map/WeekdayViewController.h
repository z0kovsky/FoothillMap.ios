//
//  WeekdayViewController.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 06.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHClass.h"

@interface WeekdayViewController : UITableViewController

@property(nonatomic) FHClass *item;

+(NSString *)getWeekdayByNumber:(NSInteger)weekdayNumber;
@end
