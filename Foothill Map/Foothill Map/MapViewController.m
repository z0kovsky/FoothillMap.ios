//
//  ViewController.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 04.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "MapViewController.h"
#import "FHLocationCatalog.h"
#import "FHClassSchedule.h"
#import "TransitionIOSHelper.h"

#define FOOTHILL_LAT 37.361426
#define FOOTHILL_LONG -122.127113
#define FOOTHILL_ZOOM 16
#define CURRENT_ZOOM 15
#define MARKER_ZOOM 19
#define MARKER_LOCATION_DELTA 0.00001


@interface MapViewController ()

@end

@implementation MapViewController {
    IBOutlet UIView *mapViewOnSreen;
    GMSMapView *mapView;
    UIButton *headerSpaceLabel;
    UIButton *currentClassLabel;
    UIButton *nextClassLabel;
    UISegmentedControl *locationSegment;

    NSMutableDictionary *markers;
    GMSMarker *markerCurrent;
    GMSMarker *markerNext;
    NSMutableDictionary *markersSchedule;


    CLLocationManager *locationManager;

    Boolean locationSegmentAction;
    double labelHeight;

}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        markersSchedule = [[NSMutableDictionary alloc] init];
        markers = [[NSMutableDictionary alloc] init];
        markerCurrent = [[GMSMarker alloc] init];
        markerCurrent.icon = [UIImage imageNamed:@"ic-pin_red"];
        markerNext = [[GMSMarker alloc] init];
        markerNext.icon = [UIImage imageNamed:@"ic-pin_blue"];

        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

        labelHeight = 32;
    }

    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:FOOTHILL_LAT
                                                            longitude:FOOTHILL_LONG
                                                                 zoom:FOOTHILL_ZOOM];
    mapView = [GMSMapView mapWithFrame:mapViewOnSreen.bounds camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = NO;

    mapView.settings.zoomGestures = YES;
    mapView.settings.scrollGestures = YES;
    mapView.userInteractionEnabled = YES;

    mapView.delegate = self;
    [mapViewOnSreen addSubview:mapView];

    headerSpaceLabel = [[UIButton alloc] init];
    headerSpaceLabel.frame = CGRectMake(0, 0, mapViewOnSreen.frame.size.width, [TransitionIOSHelper offsetY]);
    headerSpaceLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    headerSpaceLabel.hidden = true;
    [mapViewOnSreen addSubview:headerSpaceLabel];

    currentClassLabel = [[UIButton alloc] init];
    currentClassLabel.frame = CGRectMake(0, [TransitionIOSHelper offsetY], mapViewOnSreen.frame.size.width, labelHeight);
    currentClassLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    currentClassLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [currentClassLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [currentClassLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    currentClassLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    currentClassLabel.hidden = true;
    [currentClassLabel addTarget:self action:@selector(showCurrentMarker:) forControlEvents:UIControlEventTouchUpInside];
    [mapViewOnSreen addSubview:currentClassLabel];

    nextClassLabel = [[UIButton alloc] init];
    nextClassLabel.frame = CGRectMake(0, [TransitionIOSHelper offsetY] + labelHeight, mapViewOnSreen.frame.size.width, labelHeight);
    nextClassLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextClassLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextClassLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextClassLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    nextClassLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    nextClassLabel.hidden = true;
    [nextClassLabel addTarget:self action:@selector(showNextMarker:) forControlEvents:UIControlEventTouchUpInside];
    [mapViewOnSreen addSubview:nextClassLabel];

    locationSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"", NSLocalizedString(@"Foothill", @"Foothill"), nil]];
    locationSegment.selectedSegmentIndex = 1;
    [locationSegment addTarget:self
                        action:@selector(pickOne:)
              forControlEvents:UIControlEventValueChanged];
    [locationSegment setImage:[[UIImage imageNamed:@"ic-currentLocation"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)] forSegmentAtIndex:0];
    [locationSegment setWidth:30 forSegmentAtIndex:0];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [locationSegment setBackgroundColor:[UIColor whiteColor]];
        double offsetY = 100;
        locationSegment.frame = CGRectMake(20, mapViewOnSreen.frame.size.height - offsetY, 90, 32);
        locationSegment.segmentedControlStyle = UISegmentedControlStylePlain;
    } else {
        locationSegment.frame = CGRectMake(20, 360, 90, 32);
        locationSegment.segmentedControlStyle = UISegmentedControlStyleBar;
        [locationSegment setContentMode:UIViewContentModeScaleToFill];

    }
    [mapViewOnSreen addSubview:locationSegment];
    [self addDefaultMarkers];
}

