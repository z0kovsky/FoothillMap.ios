//
//  TransitionIOSHelper.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 10.09.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "TransitionIOSHelper.h"

@implementation TransitionIOSHelper

+(double)offsetY {
    double labelOffsetY;

    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        labelOffsetY = 15;
    } else {
        labelOffsetY = 0;
    }

    return labelOffsetY;
}


+(CGFloat)heightForHeaderInSection {
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        return 0.1;
    } else {
        return 15;
    }
}
@end
