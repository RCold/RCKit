//
//  CustomAlertController.m
//  RCKitDemo
//
//  Created by Yeuham Wang on 16/2/28.
//  Copyright (c) 2016 Yeuham Wang. All rights reserved.
//

#import "CustomAlertController.h"

@implementation CustomAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_okButton setBackgroundImage:UIImageFromColor([UIColor whiteColor], CGSizeMake(1.0, 1.0)) forState:UIControlStateNormal];
    CALayer *layer = _okButton.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0, -1.0 / [UIScreen mainScreen].scale);
    layer.shadowRadius = 0.0;
    layer.shadowOpacity = 0.25;
}

- (IBAction)okButtonDidTouch:(UIButton *)sender {
    [self dismissAlertAnimated:YES];
}

@end
