//
//  ClassDetailViewController.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 6.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "LocationViewController.h"
#import "WeekdayViewController.h"
#import "ClassDetailViewController.h"
#import "FHClassSchedule.h"
#import "TimeEditCell.h"
#import "TransitionIOSHelper.h"

#define NUM_TITLE 0
#define NUM_TIME 1
#define NUM_WEEKDAY 2
#define NUM_LOCATION 3
#define NUM_DURATION 4
#define HEIGHT_TIME 230.0
#define HEIGHT_DEFAULT 42.0


@interface ClassDetailViewController ()

@end

@implementation ClassDetailViewController {
    UIColor *detailColor;
    __weak IBOutlet UIDatePicker *timePicker;
    Boolean isTimeSelected;

    UITextField *titleField;
    WeekdayViewController *weekdayViewController;
    LocationViewController *locationViewController;
}

@synthesize item = _item;
@synthesize state = _state;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, 290, 25)];
        } else {
            titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, 280, 25)];
        }
        titleField.adjustsFontSizeToFitWidth = NO;
        titleField.autocorrectionType = UITextAutocorrectionTypeNo;
        titleField.keyboardType = UIKeyboardTypeDefault;
        titleField.returnKeyType = UIReturnKeyDone;
        titleField.clearButtonMode = UITextFieldViewModeNever;
        titleField.placeholder = NSLocalizedString(@"Title", @"Title");
        titleField.delegate = self;

        weekdayViewController = [[WeekdayViewController alloc] init];
        locationViewController = [[LocationViewController alloc] init];

        isTimeSelected = NO;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    tableview.dataSource = self;
    tableview.delegate = self;
}

-(void)viewDidLayoutSubviews {
    [timePicker setHidden:YES];
    [(UIView *)timePicker setFrame:CGRectMake(timePicker.frame.origin.x, self.view.frame.size.height - timePicker.frame.size.height,
            timePicker.frame.size.width, timePicker.frame.size.height)];

    [tableview setScrollEnabled:YES];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    isTimeSelected = NO;

    [timePicker setMinuteInterval:5];
    [timePicker setDatePickerMode:UIDatePickerModeTime];

    UINavigationItem *navigationItem = [self navigationItem];
    [navigationItem setTitle:NSLocalizedString(@"Class Info", @"Class Info")];

    UIBarButtonItem *cancelBarButtonItem;
    UIBarButtonItem *editBarButtonItem;
    UIBarButtonItem *doneBarButtonItem;

    switch (_state) {
        case EditState_new:
            [titleField becomeFirstResponder];

            cancelBarButtonItem = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelBarButtonItem];

            doneBarButtonItem = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(done:)];
            [[self navigationItem] setRightBarButtonItem:doneBarButtonItem];

            [self.navigationItem setHidesBackButton:YES];

            break;

        case EditState_view:
            editBarButtonItem = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                         target:self
                                         action:@selector(edit:)];
            [[self navigationItem] setRightBarButtonItem:editBarButtonItem];
            [self.navigationItem setHidesBackButton:NO];

            break;

        case EditState_edit:
            [titleField becomeFirstResponder];

            doneBarButtonItem = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(done:)];
            [[self navigationItem] setRightBarButtonItem:doneBarButtonItem];
            [self.navigationItem setHidesBackButton:YES];

            break;
    }

    if (!_item) {
        _item = [FHClass classInfoWithTitle:@"" andTime:[NSDate date] weekday:1 location:@""];
    }

    if (![_item time]) {
        _item.time = [NSDate date];
    }

    [timePicker setDate:_item.time];
    [tableview reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[self view] endEditing:YES];

    [_item setTitle:[titleField text]];
}

-(void)setItem:(FHClass *)item {
    _item = item;
    [[self navigationItem] setTitle:[_item title]];
}

-(void)cancel:(id)sender {
    [[FHClassSchedule sharedSchedule] removeItem:_item];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)done:(id)sender {
    if ([[[titleField text] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"An Empty Title", @"An Empty Title")
                                                        message:NSLocalizedString(@"A title cannot be an empty string", @"A title cannot be an empty string")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];

        return;
    }

    [self tableView:tableview didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    [_item setTitle:[titleField text]];

    if (_state == EditState_new) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    [self.navigationItem setHidesBackButton:NO];
    self.navigationItem.leftBarButtonItem = nil;

    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                 target:self
                                 action:@selector(edit:)];
    [[self navigationItem] setRightBarButtonItem:editBarButtonItem];

    _state = EditState_view;
    [tableview reloadData];

    [titleField resignFirstResponder];
}

