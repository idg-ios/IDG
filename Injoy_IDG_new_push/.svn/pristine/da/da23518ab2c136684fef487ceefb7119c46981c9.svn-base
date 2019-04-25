//
//  CXBussinessSelectView.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/23.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXBussinessSelectView : UIView
typedef void(^selectDataCallBack)(NSString * selectedData);

@property (nonatomic, copy) selectDataCallBack selectDataCallBack;

//dataSource是选择用的数据源，title是选择弹出框的标题，selectData是已经选择的数据
- (id)initWithSelectArray:(NSArray *)dataSource Title:(NSString *)title AndSelectData:(NSString *)selectData;
@end
