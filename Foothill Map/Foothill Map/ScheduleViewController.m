//
//  ScheduleViewController.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 05.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "ScheduleViewController.h"
#import "FHClassSchedule.h"
#import "ClassDetailViewController.h"
#import "WeekdayViewController.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

-(id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *navigationItem = [self navigationItem];
        [navigationItem setTitle:NSLocalizedString(@"Schedule", @"Schedule")];

        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addNewItem:)];

        [[self navigationItem] setRightBarButtonItem:barButtonItem];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];

    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

-(void)viewDidLoad {
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:[FHClassInfoCell reuseIdentifier] bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:[FHClassInfoCell reuseIdentifier]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self tableView] reloadData];

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[[FHClassSchedule sharedSchedule] allItems] allKeys] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[FHClassSchedule sharedSchedule] allItems] objectForKey:[self weekdayBySection:section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHClassInfoCell *cell = (FHClassInfoCell *)[tableView dequeueReusableCellWithIdentifier:[FHClassInfoCell reuseIdentifier]];

    if (cell == nil) {
        cell = [FHClassInfoCell cell];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    FHClass *item = [self getItemByPath:indexPath];

    [[cell titleLabel] setText:[item title]];
    [[cell timeLabel] setText:[item timeString]];
    [[cell locationLabel] setText:[item location]];

    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];

        NSString *key = [self weekdayBySection:indexPath.section];

        if ([[[[FHClassSchedule sharedSchedule] allItems] objectForKey:key] count] > 1) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];

        } else {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                     withRowAnimation:UITableViewRowAnimationFade];
        }
        [[FHClassSchedule sharedSchedule] removeItem:[self getItemByPath:indexPath]];
        [tableView endUpdates];
    }
}

-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassDetailViewController *detailViewController = [[ClassDetailViewController alloc] init];

    [detailViewController setItem:[self getItemByPath:indexPath]];
    [detailViewController setState:EditState_view];
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [WeekdayViewController getWeekdayByNumber:[self weekdayBySection:section].intValue];
}

-(IBAction)addNewItem:(id)sender {

    FHClass *item = [FHClass empty];
    [[FHClassSchedule sharedSchedule] addItem:item];

    ClassDetailViewController *detailViewController = [[ClassDetailViewController alloc] init];
    [detailViewController setItem:item];
    [detailViewController setState:EditState_new];
    [[self navigationController] pushViewController:detailViewController animated:YES];

}

-(NSString *)weekdayBySection:(NSInteger)section {
    if ([[[[FHClassSchedule sharedSchedule] allItems] allKeys] count] <= section) {
        return nil;
    }
    return [[[[[FHClassSchedule sharedSchedule] allItems] allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section];
}

-(FHClass *)getItemByPath:(NSIndexPath *)indexPath {
    return [[[[FHClassSchedule sharedSchedule] allItems] objectForKey:[self weekdayBySection:[indexPath section]]] objectAtIndex:[indexPath row]];
}
@end
