//
//  TimeEditCell.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 12.09.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHClass.h"

@interface TimeEditCell : UITableViewCell

-(void)setItem:(FHClass *)item;

+(NSString *)reuseIdentifier;

+(TimeEditCell *)cell;

@end
