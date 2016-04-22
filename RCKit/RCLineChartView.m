//
//  RCLineChartView.m
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

#import "RCLineChartView.h"

@implementation RCLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil)
        [self _initRCLineChartView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil)
        [self _initRCLineChartView];
    return self;
}

- (void)_initRCLineChartView {
    _dataSource = nil;
    _displayIndexLabel = YES;
    _indexLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    _indexLabelTextColor = [UIColor grayColor];
    _indexLabelBackgroundColor = [UIColor clearColor];
    _displayValueLabel = YES;
    _minValueScaleStep = 1.0;
    _valueLabelFont = _indexLabelFont;
    _valueLabelTextColor = _indexLabelTextColor;
    _valueLabelBackgroundColor = _indexLabelBackgroundColor;
    _margin = 4.0;
    _displayAxis = YES;
    _displayAxisScale = YES;
    _axisLineWidth = 1.0;
    _axisColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _displayInnerGrid = NO;
    _innerGridLineWidth = 1.0 / [UIScreen mainScreen].scale;
    _innerGridColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _displayFillColor = NO;
    _lineWidth = 2.0;
    _color = [UIColor redColor];
    _fillColor = [_color colorWithAlphaComponent:0.2];
    _displayDataPoint = NO;
    _dataPointRadius = 2.0;
    _dataPointBorderWidth = 1.0;
    _dataPointColor = [UIColor whiteColor];
    _dataPointBorderColor = _color;
    _displayDataLabel = NO;
    _dataLabelFont = _indexLabelFont;
    _dataLabelTextColor = _indexLabelTextColor;
    _dataLabelBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    _bezierSmoothing = YES;
    _bezierSmoothingTension = 0.25;
    [self reloadData];
}

- (CGFloat)_valueForValueLabelAtIndex:(NSUInteger)index {
    NSUInteger numberOfValueScales = [_dataSource numberOfValueScalesInLineChartView:self];
    if (numberOfValueScales < 1)
        numberOfValueScales = 1;
    return _minValue + (_maxValue - _minValue) / numberOfValueScales * (index + 1);
}

- (CGPoint)_pointForValue:(CGFloat)value atIndex:(NSUInteger)index {
    CGSize size = self.bounds.size;
    CGFloat chartWidth = size.width - _chartMarginLeading - _chartMarginTrailing;
    CGFloat chartHeight = size.height - _chartMarginTop - _chartMarginButtom;
    CGPoint point = CGPointMake(_chartMarginLeading, size.height - _chartMarginButtom);
    NSUInteger numberOfIndexScales = [_dataSource numberOfIndexScalesInLineChartView:self];
    if (numberOfIndexScales < 2)
        numberOfIndexScales = 2;
    point.x += chartWidth / (numberOfIndexScales - 1) * index;
    point.y -= chartHeight / (_maxValue - _minValue) * (value - _minValue);
    return point;
}

- (CGPoint)_pointForValue:(CGFloat)value atDataPointIndex:(NSUInteger)index {
    CGSize size = self.bounds.size;
    CGFloat chartWidth = size.width - _chartMarginLeading - _chartMarginTrailing;
    CGFloat chartHeight = size.height - _chartMarginTop - _chartMarginButtom;
    CGPoint point = CGPointMake(_chartMarginLeading, size.height - _chartMarginButtom);
    NSUInteger numberOfDataPoints = 2;
    if ([_dataSource respondsToSelector:@selector(numberOfDataPointsInLineChartView:)])
        numberOfDataPoints = [_dataSource numberOfDataPointsInLineChartView:self];
    if (numberOfDataPoints < 2)
        numberOfDataPoints = 2;
    point.x += chartWidth / (numberOfDataPoints - 1) * index;
    point.y -= chartHeight / (_maxValue - _minValue) * (value - _minValue);
    return point;
}

- (CGFloat)_roundValueForValue:(CGFloat)value {
    return value;
}