-(void)addDefaultMarkers {
    for (FHLocation *location in [[FHLocationCatalog sharedCatalog] allItems]) {

        if ([FHLocationCategory isKnownCategory:location.locationCategory]) {

            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
            marker.title = location.title;
            marker.snippet = location.room;
            marker.userData = location;
            marker.icon = [FHLocationCategory getIconForCategory:location.locationCategory];
            marker.map = nil;


            NSNumber *key = [NSNumber numberWithInt:location.locationCategory];
            if (![markers objectForKey:key]) {
                [markers setObject:[[NSMutableArray alloc] init] forKey:key];
            }
            [[markers objectForKey:key] addObject:marker];
        }
    }
}

-(void)findLocation {
    [locationManager startUpdatingLocation];
}

-(void)foundLocation:(CLLocation *)loc {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:[loc coordinate]
                                                               zoom:6];
    [mapView setCamera:camera];

    [locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation {
}

-(void)pickOne:(id)sender {
    GMSCameraPosition *mapCenter;
    switch ([locationSegment selectedSegmentIndex]) {
        case 0:
            mapCenter = [GMSCameraPosition cameraWithTarget:[[locationManager location] coordinate]
                                                       zoom:CURRENT_ZOOM];
            break;
        case 1:
            mapCenter = [GMSCameraPosition cameraWithLatitude:FOOTHILL_LAT
                                                    longitude:FOOTHILL_LONG
                                                         zoom:FOOTHILL_ZOOM];

            break;
        default:
            break;
    }
    locationSegmentAction = true;
    [mapView setCamera:mapCenter];
}

-(void)recalculateLabelPosition {
    CGRect labelFrame = [nextClassLabel frame];

    headerSpaceLabel.hidden = nextClassLabel.hidden && currentClassLabel.hidden;

    if (currentClassLabel.hidden) {
        labelFrame.origin.y = [TransitionIOSHelper offsetY];
    } else {
        labelFrame.origin.y = [TransitionIOSHelper offsetY] + labelHeight;

    }

    if (nextClassLabel.hidden) {
        [currentClassLabel.layer setShadowOffset:CGSizeMake(0, 5)];
        [currentClassLabel.layer setShadowColor:[[UIColor grayColor] CGColor]];
        [currentClassLabel.layer setShadowOpacity:0.5];
    } else {
        [currentClassLabel.layer setShadowOpacity:0.0];
        [nextClassLabel.layer setShadowOffset:CGSizeMake(0, 5)];
        [nextClassLabel.layer setShadowColor:[[UIColor grayColor] CGColor]];
        [nextClassLabel.layer setShadowOpacity:0.5];
    }

    nextClassLabel.frame = labelFrame;
}

-(void)recalculateMarkerPositions {
    if (!currentClassLabel.hidden && !nextClassLabel.hidden &&
            markerNext.position.latitude == markerCurrent.position.latitude &&
            markerNext.position.longitude == markerCurrent.position.longitude) {

        markerNext.position = CLLocationCoordinate2DMake(((FHLocation *)markerNext.userData).latitude,
                ((FHLocation *)markerNext.userData).longitude + MARKER_LOCATION_DELTA);
    } else if (markerNext.position.longitude != ((FHLocation *)markerNext.userData).longitude) {
        markerNext.position = CLLocationCoordinate2DMake(((FHLocation *)markerNext.userData).latitude,
                ((FHLocation *)markerNext.userData).longitude);
    }
}

-(Boolean)setMarker:(GMSMarker *)marker byLocation:(FHLocation *)location classData:(FHClass *)item addPrefix:(NSString *)prefix {
    if (location && item) {
        marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        marker.title = [NSString stringWithFormat:@"%@%@", prefix, item.title];
        marker.snippet = [NSString stringWithFormat:@"%@, %@", item.timeString, item.location];
        marker.userData = location;

        return true;
    }

    return false;
}

-(void)updateBySetting:(FHMapSetting *)setting {
    if ([FHLocationCategory isKnownCategory:setting.locationCategory]) {

        NSNumber *key = [NSNumber numberWithInt:setting.locationCategory];
        id mapValue = [setting.show isEqualToString:@"YES"] ? mapView : nil;

        for (GMSMarker *marker in [markers objectForKey:key]) {
            if (((FHLocation *)marker.userData).locationCategory == setting.locationCategory) {
                marker.map = mapValue;
            }
        }
    }
}

-(void)allTodayClasses:(NSMutableArray *)classes updateView:(Boolean)show {
    return;
    // it is ready to work, however it is commented due to
    // unclear some ui like several classes are on the same location -
    // what is the best way to show this case? Also I should mention
    // that there are current and next markers which should be on the same place
    for (NSString *key in markersSchedule.allKeys) {
        FHClass *item = [[FHClassSchedule sharedSchedule] getClassByID:key];
        if (!item) {continue;}

        FHLocation *location = [[FHLocationCatalog sharedCatalog] locationForClass:item];

        GMSMarker *marker = [markersSchedule objectForKey:item];
        if ([classes containsObject:item]) {
            if (!([marker.title isEqualToString:item.title] &&
                    [marker.snippet isEqualToString:[NSString stringWithFormat:@"%@, %@", item.timeString, item.location]] &&
                    (FHLocation *)marker.userData == location)) {

                marker.title = item.title;
                marker.snippet = [NSString stringWithFormat:@"%@, %@", item.timeString, item.location];
                marker.position = CLLocationCoordinate2DMake(location.latitude + MARKER_LOCATION_DELTA, location.longitude);
                marker.userData = location;
            }
            marker.map = show ? mapView : nil;
            [classes removeObject:item];
        } else {
            marker.map = nil;
            [markersSchedule removeObjectForKey:item];
        }

    }

    for (FHClass *item in classes) {
        FHLocation *location = [[FHLocationCatalog sharedCatalog] locationForClass:item];

        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:@"ic-pin_blue"];
        marker.title = item.title;
        marker.snippet = [NSString stringWithFormat:@"%@, %@", item.timeString, item.location];
        marker.position = CLLocationCoordinate2DMake(location.latitude + MARKER_LOCATION_DELTA, location.longitude);
        marker.userData = location;
        marker.map = show ? mapView : nil;

        [markersSchedule setObject:marker forKey:item.ID];
    }
}

