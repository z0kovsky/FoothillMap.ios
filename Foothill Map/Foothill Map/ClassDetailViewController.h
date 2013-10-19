//
//  ClassDetailViewController.h
//  Foothill Map
//
//  Created by Elena Pychenkova on 6.08.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@class FHClass;

typedef enum EditState : NSInteger EditState;
enum EditState : NSInteger {
    EditState_new,
    EditState_view,
    EditState_edit
};

@interface ClassDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    __weak IBOutlet UITableView *tableview;
}

@property(nonatomic, strong) FHClass *item;
@property(nonatomic) enum EditState state;

@end
