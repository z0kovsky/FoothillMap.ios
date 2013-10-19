//
//  FHMapSettings.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 8.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHMapSettingList.h"

@implementation FHMapSettingList {
    NSMutableDictionary *allItems;
}

-(id)init {
    if (self = [super init]) {
        NSString *path = [self itemSettingsPath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

        if (!allItems) {
            allItems = [[NSMutableDictionary alloc] init];

            NSString *defaultSettingsPath = [[NSBundle mainBundle] pathForResource:@"DefaultFilterSettings" ofType:@"txt"];
            NSData *data = [NSData dataWithContentsOfFile:defaultSettingsPath];
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];

            [xmlParser setDelegate:self];
            BOOL success = [xmlParser parse];
            if (success) {NSLog(@"xmlParser:Success");}
            else {NSLog(@"xmlParser:Error");}
        } else {
            for (NSString *key in [allItems allKeys]) {
                ((FHMapSetting *)[allItems objectForKey:key]).delegate = self;
            }
        }
    }

    return self;
}

+(FHMapSettingList *)sharedSettings {
    static FHMapSettingList *sharedSettings = nil;
    if (!sharedSettings)
        sharedSettings = [[super allocWithZone:nil] init];

    return sharedSettings;
}

+(id)allocWithZone:(NSZone *)zone {
    return [self sharedSettings];
}

-(NSDictionary *)allItems {
    return allItems;
}

-(void)dealloc {
    allItems = nil;
}

-(NSString *)itemSettingsPath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentDirectory = [documentDirectories objectAtIndex:0];

    return [documentDirectory stringByAppendingPathComponent:@"FHMap.settings"];
}

-(BOOL)saveChanges {
    NSString *path = [self itemSettingsPath];

    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"filter"]) {
        FHMapSetting *setting = [[FHMapSetting alloc] init];
        [setting setTitle:[attributeDict objectForKey:@"title"]];
        [setting setShow:[attributeDict objectForKey:@"show"]];
        NSString *categoryTitle = [attributeDict objectForKey:@"category"];
        [setting setLocationCategory:[FHLocationCategory categoryByString:categoryTitle]];
        NSString *filterTitle = [attributeDict objectForKey:@"filter"];
        [setting setFilter:[FHMapFilter filterByString:filterTitle]];

        setting.delegate = self;

        [allItems setObject:setting forKey:[setting title]];
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];

}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
}

-(void)showChangedDelegateMethod:(FHMapSetting *)setting {
    [self.delegate showChangedDelegateMethod:setting];
}

-(void)addSetting:(FHMapSetting *)setting {
    setting.delegate = self;
    [allItems setObject:setting forKey:setting.title];
}

@end
