//
//  CXPopupsViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2018/6/2.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXPopupsViewController : UIViewController


/**
 
 CXPopupsViewController *pop = [[CXPopupsViewController alloc]init];
 pop.titelString = @"选择行业类型";
 pop.popupDataBlock = ^(NSDictionary *data) {
 
 };
 pop.dataArray = @[
 @"你有看见我的小熊吗？",
 @"让我们猎杀那些陷入黑暗中的人？",
 @"万物皆系于一箭之上？",
 @"真男人永不畏惧？"];
 if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
 pop.modalPresentationStyle = UIModalPresentationOverCurrentContext;
 }else{
 pop.modalPresentationStyle = UIModalPresentationCurrentContext;
 }
 
 [self presentViewController:pop animated:YES completion:nil];
 */


/** 数据回调 */
@property (nonatomic,copy) void(^popupDataBlock)(NSString *dataString);

/** 数据源 */
@property (nonatomic,strong) NSArray <NSString *>*dataArray;

/** topViewTitle*/
@property (nonatomic,strong) NSString *titelString;


@end
