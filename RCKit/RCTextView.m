//
//  RCTextView.m
//  RCKit
//
//  Created by Yeuham Wang on 16/8/26.
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

#import "RCTextView.h"

@implementation RCTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCTextView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self != nil)
        [self _initRCTextView];
    return self;
}

- (void)_initRCTextView {
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _placeholderLabel.font = self.font;
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.preferredMaxLayoutWidth = 0.0;
    self.placeholderColor = [UIColor colorWithWhite:0.0 alpha:0.22];
    [self insertSubview:_placeholderLabel atIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeWithNotification:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textViewTextDidChangeWithNotification:(NSNotification *)notification {
    _placeholderLabel.hidden = self.text.length != 0;
}

- (void)setText:(NSString *)text {
    super.text = text;
    [self textViewTextDidChangeWithNotification:nil];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    super.attributedText = attributedText;
    [self textViewTextDidChangeWithNotification:nil];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (NSString *)placeholder {
    return _placeholderLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    return _placeholderLabel.textColor;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _placeholderLabel.attributedText = attributedPlaceholder;
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedPlaceholder {
    return _placeholderLabel.attributedText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;
    frame.origin.x += 4.0;
    frame.origin.y += 8.0;
    frame.size.width -= 8.0;
    frame.size.height = 0.0;
    _placeholderLabel.frame = frame;
    [_placeholderLabel sizeToFit];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
