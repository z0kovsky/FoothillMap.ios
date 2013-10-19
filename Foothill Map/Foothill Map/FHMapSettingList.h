//
//  FHMapSettings.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 8.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHMapSetting.h"

@interface FHMapSettingList : NSObject <NSXMLParserDelegate, FHMapSettingDelegate>

@property(nonatomic) id <FHMapSettingDelegate> delegate;


+(FHMapSettingList *)sharedSettings;

-(NSMutableDictionary *)allItems;

-(BOOL)saveChanges;

-(NSString *)itemSettingsPath;

-(void)addSetting:(FHMapSetting *)setting;
@end
