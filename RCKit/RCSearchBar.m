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

@end

@interface UISearchBar (RCSearchBar)

- (UISearchBarTextField *)_searchBarTextField;

@end

@implementation RCSearchBar

- (UISearchBarTextField *)searchBarTextField {
    if ([super respondsToSelector:@selector(_searchBarTextField)])
        return [super _searchBarTextField];
    return nil;
}

- (void)setTextColor:(UIColor *)textColor {
    NSMutableAttributedString *attributedText = [self.attributedText mutableCopy];
    [attributedText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attributedText.length)];
    self.attributedText = attributedText;
}

- (UIColor *)textColor {
    NSAttributedString *attributedText = self.attributedText;
    return [attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [self searchBarTextField].attributedText = attributedText;
}

- (NSAttributedString *)attributedText {
    return [self searchBarTextField].attributedText;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    NSMutableAttributedString *attributedPlaceholder = [self.attributedPlaceholder mutableCopy];
    [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:placeholderColor range:NSMakeRange(0, attributedPlaceholder.length)];
    self.attributedPlaceholder = attributedPlaceholder;
    UIImageView *leftView = (UIImageView *)[self searchBarTextField].leftView;
    leftView.image = [leftView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    leftView.tintColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    NSAttributedString *attributedPlaceholder = self.attributedPlaceholder;
    return [attributedPlaceholder attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    [self searchBarTextField].attributedPlaceholder = attributedPlaceholder;
}

- (NSAttributedString *)attributedPlaceholder {
    return [self searchBarTextField].attributedPlaceholder;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    [self searchBarTextField].adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

- (BOOL)adjustsFontSizeToFitWidth {
    return [self searchBarTextField].adjustsFontSizeToFitWidth;
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize {
    [self searchBarTextField].minimumFontSize = minimumFontSize;
}

- (CGFloat)minimumFontSize {
    return [self searchBarTextField].minimumFontSize;
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode {
    [self searchBarTextField].clearButtonMode = clearButtonMode;
}

- (UITextFieldViewMode)clearButtonMode {
    return [self searchBarTextField].clearButtonMode;
}

@end
