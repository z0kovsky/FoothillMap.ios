//
//  FHClassInfoCell.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 05.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FHClassInfoCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *locationLabel;

+(NSString *)reuseIdentifier;

+(FHClassInfoCell *)cell;

@end
