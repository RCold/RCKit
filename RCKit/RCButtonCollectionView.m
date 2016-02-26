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
        [self initChoiceControl];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self initChoiceControl];
    return self;
}

- (void)initChoiceControl {
    _allowSelection = YES;
    _allowMultiSelection = NO;
}

- (void)setAllowSelection:(BOOL)allowSelection {
    _allowSelection = allowSelection;
    if (!_allowSelection)
        [self deselectAllButtons];
}

- (void)setButtons:(NSArray *)buttons {
    _buttons = [buttons copy];
    for (UIButton *button in buttons) {
        [button addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)selectButtonAtIndex:(NSUInteger)index {
    if (!_allowSelection)
        return;
    if (!_allowMultiSelection)
        [self deselectAllButtons];
    if (index < _buttons.count)
        ((UIButton *)_buttons[index]).selected = YES;
}

- (void)selectAllButtons {
    if (!_allowMultiSelection)
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

- (void)buttonDidTouch:(UIButton *)button {
    if (!_allowSelection)
        return;
    if (!_allowMultiSelection)
        [self deselectAllButtons];
    button.selected = !button.selected;
    if (button.selected) {
        if ([_delegate respondsToSelector:@selector(buttonCollectionView:didSelectedButtonAtIndex:)])
            [_delegate buttonCollectionView:self didSelectedButtonAtIndex:[_buttons indexOfObject:button]];
    } else {
        if ([_delegate respondsToSelector:@selector(buttonCollectionView:didDeselectedButtonAtIndex:)])
            [_delegate buttonCollectionView:self didDeselectedButtonAtIndex:[_buttons indexOfObject:button]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGPoint currentOrigin = CGPointZero;
    CGSize currentSize;
    CGFloat currentRowHeight = 0.0;
    CGRect frame;
    for (UIButton *button in _buttons) {
        currentSize = button.frame.size;
        if (currentOrigin.x + currentSize.width + 8.0 > size.width) {
            currentOrigin.x = 0.0;
            currentOrigin.y += currentRowHeight;
            currentRowHeight = 0.0;
        }
        if (currentRowHeight < currentSize.height + 8.0)
            currentRowHeight = currentSize.height + 8.0;
        frame.origin = currentOrigin;
        frame.size = currentSize;
        button.frame = frame;
        currentOrigin.x += currentSize.width + 8.0;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGPoint currentOrigin = CGPointZero;
    CGSize currentSize;
    CGFloat currentRowHeight = 0.0;
    CGRect frame;
    for (UIButton *button in _buttons) {
        currentSize = button.frame.size;
        if (currentOrigin.x + currentSize.width + 8.0 > size.width) {
            currentOrigin.x = 0.0;
            currentOrigin.y += currentRowHeight;
            currentRowHeight = 0.0;
        }
        if (currentRowHeight < currentSize.height + 8.0)
            currentRowHeight = currentSize.height + 8.0;
        frame.origin = currentOrigin;
        frame.size = currentSize;
        currentOrigin.x += currentSize.width + 8.0;
    }
    size.height = currentOrigin.y + currentRowHeight - 8.0;
    return size;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}

@end
