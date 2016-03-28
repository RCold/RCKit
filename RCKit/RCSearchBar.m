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

@interface UISearchBarTextField : UITextField

- (UIColor *)_placeholderColor;

@end

@interface UISearchBar (RCSearchBar)

- (UISearchBarTextField *)_searchBarTextField;

@end

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
    if ([[self _searchBarTextField] respondsToSelector:@selector(_placeholderColor)])
        _placeholderColor = [[self _searchBarTextField] _placeholderColor];
    else
        _placeholderColor = [UIColor colorWithWhite:0.7 alpha:1.0];
}

- (UISearchBarTextField *)_searchBarTextField {
    if ([super respondsToSelector:@selector(_searchBarTextField)])
        return [super _searchBarTextField];
    return nil;
}

- (void)_updatePlaceholderColor {
    UISearchBarTextField *searchBarTextField = [self _searchBarTextField];
    NSMutableAttributedString *attributedPlaceholder = [searchBarTextField.attributedPlaceholder mutableCopy];
    [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:_placeholderColor range:NSMakeRange(0, attributedPlaceholder.length)];
    searchBarTextField.attributedPlaceholder = attributedPlaceholder;
    UIImageView *leftView = (UIImageView *)searchBarTextField.leftView;
    leftView.image = [leftView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    leftView.tintColor = _placeholderColor;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self _searchBarTextField].attributedText = attributedText;
}

- (NSAttributedString *)attributedText {
    return [self _searchBarTextField].attributedText;
}

- (void)setFont:(UIFont *)font {
    [self _searchBarTextField].font = font;
}

- (UIFont *)font {
    return [self _searchBarTextField].font;
}

- (void)setTextColor:(UIColor *)textColor {
    [self _searchBarTextField].textColor = textColor;
}

- (UIColor *)textColor {
    return [self _searchBarTextField].textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [self _searchBarTextField].textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment {
    return [self _searchBarTextField].textAlignment;
}

- (void)setDefaultTextAttributes:(NSDictionary *)defaultTextAttributes {
    [self _searchBarTextField].defaultTextAttributes = defaultTextAttributes;
}

- (NSDictionary *)defaultTextAttributes {
    return [self _searchBarTextField].defaultTextAttributes;
}

- (void)setPlaceholder:(NSString *)placeholder {
    super.placeholder = placeholder;
    [self _updatePlaceholderColor];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    [self _searchBarTextField].attributedPlaceholder = attributedPlaceholder;
}

- (NSAttributedString *)attributedPlaceholder {
    return [self _searchBarTextField].attributedPlaceholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self _updatePlaceholderColor];
}

- (void)setTypingAttributes:(NSDictionary *)typingAttributes {
    [self _searchBarTextField].typingAttributes = typingAttributes;
}

- (NSDictionary *)typingAttributes {
    return [self _searchBarTextField].typingAttributes;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    [self _searchBarTextField].adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

- (BOOL)adjustsFontSizeToFitWidth {
    return [self _searchBarTextField].adjustsFontSizeToFitWidth;
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize {
    [self _searchBarTextField].minimumFontSize = minimumFontSize;
}

- (CGFloat)minimumFontSize {
    return [self _searchBarTextField].minimumFontSize;
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode {
    [self _searchBarTextField].clearButtonMode = clearButtonMode;
}

- (UITextFieldViewMode)clearButtonMode {
    return [self _searchBarTextField].clearButtonMode;
}

@end
