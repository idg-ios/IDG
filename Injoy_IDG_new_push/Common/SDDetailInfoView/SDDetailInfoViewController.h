//
//  SDDetailInfoViewController.h
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/7/1.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDDetailInfoViewController : UIViewController

@property (nonatomic, strong) SDRootTopView *rootTopView;
@property (nonatomic, copy) NSArray *annexArray;
//传回要预览的当前图片
@property (nonatomic, assign)NSUInteger index;

@end
