//
//  ICEFORCEWorkShowTextCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/9.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger,  ICEFORCEWorkShowOptions) {
    ICEFORCEWorkShowOptionText        = 0,
    ICEFORCEWorkShowOptionGif         = 1,
    ICEFORCEWorkShowOptionAttText     = 2,
    
};

@class ICEFORCEWorkShowTextCell;
@protocol ICEFORCEWorkShowTextDelegate <NSObject>

@optional
//后面的字符串只是暂时添加 存在真实数据后 在修改
- (void)showTextCell:(ICEFORCEWorkShowTextCell *)cell selectIndex:(NSIndexPath *)path;

-(void)showTextCell:(ICEFORCEWorkShowTextCell *)cell jumpDescDetail:(NSString *)detail;

@end

@interface ICEFORCEWorkShowTextCell : UITableViewCell

/** 普通内容 */
@property (nonatomic ,strong) NSString *attString;

/** 富文本内容 */
@property (nonatomic ,strong) NSString *selectString;

/** 状态内容 */
@property (nonatomic ,strong) NSString *stateString;

@property (nonatomic ,strong) NSIndexPath *indexPath;

/** 语音URL */
@property (nonatomic ,strong) NSString *voiceUrl;
/** 语音时间 */
@property (nonatomic ,assign) NSInteger voiceTime;

/** 是否开启长按手势 */
@property (nonatomic ,assign) BOOL isLongPress;

@property (nonatomic ,assign) ICEFORCEWorkShowOptions options;

@property (nonatomic, weak) id<ICEFORCEWorkShowTextDelegate> delegateCell;


@end
