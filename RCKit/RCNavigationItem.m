//
//  RCNavigationItem.m
//  RCKit
//
//  Created by Yeuham Wang on 16/1/28.
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

#import "RCNavigationItem.h"

@interface UINavigationItem (RCNavigationItem)

- (void)setBackButtonTitle:(NSString *)backButtonTitle;
- (NSString *)backButtonTitle;

@end

@implementation RCNavigationItem

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithTitle:title];
    if (self != nil)
        [self _initRCNavigationItem];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self)
        [self _initRCNavigationItem];
    return self;
}

- (void)_initRCNavigationItem {
    self.backButtonTitle = [NSString string];
}

- (void)setBackButtonTitle:(NSString *)backButtonTitle {
    if ([super respondsToSelector:@selector(setBackButtonTitle:)])
        [super setBackButtonTitle:backButtonTitle];
}

- (NSString *)backButtonTitle {
    if ([super respondsToSelector:@selector(backButtonTitle)])
        return [super backButtonTitle];
    return nil;
}

@end
