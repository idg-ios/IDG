//
//  CXYMTextViewCell.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXYMPlaceholderTextView;

@interface CXYMTextViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CXYMPlaceholderTextView *textView;
@end
