//
//  ShowAlertSegue.m
//  RCKitDemo
//
//  Created by Yeuham Wang on 16/2/28.
//  Copyright (c) 2016 Yeuham Wang. All rights reserved.
//

#import "RCKit.h"
#import "ShowAlertSegue.h"

@implementation ShowAlertSegue

- (void)perform {
    RCAlertController *alertController = (RCAlertController *)self.destinationViewController;
    [alertController presentAlertWithStyle:RCAlertControllerStyleAlert animated:YES];
}

@end
