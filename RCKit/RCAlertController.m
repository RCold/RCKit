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
    _alertWindowHeight = _alertWindow.bounds.size.height;
    _animating = NO;
    _dimmingView = [[UIView alloc] initWithFrame:_alertWindow.bounds];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _presented = NO;
    _tappingView = [[UIView alloc] initWithFrame:_alertWindow.bounds];
    _tappingView.backgroundColor = [UIColor clearColor];
    [_tappingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissAlertForGestureRecognizer:)]];
    self.delegate = nil;
    self.dimsBackgroundDuringPresentation = YES;
    self.animationDuration = 0.4;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_positionAlertForNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)_positionAlertForNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = (NSTimeInterval)[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    UIView *alertView = self.view;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    if (!_presented)
        animationDuration = 0.0;
    [alertView layoutIfNeeded];
    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        _alertWindowHeight = keyboardFrameEnd.origin.y;
        CGPoint center = alertView.center;
        switch (_style) {
            case RCAlertControllerStyleActionSheet:
                center.y = _alertWindowHeight - alertView.bounds.size.height / 2.0;
                break;
            case RCAlertControllerStyleAlert:
                center.y = _alertWindowHeight / 2.0;
                break;
        }
        alertView.center = center;
    } completion:nil];
}

- (void)_dismissAlert {
    UIView *alertView = self.view;
    _animating = NO;
    [alertView removeFromSuperview];
    [alertView.layer removeAllAnimations];
    [_tappingView removeFromSuperview];
    [_dimmingView removeFromSuperview];
    [_dimmingView.layer removeAllAnimations];
    _alertWindow.hidden = YES;
    _alertWindow.rootViewController = nil;
    [self removeFromParentViewController];
}

- (void)_dismissAlertForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (!_animating && _style == RCAlertControllerStyleActionSheet)
        [self dismissAlertAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _alertWindow.windowLevel = UIWindowLevelAlert;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _alertWindow.windowLevel = UIWindowLevelNormal;
}

- (void)presentAlertWithStyle:(RCAlertControllerStyle)style animated:(BOOL)animated completion:(void (^)(void))completion {
    if ([self.delegate respondsToSelector:@selector(willPresentAlertController:)])
        [self.delegate willPresentAlertController:self];
    [self _dismissAlert];
    _style = style;
    UIViewController *rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    _alertWindow.rootViewController = rootViewController;
    UIView *rootView = rootViewController.view;
    UIView *alertView = self.view;
    CGSize alertWindowSize = _alertWindow.bounds.size;
    alertWindowSize.height = _alertWindowHeight;
    CGSize alertViewSize = alertView.bounds.size;
    switch (_style) {
        case RCAlertControllerStyleActionSheet:
            alertView.alpha = 1.0;
            alertView.center = CGPointMake(alertWindowSize.width / 2.0, alertWindowSize.height + alertViewSize.height / 2.0);
            alertView.transform = CGAffineTransformIdentity;
            break;
        case RCAlertControllerStyleAlert:
            alertView.alpha = 0.0;
            alertView.center = CGPointMake(alertWindowSize.width / 2.0, alertWindowSize.height / 2.0);
            alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            break;
    }
    _dimmingView.alpha = 0.0;
    [rootView addSubview:_dimmingView];
    [rootView addSubview:_tappingView];
    [rootView addSubview:alertView];
    [_alertWindow makeKeyAndVisible];
    NSTimeInterval animationDuration = animated ? self.animationDuration : 0.0;
    [rootViewController addChildViewController:self];
    [alertView layoutIfNeeded];
    _animating = YES;
    [UIView animateWithDuration:animationDuration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        if (self.dimsBackgroundDuringPresentation)
            _dimmingView.alpha = 0.4;
        switch (_style) {
            case RCAlertControllerStyleActionSheet:
                alertView.center = CGPointMake(alertWindowSize.width / 2.0, alertWindowSize.height - alertViewSize.height / 2.0);
                break;
            case RCAlertControllerStyleAlert:
                alertView.alpha = 1.0;
                alertView.transform = CGAffineTransformIdentity;
                break;
        }
    } completion:^(BOOL finished) {
        if (!finished)
            return;
        _animating = NO;
        _presented = YES;
        [self didMoveToParentViewController:rootViewController];
        if ([self.delegate respondsToSelector:@selector(didPresentAlertController:)])
            [self.delegate didPresentAlertController:self];
        if (completion != nil)
            completion();
    }];
}

- (void)dismissAlertAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if ([self.delegate respondsToSelector:@selector(willDismissAlertController:)])
        [self.delegate willDismissAlertController:self];
    _presented = NO;
    if (_animating) {
        _animating = NO;
        [self _dismissAlert];
        if ([self.delegate respondsToSelector:@selector(didDismissAlertController:)])
            [self.delegate didDismissAlertController:self];
        return;
    }
    UIView *alertView = self.view;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize alertViewSize = alertView.bounds.size;
    NSTimeInterval animationDuration = animated ? self.animationDuration : 0.0;
    [self willMoveToParentViewController:nil];
    _animating = YES;
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
        if (!finished)
            return;
        _animating = NO;
        [self _dismissAlert];
        if ([self.delegate respondsToSelector:@selector(didDismissAlertController:)])
            [self.delegate didDismissAlertController:self];
        if (completion != nil)
            completion();
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
