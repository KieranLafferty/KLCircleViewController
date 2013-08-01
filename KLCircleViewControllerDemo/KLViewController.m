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
    UIViewController* center = [[UIViewController alloc] init];
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
    
    UIViewController* left = [[UIViewController alloc] init];
    [left.view setBackgroundColor: [UIColor whiteColor]];
    CALayer* leftLayer =  left.view.layer;
    leftLayer.cornerRadius = 10.0;
    
    
    UIViewController* right = [[UIViewController alloc] init];
    [right.view setBackgroundColor: [UIColor whiteColor]];
    CALayer* rightLayer =  right.view.layer;
    rightLayer.cornerRadius = 10.0;
    
    UIViewController* bottom = [[UIViewController alloc] init];
    [bottom.view setBackgroundColor: [UIColor purpleColor]];
    
    self.circleVC = [[KLCircleViewController alloc] initWithCenterViewController: center
                                                              leftViewController: left
                                                             rightViewController: right
                                                               topViewController: nil
                                                            bottomViewController: bottom];

    [self.circleVC.view setFrame: self.view.bounds];
    [self.view insertSubview: self.circleVC.view
                belowSubview: self.leftButton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
