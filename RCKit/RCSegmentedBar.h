//
//  RCSegmentedBar.h
//  RCKit
//
//  Created by Yeuham Wang on 16/4/20.
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

@protocol RCSegmentedBarDelegate;

@interface RCSegmentedBar : UIView {
    NSMutableArray *_buttons;
    UIView *_indicatorBar;
}

@property (weak, nonatomic) id<RCSegmentedBarDelegate> delegate;
@property (copy, nonatomic) NSArray *items;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic) CGFloat indicatorBarHeight;
@property (nonatomic) CGFloat indicatorBarOffset;
@property (nonatomic) CGFloat animateDuration;

@end


@protocol RCSegmentedBarDelegate <NSObject>

@optional
- (void)segmentedBar:(RCSegmentedBar *)segmentedBar segmentButtonAtIndexDidTouch:(NSInteger)segmentIndex;

@end