-(void)currentClass:(FHClass *)classInfo updateView:(Boolean)show {
    if (show && classInfo) {
        [currentClassLabel setTitle:[NSString stringWithFormat:@"Current at %@, %@", classInfo.timeString, classInfo.title]
                           forState:UIControlStateNormal];
        currentClassLabel.hidden = false;

        FHLocation *location = [[FHLocationCatalog sharedCatalog] locationForClass:classInfo];
        if ([self setMarker:markerCurrent byLocation:location classData:classInfo addPrefix:NSLocalizedString(@"Current: ", @"Current: ")]) {
            markerCurrent.map = mapView;
            [currentClassLabel setImage:[UIImage imageNamed:@"ic-pin_red"] forState:UIControlStateNormal];
        } else {
            markerCurrent.map = nil;
            [currentClassLabel setImage:nil forState:UIControlStateNormal];
        }
    } else {
        [currentClassLabel setTitle:@"" forState:UIControlStateNormal];
        currentClassLabel.hidden = true;
        markerCurrent.map = nil;
        [currentClassLabel setImage:nil forState:UIControlStateNormal];
    }

    [self recalculateLabelPosition];
    [self recalculateMarkerPositions];
}

-(void)nextClass:(FHClass *)classInfo updateView:(Boolean)show {
    if (show && classInfo) {
        [nextClassLabel setTitle:[NSString stringWithFormat:@"Next at %@, %@", classInfo.timeString, classInfo.title]
                        forState:UIControlStateNormal];
        nextClassLabel.hidden = false;

        FHLocation *location = [[FHLocationCatalog sharedCatalog] locationForClass:classInfo];
        if ([self setMarker:markerNext byLocation:location classData:classInfo addPrefix:NSLocalizedString(@"Next: ", @"Next: ")]) {
            markerNext.map = mapView;
            [nextClassLabel setImage:[UIImage imageNamed:@"ic-pin_blue"] forState:UIControlStateNormal];


        } else {
            markerNext.map = nil;
            [nextClassLabel setImage:nil forState:UIControlStateNormal];
        }
    } else {
        [nextClassLabel setTitle:@"" forState:UIControlStateNormal];
        nextClassLabel.hidden = true;
        markerNext.map = nil;
        [nextClassLabel setImage:nil forState:UIControlStateNormal];
    }
    [self recalculateLabelPosition];
    [self recalculateMarkerPositions];
}

-(IBAction)showCurrentMarker:(id)sender {
    if (!markerCurrent.map) {
        return;
    }

    FHLocation *location = markerCurrent.userData;
    GMSCameraPosition *mapCenter = [GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(location.latitude, location.longitude)
                                                                  zoom:MARKER_ZOOM];
    [mapView setCamera:mapCenter];
}

-(IBAction)showNextMarker:(id)sender {
    if (!markerNext.map) {
        return;
    }

    FHLocation *location = markerNext.userData;
    GMSCameraPosition *mapCenter = [GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(location.latitude, location.longitude)
                                                                  zoom:MARKER_ZOOM];
    [mapView setCamera:mapCenter];
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    if (locationSegmentAction) {
        locationSegmentAction = false;
    } else {
        [locationSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    }
}

-(void)allowGestures {
    mapView.settings.zoomGestures = YES;
    mapView.settings.scrollGestures = YES;
    mapView.userInteractionEnabled = YES;
}

-(void)forbidGestures {
    mapView.settings.zoomGestures = NO;
    mapView.settings.scrollGestures = NO;
    mapView.userInteractionEnabled = NO;
}
@end
