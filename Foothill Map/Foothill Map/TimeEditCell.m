//
//  TimeEditCell.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 12.09.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "TimeEditCell.h"

@implementation TimeEditCell {

    __weak IBOutlet UILabel *timeField;
    __weak IBOutlet UIDatePicker *timePicker;
    FHClass *_item;
}

-(void)awakeFromNib {

}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

-(IBAction)timeChanged:(id)sender {
    _item.time = timePicker.date;
    [timeField setText:_item.timeString];
}

-(void)setItem:(FHClass *)item {
    _item = item;
    [timeField setText:_item.timeString];
    [timePicker setDate:_item.time];
}

+(NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

-(NSString *)reuseIdentifier {
    return [[self class] reuseIdentifier];
}

+(TimeEditCell *)cell {
    return [[[NSBundle mainBundle] loadNibNamed:[self reuseIdentifier] owner:self options:nil] objectAtIndex:0];
}
@end
