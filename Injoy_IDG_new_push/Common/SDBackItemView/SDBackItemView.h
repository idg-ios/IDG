//
//  SDBackItemView.h
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/7/8.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSendCellModel.h"

@class SDBackItemView;
@protocol  SDBackItemViewDelegate<NSObject>

@optional
-(void)backItemView:(SDBackItemView *)backItemView selectCellModel:(SDSendCellModel *)cellModel;

@end

@interface SDBackItemView : UIView

@property (nonatomic, copy) SDSendCellModel *model;

@property (nonatomic, strong)UIButton *deleteButton;

@property (nonatomic, strong)UILabel *infoLabel;

//任务完成时间
@property (nonatomic, assign)BOOL isOrderFinishTime;

@property (nonatomic, weak) id<SDBackItemViewDelegate> delegate;

//开始播放声音动画
-(void)playRecordStartAnimation;

//结束播放录音动画
-(void)stopRecordPlayAnimation;

@end
