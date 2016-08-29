//
//  RCTextView.h
//  RCKit
//
//  Created by Yeuham Wang on 16/8/26.
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

NS_CLASS_AVAILABLE_IOS(7_0) @interface RCTextView : UITextView {
    UILabel *_placeholderLabel;
}

@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) UIColor *placeholderColor;
@property (copy, nonatomic) NSAttributedString *attributedPlaceholder;

@end
