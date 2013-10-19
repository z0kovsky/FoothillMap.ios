//
//  FHController.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 27.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHMapSetting.h"
#import "FHClassSchedule.h"

// This controller is responsible for Current&Next classes
// and their appearance on a map. It uses timer and
// It is listening to Map and Schedule for events
@interface FHController : NSObject <FHMapSettingDelegate, FHClassScheduleDelegate>

-(id)initWithMap:map Schedule:schedule;

@end
