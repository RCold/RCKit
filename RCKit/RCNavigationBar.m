//
//  RCNavigationBar.m
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

#import "RCNavigationBar.h"

@interface UINavigationBar (RCNavigationBar)

- (void)_setHidesShadow:(BOOL)hidesShadow;
- (BOOL)_hidesShadow;

@end

@implementation RCNavigationBar

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    NSMutableDictionary *titleTextAttributes = [self.titleTextAttributes mutableCopy];
    if (titleTextAttributes == nil)
        titleTextAttributes = [NSMutableDictionary dictionary];
    if (titleTextColor == nil)
        [titleTextAttributes removeObjectForKey:NSForegroundColorAttributeName];
    else
        titleTextAttributes[NSForegroundColorAttributeName] = titleTextColor;
    self.titleTextAttributes = titleTextAttributes;
}

- (UIColor *)titleTextColor {
    return self.titleTextAttributes[NSForegroundColorAttributeName];
}

- (void)setHidesShadow:(BOOL)hidesShadow {
    if ([super respondsToSelector:@selector(_setHidesShadow:)])
        [super _setHidesShadow:hidesShadow];
}

- (BOOL)hidesShadow {
    if ([super respondsToSelector:@selector(_hidesShadow)])
        return [super _hidesShadow];
    return NO;
}

@end
