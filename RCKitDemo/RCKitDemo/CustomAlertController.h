//
//  CustomAlertController.h
//  RCKitDemo
//
//  Created by Yeuham Wang on 16/2/28.
//  Copyright (c) 2016 Yeuham Wang. All rights reserved.
//

#import "RCKit.h"

@interface CustomAlertController : RCAlertController

@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (IBAction)okButtonDidTouch:(UIButton *)sender;

@end
