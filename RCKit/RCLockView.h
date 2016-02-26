//
//  RCLockView.h
//  RCKit
//
//  Created by Yeuham Wang on 16/1/13.
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

#import <UIKit/UIKit.h>

@protocol RCLockViewDelegate;

NS_CLASS_AVAILABLE_IOS(7_0) @interface RCLockView : UIView {
    NSMutableArray *_buttons;
    NSMutableArray *_selectedButtons;
    CGPoint _currentTouchLocation;
}

// Delegate
@property (weak, nonatomic) id<RCLockViewDelegate> delegate;

// Path parameters
@property (nonatomic) BOOL displayPath;
@property (nonatomic) CGFloat pathLineWidth;
@property (nonatomic) UIColor *pathLineColor;

// Number of buttons
@property (nonatomic) NSUInteger numberOfRows;
@property (nonatomic) NSUInteger numberOfColumns;

// Button parameters
@property (nonatomic) CGSize buttonSize;
@property (strong, nonatomic) UIImage *buttonImage;
@property (strong, nonatomic) UIImage *buttonSelectedImage;

@end

@protocol RCLockViewDelegate <NSObject>

@optional
- (void)lockView:(RCLockView *)lockView didFinishInputingWithPath:(NSString *)path;

@end
