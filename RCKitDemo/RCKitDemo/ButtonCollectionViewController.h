//
//  ButtonCollectionViewController.h
//  RCKitDemo
//
//  Created by Yeuham Wang on 16/2/28.
//  Copyright (c) 2016 Yeuham Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCButtonCollectionView;

@interface ButtonCollectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet RCButtonCollectionView *buttonCollectionView1;
@property (weak, nonatomic) IBOutlet RCButtonCollectionView *buttonCollectionView2;
@property (weak, nonatomic) IBOutlet UILabel *preferredLayoutWidthValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineSpacingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *interitemSpacingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *edgeInsetsValueLabel;

- (IBAction)preferredLayoutWidthSliderValueChanged:(UISlider *)sender;
- (IBAction)lineSpecingSliderValueChanged:(UISlider *)sender;
- (IBAction)interitemSpacingSliderValueChanged:(UISlider *)sender;
- (IBAction)edgeInsetsSliderValueChanged:(UISlider *)sender;

@end
