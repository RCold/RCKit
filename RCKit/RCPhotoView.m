//
//  RCPhotoView.m
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

#import "RCPhotoView.h"

@implementation RCPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCPhotoView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self != nil)
        [self _initRCPhotoView];
    return self;
}

- (void)_initRCPhotoView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.delegate = self;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [_scrollView addSubview:_imageView];
    self.contentSize = CGSizeZero;
    [self addSubview:_scrollView];
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    if (CGSizeEqualToSize(self.contentSize, CGSizeZero))
        self.contentSize = image.size;
    [self setNeedsLayout];
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setContentSize:(CGSize)contentSize {
    _contentSize = contentSize;
    [self setNeedsLayout];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    _scrollView.contentOffset = contentOffset;
}

- (CGPoint)contentOffset {
    return _scrollView.contentOffset;
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale {
    _scrollView.maximumZoomScale = maximumZoomScale;
}

- (CGFloat)maximumZoomScale {
    return _scrollView.maximumZoomScale;
}

- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale {
    _scrollView.minimumZoomScale = minimumZoomScale;
}

- (CGFloat)minimumZoomScale {
    return _scrollView.minimumZoomScale;
}

- (void)setZoomScale:(CGFloat)zoomScale {
    _scrollView.zoomScale = zoomScale;
}

- (CGFloat)zoomScale {
    return _scrollView.zoomScale;
}

- (void)setBouncesZoom:(BOOL)bouncesZoom {
    _scrollView.bouncesZoom = bouncesZoom;
}

- (BOOL)bouncesZoom {
    return _scrollView.bouncesZoom;
}

- (BOOL)isZooming {
    return _scrollView.zooming;
}

- (BOOL)isZoomBouncing {
    return _scrollView.zoomBouncing;
}

- (void)setZoomScale:(CGFloat)scale animated:(BOOL)animated {
    [_scrollView setZoomScale:scale animated:animated];
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
    [_scrollView zoomToRect:rect animated:animated];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    _imageView.contentMode = contentMode;
}

- (UIViewContentMode)contentMode {
    return _imageView.contentMode;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    _scrollView.frame = bounds;
    CGSize size = bounds.size;
    CGFloat zoomScale = _scrollView.zoomScale;
    CGSize imageViewSize;
    imageViewSize.width = self.contentSize.width * zoomScale;
    imageViewSize.height = self.contentSize.height * zoomScale;
    CGSize contentSize;
    contentSize.width = MAX(size.width, imageViewSize.width);
    contentSize.height = MAX(size.height, imageViewSize.height);
    _scrollView.contentSize = contentSize;
    CGRect imageViewFrame;
    imageViewFrame.origin.x = (contentSize.width - imageViewSize.width) / 2.0;
    imageViewFrame.origin.y = (contentSize.height - imageViewSize.height) / 2.0;
    imageViewFrame.size = imageViewSize;
    _imageView.frame = imageViewFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize size = self.bounds.size;
    CGSize imageViewSize = _imageView.frame.size;
    CGSize contentSize;
    contentSize.width = MAX(size.width, imageViewSize.width);
    contentSize.height = MAX(size.height, imageViewSize.height);
    _scrollView.contentSize = contentSize;
    _imageView.center = CGPointMake(contentSize.width / 2.0, contentSize.height / 2.0);
}

@end
