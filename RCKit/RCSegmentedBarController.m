//
//  RCSegmentedBarController.m
//  RCKit
//
//  Created by Yeuham Wang on 16/4/25.
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

#import "RCSegmentedBarController.h"

@implementation RCSegmentedBarController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil)
        [self _initRCSegmentedBarController];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCSegmentedBarController];
    return self;
}

- (void)_initRCSegmentedBarController {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _segmentedBar = [[RCSegmentedBar alloc] initWithFrame:CGRectZero];
    _segmentedBar.delegate = self;
}

- (void)loadView {
    [super loadView];
    _segmentedBar.translatesAutoresizingMaskIntoConstraints = NO;
    [_segmentedBar addConstraint:[NSLayoutConstraint constraintWithItem:_segmentedBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40.0]];
    UINavigationBar *topBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    topBar.translucent = NO;
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    [topBar addSubview:_segmentedBar];
    [topBar addConstraints:@[[NSLayoutConstraint constraintWithItem:_segmentedBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_segmentedBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_segmentedBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]];
    UIView *view = self.view;
    [view addSubview:topBar];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:_scrollView];
    [view addConstraints:@[[NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:topBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:40.0], [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]];
    [view bringSubviewToFront:topBar];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = [viewControllers copy];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:viewControllers.count];
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *viewController = viewControllers[i];
        UIView *view = viewController.view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView addSubview:view];
        [_scrollView addConstraints:@[[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0],[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0], [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]]];
        if (i == 0)
            [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
        else
            [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[viewControllers[i - 1] view] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        [items addObject:viewController.title];
    }
    UIView *lastView = [viewControllers.lastObject view];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [_scrollView setNeedsLayout];
    _segmentedBar.items = items;
}

- (void)segmentedBar:(RCSegmentedBar *)segmentedBar buttonAtIndexDidTouch:(NSInteger)segmentIndex {
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * segmentIndex, 0.0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _segmentedBar.indicatorBarOffset = scrollView.contentOffset.x / scrollView.bounds.size.width;
}

@end
