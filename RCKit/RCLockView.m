//
//  RCLockView.m
//  RCKit
//
//  Created by Yeuham Wang on 16/1/13.
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

#import "RCLockView.h"

@implementation RCLockView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self initLockView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self initLockView];
    return self;
}

- (void)initLockView {
    _displayPath = YES;
    _pathLineWidth = 10.0;
    _pathLineColor = [UIColor lightGrayColor];
    _numberOfRows = 3;
    _numberOfColumns = 3;
    _buttonSize = CGSizeMake(74.0, 74.0);
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"RCLockView" ofType:@"bundle"]];
    _buttonImage = [UIImage imageNamed:@"gesture_node_normal.png" inBundle:bundle compatibleWithTraitCollection:nil];
    _buttonSelectedImage = [UIImage imageNamed:@"gesture_node_selected.png" inBundle:bundle compatibleWithTraitCollection:nil];
    self.backgroundColor = [UIColor clearColor];
    [self updateSubviews];
}

- (void)setDisplayPath:(BOOL)displayPath {
    _displayPath = displayPath;
    [self setNeedsDisplay];
}

- (void)setPathLineWidth:(CGFloat)pathLineWidth {
    if (pathLineWidth < 0.0)
        return;
    _pathLineWidth = pathLineWidth;
    [self setNeedsDisplay];
}

- (void)setPathLineColor:(UIColor *)pathLineColor {
    if (pathLineColor == nil)
        return;
    _pathLineColor = pathLineColor;
    [self setNeedsDisplay];
}

- (void)setNumberOfRows:(NSUInteger)numberOfRows {
    if (numberOfRows < 3)
        return;
    _numberOfRows = numberOfRows;
    [self updateSubviews];
}

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns {
    if (numberOfColumns < 3)
        return;
    _numberOfColumns = numberOfColumns;
    [self updateSubviews];
}

- (void)setButtonSize:(CGSize)buttonSize {
    _buttonSize = buttonSize;
    [self setNeedsLayout];
}

- (void)setButtonImage:(UIImage *)buttonImage {
    _buttonImage = buttonImage;
    [self updateSubviews];
}

- (void)setButtonSelectedImage:(UIImage *)buttonSelectedImage {
    _buttonSelectedImage = buttonSelectedImage;
    [self updateSubviews];
}

- (void)updateSubviews {
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger numberOfButtons = _numberOfRows * _numberOfColumns;
    _buttons = [NSMutableArray arrayWithCapacity:numberOfButtons];
    _selectedButtons = [NSMutableArray arrayWithCapacity:numberOfButtons];
    for (int i = 0; i < numberOfButtons ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:_buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:_buttonSelectedImage forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        button.tag = i;
        [_buttons addObject:button];
        [self addSubview:button];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIButton *button in _buttons) {
        NSInteger i = button.tag;
        NSUInteger column = i % _numberOfColumns;
        NSUInteger row = i / _numberOfColumns;
        CGSize size = self.bounds.size;
        CGFloat marginX = (size.width - _numberOfColumns * _buttonSize.width) / (_numberOfColumns + 1);
        CGFloat marginY = (size.height - _numberOfRows * _buttonSize.height) / (_numberOfRows + 1);
        CGRect buttonFrame;
        buttonFrame.origin.x = marginX + column * (_buttonSize.width + marginX);
        buttonFrame.origin.y = marginY + row * (_buttonSize.height + marginY);
        buttonFrame.size = _buttonSize;
        button.frame = buttonFrame;
    }
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    _currentTouchLocation = touchLocation;
    for (UIButton *button in self.subviews)
        if (CGRectContainsPoint(button.frame, touchLocation)) {
            if (_displayPath)
                button.selected = YES;
            if (![_selectedButtons containsObject:button])
                [_selectedButtons addObject:button];
        }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSMutableString *path = [NSMutableString string];
    for (UIButton *button in _selectedButtons) {
        button.selected = NO;
        [path appendFormat:@"%ld", (long)button.tag];
    }
    [_selectedButtons makeObjectsPerformSelector:@selector(setSelected:) withObject:@NO];
    [_selectedButtons removeAllObjects];
    if (path.length > 0 && [_delegate respondsToSelector:@selector(lockView:didFinishInputingWithPath:)])
        [_delegate lockView:self didFinishInputingWithPath:[path copy]];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!_displayPath)
        return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = _pathLineWidth;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [_pathLineColor setStroke];
    for (int i = 0; i < _selectedButtons.count; i++) {
        UIButton *button = _selectedButtons[i];
        if (i == 0)
            [path moveToPoint:button.center];
        else
            [path addLineToPoint:button.center];
    }
    if (_selectedButtons.count != 0)
        [path addLineToPoint:_currentTouchLocation];
    [path stroke];
}

@end
