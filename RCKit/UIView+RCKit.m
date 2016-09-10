//
//  UIView+RCKit.m
//  RCKit
//
//  Created by Yeuham Wang on 16/9/9.
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

#import "UIView+RCKit.h"

@implementation UIView (RCKit)

- (void)_addSubviews:(NSArray *)subviews thatIsClassNamed:(NSString *)className toArray:(NSMutableArray *)array {
    if (subviews.count == 0)
        return;
    for (UIView *subview in subviews) {
        NSString *subviewClassName = NSStringFromClass([subview class]);
        if ([subviewClassName isEqualToString:className] || [subviewClassName isEqualToString:[@"_" stringByAppendingString:className]])
            [array addObject:subview];
        [self _addSubviews:subview.subviews thatIsClassNamed:className toArray:array];
    }
}

- (NSArray *)subviewsThatIsClassNamed:(NSString *)className {
    NSMutableArray *array = [NSMutableArray array];
    [self _addSubviews:self.subviews thatIsClassNamed:className toArray:array];
    return [array copy];
}

@end
