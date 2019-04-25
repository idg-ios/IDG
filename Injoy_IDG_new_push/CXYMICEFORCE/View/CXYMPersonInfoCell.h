//
//  CXYMPersonInfoCell.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/25.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

//标准个人信息cell,包含左侧图标,title,右侧的文本
@interface CXYMPersonInfoCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

//个人信息-头像cell,包含左侧图标,title,右侧的头像
@interface CXYMPersonInfoImageCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
