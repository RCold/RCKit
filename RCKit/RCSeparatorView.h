//
//  RCSeparatorView.h
//  RCKit
//
//  Created by Yeuham Wang on 16/4/18.
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

@interface RCSeparatorView : UIView

@property (strong, nonatomic) UIColor *separatorColor;
@property (nonatomic) BOOL showTopSeparator;
@property (nonatomic) BOOL showBottomSeparator;
@property (nonatomic) BOOL showLeadingSeparator;
@property (nonatomic) BOOL showTrailingSeparator;

@end
