//
//  RCAlertController.m
//  RCKit
//
//  Created by Yeuham Wang on 16/2/21.
//  Copyright (c) 2016 Yeuham Wang.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "RCAlertController.h"

@implementation RCAlertController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil)
        [self _initRCAlertController];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCAlertController];
    return self;
}

- (void)_initRCAlertController {
    _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _alertWindow.windowLevel = UIWindowLevelAlert;
    _dimmingView = [[UIView alloc] initWithFrame:_alertWindow.bounds];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimsBackgroundDuringPresentation = YES;
    _presented = NO;
}

- (void)_dimmingViewDidTap:(UITapGestureRecognizer *)sender {
    [self dismissAlertAnimated:YES];
}

- (void)setDimsBackgroundDuringPresentation:(BOOL)dimsBackgroundDuringPresentation {
    _dimsBackgroundDuringPresentation = dimsBackgroundDuringPresentation;
    _dimmingView.hidden = !_dimsBackgroundDuringPresentation;
}

- (void)presentAlertWithStyle:(RCAlertControllerStyle)style animated:(BOOL)animated {
    if (_presented)
        return;
    _style = style;
    UIViewController *rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    _alertWindow.rootViewController = rootViewController;
    UIView *rootView = rootViewController.view;
    UIView *alertView = self.view;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize alertViewSize = alertView.bounds.size;
    [rootViewController addChildViewController:self];
    [rootView addSubview:_dimmingView];
    [rootView addSubview:alertView];
    _dimmingView.alpha = 0.0;
    switch (_style) {
        case RCAlertControllerStyleActionSheet:
            [_dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dimmingViewDidTap:)]];
            alertView.alpha = 1.0;
            alertView.center = CGPointMake(screenSize.width / 2.0, screenSize.height + alertViewSize.height / 2.0);
            alertView.transform = CGAffineTransformIdentity;
            break;
        case RCAlertControllerStyleAlert:
            alertView.alpha = 0.0;
            alertView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
            alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            break;
    }
    [_alertWindow makeKeyAndVisible];
    CGFloat animationDuration = animated ? 0.4 : 0.0;
    [UIView animateWithDuration:animationDuration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        _dimmingView.alpha = 0.4;
        switch (_style) {
            case RCAlertControllerStyleActionSheet:
                alertView.center = CGPointMake(screenSize.width / 2.0, screenSize.height - alertViewSize.height / 2.0);
                break;
            case RCAlertControllerStyleAlert:
                alertView.alpha = 1.0;
                alertView.transform = CGAffineTransformIdentity;
                break;
        }
    } completion:^(BOOL finished) {
        _presented = YES;
        [self didMoveToParentViewController:rootViewController];
        if (!finished)
            [self dismissAlertAnimated:NO];
    }];
}

- (void)dismissAlertAnimated:(BOOL)animated {
    if (!_presented)
        return;
    UIView *alertView = self.view;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize alertViewSize = self.view.bounds.size;
    CGFloat animationDuration = animated ? 0.4 : 0.0;
    [self willMoveToParentViewController:nil];
    [UIView animateWithDuration:animationDuration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        _dimmingView.alpha = 0.0;
        switch (_style) {
            case RCAlertControllerStyleActionSheet:
                alertView.center = CGPointMake(screenSize.width / 2.0, screenSize.height + alertViewSize.height / 2.0);
                break;
            case RCAlertControllerStyleAlert:
                alertView.alpha = 0.0;
                break;
        }
    } completion:^(BOOL finished) {
        _alertWindow.hidden = YES;
        _alertWindow.rootViewController = nil;
        _presented = NO;
        [self removeFromParentViewController];
    }];
}

@end
