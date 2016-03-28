//
//  RCTextField.m
//  RCKit
//
//  Created by Yeuham Wang on 16/1/27.
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

#import "RCTextField.h"

@interface UITextField (RCTextField)

- (UIColor *)_placeholderColor;

@end

@implementation RCTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCTextField];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCTextField];
    return self;
}

- (void)_initRCTextField {
    if ([super respondsToSelector:@selector(_placeholderColor)])
        _placeholderColor = [super _placeholderColor];
    else
        _placeholderColor = [UIColor colorWithWhite:0.7 alpha:1.0];
}

- (void)_updatePlaceholderColor {
    NSMutableAttributedString *attributedPlaceholder = [super.attributedPlaceholder mutableCopy];
    [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:_placeholderColor range:NSMakeRange(0, attributedPlaceholder.length)];
    super.attributedPlaceholder = attributedPlaceholder;
}

- (void)setPlaceholder:(NSString *)placeholder {
    super.placeholder = placeholder;
    [self _updatePlaceholderColor];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self _updatePlaceholderColor];
}

@end
