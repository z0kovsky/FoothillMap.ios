//
//  WeekdayViewController.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 06.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "WeekdayViewController.h"
#import "TransitionIOSHelper.h"

@interface WeekdayViewController ()

@end

@implementation WeekdayViewController

@synthesize item;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *navigationItem = [self navigationItem];
        [navigationItem setTitle:NSLocalizedString(@"Weekday", @"Weekday")];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self tableView] reloadData];

    int weekday = item.weekday;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weekday - 1 inSection:0];
    [[self tableView] selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


+(NSArray *)sharedWeekdays {
    static NSArray *sharedWeekdays;
    if (!sharedWeekdays) {

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

        sharedWeekdays = [dateFormatter weekdaySymbols];
    }

    return sharedWeekdays;
}

+(NSString *)getWeekdayByNumber:(NSInteger)weekdayNumber {
    return [[WeekdayViewController sharedWeekdays] objectAtIndex:weekdayNumber - 1];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[WeekdayViewController sharedWeekdays] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WeekdayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *weekdayTitle = [[WeekdayViewController sharedWeekdays] objectAtIndex:indexPath.row];
    [cell.textLabel setText:weekdayTitle];

    return cell;
}

-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    item.weekday = indexPath.row + 1;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
    [self.tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.tableView cellForRowAtIndexPath:oldIndex].selectionStyle = UITableViewCellSelectionStyleNone;

    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
    return indexPath;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [TransitionIOSHelper heightForHeaderInSection];
}
@end
