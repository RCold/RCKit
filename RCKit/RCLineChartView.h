//
//  RCLineChartView.h
//  RCKit
//
//  Created by Yeuham Wang on 16/1/14.
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

@protocol RCLineChartViewDataSource;

NS_CLASS_AVAILABLE_IOS(7_0) @interface RCLineChartView : UIView {
    NSMutableArray *_indexLabels;
    NSMutableArray *_valueLabels;
    NSMutableArray *_dataLabels;
    CGFloat _chartMarginTop;
    CGFloat _chartMarginButtom;
    CGFloat _chartMarginLeading;
    CGFloat _chartMarginTrailing;
    CGFloat _maxValue;
    CGFloat _minValue;
}

// Data source
@property (weak, nonatomic) id<RCLineChartViewDataSource> dataSource;

// X Index label parameters
@property (nonatomic) BOOL displayIndexLabel;
@property (strong, nonatomic) UIFont *indexLabelFont;
@property (strong, nonatomic) UIColor *indexLabelTextColor;
@property (strong, nonatomic) UIColor *indexLabelBackgroundColor;

// Y Value label parameters
@property (nonatomic) BOOL displayValueLabel;
@property (nonatomic) CGFloat minValueScaleStep;
@property (strong, nonatomic) UIFont *valueLabelFont;
@property (strong, nonatomic) UIColor *valueLabelTextColor;
@property (strong, nonatomic) UIColor *valueLabelBackgroundColor;

// Margin of the chart
@property (nonatomic) CGFloat margin;

// Axis parameters
@property (nonatomic) BOOL displayAxis;
@property (nonatomic) BOOL displayAxisScale;
@property (nonatomic) CGFloat axisLineWidth;
@property (strong, nonatomic) UIColor *axisColor;

// Grid parameters
@property (nonatomic) BOOL displayInnerGrid;
@property (nonatomic) CGFloat innerGridLineWidth;
@property (strong, nonatomic) UIColor *innerGridColor;

// Chart parameters
@property (nonatomic) BOOL displayFillColor;
@property (nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *fillColor;

// Data point parameters
@property (nonatomic) BOOL displayDataPoint;
@property (nonatomic) CGFloat dataPointRadius;
@property (nonatomic) CGFloat dataPointBorderWidth;
@property (strong, nonatomic) UIColor *dataPointColor;
@property (strong, nonatomic) UIColor *dataPointBorderColor;

// Data label parameters
@property (nonatomic) BOOL displayDataLabel;
@property (strong, nonatomic) UIFont *dataLabelFont;
@property (strong, nonatomic) UIColor *dataLabelTextColor;
@property (strong, nonatomic) UIColor *dataLabelBackgroundColor;

// Smoothing parameters
@property (nonatomic) BOOL bezierSmoothing;
@property (nonatomic) CGFloat bezierSmoothingTension;

// Number of labels of the chart
@property (nonatomic, readonly) NSUInteger numberOfIndexLabels;
@property (nonatomic, readonly) NSUInteger numberOfValueLabels;
@property (nonatomic, readonly) NSUInteger numberOfDataLabels;

// Labels of the chart
- (UILabel *)indexLabelAtIndex:(NSUInteger)index;
- (UILabel *)valueLabelAtIndex:(NSUInteger)index;
- (UILabel *)dataLabelAtIndex:(NSUInteger)index;

- (void)reloadData;

@end

@protocol RCLineChartViewDataSource <NSObject>

@required

// Chart data source
- (NSUInteger)numberOfDataPointsInLineChartView:(RCLineChartView *)lineChartView;
- (CGFloat)lineChartView:(RCLineChartView *)lineChartView valueAtIndex:(NSUInteger)index;

// Chart gird data source
- (NSUInteger)numberOfIndexScalesInLineChartView:(RCLineChartView *)lineChartView;
- (NSUInteger)numberOfValueScalesInLineChartView:(RCLineChartView *)lineChartView;

@optional

// Index label data source
- (NSString *)lineChartView:(RCLineChartView *)lineChartView titleForIndexLabelAtIndex:(NSUInteger)index;
- (UILabel *)lineChartView:(RCLineChartView *)lineChartView labelForIndexLabelAtIndex:(NSUInteger)index;

// Value label data source
- (CGFloat)maxValueInLineChartView:(RCLineChartView *)lineChartView;
- (CGFloat)minValueInLineChartView:(RCLineChartView *)lineChartView;
- (NSString *)lineChartView:(RCLineChartView *)lineChartView titleForValueLabelAtValue:(CGFloat)value;
- (NSString *)lineChartView:(RCLineChartView *)lineChartView titleForValueLabelAtIndex:(NSUInteger)index;
- (UILabel *)lineChartView:(RCLineChartView *)lineChartView labelForValueLabelAtValue:(CGFloat)value;
- (UILabel *)lineChartView:(RCLineChartView *)lineChartView labelForValueLabelAtIndex:(NSUInteger)index;

// Data label data source
- (NSString *)lineChartView:(RCLineChartView *)lineChartView titleForDataLabelAtValue:(CGFloat)value;
- (NSString *)lineChartView:(RCLineChartView *)lineChartView titleForDataLabelAtIndex:(NSUInteger)index;
- (UILabel *)lineChartView:(RCLineChartView *)lineChartView labelForDataLabelAtValue:(CGFloat)value;
- (UILabel *)lineChartView:(RCLineChartView *)lineChartView labelForDataLabelAtIndex:(NSUInteger)index;

@end
