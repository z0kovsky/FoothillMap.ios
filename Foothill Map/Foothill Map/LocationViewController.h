//
//  LocationViewController.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 29.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHClass.h"

@interface LocationViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {

    __weak IBOutlet UITextField *locationField;
    __weak IBOutlet UITableView *autocompleteTableView;
}

@property(nonatomic) FHClass *item;

@end
