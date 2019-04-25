//
//  CXAnnexsView.h
//  SDMarketingManagement
//
//  Created by admin on 16/4/28.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSendCellModel.h"
#import "SDBackItemView.h"

@class CXAnnexTwoView;

@protocol CXAnnexsViewDelegate<NSObject>

@optional
-(void)approvalAnnex:(CXAnnexTwoView *)approvalAnnexView dataType:(NSInteger)dataType;

@end

@interface CXAnnexTwoView : UIView

//标题
@property (nonatomic ,copy) NSString *contactTitle;

//图片名
@property (nonatomic ,copy) NSString *imageName;

//关联的内容
@property (nonatomic, copy) SDSendCellModel *cellModel;

//显示关联信息的条目
@property (nonatomic, strong) SDBackItemView *itemView;

@property (nonatomic, weak) id<CXAnnexsViewDelegate> delegate;

@end
