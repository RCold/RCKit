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
    _clippingView = [[UIView alloc] initWithFrame:CGRectZero];
    _clippingView.clipsToBounds = YES;
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _dimmingView = [[UIView alloc] initWithFrame:CGRectZero];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimsBackgroundDuringPresentation = YES;
    _presented = NO;
    _tappingView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tappingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissViewForGestureRecognizer:)]];
}

- (void)_dismissView {
    _animating = NO;
    [self removeFromSuperview];
    [self.layer removeAllAnimations];
    [_clippingView removeFromSuperview];
    [_clippingView.layer removeAllAnimations];
    [_tappingView removeFromSuperview];
    [_dimmingView removeFromSuperview];
    [_dimmingView.layer removeAllAnimations];
    [_containerView removeFromSuperview];
}

- (void)_dismissViewForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self dismissViewAnimated:YES completion:nil];
}

- (void)presentInView:(UIView *)view atPoint:(CGPoint)point withDirection:(RCDropdownViewDirection)direction animated:(BOOL)animated completion:(void (^)(void))completion {
    if ([_delegate respondsToSelector:@selector(willPresentDropdownView:)])
        [_delegate willPresentDropdownView:self];
    [self _dismissView];
    CGSize size = self.bounds.size;
    CGRect finalViewFrame = CGRectMake(0.0, 0.0, size.width, size.height);
    CGRect initialViewFrame = finalViewFrame;
    CGRect clipperFinalViewFrame = CGRectMake(point.x, point.y, size.width, size.height);
    CGRect clipperInitialViewFrame = clipperFinalViewFrame;
    UIView *presentingView = view.superview;
    if (presentingView != nil)
        _containerView.frame = view.frame;
    else {
        presentingView = view;
        _containerView.frame = view.bounds;
    }
    switch (direction) {
        case RCDropdownViewDirectionBottomToTop:
            initialViewFrame.origin.y -= size.height;
            clipperInitialViewFrame.origin.y += size.height;
        case RCDropdownViewDirectionTopToBottom:
            clipperInitialViewFrame.size.height = 0.0;
            break;
        case RCDropdownViewDirectionRightToLeft:
            initialViewFrame.origin.x -= size.width;
            clipperInitialViewFrame.origin.x += size.width;
        case RCDropdownViewDirectionLeftToRight:
            clipperInitialViewFrame.size.width = 0.0;
            break;
    }
    _clippingView.alpha = 1.0;
    _clippingView.frame = clipperInitialViewFrame;
    _dimmingView.alpha = 0.0;
    _dimmingView.frame = _containerView.bounds;
    _tappingView.frame = _containerView.bounds;
    self.frame = initialViewFrame;
    [_clippingView addSubview:self];
    [_containerView addSubview:_dimmingView];
    [_containerView addSubview:_tappingView];
    [_containerView addSubview:_clippingView];
    [presentingView addSubview:_containerView];
    NSTimeInterval animationDuration = animated ? _animationDuration : 0.0;
    _animating = YES;
    [UIView animateWithDuration:animationDuration animations:^{
        if (_dimsBackgroundDuringPresentation)
            _dimmingView.alpha = 0.4;
        _clippingView.frame = clipperFinalViewFrame;
        self.frame = finalViewFrame;
    } completion:^(BOOL finished) {
        if (!finished)
            return;
        _animating = NO;
        _presented = YES;
        if ([_delegate respondsToSelector:@selector(didPresentDropdownView:)])
            [_delegate didPresentDropdownView:self];
        if (completion != nil)
            completion();
    }];
}

- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if ([_delegate respondsToSelector:@selector(willDismissDropdownView:)])
        [_delegate willDismissDropdownView:self];
    _presented = NO;
    if (_animating) {
        _animating = NO;
        [self _dismissView];
        if ([_delegate respondsToSelector:@selector(didDismissDropdownView:)])
            [_delegate didDismissDropdownView:self];
        return;
    }
    NSTimeInterval animationDuration = animated ? _animationDuration : 0.0;
    _animating = YES;
    [UIView animateWithDuration:animationDuration animations:^{
        _dimmingView.alpha = 0.0;
        _clippingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (!finished)
            return;
        _animating = NO;
        [self _dismissView];
        if ([_delegate respondsToSelector:@selector(didDismissDropdownView:)])
            [_delegate didDismissDropdownView:self];
        if (completion != nil)
            completion();
    }];
}

@end