- (UIBezierPath *)_linePathWithSmoothing:(BOOL)smoothed closing:(BOOL)closed {
    NSUInteger numberOfDataPoints = [_dataSource numberOfDataPointsInLineChartView:self];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (numberOfDataPoints < 2)
        return bezierPath;
    CGFloat value = [_dataSource lineChartView:self valueAtIndex:0];
    CGPoint point = [self _pointForValue:value atDataPointIndex:0];
    [bezierPath moveToPoint:point];
    if(!smoothed)
        for (int i = 1; i < numberOfDataPoints; i++)
            [bezierPath addLineToPoint:[self _pointForValue:[_dataSource lineChartView:self valueAtIndex:i] atDataPointIndex:i]];
    else {
        if (numberOfDataPoints == 2)
            [bezierPath addLineToPoint:[self _pointForValue:[_dataSource lineChartView:self valueAtIndex:1] atDataPointIndex:1]];
        if (numberOfDataPoints > 2) {
            CGPoint controlPoint;
            CGFloat previousValue = [_dataSource lineChartView:self valueAtIndex:0];
            CGFloat value = [_dataSource lineChartView:self valueAtIndex:1];
            CGFloat nextValue = [_dataSource lineChartView:self valueAtIndex:2];
            CGPoint previousPoint = [self _pointForValue:previousValue atDataPointIndex:0];
            CGPoint point = [self _pointForValue:value atDataPointIndex:1];
            CGPoint nextPoint = [self _pointForValue:nextValue atDataPointIndex:2];
            CGVector gradient = CGVectorMake(nextPoint.x - previousPoint.x, nextPoint.y - previousPoint.y);
            controlPoint.x = point.x - gradient.dx / 2.0 * _bezierSmoothingTension;
            controlPoint.y = point.y - gradient.dy / 2.0 * _bezierSmoothingTension;
            [bezierPath addQuadCurveToPoint:point controlPoint:controlPoint];
        }
        for (int i = 2; i < numberOfDataPoints - 1; i++) {
            CGPoint controlPoint[2];
            CGFloat previusValue = [_dataSource lineChartView:self valueAtIndex:i - 2];
            CGFloat value = [_dataSource lineChartView:self valueAtIndex:i - 1];
            CGFloat nextValue = [_dataSource lineChartView:self valueAtIndex:i];
            CGPoint previousPoint = [self _pointForValue:previusValue atDataPointIndex:i - 2];
            CGPoint point = [self _pointForValue:value atDataPointIndex:i - 1];
            CGPoint nextPoint = [self _pointForValue:nextValue atDataPointIndex:i];
            CGVector gradient = CGVectorMake(nextPoint.x - previousPoint.x, nextPoint.y - previousPoint.y);
            controlPoint[0].x = point.x + gradient.dx / 2.0 * _bezierSmoothingTension;
            controlPoint[0].y = point.y + gradient.dy / 2.0 * _bezierSmoothingTension;
            previusValue = value;
            value = nextValue;
            nextValue = [_dataSource lineChartView:self valueAtIndex:i + 1];
            previousPoint = point;
            point = nextPoint;
            nextPoint = [self _pointForValue:nextValue atDataPointIndex:i + 1];
            gradient = CGVectorMake(nextPoint.x - previousPoint.x, nextPoint.y - previousPoint.y);
            controlPoint[1].x = point.x - gradient.dx / 2.0 * _bezierSmoothingTension;
            controlPoint[1].y = point.y - gradient.dy / 2.0 * _bezierSmoothingTension;
            [bezierPath addCurveToPoint:point controlPoint1:controlPoint[0] controlPoint2:controlPoint[1]];
        }
        if (numberOfDataPoints > 2) {
            CGPoint controlPoint;
            CGFloat previusValue = [_dataSource lineChartView:self valueAtIndex:numberOfDataPoints - 3];
            CGFloat value = [_dataSource lineChartView:self valueAtIndex:numberOfDataPoints - 2];
            CGFloat nextValue = [_dataSource lineChartView:self valueAtIndex:numberOfDataPoints - 1];
            CGPoint previousPoint = [self _pointForValue:previusValue atDataPointIndex:numberOfDataPoints - 3];
            CGPoint point = [self _pointForValue:value atDataPointIndex:numberOfDataPoints - 2];
            CGPoint nextPoint = [self _pointForValue:nextValue atDataPointIndex:numberOfDataPoints - 1];
            CGVector gradient = CGVectorMake(nextPoint.x - previousPoint.x, nextPoint.y - previousPoint.y);
            controlPoint.x = point.x + gradient.dx / 2.0 * _bezierSmoothingTension;
            controlPoint.y = point.y + gradient.dy / 2.0 * _bezierSmoothingTension;
            [bezierPath addQuadCurveToPoint:nextPoint controlPoint:controlPoint];
        }
    }
    if(closed) {
        [bezierPath addLineToPoint:[self _pointForValue:_minValue atDataPointIndex:numberOfDataPoints - 1]];
        [bezierPath addLineToPoint:[self _pointForValue:_minValue atIndex:0]];
        [bezierPath closePath];
    }
    return bezierPath;
}

