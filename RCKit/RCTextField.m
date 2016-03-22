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

@implementation RCTextField

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    NSMutableAttributedString *attributedPlaceholder = [super.attributedPlaceholder mutableCopy];
    [attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:placeholderColor range:NSMakeRange(0, attributedPlaceholder.length)];
    self.attributedPlaceholder = attributedPlaceholder;
}

- (UIColor *)placeholderColor {
    NSAttributedString *attributedPlaceholder = super.attributedPlaceholder;
    return [attributedPlaceholder attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
}

@end
