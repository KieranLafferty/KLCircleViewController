//
//  KLViewController.m
//  KLCircleViewControllerDemo
//
//  Created by IBM on 2013-07-23.
//  Copyright (c) 2013 KL. All rights reserved.
//

#import "KLViewController.h"

@interface KLViewController ()

@end

@implementation KLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIViewController* center = [[UIViewController alloc] init];
    [center.view setBackgroundColor: [UIColor darkGrayColor]];
    self.circleVC = [[KLCircleViewController alloc] initWithCenterViewController: center];
    [self.circleVC.view setFrame: self.view.bounds];
    [self.view addSubview: self.circleVC.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
