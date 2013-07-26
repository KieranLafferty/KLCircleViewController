//
//  KLViewController.h
//  KLCircleViewControllerDemo
//
//  Created by IBM on 2013-07-23.
//  Copyright (c) 2013 KL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KLCircleViewController/KLCircleViewController.h>
@interface KLViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (nonatomic, strong) KLCircleViewController* circleVC;
- (IBAction)didPressCenter:(id)sender;
- (IBAction)didPressLeftButton:(id)sender;
- (IBAction)didPressRightButton:(id)sender;
- (IBAction)didPressDownButton:(id)sender;
@end
