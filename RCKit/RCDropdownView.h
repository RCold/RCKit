//
//  RCDropdownView.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RCDropdownViewDirection) {
    RCDropdownViewDirectionTopToBottom,
    RCDropdownViewDirectionBottomToTop,
    RCDropdownViewDirectionLeftToRight,
    RCDropdownViewDirectionRightToLeft,
} NS_ENUM_AVAILABLE_IOS(7_0);

@protocol RCDropdownViewDelegate;

NS_CLASS_AVAILABLE_IOS(7_0) @interface RCDropdownView : UIView {
    UIView *_clippingView;
    UIView *_containerView;
    UIView *_dimmingView;
    UIView *_tappingView;
}

@property (weak, nonatomic) id<RCDropdownViewDelegate> delegate;
@property (nonatomic) BOOL dimsBackgroundDuringPresentation;
@property (nonatomic) NSTimeInterval animationDuration;
@property (readonly, nonatomic, getter=isPresented) BOOL presented;
@property (readonly, nonatomic, getter=isAnimating) BOOL animating;

- (void)presentInView:(UIView *)view atPoint:(CGPoint)point withDirection:(RCDropdownViewDirection)direction animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end

@protocol RCDropdownViewDelegate <NSObject>

@optional
- (void)willPresentDropdownView:(RCDropdownView *)dropdownView;
- (void)didPresentDropdownView:(RCDropdownView *)dropdownView;
- (void)willDismissDropdownView:(RCDropdownView *)dropdownView;
- (void)didDismissDropdownView:(RCDropdownView *)dropdownView;

@end
