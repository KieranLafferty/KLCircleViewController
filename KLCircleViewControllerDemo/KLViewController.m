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
    
    CGRect leftFrame = left.view.frame;
    leftFrame.origin.y = 10;
    leftFrame.size.height -= 2 * 10;
    [left.view setFrame: leftFrame];
    
    [left.view setBackgroundColor: [UIColor whiteColor]];
    CALayer* leftLayer =  left.view.layer;
    leftLayer.cornerRadius = 10.0;
    
    
    UIViewController* right = [[UIViewController alloc] init];
    
    CGRect rightFrame = right.view.frame;
    rightFrame.origin.y = 10;
    rightFrame.size.height -= 2 * 10;
    [right.view setFrame: rightFrame];
    
    [right.view setBackgroundColor: [UIColor whiteColor]];
    CALayer* rightLayer =  right.view.layer;
    rightLayer.cornerRadius = 10.0;
    
    UIViewController* bottom = [[UIViewController alloc] init];
    CGRect bottomFrame = bottom.view.frame;
    bottomFrame.origin.x = 10;
    bottomFrame.size.width -= 2 * 10;
    [bottom.view setFrame: bottomFrame];
    
    [bottom.view setBackgroundColor: [UIColor lightGrayColor]];
    
    self.circleVC = [[KLCircleViewController alloc] initWithCenterViewController: center
                                                              leftViewController: left
                                                             rightViewController: right
                                                               topViewController: nil
                                                            bottomViewController: bottom];

    [self.circleVC.view setFrame: self.view.bounds];
    [self.view insertSubview: self.circleVC.view
                belowSubview: self.leftButton];
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