-(void)edit:(id)sender {
    [self.navigationItem setHidesBackButton:YES];

    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                 target:self
                                 action:@selector(done:)];
    [[self navigationItem] setRightBarButtonItem:doneBarButtonItem];
    _state = EditState_edit;
    [tableview reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (isTimeSelected || !timePicker.hidden) {
        [self tableView:tableview didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [_item setTitle:[titleField text]];
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _state == EditState_view ? 5 : 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *edittextCellIdentifier = @"EditTextCell";
    static NSString *weekdayCellIdentifier = @"WeekdayCell";
    static NSString *locationCellIdentifier = @"LocationCell";
    static NSString *timeViewCellIdentifier = @"TimeCell_View";
    static NSString *durationCellIdentifier = @"DurationCell";


    switch (indexPath.row) {
        case NUM_TITLE:
            cell = [tableView dequeueReusableCellWithIdentifier:edittextCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] init];
            }
            cell.accessoryView = titleField;

            titleField.enabled = _state != EditState_view;
            titleField.textAlignment = _state == EditState_view ? UITextAlignmentCenter : UITextAlignmentLeft;
            titleField.font = _state == EditState_view ? [UIFont boldSystemFontOfSize:16] : [UIFont systemFontOfSize:16];
            [(UITextField *)cell.accessoryView setText:_item.title];
            if (_state != EditState_view && (timePicker.hidden && !isTimeSelected)) {
                [titleField becomeFirstResponder];
            } else {
                [titleField resignFirstResponder];
            }
            break;
        case NUM_TIME:
            if (isTimeSelected) {
                cell = (TimeEditCell *)[tableView dequeueReusableCellWithIdentifier:[TimeEditCell reuseIdentifier]];

                if (cell == nil) {
                    cell = [TimeEditCell cell];
                }
                [((TimeEditCell *)cell) setItem:_item];
            } else {

                cell = [tableView dequeueReusableCellWithIdentifier:timeViewCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:timeViewCellIdentifier];
                    [cell.textLabel setText:NSLocalizedString(@"Time", @"Time")];
                    detailColor = cell.detailTextLabel.textColor;
                }

                [cell.detailTextLabel setText:_item.timeString];
            }
            break;
        case NUM_WEEKDAY:
            cell = [tableView dequeueReusableCellWithIdentifier:weekdayCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:weekdayCellIdentifier];
                [cell.textLabel setText:NSLocalizedString(@"Weekday", @"Weekday")];
            }
            cell.accessoryType = _state == EditState_view ?
                    UITableViewCellAccessoryNone :
                    UITableViewCellAccessoryDisclosureIndicator;

            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",
                                                                     [WeekdayViewController getWeekdayByNumber:[_item weekday]]]];
            break;
        case NUM_LOCATION:
            cell = [tableView dequeueReusableCellWithIdentifier:locationCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:locationCellIdentifier];

                [cell.textLabel setText:NSLocalizedString(@"Location", @"Location")];
            }
            cell.accessoryType = _state == EditState_view ?
                    UITableViewCellAccessoryNone :
                    UITableViewCellAccessoryDisclosureIndicator;
            [cell.detailTextLabel setText:_item.location];

            break;
        case NUM_DURATION:
            cell = [tableView dequeueReusableCellWithIdentifier:durationCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:durationCellIdentifier];

                [cell.textLabel setText:NSLocalizedString(@"Duration", @"Duration")];
            }
            [cell.detailTextLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%d min", @"%d min"), _item.classDuration]];
            break;
        default:
            break;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_state == EditState_view) {
        return;
    }

    switch (indexPath.row) {
        case NUM_TITLE:
            [titleField becomeFirstResponder];
            break;
        case NUM_TIME:
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
                isTimeSelected = !isTimeSelected;
            } else {
                [timePicker setHidden:!timePicker.hidden];
            }
            [tableview reloadData];
            break;
        case NUM_WEEKDAY:
            [weekdayViewController setItem:_item];
            [[self navigationController] pushViewController:weekdayViewController animated:YES];
            break;
        case NUM_LOCATION:
            [locationViewController setItem:_item];
            [[self navigationController] pushViewController:locationViewController animated:YES];
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_state == EditState_view) {
        return;
    }

    switch (indexPath.row) {
        case NUM_TITLE:
            [titleField resignFirstResponder];
            break;
        case NUM_TIME:
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
                isTimeSelected = NO;
                [tableview reloadData];

            } else {
                [timePicker setHidden:YES];
            }
            break;
        default:
            break;
    }
}

-(IBAction)timeChanged:(id)sender {
    _item.time = timePicker.date;
    [tableview reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [TransitionIOSHelper heightForHeaderInSection];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && isTimeSelected) {
        return HEIGHT_TIME;
    }

    return HEIGHT_DEFAULT;
}

@end
