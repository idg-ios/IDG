//
//  CXNoticeCell.h
//  InjoyIDG
//
//  Created by cheng on 2017/11/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXNoticeCell : UITableViewCell

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容 */
@property (nonatomic, copy) NSString *remark;
/** 时间 */
@property (nonatomic, copy) NSString *createTime;

@end
