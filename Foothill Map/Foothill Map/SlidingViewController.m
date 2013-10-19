//
//  SlidingViewController.m
//  SlidingViewTest
//
//  Created by Elena Pychenkova on 06.09.13.
//  Copyright (c) 2013 All rights reserved.
//

#import "TransitionIOSHelper.h"
#import "SlidingViewController.h"

#define CENTER_TAG 1
#define RIGHT_PANEL_TAG 2
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface SlidingViewController ()

@end

@implementation SlidingViewController

-(id)initWithCenter:(UIViewController <CenterViewControllerDelegate> *)centerVC andRight:(UIViewController *)rightVC {
    self = [super init];
    if (self) {
        self.centerViewController = centerVC;
        self.rightViewController = rightVC;

        self.slideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.slideButton setFrame:CGRectMake(270.0, 69.0 + [TransitionIOSHelper offsetY], 50.0, 32.0)];
        [self.slideButton setImage:[UIImage imageNamed:@"ic-slidebtn"] forState:UIControlStateNormal];
        [self.slideButton addTarget:self
                             action:@selector(slidePanel:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.slideButton setTag:1];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];

    [self.centerViewController.view addGestureRecognizer:panRecognizer];

    self.rightViewController.view.tag = RIGHT_PANEL_TAG;
    [self.view addSubview:self.rightViewController.view];
    [self addChildViewController:_rightViewController];
    [_rightViewController didMoveToParentViewController:self];
    _rightViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);


    self.centerViewController.view.tag = CENTER_TAG;
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:_centerViewController];
    [self.centerViewController.view addSubview:self.slideButton];

    [_centerViewController didMoveToParentViewController:self];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self movePanelToOriginalPosition];
    [_slideButton setTag:1];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)slidePanel:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
            [self movePanelToOriginalPosition];
            break;
        case 1:
            [self movePanelLeft];
            break;
        default:
            break;
    }
}

-(void)movePanelLeft {
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];

    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.slideButton.tag = 0;
                             [_centerViewController forbidGestures];
                         }
                     }];
}

-(void)movePanelToOriginalPosition {
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _centerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                             [_centerViewController allowGestures];
                         }
                     }];
}

-(void)resetMainView {
    if (_rightViewController != nil) {
        self.slideButton.tag = 1;
        self.showingRightPanel = NO;
    }
}

-(UIView *)getRightView {
    self.showingRightPanel = YES;

    UIView *view = self.rightViewController.view;
    return view;
}

-(void)movePanel:(UIGestureRecognizer *)sender {
    [[[(UITapGestureRecognizer *)sender view] layer] removeAllAnimations];

    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:[sender view]];

    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;

        if (velocity.x < 0) {
            if (!_showingRightPanel) {
                childView = [self getRightView];
            }

        }
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer *)sender view]];
    }

    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
            if (_showingRightPanel) {
                [self movePanelLeft];
            }
        }
    }

    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateChanged) {
        _showPanel = abs([sender view].center.x - _centerViewController.view.frame.size.width / 2) > _centerViewController.view.frame.size.width / 2;

        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0, 0) inView:self.view];

        _preVelocity = velocity;
    }
}

@end
