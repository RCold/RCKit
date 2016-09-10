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
    _buttons = [NSMutableArray array];
    _indicatorBar = [[UIView alloc] initWithFrame:CGRectZero];
    self.delegate = nil;
    self.items = nil;
    self.titleColor = [UIColor lightGrayColor];
    self.titleFont = [UIFont systemFontOfSize:15.0];
    self.selectedSegmentIndex = 0;
    self.indicatorBarHeight = 2.0;
    self.indicatorBarOffset = 0.0;
    self.animateDuration = 0.3;
    [self addSubview:_indicatorBar];
}

- (void)_updateSubviews {
    for (UIButton *button in _buttons) {
        button.selected = NO;
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor forState:UIControlStateHighlighted];
        [button setTitleColor:self.tintColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(_buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = self.titleFont;
    }
    [_buttons.firstObject setSelected:YES];
    _indicatorBar.backgroundColor = self.tintColor;
    [self setNeedsLayout];
}

- (void)_buttonDidTouch:(id)sender {
    NSInteger index = [_buttons indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(segmentedBar:buttonAtIndexDidTouch:)])
        [self.delegate segmentedBar:self buttonAtIndexDidTouch:index];
    else
        [self setSelectedSegmentIndex:index animated:YES];
}

- (void)setItems:(NSArray *)items {
    _items = [items copy];
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
    self.indicatorBarOffset = (CGFloat)selectedSegmentIndex;
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated {
    NSTimeInterval animateDuration = animated ? self.animateDuration : 0.0;
    [self layoutIfNeeded];
    [UIView animateWithDuration:animateDuration animations:^{
        self.indicatorBarOffset = selectedSegmentIndex;
        [self layoutIfNeeded];
    }];
}

- (void)setIndicatorBarHeight:(CGFloat)indicatorBarHeight {
    _indicatorBarHeight = indicatorBarHeight;
    [self setNeedsLayout];
}

- (void)setIndicatorBarOffset:(CGFloat)indicatorBarOffset {
    _indicatorBarOffset = indicatorBarOffset;
    _selectedSegmentIndex = (NSInteger)(indicatorBarOffset + 0.5);
    if (_selectedSegmentIndex < 0)
        _selectedSegmentIndex = 0;
    else if (_buttons.count > 0 && _selectedSegmentIndex > _buttons.count - 1)
        _selectedSegmentIndex = self.items.count - 1;
    for (UIButton *button in _buttons)
        button.selected = NO;
    if (_buttons.count > 0)
        [_buttons[self.selectedSegmentIndex] setSelected:YES];
    [self setNeedsLayout];
}

- (void)tintColorDidChange {
    [self _updateSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGRect buttonFrame = CGRectZero;
    if (self.items.count != 0)
        buttonFrame.size = CGSizeMake(size.width / self.items.count, size.height - self.indicatorBarHeight);
    for (UIButton *button in _buttons) {
        button.frame = buttonFrame;
        buttonFrame.origin.x += buttonFrame.size.width;
    }
    _indicatorBar.frame = CGRectMake(buttonFrame.size.width * self.indicatorBarOffset, size.height - self.indicatorBarHeight, buttonFrame.size.width, self.indicatorBarHeight);
}

@end
