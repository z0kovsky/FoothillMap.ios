//
//  SlidingViewController.h
//  SlidingViewTest
//
//  Created by Elena Pychenkova on 06.09.13.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CenterViewControllerDelegate <NSObject>

@required
-(void)forbidGestures;

-(void)allowGestures;

@end

@interface SlidingViewController : UIViewController <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIViewController <CenterViewControllerDelegate> *centerViewController;
@property(nonatomic, strong) UIViewController *rightViewController;
@property(nonatomic, assign) BOOL showingRightPanel;
@property(nonatomic, assign) BOOL showPanel;
@property(nonatomic, assign) CGPoint preVelocity;
@property(nonatomic, strong) UIButton *slideButton;

-(id)initWithCenter:(UIViewController <CenterViewControllerDelegate> *)centerVC andRight:(UIViewController *)rightVC;

@end
