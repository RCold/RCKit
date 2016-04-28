//
//  RCSeparatorView.m
//  RCKit
//
//  Created by Yeuham Wang on 16/4/18.
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

#import "RCSeparatorView.h"

@implementation RCSeparatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCSeparatorView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCSeparatorView];
    return self;
}

- (void)_initRCSeparatorView {
    _separatorColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _showTopSeparator = NO;
    _showBottomSeparator = NO;
    _showLeadingSeparator = NO;
    _showTrailingSeparator = NO;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    [self setNeedsDisplay];
}

- (void)setShowTopSeparator:(BOOL)showTopSeparator {
    _showTopSeparator = showTopSeparator;
    [self setNeedsDisplay];
}

- (void)setShowBottomSeparator:(BOOL)showBottomSeparator {
    _showBottomSeparator = showBottomSeparator;
    [self setNeedsDisplay];
}

- (void)setShowLeadingSeparator:(BOOL)showLeadingSeparator {
    _showLeadingSeparator = showLeadingSeparator;
    [self setNeedsDisplay];
}

- (void)setShowTrailingSeparator:(BOOL)showTrailingSeparator {
    _showTrailingSeparator = showTrailingSeparator;
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGSize size = rect.size;
    CGFloat separatorWidth = 1.0 / [UIScreen mainScreen].scale;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (_showTopSeparator) {
        [bezierPath moveToPoint:CGPointMake(0.0, separatorWidth / 2.0)];
        [bezierPath addLineToPoint:CGPointMake(size.width, separatorWidth / 2.0)];
    }
    if (_showBottomSeparator) {
        [bezierPath moveToPoint:CGPointMake(0.0, size.height - separatorWidth / 2.0)];
        [bezierPath addLineToPoint:CGPointMake(size.width, size.height - separatorWidth / 2.0)];
    }
    if (_showLeadingSeparator ) {
        [bezierPath moveToPoint:CGPointMake(separatorWidth / 2.0, 0.0)];
        [bezierPath addLineToPoint:CGPointMake(separatorWidth / 2.0, size.height)];
    }
    if (_showTrailingSeparator ) {
        [bezierPath moveToPoint:CGPointMake(size.width - separatorWidth / 2.0, 0.0)];
        [bezierPath addLineToPoint:CGPointMake(size.width - separatorWidth / 2.0, size.height)];
    }
    bezierPath.lineWidth = separatorWidth;
    [_separatorColor setStroke];
    [bezierPath stroke];
}

@end
