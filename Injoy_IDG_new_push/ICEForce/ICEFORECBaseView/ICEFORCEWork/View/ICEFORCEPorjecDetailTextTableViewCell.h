//
//  ICEFORCEPorjecDetailTextTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/11.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEFORCEWorkProjectModel.h"
typedef NS_OPTIONS(NSUInteger,  ICEFORCEWorkDetailOptions) {
    ICEFORCEWorkDetailOptionText        = 0,
    ICEFORCEWorkDetailOptionGif         = 1,
    ICEFORCEWorkDetailOptionAttText     = 2,
};


@interface ICEFORCEPorjecDetailTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subsViewH;

@property (nonatomic ,strong) ICEFORCEWorkProjectModel *detailModel;

@property (nonatomic ,strong) NSDictionary *dataDic;

/** 普通内容 */
@property (nonatomic ,strong) NSString *attString;

/** 富文本内容 */
@property (nonatomic ,strong) NSString *selectString;

/** 状态内容 */
@property (nonatomic ,strong) NSString *stateString;

@property (nonatomic ,assign) BOOL isMore;

@property (nonatomic ,assign) ICEFORCEWorkDetailOptions options;
@end
