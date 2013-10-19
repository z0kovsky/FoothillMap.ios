//
//  LocationViewController.m
//  Foothill Map
//
//  Created by Elena Pychenkova on 29.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "LocationViewController.h"
#import "FHLocationCatalog.h"

@implementation LocationViewController {
    NSMutableArray *autocompleteLocations;
}

@synthesize item = _item;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *navigationItem = [self navigationItem];
        [navigationItem setTitle:NSLocalizedString(@"Location", @"Location")];

        autocompleteLocations = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;

    [locationField setText:_item.location];
    locationField.delegate = self;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [locationField becomeFirstResponder];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_item setLocation:[locationField text]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [autocompleteLocations count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WeekdayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *locationTitle = [autocompleteLocations objectAtIndex:[indexPath row]];
    [cell.textLabel setText:locationTitle];

    return cell;
}

-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [locationField setText:[autocompleteLocations objectAtIndex:[indexPath row]]];
    [_item setLocation:[locationField text]];
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

-(void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [autocompleteLocations removeAllObjects];

    NSString *target = [[substring lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];

    for (NSString *curString in [[FHLocationCatalog sharedCatalog] locationTitlesList]) {
        NSString *curTarget = [[curString lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSRange substringRange = [curTarget rangeOfString:target];
        if (substringRange.location < curTarget.length) {
            if (![autocompleteLocations containsObject:curString]) {
                [autocompleteLocations addObject:curString];
            }
        }
    }

    if ([autocompleteLocations count] == 0) {
        autocompleteTableView.hidden = YES;
    } else {
        autocompleteTableView.hidden = NO;
    }

    [autocompleteTableView reloadData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [_item setLocation:[locationField text]];
    autocompleteTableView.hidden = YES;
}
@end
