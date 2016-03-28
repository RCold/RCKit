//
//  RCButtonCollectionView.m
//  RCKit
//
//  Created by Yeuham Wang on 16/2/23.
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

#import "RCButtonCollectionView.h"

@implementation RCButtonCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCButtonCollectionView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCButtonCollectionView];
    return self;
}

- (void)_initRCButtonCollectionView {
    _allowSelection = YES;
    _allowMultipleSelection = NO;
    _edgeInsets = UIEdgeInsetsZero;
    _interitemSpacing = 8.0;
    _lineSpacing = 8.0;
    _preferredLayoutWidth = 0.0;
}

- (void)_buttonDidTouch:(UIButton *)sender {
    if (!_allowSelection)
        return;
    if (!_allowMultipleSelection)
        [self deselectAllButtons];
    sender.selected = !sender.selected;
    if (sender.selected) {
        if ([_delegate respondsToSelector:@selector(buttonCollectionView:didSelectedButtonAtIndex:)])
            [_delegate buttonCollectionView:self didSelectedButtonAtIndex:[_buttons indexOfObject:sender]];
    } else {
        if ([_delegate respondsToSelector:@selector(buttonCollectionView:didDeselectedButtonAtIndex:)])
            [_delegate buttonCollectionView:self didDeselectedButtonAtIndex:[_buttons indexOfObject:sender]];
    }
}

- (void)setAllowSelection:(BOOL)allowSelection {
    _allowSelection = allowSelection;
    if (!_allowSelection)
        [self deselectAllButtons];
}

- (void)setAllowMultiSelection:(BOOL)allowMultiSelection {
    allowMultiSelection = allowMultiSelection;
    if (!allowMultiSelection)
        [self deselectAllButtons];
}

- (void)setButtons:(NSArray *)buttons {
    _buttons = [buttons copy];
    for (UIButton *button in buttons) {
        [button addTarget:self action:@selector(_buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    [self setNeedsLayout];
}

- (NSArray *)selectedButtons {
    NSMutableArray *selectedButtons = [NSMutableArray array];
    for (UIButton *button in _buttons)
        if (button.selected)
            [selectedButtons addObject:button];
    return [selectedButtons copy];
}

- (void)setPreferredLayoutWidth:(CGFloat)preferredLayoutWidth {
    _preferredLayoutWidth = preferredLayoutWidth;
    [self setNeedsLayout];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    [self setNeedsLayout];
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    [self setNeedsLayout];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self setNeedsLayout];
}

- (void)selectButtonAtIndex:(NSUInteger)index {
    if (!_allowSelection)
        return;
    if (!_allowMultipleSelection)
        [self deselectAllButtons];
    if (index < _buttons.count)
        ((UIButton *)_buttons[index]).selected = YES;
}

- (void)selectAllButtons {
    if (!_allowMultipleSelection)
        return;
    for (UIButton *button in _buttons)
        button.selected = YES;
}

- (void)deselectButtonAtIndex:(NSUInteger)index {
    if (index < _buttons.count)
        ((UIButton *)_buttons[index]).selected = NO;
}

- (void)deselectAllButtons {
    for (UIButton *button in _buttons)
        button.selected = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat layoutWidth = self.bounds.size.width;
    CGPoint currentOrigin = CGPointMake(_edgeInsets.left, _edgeInsets.top);
    CGSize currentSize;
    CGFloat currentRowHeight = 0.0;
    CGRect frame;
    if (_preferredLayoutWidth != 0.0)
        layoutWidth = _preferredLayoutWidth;
    for (UIButton *button in _buttons) {
        currentSize = button.frame.size;
        if (currentOrigin.x + currentSize.width > layoutWidth - _edgeInsets.right) {
            currentOrigin.x = _edgeInsets.left;
            currentOrigin.y += currentRowHeight;
            currentRowHeight = 0.0;
        }
        frame.origin = currentOrigin;
        frame.size = currentSize;
        button.frame = frame;
        currentOrigin.x += currentSize.width + _interitemSpacing;
        if (currentRowHeight < currentSize.height + _lineSpacing)
            currentRowHeight = currentSize.height + _lineSpacing;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGPoint currentOrigin = CGPointMake(_edgeInsets.left, _edgeInsets.top);
    CGSize currentSize;
    CGFloat currentRowHeight = 0.0;
    for (UIButton *button in _buttons) {
        currentSize = button.frame.size;
        if (currentOrigin.x + currentSize.width > size.width - _edgeInsets.right) {
            currentOrigin.x = _edgeInsets.left;
            currentOrigin.y += currentRowHeight;
            currentRowHeight = 0.0;
        }
        currentOrigin.x += currentSize.width + _interitemSpacing;
        if (currentRowHeight < currentSize.height + _lineSpacing)
            currentRowHeight = currentSize.height + _lineSpacing;
    }
    size.height = currentOrigin.y + currentRowHeight - _lineSpacing + _edgeInsets.bottom;
    return size;
}

- (CGSize)intrinsicContentSize {
    CGSize size = self.bounds.size;
    if (_preferredLayoutWidth != 0.0)
        size.width = _preferredLayoutWidth;
    return [self sizeThatFits:size];
}

@end
