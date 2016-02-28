//
//  ButtonCollectionViewController.m
//  RCKitDemo
//
//  Created by Yeuham Wang on 16/2/28.
//  Copyright (c) 2016 Yeuham Wang. All rights reserved.
//

#import "ButtonCollectionViewController.h"
#import "RCKit.h"

@implementation ButtonCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *buttonTitles1 = @[@"This", @"is", @"a", @"button", @"collection", @"view"];
    NSArray *buttonTitles2 = @[@"This", @"is", @"a", @"button", @"collection", @"view", @"with", @"multiple", @"selection"];
    NSMutableArray *buttons = [NSMutableArray array];
    for (int i = 0; i < buttonTitles1.count; i++)
        [buttons addObject:[self buttonWithTitle:buttonTitles1[i]]];
    _buttonCollectionView1.buttons = buttons;
    _buttonCollectionView1.edgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    [_buttonCollectionView1 selectButtonAtIndex:0];
    [buttons removeAllObjects];
    for (int i = 0; i < buttonTitles2.count; i++)
        [buttons addObject:[self buttonWithTitle:buttonTitles2[i]]];
    _buttonCollectionView2.buttons = buttons;
    _buttonCollectionView2.allowMultipleSelection = YES;
    _buttonCollectionView2.edgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
    [_buttonCollectionView2 selectButtonAtIndex:3];
    [_buttonCollectionView2 selectButtonAtIndex:4];
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5.0;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundImage:UIImageFromColor([UIColor groupTableViewBackgroundColor], CGSizeMake(1.0, 1.0)) forState:UIControlStateNormal];
    [button setBackgroundImage:UIImageFromColor(button.tintColor, CGSizeMake(1.0, 1.0)) forState:UIControlStateHighlighted];
    [button setBackgroundImage:UIImageFromColor(button.tintColor, CGSizeMake(1.0, 1.0)) forState:UIControlStateSelected];
    [button sizeToFit];
    CGRect bounds = button.bounds;
    bounds.size.width += 16.0;
    bounds.size.height += 8.0;
    button.bounds = bounds;
    return button;
}

- (IBAction)preferredLayoutWidthSliderValueChanged:(UISlider *)sender {
    CGFloat value = sender.value;
    _preferredLayoutWidthValueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    _buttonCollectionView1.preferredLayoutWidth = value;
    _buttonCollectionView2.preferredLayoutWidth = value;
}

- (IBAction)lineSpecingSliderValueChanged:(UISlider *)sender {
    CGFloat value = sender.value;
    _lineSpacingValueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    _buttonCollectionView1.lineSpacing = value;
    _buttonCollectionView2.lineSpacing = value;
}

- (IBAction)interitemSpacingSliderValueChanged:(UISlider *)sender {
    CGFloat value = sender.value;
    _interitemSpacingValueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    _buttonCollectionView1.interitemSpacing = value;
    _buttonCollectionView2.interitemSpacing = value;
}

- (IBAction)edgeInsetsSliderValueChanged:(UISlider *)sender {
    CGFloat value = sender.value;
    _edgeInsetsValueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    _buttonCollectionView1.edgeInsets = UIEdgeInsetsMake(value, value, value, value);
    _buttonCollectionView2.edgeInsets = UIEdgeInsetsMake(value, value, value, value);
}
@end
