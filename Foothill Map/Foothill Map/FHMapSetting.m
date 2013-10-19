//
//  FHMarkerType.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 12.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "FHMapSetting.h"

@implementation FHMapSetting

@synthesize show = _show;

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.show forKey:@"show"];
    [aCoder encodeInt:self.locationCategory forKey:@"locationCategory"];
    [aCoder encodeInt:self.filter forKey:@"filter"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setShow:[aDecoder decodeObjectForKey:@"show"]];
        [self setLocationCategory:[aDecoder decodeIntForKey:@"locationCategory"]];
        [self setFilter:[aDecoder decodeIntForKey:@"filter"]];
    }
    return self;
}

-(void)setShow:(NSString *)show {
    _show = show;
    [self.delegate showChangedDelegateMethod:self];

}

-(NSString *)show {
    return _show;
}

@end
