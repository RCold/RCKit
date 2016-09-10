//
//  RCSearchBar.m
//  RCKit
//
//  Created by Yeuham Wang on 16/3/22.
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

#import "RCSearchBar.h"
#import "UIView+RCKit.h"

@implementation RCSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCSearchBar];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCSearchBar];
    return self;
}

- (void)_initRCSearchBar {
    _searchBarTextField = [self subviewsThatIsClassNamed:@"UISearchBarTextField"].firstObject;
    self.placeholderColor = [UIColor colorWithWhite:0.0 alpha:0.22];
}

- (void)_updatePlaceholderColor {
    NSMutableAttributedString *attributedPlaceholder = [_searchBarTextField.attributedPlaceholder mutableCopy];
    [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:self.placeholderColor range:NSMakeRange(0, attributedPlaceholder.length)];
    _searchBarTextField.attributedPlaceholder = attributedPlaceholder;
    UIImageView *leftView = (UIImageView *)_searchBarTextField.leftView;
    leftView.image = [leftView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    leftView.tintColor = self.placeholderColor;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _searchBarTextField.attributedText = attributedText;
}

- (NSAttributedString *)attributedText {
    return _searchBarTextField.attributedText;
}

- (void)setFont:(UIFont *)font {
    _searchBarTextField.font = font;
}

- (UIFont *)font {
    return _searchBarTextField.font;
}

- (void)setTextColor:(UIColor *)textColor {
    _searchBarTextField.textColor = textColor;
}

- (UIColor *)textColor {
    return _searchBarTextField.textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _searchBarTextField.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment {
    return _searchBarTextField.textAlignment;
}

- (void)setDefaultTextAttributes:(NSDictionary *)defaultTextAttributes {
    _searchBarTextField.defaultTextAttributes = defaultTextAttributes;
}

- (NSDictionary *)defaultTextAttributes {
    return _searchBarTextField.defaultTextAttributes;
}

- (void)setPlaceholder:(NSString *)placeholder {
    super.placeholder = placeholder;
    [self _updatePlaceholderColor];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _searchBarTextField.attributedPlaceholder = attributedPlaceholder;
}

- (NSAttributedString *)attributedPlaceholder {
    return _searchBarTextField.attributedPlaceholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self _updatePlaceholderColor];
}

- (void)setTypingAttributes:(NSDictionary *)typingAttributes {
    _searchBarTextField.typingAttributes = typingAttributes;
}

- (NSDictionary *)typingAttributes {
    return _searchBarTextField.typingAttributes;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    _searchBarTextField.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

- (BOOL)adjustsFontSizeToFitWidth {
    return _searchBarTextField.adjustsFontSizeToFitWidth;
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize {
    _searchBarTextField.minimumFontSize = minimumFontSize;
}

- (CGFloat)minimumFontSize {
    return _searchBarTextField.minimumFontSize;
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode {
    _searchBarTextField.clearButtonMode = clearButtonMode;
}

- (UITextFieldViewMode)clearButtonMode {
    return _searchBarTextField.clearButtonMode;
}

@end
