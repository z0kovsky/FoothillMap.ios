//
//  AppDelegate.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 04.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "ScheduleViewController.h"
#import "FHClassSchedule.h"
#import "FHController.h"
#import "SettingsViewController.h"
#import "Appirater.h"

@implementation AppDelegate {
    FHController *controller;
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Appirater setAppId:@"706634062"];
    [Appirater setDaysUntilPrompt:0];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setTimeBeforeReminding:2];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [GMSServices provideAPIKey:@"AIzaSyAn84mxBdW8k48-LI4j1PekvDhAeOGrUaI"];

    MapViewController *mapvc = [[MapViewController alloc] init];
    SettingsViewController *settingsvc = [[SettingsViewController alloc] init];
    SlidingViewController *slidingViewController = [[SlidingViewController alloc] initWithCenter:mapvc andRight:settingsvc];

    ScheduleViewController *schedulevc = [[ScheduleViewController alloc] init];
    UINavigationController *navigationSchedulevc = [[UINavigationController alloc] initWithRootViewController:schedulevc];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:slidingViewController, navigationSchedulevc, nil];
    slidingViewController.tabBarItem = [[UITabBarItem alloc]
            initWithTitle:@"Map"
                    image:[UIImage imageNamed:@"ic-pin_blue.png"]
                      tag:3];
    navigationSchedulevc.tabBarItem = [[UITabBarItem alloc]
            initWithTitle:@"Schedule"
                    image:[UIImage imageNamed:@"ic-schedule.png"]
                      tag:3];
    [tabBarController setViewControllers:viewControllers];

    controller = [[FHController alloc] initWithMap:mapvc Schedule:schedulevc];

    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];

    [Appirater appLaunched:YES];

    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

-(void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
