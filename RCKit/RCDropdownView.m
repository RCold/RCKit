//
//  RCDropdownView.m
//  RCKit
//
//  Created by Yeuham Wang on 16/4/26.
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

#import "RCDropdownView.h"

@implementation RCDropdownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCDropdownView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCDropdownView];
    return self;
}

- (void)_initRCDropdownView {
    _animating = NO;
    _animationDuration = 0.2;
    _dimmingView = [[UIView alloc] initWithFrame:CGRectZero];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimmingView.hidden = YES;
    [_dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dimmingViewDidTap:)]];
    _dimsBackgroundDuringPresentation = YES;
    self.hidden = YES;
    [self addSubview:_dimmingView];
}

- (void)_dismissView {
    _dimmingView.hidden = YES;
    [_dimmingView.layer removeAllAnimations];
    [_presentedView removeFromSuperview];
    [_presentedView.layer removeAllAnimations];
    _presentedView = nil;
    self.hidden = YES;
}

- (void)_dimmingViewDidTap:(id)sender {
    if ([_delegate respondsToSelector:@selector(dropdownViewDimmingViewDidTap:)])
        [_delegate dropdownViewDimmingViewDidTap:self];
}

- (void)presentView:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion {
    _presented = YES;
    if (_animating) {
        _animating = NO;
        [self _dismissView];
    }
    CGSize size = self.bounds.size;
    CGSize viewSize = view.frame.size;
    CGRect initialViewFrame = CGRectMake(0.0, 0.0, size.width, 0.0);
    CGRect finalViewFrame = CGRectMake(0.0, 0.0, size.width, viewSize.height);
    _dimmingView.alpha = 0.0;
    _dimmingView.hidden = !_dimsBackgroundDuringPresentation;
    _presentedView = view;
    view.alpha = 1.0;
    view.frame = initialViewFrame;
    [self addSubview:view];
    self.hidden = NO;
    NSTimeInterval animationDuration = animated ? _animationDuration : 0.0;
    _animating = YES;
    [UIView animateWithDuration:animationDuration animations:^{
        _dimmingView.alpha = 0.3;
        view.alpha = 1.0;
        view.frame = finalViewFrame;
    } completion:^(BOOL finished) {
        if (!finished)
            return;
        _animating = NO;
        if (completion != nil)
            completion();
    }];
}

- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (!_presented)
        return;
    _presented = NO;
    if (_animating) {
        _animating = NO;
        [self _dismissView];
        return;
    }
    NSTimeInterval animationDuration = animated ? _animationDuration : 0.0;
    _animating = YES;
    [UIView animateWithDuration:animationDuration animations:^{
        _dimmingView.alpha = 0.0;
        _presentedView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (!finished)
            return;
        _animating = NO;
        [self _dismissView];
        if (completion != nil)
            completion();
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _dimmingView.frame = self.bounds;
}

@end
