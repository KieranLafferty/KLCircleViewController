//
//  KLViewController.m
//  KLCircleViewControllerDemo
//
//  Created by IBM on 2013-07-23.
//  Copyright (c) 2013 KL. All rights reserved.
//

#import "KLViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface KLViewController ()

@end

@implementation KLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIViewController* center = [self.storyboard instantiateViewControllerWithIdentifier:@"centerVC"];
    [center.view setBackgroundColor: [UIColor whiteColor]];
    CALayer* centerLayer =  center.view.layer;
    // border radius
    [centerLayer setCornerRadius:10.0];
    
    // drop shadow
    [centerLayer setShadowColor:[UIColor blackColor].CGColor];
    [centerLayer setShadowOpacity:0.6];
    [centerLayer setShadowRadius:4.0];
    [centerLayer setRasterizationScale: 5.0];
    [centerLayer setShadowPath: [[UIBezierPath
                                  bezierPathWithRect: centerLayer.bounds] CGPath]];
    
    
    //Configure the left view and resize it appropriately
    UIViewController* left = [self.storyboard instantiateViewControllerWithIdentifier:@"leftVC"];
    
    CGRect leftFrame = left.view.frame;
    leftFrame.origin.y = 10;
    leftFrame.size.height -= 2 * 10;
    [left.view setFrame: leftFrame];
    
    CALayer* leftLayer =  left.view.layer;
    leftLayer.cornerRadius = 10.0;
    
    //Configure the right view and resize it appropriately
    UIViewController* right = [self.storyboard instantiateViewControllerWithIdentifier:@"rightVC"];
    
    CGRect rightFrame = right.view.frame;
    rightFrame.origin.y = 10;
    rightFrame.size.height -= 2 * 10;
    [right.view setFrame: rightFrame];
    
    CALayer* rightLayer =  right.view.layer;
    rightLayer.cornerRadius = 10.0;
    
    //Configure the bottom view and resize it appropriately
    UIViewController* bottom = [self.storyboard instantiateViewControllerWithIdentifier:@"bottomVC"];
    CGRect bottomFrame = bottom.view.frame;
    bottomFrame.origin.x = 10;
    bottomFrame.size.width -= 2 * 10;
    [bottom.view setFrame: bottomFrame];
        
    self.circleVC = [[KLCircleViewController alloc] initWithCenterViewController: center
                                                              leftViewController: left
                                                             rightViewController: right
                                                            bottomViewController: bottom];

    [self.circleVC setWillTransitionState: ^(KLCircleViewController* circleViewController, KLCircleState fromState,
                                            KLCircleState toState) {
        NSLog(@"State before change: %d", circleViewController.state);
    }];
    [self.circleVC setDidTransitionState:^(KLCircleViewController* circleViewController, KLCircleState fromState,
                                          KLCircleState toState) {
        NSLog(@"State after change: %d", circleViewController.state);
    }];
}
-(void) viewDidAppear:(BOOL)animated {
    [self presentViewController: self.circleVC animated:YES completion:nil];

}
- (IBAction)didPressCenter:(id)sender {
    [self.circleVC setState:KLCircleStateCenter
                   animated:YES];
}

- (IBAction)didPressLeftButton:(id)sender {
    [self.circleVC setState:KLCircleStateLeft
                   animated:YES];
}

- (IBAction)didPressRightButton:(id)sender {
    [self.circleVC setState:KLCircleStateRight
                   animated:YES];
}

- (IBAction)didPressDownButton:(id)sender {
    [self.circleVC setState: KLCircleStateBottom
                   animated:YES];
}
@end
