//
//  FHClassInfoCell.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 05.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHClassInfoCell.h"

@implementation FHClassInfoCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

-(NSString *)reuseIdentifier {
    return [[self class] reuseIdentifier];
}

+(FHClassInfoCell *)cell {
    return [[[NSBundle mainBundle] loadNibNamed:[self reuseIdentifier] owner:self options:nil] objectAtIndex:0];
}

@end