- (void)_updateMinMaxValue {
    NSUInteger numberOfDataPoints = [_dataSource numberOfDataPointsInLineChartView:self];
    NSUInteger numberOfValueScales = [_dataSource numberOfValueScalesInLineChartView:self];
    if (numberOfValueScales < 1)
        numberOfValueScales = 1;
    _maxValue = 0.0;
    _minValue = 0.0;
    if (numberOfDataPoints > 0) {
        _maxValue = -CGFLOAT_MAX;
        _minValue = CGFLOAT_MAX;
        for (int i = 0; i < numberOfDataPoints; i++) {
            CGFloat value = [_dataSource lineChartView:self valueAtIndex:i];
            if (_maxValue < value)
                _maxValue = value;
            if (_minValue > value)
                _minValue = value;
        }
    }
    if ([_dataSource respondsToSelector:@selector(maxValueInLineChartView:)])
        _maxValue = [_dataSource maxValueInLineChartView:self];
    if ([_dataSource respondsToSelector:@selector(minValueInLineChartView:)])
        _minValue = [_dataSource minValueInLineChartView:self];
    if (_maxValue < _minValue + numberOfValueScales * _minValueScaleStep)
        _maxValue = _minValue + numberOfValueScales * _minValueScaleStep;
    _maxValue = [self _roundValueForValue:_maxValue];
    _minValue = [self _roundValueForValue:_minValue];
    [self setNeedsLayout];
}

- (void)_updateSubviews {
    [self _updateIndexLabels];
    [self _updateValueLabels];
    [self _updateDataLabels];
}

