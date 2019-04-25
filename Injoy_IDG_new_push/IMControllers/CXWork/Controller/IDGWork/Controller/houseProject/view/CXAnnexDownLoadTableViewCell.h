//
//  CXAnnexDownLoadTableViewCell.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/29.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXAnnexDownLoadManager.h"

@interface CXAnnexDownLoadTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic, strong)id model;
@property (nonatomic, assign)NSInteger projId;
@property (nonatomic, assign)downloadStatus status;
@property (nonatomic, strong)UIViewController *vc;
@property (nonatomic, assign)BOOL hasRightDownload;
@end
