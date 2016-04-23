//
//  RCPhotoView.h
//  RCKit
//
//  Created by Yeuham Wang on 16/4/22.
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

NS_CLASS_AVAILABLE_IOS(7_0) @interface RCPhotoView : UIView <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
}

@property (strong, nonatomic) UIImage *image;
@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) BOOL showsHorizontalScrollIndicator;
@property (nonatomic) BOOL showsVerticalScrollIndicator;
@property (nonatomic) UIEdgeInsets scrollIndicatorInsets;
@property (nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
@property (nonatomic) CGFloat minimumZoomScale;
@property (nonatomic) CGFloat maximumZoomScale;
@property (nonatomic) CGFloat zoomScale;
@property (nonatomic) BOOL bouncesZoom;
@property (readonly, nonatomic, getter=isZooming) BOOL zooming;
@property (readonly, nonatomic, getter=isZoomBouncing) BOOL zoomBouncing;

- (void)setZoomScale:(CGFloat)scale animated:(BOOL)animated;
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

@end
