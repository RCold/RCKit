//
//  RCButtonCollectionView.h
//  RCKit
//
//  Created by Yeuham Wang on 16/2/23.
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

@protocol RCButtonCollectionViewDelegate;

NS_CLASS_AVAILABLE_IOS(7_0) @interface RCButtonCollectionView : UIView

@property (weak, nonatomic) id<RCButtonCollectionViewDelegate> delegate;
@property (copy, nonatomic) NSArray *buttons;
@property (readonly, nonatomic) NSArray *selectedButtons;
@property (nonatomic) BOOL allowSelection;
@property (nonatomic) BOOL allowMultiSelection;
@property (nonatomic) CGFloat preferredLayoutWidth;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat interitemSpacing;
@property (nonatomic) UIEdgeInsets edgeInsets;

- (void)selectButtonAtIndex:(NSUInteger)index;
- (void)selectAllButtons;
- (void)deselectButtonAtIndex:(NSUInteger)index;
- (void)deselectAllButtons;

@end

@protocol RCButtonCollectionViewDelegate <NSObject>

@optional
- (void)buttonCollectionView:(RCButtonCollectionView *)buttonCollectionView didSelectedButtonAtIndex:(NSUInteger)index;
- (void)buttonCollectionView:(RCButtonCollectionView *)buttonCollectionView didDeselectedButtonAtIndex:(NSUInteger)index;

@end
