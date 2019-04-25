//
//  SDContactInfoView.h
//  SDMarketingManagement
//
//  Created by huihui on 15/11/19.
//  Copyright © 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSendCellModel.h"
#import "SDBackItemView.h"

@class SDContactInfoView;
@protocol SDContactInfoDelegate<NSObject>

@optional
-(void)approvalAnnex:(SDContactInfoView *)approvalAnnexView dataType:(NSInteger)dataType;

@end

@interface SDContactInfoView : UIView

//标题
@property (nonatomic ,copy) NSString *contactTitle;

//图片名
@property (nonatomic ,copy) NSString *imageName;

//关联的内容
@property (nonatomic, copy) SDSendCellModel *cellModel;

//显示关联信息的条目
@property (nonatomic, strong) SDBackItemView *itemView;

@property (nonatomic, weak) id<SDContactInfoDelegate> delegate;

@end
