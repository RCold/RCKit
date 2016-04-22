//
//  RCSegmentedBar.m
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

#import "RCSegmentedBar.h"

@implementation RCSegmentedBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCSegmentedBar];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCSegmentedBar];
    return self;
}

- (void)_initRCSegmentedBar {
    _buttons = nil;
    _indicatorBar = [[UIView alloc] initWithFrame:CGRectZero];
    _items = nil;
    _titleColor = [UIColor lightGrayColor];
    _titleFont = [UIFont systemFontOfSize:15.0];
    _indicatorBarHeight = 2.0;
    _indicatorBarOffset = 0.0;
    _animateDuration = 0.3;
    [self addSubview:_indicatorBar];
}

- (void)_updateSubviews {
    for (UIButton *button in _buttons) {
        button.selected = NO;
        [button setTitleColor:_titleColor forState:UIControlStateNormal];
        [button setTitleColor:_titleColor forState:UIControlStateHighlighted];
        [button setTitleColor:self.tintColor forState:UIControlStateSelected];
        [button setTitleColor:_titleColor forState:UIControlStateReserved];
        [button addTarget:self action:@selector(_buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = _titleFont;
    }
    [_buttons.firstObject setSelected:YES];
    _indicatorBar.backgroundColor = self.tintColor;
    [self setNeedsLayout];
}

- (void)_setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (selectedSegmentIndex < 0)
        selectedSegmentIndex = 0;
    else if (selectedSegmentIndex > _items.count - 1)
        selectedSegmentIndex = _items.count - 1;
    for (UIButton *button in _buttons)
        button.selected = NO;
    [_buttons[selectedSegmentIndex] setSelected:YES];
}

- (void)_buttonDidTouch:(id)sender {
    if ([_delegate respondsToSelector:@selector(segmentedBar:segmentButtonAtIndexDidTouch:)])
        [_delegate segmentedBar:self segmentButtonAtIndexDidTouch:[_buttons indexOfObject:sender]];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    _buttons = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString *item in items) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:item forState:UIControlStateNormal];
        [_buttons addObject:button];
        [self addSubview:button];
    }
    [self _updateSubviews];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self _updateSubviews];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self _updateSubviews];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    _selectedSegmentIndex = selectedSegmentIndex;
    [self _setSelectedSegmentIndex:selectedSegmentIndex];
    [UIView animateWithDuration:_animateDuration animations:^{
        self.indicatorBarOffset = selectedSegmentIndex;
        [self layoutIfNeeded];
    }];
}

- (void)setIndicatorBarHeight:(CGFloat)indicatorBarHeight {
    _indicatorBarHeight = indicatorBarHeight;
    [self setNeedsLayout];
}

- (void)setIndicatorBarOffset:(CGFloat)indicatorBarOffset {
    if (indicatorBarOffset < 0.0)
        indicatorBarOffset = 0.0;
    else if (indicatorBarOffset > _items.count - 1)
        indicatorBarOffset = _items.count - 1;
    _indicatorBarOffset = indicatorBarOffset;
    _selectedSegmentIndex = (NSInteger)(indicatorBarOffset + 0.5);
    [self _setSelectedSegmentIndex:_selectedSegmentIndex];
    [self setNeedsLayout];
}

- (void)tintColorDidChange {
    [self _updateSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGRect buttonFrame = CGRectZero;
    if (_items.count != 0)
        buttonFrame.size = CGSizeMake(size.width / _items.count, size.height - _indicatorBarHeight);
    for (UIButton *button in _buttons) {
        button.frame = buttonFrame;
        buttonFrame.origin.x += buttonFrame.size.width;
    }
    _indicatorBar.frame = CGRectMake(buttonFrame.size.width * _indicatorBarOffset, size.height - _indicatorBarHeight, buttonFrame.size.width, _indicatorBarHeight);
}

@end