- (void)_updateIndexLabels {
    [_indexLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _indexLabels = nil;
    NSUInteger numberOfIndexLabels = 0;
    if (_displayIndexLabel) {
        numberOfIndexLabels = [_dataSource numberOfIndexScalesInLineChartView:self];
        _indexLabels = [NSMutableArray arrayWithCapacity:numberOfIndexLabels];
    }
    for (int i = 0; i < numberOfIndexLabels; i++) {
        UILabel *label;
        if ([_dataSource respondsToSelector:@selector(lineChartView:labelForIndexLabelAtIndex:)])
            label = [_dataSource lineChartView:self labelForIndexLabelAtIndex:i];
        else {
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            if ([_dataSource respondsToSelector:@selector(lineChartView:titleForIndexLabelAtIndex:)])
                label.text = [_dataSource lineChartView:self titleForIndexLabelAtIndex:i];
            else
                label.text = [NSString stringWithFormat:@"%d", i];
            label.font = _indexLabelFont;
            label.textColor = _indexLabelTextColor;
            label.backgroundColor = _indexLabelBackgroundColor;
        }
        label.tag = i;
        [_indexLabels addObject:label];
        [self addSubview:label];
    }
    [self setNeedsLayout];
}

- (void)_updateValueLabels {
    [_valueLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _valueLabels = nil;
    NSUInteger numberOfValueLabels = 0;
    if (_displayValueLabel) {
        numberOfValueLabels = [_dataSource numberOfValueScalesInLineChartView:self];
        _valueLabels = [NSMutableArray arrayWithCapacity:numberOfValueLabels];
    }
    for (int i = 0; i < numberOfValueLabels; i++) {
        UILabel *label;
        if ([_dataSource respondsToSelector:@selector(lineChartView:labelForValueLabelAtIndex:)])
            label = [_dataSource lineChartView:self labelForValueLabelAtIndex:i];
        else if ([_dataSource respondsToSelector:@selector(lineChartView:labelForValueLabelAtValue:)])
            label = [_dataSource lineChartView:self labelForValueLabelAtValue:[self _valueForValueLabelAtIndex:i]];
        else {
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            if ([_dataSource respondsToSelector:@selector(lineChartView:titleForValueLabelAtIndex:)])
                label.text = [_dataSource lineChartView:self titleForValueLabelAtIndex:i];
            else if ([_dataSource respondsToSelector:@selector(lineChartView:titleForValueLabelAtValue:)])
                label.text = [_dataSource lineChartView:self titleForValueLabelAtValue:[self _valueForValueLabelAtIndex:i]];
            else
                label.text = [NSString stringWithFormat:@"%.0f", [self _valueForValueLabelAtIndex:i]];
            label.font = _valueLabelFont;
            label.textColor = _valueLabelTextColor;
            label.backgroundColor = _valueLabelBackgroundColor;
        }
        label.tag = i;
        [_valueLabels addObject:label];
        [self addSubview:label];
    }
    [self setNeedsLayout];
}

- (void)_updateDataLabels {
    [_dataLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _dataLabels = nil;
    NSUInteger numberOfDataLabels = 0;
    if (_displayDataLabel) {
        numberOfDataLabels = [_dataSource numberOfDataPointsInLineChartView:self];
        _dataLabels = [NSMutableArray arrayWithCapacity:numberOfDataLabels];
    }
    for (int i = 0; i < numberOfDataLabels; i++) {
        UILabel *label;
        if ([_dataSource respondsToSelector:@selector(lineChartView:labelForDataLabelAtIndex:)])
            label = [_dataSource lineChartView:self labelForDataLabelAtIndex:i];
        else if ([_dataSource respondsToSelector:@selector(lineChartView:labelForDataLabelAtValue:)])
            label = [_dataSource lineChartView:self labelForDataLabelAtValue:[_dataSource lineChartView:self valueAtIndex:i]];
        else {
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            if ([_dataSource respondsToSelector:@selector(lineChartView:titleForDataLabelAtIndex:)])
                label.text = [_dataSource lineChartView:self titleForDataLabelAtIndex:i];
            else if ([_dataSource respondsToSelector:@selector(lineChartView:titleForDataLabelAtValue:)])
                label.text = [_dataSource lineChartView:self titleForDataLabelAtValue:[_dataSource lineChartView:self valueAtIndex:i]];
            else if ([_dataSource respondsToSelector:@selector(lineChartView:titleForValueLabelAtValue:)])
                label.text = [_dataSource lineChartView:self titleForValueLabelAtValue:[_dataSource lineChartView:self valueAtIndex:i]];
            else
                label.text = [NSString stringWithFormat:@"%.0f", [self _valueForValueLabelAtIndex:i]];
            label.font = _dataLabelFont;
            label.textColor = _dataLabelTextColor;
            label.backgroundColor = _dataLabelBackgroundColor;
        }
        label.tag = i;
        [_dataLabels addObject:label];
        [self addSubview:label];
    }
    [self setNeedsLayout];
}

- (void)setDataSource:(id<RCLineChartViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)setDisplayIndexLabel:(BOOL)displayIndexLabel {
    _displayIndexLabel = displayIndexLabel;
    [self _updateIndexLabels];
}

- (void)setIndexLabelFont:(UIFont *)indexLabelFont {
    if (indexLabelFont == nil)
        return;
    _indexLabelFont = indexLabelFont;
    [self _updateIndexLabels];
}

- (void)setIndexLabelTextColor:(UIColor *)indexLabelTextColor {
    if (indexLabelTextColor == nil)
        return;
    _indexLabelTextColor = indexLabelTextColor;
    [self _updateIndexLabels];
}

- (void)setIndexLabelBackgroundColor:(UIColor *)indexLabelBackgroundColor {
    if (indexLabelBackgroundColor == nil)
        return;
    _indexLabelBackgroundColor = indexLabelBackgroundColor;
    [self _updateIndexLabels];
}

- (void)setDisplayValueLabel:(BOOL)displayValueLabel {
    _displayValueLabel = displayValueLabel;
    [self _updateValueLabels];
}

- (void)setMinValueScaleStep:(CGFloat)minValueScaleStep {
    if (minValueScaleStep <= 0.0)
        return;
    _minValueScaleStep = minValueScaleStep;
    [self _updateMinMaxValue];
}

- (void)setValueLabelFont:(UIFont *)valueLabelFont {
    if (valueLabelFont == nil)
        return;
    _valueLabelFont = valueLabelFont;
    [self _updateValueLabels];
}

- (void)setValueLabelTextColor:(UIColor *)valueLabelTextColor {
    if (valueLabelTextColor == nil)
        return;
    _valueLabelTextColor = valueLabelTextColor;
    [self _updateValueLabels];
}

- (void)setValueLabelBackgroundColor:(UIColor *)valueLabelBackgroundColor {
    if (valueLabelBackgroundColor == nil)
        return;
    _valueLabelBackgroundColor = valueLabelBackgroundColor;
    [self _updateValueLabels];
}

- (void)setMargin:(CGFloat)margin {
    if (margin < 0.0)
        return;
    _margin = margin;
    [self setNeedsLayout];
}

- (void)setDisplayAxis:(BOOL)displayAxis {
    _displayAxis = displayAxis;
    [self setNeedsDisplay];
}

- (void)setDisplayAxisScale:(BOOL)displayAxisScale {
    _displayAxisScale = displayAxisScale;
    [self setNeedsDisplay];
}

- (void)setAxisLineWidth:(CGFloat)axisLineWidth {
    if (axisLineWidth < 0.0)
        return;
    _axisLineWidth = axisLineWidth;
    [self setNeedsDisplay];
}

- (void)setAxisColor:(UIColor *)axisColor {
    if (axisColor == nil)
        return;
    _axisColor = axisColor;
    [self setNeedsDisplay];
}

- (void)setDisplayInnerGrid:(BOOL)displayInnerGrid {
    _displayInnerGrid = displayInnerGrid;
    [self setNeedsDisplay];
}

- (void)setInnerGridLineWidth:(CGFloat)innerGridLineWidth {
    if (innerGridLineWidth < 0.0)
        return;
    _innerGridLineWidth = innerGridLineWidth;
    [self setNeedsDisplay];
}

- (void)setInnerGridColor:(UIColor *)innerGridColor {
    if (innerGridColor == nil)
        return;
    _innerGridColor = innerGridColor;
    [self setNeedsDisplay];
}

- (void)setDisplayFillColor:(BOOL)displayFillColor {
    _displayFillColor = displayFillColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (lineWidth <= 0.0)
        return;
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color {
    if (color == nil)
        return;
    _color = color;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    if (fillColor == nil)
        return;
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setDisplayDataPoint:(BOOL)displayDataPoint {
    _displayDataPoint = displayDataPoint;
    [self setNeedsDisplay];
}

- (void)setDataPointRadius:(CGFloat)dataPointRadius {
    if (dataPointRadius < 0.0)
        return;
    _dataPointRadius = dataPointRadius;
    [self setNeedsDisplay];
}

- (void)setDataPointBorderWidth:(CGFloat)dataPointBorderWidth {
    if (dataPointBorderWidth < 0.0)
        return;
    _dataPointBorderWidth = dataPointBorderWidth;
    [self setNeedsDisplay];
}

- (void)setDataPointColor:(UIColor *)dataPointColor {
    if (dataPointColor == nil)
        return;
    _dataPointColor = dataPointColor;
    [self setNeedsDisplay];
}

- (void)setDataPointBorderColor:(UIColor *)dataPointBorderColor {
    if (dataPointBorderColor == nil)
        return;
    _dataPointBorderColor = dataPointBorderColor;
    [self setNeedsDisplay];
}

- (void)setDisplayDataLabel:(BOOL)displayDataLabel {
    _displayDataLabel = displayDataLabel;
    [self _updateDataLabels];
}

- (void)setDataLabelFont:(UIFont *)dataLabelFont {
    if (dataLabelFont == nil)
        return;
    _dataLabelFont = dataLabelFont;
    [self _updateDataLabels];
}

- (void)setDataLabelTextColor:(UIColor *)dataLabelTextColor {
    if (dataLabelTextColor == nil)
        return;
    _dataLabelTextColor = dataLabelTextColor;
    [self _updateDataLabels];
}

- (void)setDataLabelBackgroundColor:(UIColor *)dataLabelBackgroundColor {
    if (dataLabelBackgroundColor == nil)
        return;
    _dataLabelBackgroundColor = dataLabelBackgroundColor;
    [self _updateDataLabels];
}

- (void)setBezierSmoothing:(BOOL)bezierSmoothing {
    _bezierSmoothing = bezierSmoothing;
    [self setNeedsDisplay];
}

- (void)setBezierSmoothingTension:(CGFloat)bezierSmoothingTension {
    if (bezierSmoothingTension < 0.0 || bezierSmoothingTension > 1.0)
        return;
    _bezierSmoothingTension = bezierSmoothingTension;
    [self setNeedsDisplay];
}

- (NSUInteger)numberOfIndexLabels {
    return _indexLabels.count;
}

- (NSUInteger)numberOfValueLabels {
    return _valueLabels.count;
}

- (NSUInteger)numberOfDataLabels {
    return _dataLabels.count;
}

- (UILabel *)indexLabelAtIndex:(NSUInteger)index {
    return _indexLabels[index];
}

- (UILabel *)valueLabelAtIndex:(NSUInteger)index {
    return _valueLabels[index];
}

- (UILabel *)dataLabelAtIndex:(NSUInteger)index {
    return _dataLabels[index];
}

- (void)reloadData {
    [self _updateMinMaxValue];
    [self _updateSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_indexLabels makeObjectsPerformSelector:@selector(sizeToFit)];
    [_valueLabels makeObjectsPerformSelector:@selector(sizeToFit)];
    [_dataLabels makeObjectsPerformSelector:@selector(sizeToFit)];
    NSUInteger numberOfDataPoints = [_dataSource numberOfDataPointsInLineChartView:self];
    CGFloat maxIndexLabelHeight = 0.0;
    CGFloat maxValueLabelWidth = 0.0;
    CGFloat firstIndexLabelWidth = ((UILabel *)_indexLabels.firstObject).frame.size.width;
    CGFloat lastIndexLabelWidth = ((UILabel *)_indexLabels.lastObject).frame.size.width;
    CGFloat lastValueLabelHeight = ((UILabel *)_valueLabels.lastObject).frame.size.height;
    CGFloat lastDataLabelWidth = ((UILabel *)_dataLabels.lastObject).frame.size.width;
    for (UILabel *label in _indexLabels)
        if (maxIndexLabelHeight < label.frame.size.height)
            maxIndexLabelHeight = label.frame.size.height;
    for (UILabel *label in _valueLabels)
        if (maxValueLabelWidth < label.frame.size.width)
            maxValueLabelWidth = label.frame.size.width;
    if (maxIndexLabelHeight > 0.0)
        maxIndexLabelHeight += 4.0;
    if (maxValueLabelWidth > 0.0)
        maxValueLabelWidth += 4.0;
    if (lastDataLabelWidth > 0.0)
        lastDataLabelWidth += 4.0;
    _chartMarginTop = _margin + lastValueLabelHeight / 2.0;
    _chartMarginButtom = _margin + maxIndexLabelHeight;
    _chartMarginLeading = _margin + MAX(maxValueLabelWidth, firstIndexLabelWidth / 2.0);
    _chartMarginTrailing = _margin + MAX(lastDataLabelWidth, lastIndexLabelWidth / 2.0);
    for (UILabel *label in _indexLabels) {
        NSInteger i = label.tag;
        CGPoint center = [self _pointForValue:_minValue atIndex:i];
        center.y += label.frame.size.height / 2.0 + 4.0;
        label.center = center;
    }
    for (UILabel *label in _valueLabels) {
        NSInteger i = label.tag;
        CGPoint center = [self _pointForValue:[self _valueForValueLabelAtIndex:i] atIndex:0];
        center.x -= label.frame.size.width / 2.0 + 4.0;
        label.center = center;
    }
    for (UILabel *label in _dataLabels) {
        NSInteger i = label.tag;
        CGFloat value = [_dataSource lineChartView:self valueAtIndex:i];
        CGFloat previousValue = value;
        CGFloat nextValue = value;
        if (i > 0)
            previousValue = [_dataSource lineChartView:self valueAtIndex:i - 1];
        if (i + 1 < numberOfDataPoints)
            nextValue = [_dataSource lineChartView:self valueAtIndex:i + 1];
        CGPoint center = [self _pointForValue:[_dataSource lineChartView:self valueAtIndex:i] atDataPointIndex:i];
        center.x += label.frame.size.width / 2.0 + 4.0;
        if (nextValue > value || (nextValue == value && previousValue < value))
            center.y += label.frame.size.height / 2.0 + 4.0;
        else
            center.y -= label.frame.size.height / 2.0 + 4.0;
        label.center = center;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat value;
    CGPoint point;
    UIBezierPath *bezierPath;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    NSUInteger numberOfDataPoints = [_dataSource numberOfDataPointsInLineChartView:self];
    NSUInteger numberOfIndexScales = [_dataSource numberOfIndexScalesInLineChartView:self];
    NSUInteger numberOfValueScales = [_dataSource numberOfValueScalesInLineChartView:self];
    if (numberOfIndexScales < 2)
        numberOfIndexScales = 2;
    if (numberOfValueScales < 1)
        numberOfValueScales = 1;
    CGSize size = self.bounds.size;
    CGFloat chartWidth = size.width - _chartMarginLeading - _chartMarginTrailing;
    CGFloat chartHeight = size.height - _chartMarginTop - _chartMarginButtom;
    if (_displayAxis) {
        if (_displayFillColor) {
            bezierPath = [self _linePathWithSmoothing:_bezierSmoothing closing:YES];
            [_fillColor setFill];
            [bezierPath fill];
        }
        if (_displayInnerGrid) {
            bezierPath = [UIBezierPath bezierPath];
            bezierPath.lineWidth = _innerGridLineWidth;
            [_innerGridColor setStroke];
            for (int i = 1; i < numberOfIndexScales; i++) {
                point = [self _pointForValue:_minValue atIndex:i];
                [bezierPath moveToPoint:point];
                point.y -= chartHeight;
                [bezierPath addLineToPoint:point];
                [bezierPath stroke];
            }
            for (int i = 0; i < numberOfValueScales; i++) {
                point = [self _pointForValue:[self _valueForValueLabelAtIndex:i] atIndex:0];
                [bezierPath moveToPoint:point];
                point.x += chartWidth;
                [bezierPath addLineToPoint:point];
                [bezierPath stroke];
            }
        }
        if (_displayAxisScale) {
            bezierPath = [UIBezierPath bezierPath];
            bezierPath.lineWidth = _axisLineWidth;
            [_axisColor setStroke];
            for (int i = 1; i < numberOfIndexScales; i++) {
                point = [self _pointForValue:_minValue atIndex:i];
                [bezierPath moveToPoint:point];
                point.y -= 3.0;
                [bezierPath addLineToPoint:point];
                [bezierPath stroke];
            }
            for (int i = 0; i < numberOfValueScales; i++) {
                point = [self _pointForValue:[self _valueForValueLabelAtIndex:i] atIndex:0];
                [bezierPath moveToPoint:point];
                point.x += 3.0;
                [bezierPath addLineToPoint:point];
                [bezierPath stroke];
            }
        }
        bezierPath = [UIBezierPath bezierPath];
        bezierPath.lineWidth = _axisLineWidth;
        [_axisColor setStroke];
        point = [self _pointForValue:_minValue atIndex:0];
        [bezierPath moveToPoint:point];
        point.x += chartWidth;
        [bezierPath addLineToPoint:point];
        [bezierPath stroke];
        point = [self _pointForValue:_minValue atIndex:0];
        [bezierPath moveToPoint:point];
        point.y -= chartHeight;
        [bezierPath addLineToPoint:point];
        [bezierPath stroke];
    }
    bezierPath = [self _linePathWithSmoothing:_bezierSmoothing closing:NO];
    bezierPath.lineWidth = _lineWidth;
    [_color setStroke];
    [bezierPath stroke];
    if (_displayDataPoint)
        for (int i = 0; i < numberOfDataPoints; i++) {
            value = [_dataSource lineChartView:self valueAtIndex:i];
            point = [self _pointForValue:value atDataPointIndex:i];
            bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - _dataPointRadius, point.y - _dataPointRadius, _dataPointRadius * 2, _dataPointRadius * 2)];
            bezierPath.lineWidth = _dataPointBorderWidth;
            [_dataPointColor setFill];
            [_dataPointBorderColor setStroke];
            [bezierPath fill];
            [bezierPath stroke];
        }
}

@end
