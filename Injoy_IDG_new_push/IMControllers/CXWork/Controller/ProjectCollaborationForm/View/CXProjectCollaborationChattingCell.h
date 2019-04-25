//
//  CXProjectCollaborationChattingCell.h
//  InjoyDDXWBG
//
//  Created by wtz on 2017/11/2.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDDataBaseHelper.h"
#import "CXProjectCollaborationFormViewController.h"
#import "CXIDGSmallBusinessAssistantModel.h"

#define kContainerViewBorderWidth .5
#define kContainerViewCornerRadius 2
#define kContainerViewBorderColor [UIColor lightGrayColor]
#define kContainerViewMinH 35.0
// 时间上下间距
#define kTimeLabelTopBottomMargin 15

#pragma mark - 协议
/**
 *  弹出菜单
 */
typedef NS_ENUM(NSInteger,CXProjectCollaborationChattingCellMenuItem) {
    /**
     *  复制
     */
    CXProjectCollaborationChattingCellMenuItemCopy,
    /**
     *  删除
     */
    CXProjectCollaborationChattingCellMenuItemDelete,
    /**
     *  转发
     */
    CXProjectCollaborationChattingCellMenuItemForward
};

@class CXProjectCollaborationChattingCell;
@protocol CXProjectCollaborationChattingCellDelegate <NSObject>

@optional
/**
 *  点击了菜单条
 *
 *  @param cell    cell
 *  @param item    菜单类型
 *  @param message 消息对象
 */
-(void)projectCollaborationChattingCell:(CXProjectCollaborationChattingCell *)cell didTapMenuItem:(CXProjectCollaborationChattingCellMenuItem)item message:(CXIMMessage *)message;

/**
 *  点击了发送失败按钮
 *
 *  @param cell cell
 *  @param null 空对象
 */
- (void)projectCollaborationChattingCell:(CXProjectCollaborationChattingCell *)cell didTapSendFailedBtn:(void *)null;

/**
 *  点击了头像
 *
 *  @param cell cell
 *  @param null 空对象
 */
- (void)projectCollaborationChattingCell:(CXProjectCollaborationChattingCell *)cell didTapAvatar:(void *)null;

/**
 *  启动了阅后即焚定时器
 *
 *  @param cell cell
 *  @param null 空对象
 */
- (void)projectCollaborationChattingCell:(CXProjectCollaborationChattingCell *)cell didStartBurnMessagesAfterReadTimer:(void *)null;

@end

@interface CXProjectCollaborationChattingCell : UITableViewCell

#pragma mark - 外部方法
+(NSString *)identifierForContentType:(CXIMMessageContentType)type;
+(NSString *)identifierForCXIDGSmallBusinessAssistantCellType;
+(CXProjectCollaborationChattingCell *)createCellForIdentifier:(NSString *)identifier;

#pragma mark - 外部属性
// 传入参数
@property (nonatomic,strong) CXIMMessage *message;
//传入参数
@property (nonatomic, strong) CXIDGSmallBusinessAssistantModel * model;
// 传入参数
@property (nonatomic,strong) NSString *job;
@property (nonatomic,assign) NSInteger compareTime;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) id<CXProjectCollaborationChattingCellDelegate> delegate;
// 传出参数
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,weak) CXProjectCollaborationFormViewController *viewController;

#pragma mark - 子类属性
/** 会话人 */
@property (nonatomic, readonly) NSString *chatter;
/** 是否需要显示时间 */
@property (nonatomic, assign, readonly) BOOL isNeedDisplayTime;
/** 是否群聊 */
@property (nonatomic, assign, readonly) BOOL isGroupChat;
/** 是否自己发送的消息 */
@property (nonatomic, assign, readonly) BOOL isFromSelf;
/** 是否聊天消息 */
@property (nonatomic, assign, readonly) BOOL isChatMessage;
/** 是否需要显示昵称 */
@property (nonatomic, assign, readonly) BOOL isNeedDisplayNickname;
/** 是否需要显示已读未读按钮 */
@property (nonatomic, assign, readonly) BOOL isNeedDisplayReadOrUnReadBtn;
/** 是否需要显示位置按钮 */
@property (nonatomic, assign, readonly) BOOL isNeedDisplayLocationBtn;
/** 是否阅后即焚消息 */
@property (nonatomic, assign, readonly) BOOL isBurnAfterReadMessage;
/** 是否是从超级搜索进来的需不需要显示已读未读 */
@property (nonatomic, assign) BOOL isNotNeedShowReadOrUnRead;

#pragma mark - 子类控件
/**
 *  时间label
 */
@property (nonatomic,strong) UILabel *timeLabel;
/**
 *  位置信息按钮
 */
@property (nonatomic, strong) UIButton *locationBtn;
/**
 *  已读未读按钮
 */
@property (nonatomic, strong) UIButton *readOrUnReadBtn;
/**
 *  发送状态菊花
 */
@property (nonatomic,strong) UIActivityIndicatorView *sendingStatusIndicator;
/**
 *  发送失败之后的重发按钮
 */
@property (nonatomic,strong) UIButton *failedResendBtn;
/**
 *  阅后即焚的锁和开锁图标
 */
@property (nonatomic,strong) UIImageView *burnAfterReadLockAndUnLockView;
/**
 *  阅后即焚的倒计时View
 */
@property (nonatomic,strong) UIView *deleteMessageCountView;

/**
 *  用来记录删除的倒计时时间
 */
@property (nonatomic, strong) UILabel * deleteTimeCountLabel;

#pragma mark - 子类方法
/**
 *  初始化cell
 */
-(void)initCell;

/**
 *  获取当前cell所在的tableview
 *
 *  @return UITableview
 */
-(UITableView *)getTableView;

/**
 *  是否启用相关menu
 *
 *  @param item menu类型
 *
 *  @return 是否启用
 */
- (BOOL)menuItemEnabled:(CXProjectCollaborationChattingCellMenuItem)item;

/**
 *  子类layoutSubviews后调用
 */
- (void)subClassLayoutSubviews;

/**
 *  子类initCell方法完成后调用
 */
- (void)cellDidLoad;

/**
 *  子类调用设置阅后即焚的时间
 */
- (void)saveBurnAfterReadTime;


@end
