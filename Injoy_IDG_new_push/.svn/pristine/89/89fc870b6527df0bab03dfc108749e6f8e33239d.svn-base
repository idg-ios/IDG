//
//  SDHeader.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/4/23.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#ifndef InjoyIDG_SDHeader_h
#define InjoyIDG_SDHeader_h

#import "SDCommonDefine.h"
#import "SDRootNavigationController.h"
#import "CXShareAlertView.h"
#import "UIColor+YYAdd.h"

#define LocalString(key) \
    [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

//------------------------------------适配iphoneX-------------------------------------
//判断是否iPhone X
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// status bar height.
#define kStatusBarHeight (IS_iPhoneX ? 44.f : 20.f)
// Navigation bar height.

#define kTabbarHeight 49.f
// Tabbar safe bottom margin.

#define kTabbarSafeBottomMargin  (IS_iPhoneX ? 34.f : 0.f)
// Status bar & navigation bar height.

#define kStatusBarAndNavigationBarHeight (IS_iPhoneX ? 90.f : 66.f)
//------------------------------------适配iphoneX-------------------------------------



// 屏幕高度
#define Screen_Height ([UIScreen mainScreen].bounds.size.height - kTabbarSafeBottomMargin)
// 屏幕宽度
#define Screen_Width [UIScreen mainScreen].bounds.size.width
// tabBar高度
#define TabBar_Height kTabbarHeight
//导航栏高
#define navHigh kStatusBarAndNavigationBarHeight
// 搜索框高度
#define searchBar_Height 50

/// 界面布局的间隔
#define Interval 10

/*
 * 分隔线背景色
 */
#define kIDGNewLineColor RGBACOLOR(242, 243, 244, 1.0)

#define kIDGSectionIndexColor RGBACOLOR(95, 107, 130, 1.0)

#define kSeperatorLineBgColor UIColorHex(dddddd)

#define bottomviewH 60

//所有应用功能标题的字体
#define kFontForAppFunction [UIFont systemFontOfSize:17.f]

/*
 * 权限管理
 */
#define CXRbac(val) ([NSString hasTheRightToVisit:val])

// 打印func
#define kLogFunc NSLog(@"%s", __func__);
// 打印frame
#define kLogFrame(view) NSLog(@"%@", NSStringFromCGRect(view.frame));

// 用户打印dealloc是否调用
#define DEALLOC_ADDITION \
    -(void)dealloc { kLogFunc; }

// frame
#define GET_WIDTH(view) (CGRectGetWidth(view.frame))
#define GET_HEIGHT(view) (CGRectGetHeight(view.frame))
#define GET_MIN_X(view) (CGRectGetMinX(view.frame))
#define GET_MID_X(view) (CGRectGetMidX(view.frame))
#define GET_MAX_X(view) (CGRectGetMaxX(view.frame))
#define GET_MIN_Y(view) (CGRectGetMinY(view.frame))
#define GET_MID_Y(view) (CGRectGetMidY(view.frame))
#define GET_MAX_Y(view) (CGRectGetMaxY(view.frame))

// 安全值
#define SAFE_STR(string) (string ? string : @"")
#define SAFE_NUMBER(number) (number ? number : [NSNull null])

#define kHudSendMessage @"请稍后"

#define LOGIN_HASLOCAL [[[NSUserDefaults standardUserDefaults]objectForKey:@"hasLocal"] integerValue]==1

#define kHudSendData @""

#define CXWeakSelf(type) __weak typeof(type) weak##type = type;
#define CXStrongSelf(type) __strong typeof(type) type = weak##type;
/** 声明weakSelf */
#define DECLARE_WEAK_SELF __weak typeof(self) weakSelf = self;
/** keywindow */
#define KEY_WINDOW ([UIApplication sharedApplication].keyWindow)
/** 显示菊花 */
#define HUD_SHOW(text) \
    { \
        HUD_HIDE; \
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW.rootViewController.view animated:NO]; \
        hud.labelText = text;                                                                                \
    }
/** 隐藏菊花 */
#define HUD_HIDE [MBProgressHUD hideAllHUDsForView:KEY_WINDOW.rootViewController.view animated:NO];
#define HUD_SendShow(kHudSendMessage) [self showHudInView:KEY_WINDOW hint:kHudSendMessage];

#define HUD_SHOW_IN(view) \
    { \
        HUD_HIDE_IN(view); \
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO]; \
        hud.labelText = nil;                                                                                \
    }
#define HUD_HIDE_IN(view) [MBProgressHUD hideAllHUDsForView:view animated:NO];

// 字体
#define kFontOfSize(_size) ([UIFont systemFontOfSize:_size])

#ifdef DEBUG
//#define kNetWorkPrefix @"http://192.168.101.233/em/" //网页本地地址
//#define kNetWorkPrefix @"http://120.26.122.28:8080/em/" //网页网络地址
#define kNetWorkPrefix @"http://webbls.chinacloudapp.cn/em/" //微软云测试环境
//#define kNetWorkPrefix @"http://em.injoy365.cn/" //微软云正式环境
#define kBackNetWorkPrefix @"http://42.159.238.151/om/" //后台网页地址

#else
//#define kNetWorkPrefix @"http://192.168.101.233/em/" //网页本地地址
//#define kNetWorkPrefix @"http://120.26.122.28:8080/em/" //网页网络地址
//#define kNetWorkPrefix @"http://webbls.chinacloudapp.cn/em/" //微软云测试环境
#define kNetWorkPrefix @"http://em.injoy365.cn/" //微软云正式环境
#define kBackNetWorkPrefix @"http://42.159.238.151/om/" //后台网页地址

#endif

// 颜色
#define kColorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1.0]
// 分割线颜色
//#define kLineColor [UIColor colorWithRed: 207.0/255.0 green:210.0/255.0 blue:213.0/255.0 alpha:0.7]
#define kLineColor [UIColor groupTableViewBackgroundColor]

//键盘高度
#define kDockH 75.f
#define DeleteDept @"deleteDept"

//拜访计划的本地消息通知
//#define kNotificationForVisitPlan @"kNotificationForVisitPlan"
//我的行程安排本地消息通知
//#define kNotificationForCalendarArrange @"kNotificationForCalendarArrange"

//办公文字的颜色
#define kContentTextColor [UIColor blackColor]
//审批状态未审批Button颜色和审批状态Label颜色
#define kContentStateColor [UIColor colorWithRed:251 / 255.0 green:155 / 255.0 blue:0 alpha:1]

//枚举回复类型
// 13=公告，14=任务，15=分享，16=工作报告，17=请假，20=采购，21=差旅，22=事务报告，23=特殊事务报告， 18=群通知, 32=市场调查,33=销售圈,34=采购圈,35=市场圈,36=仓库圈，37=机会，
typedef enum {
    announcementType = 13,
    orderType = 14,
    shareType = 15,
    reportType = 16,
    approvalType = 17,
    group = 18,
    purchase = 20,
    travel = 21,
    businessReport = 22,
    specialBusinessReport = 23,
    marketSurvey = 32,
    saleCircle = 33,
    purchasingCircle = 34,
    marketCircle = 35,
    warehouseCircle = 36,
    opportunity = 37,
    clueType = 38,
    lookHouse = 39,
} replyTypes;

// 销售圈 = 1，仓库圈 = 2，市场圈 = 3， 采购圈 = 4
typedef enum circleType {
    isFromSaleCircle = 1,
    isFromWarehouseCircle = 2,
    isFromMarketCircle = 3,
    isFromPurchaseCircle = 4
} circleType;

//枚举附件类型
typedef enum {
    oss = 1,
    localFile,
} annexWayTypes;

//费用单，请假单，差旅单，事务报告， 特殊事务报告,工作报告,工作任务,消息通知
typedef enum approvalModelType {
    purchaseApprovalType,
    holidayApprovalType,
    travelApprovalType,
    transactionApprovalType,
    specialApprovalType,
    workReportApprovalType,
    workOrderApprovalType,
    notificationApprovalType

} approvalModelType;

//工作报告类型,工作报告，工作任务，工作圈,费用申请，请假申请，差旅申请，事务申请，特殊事务申请,收到回复,@我的回复,@我的工作,我发出的工作,我的建议
typedef enum OAListType {
    workOrderListType,
    workReportListType,
    workCycleListType,
    workPurchaseListType,
    workHolidayListType,
    workTravelListType,
    workTransactionListType,
    workSpecialTransactionListType,
    workReceiveReplyListType,
    workAtMyReplyListType,
    workAtMyWorkListType,
    workMySendWorkListType,
    workNoticeListType,
    crmSalesCycleListType,
    crmWarehouseCircleListType,
    crmMarketCircleListType,
    crmPurchaseCircleListType,
    mySuggestListType
} OAListType;

typedef enum {
    /// 供应商增加
            select_customerAdd_Type_GYS = 3,
    /// 客户增加
            select_customerAdd_Type_KH = 1
} Select_customer_addType;

#ifdef DEBUG
//自定义NSLog
#define NSLog(...) NSLog(__VA_ARGS__)
#define print(...) NSLog(__VA_ARGS__)

#define HYLog(s, ...) NSLog(@"<%p %@ %s:(%d)>%@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define NSLog(...)
#define HYLog(s, ...)
#endif
//
#define Image(imageName) [UIImage imageNamed:imageName]

#define UseAutoLayout(obj) [obj setTranslatesAutoresizingMaskIntoConstraints:NO];

//记录草稿数量
#define kDraftCountInDraftViewController @"kDraftCountInDraftViewController"

#define kDraftCountID @"kDraftCountID"

//记录是否设置手势密码
#define kGesturePasswordSetting @"gesturePasswordSetting"
//纪录是否允许保存定位
#define kUserLocationSave @"userLocationSave"

// 结尾
#endif

#define trim(str) ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])

//叮当享规范
//颜色－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

//导航条背景色绿色
#define SDNavigationBackColor kColorWithRGB(67, 144, 21)

//主色
#define SDMainColor (RGBACOLOR(0, 69, 39, 1.0))

#define kBackgroundColor RGBACOLOR(242.f, 241.f, 247.f, 1.f)

//背景色
#define SDBackGroudColor (RGBACOLOR(245, 246, 248, 1.0))

//标签底色
#define SDTagBackGroundColor (RGBACOLOR(248, 248, 248, 1.0))

//字体配色深色
#define SDTextDarkColor (RGBACOLOR(128, 128, 128, 1.0))

//字体配色浅色
#define SDTextLightColor (RGBACOLOR(177, 177, 177, 1.0))

//按钮色绿色
#define SDBtnGreenColor (RGBACOLOR(11, 185, 8, 1.0))

//按钮色偏红色
#define SDBtnRedColor (RGBACOLOR(255, 95, 95, 1.0))

//按钮色浅绿色
#define SDBtnLightGreenColor (RGBACOLOR(113, 199, 98, 1.0))

//退出删除按钮颜色
#define SDQuitOrDeleteBtnColor (RGBACOLOR(255, 59, 47, 1.0))

//语音会议灰色
#define SDVoiceConferenceGrayColor (RGBACOLOR(51, 55, 58, 1.0))

//语音会议黑色
#define SDVoiceConferenceBlackColor (RGBACOLOR(29, 32, 39, 1.0))

//导航栏文字颜色
#define SDNavgationBarTitleColor (RGBACOLOR(255, 255, 255, 1.0))

//超信cell的昵称颜色
#define SDChatterDisplayNameColor (RGBACOLOR(31.0, 34.0, 40.0, 1.0))

//超信cell的时间颜色
#define SDCellTimeColor (RGBACOLOR(177, 177, 177, 1.0))

//超信cellLastMessage的颜色
#define SDCellLastMessageColor (RGBACOLOR(132.0, 142.0, 153.0, 1.0))

//tabbar上的文字的灰色颜色
#define SDTabbarTitleGrayColor (RGBACOLOR(164, 171, 179, 1.0))

//tabbar上被选中的文字的红色颜色
#define SDTabbarTitleGreenColor (RGBACOLOR(174, 17, 41, 1.0))

//数字时间等补充信息（比如已添加，时间等）
#define SDAdditionalInformationColor (RGBACOLOR(132.0, 142.0, 153.0, 1.0))

//标签名字，成员等sectionTitle的颜色
#define SDSectionTitleColor (RGBACOLOR(128, 128, 128, 1.0))

//我要收款的按钮颜色
#define SDReceiveMoneyBtnColor (RGBACOLOR(246, 140, 45, 1.0))

//颜色－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

//大小－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

//设置圆角
#define CornerRadius 0

//导航栏文字字号
#define SDNavgationBarTitleFont 17

//叮当享cell的昵称文字字号
#define SDChatterDisplayNameFont 18.0

//叮当享cell的lastMessage的文字字号
#define SDCellLastMessageFont 14.0

//叮当享cell的时间的文字字号
#define SDCellTimeFont 12.0

//主要信息，名字，内容，设置信息等(比如李妍这样的昵称，扫一扫这种，聊天的文字字体)
#define SDMainMessageFont 16.0

//tabbar的title文字字号
#define SDTabbarTitleFont 12

//selectMenu的文字字号
#define SDSelectMenuTextFont 16

//selectMenu的每行高度
#define SDSelectMenuEachRowHeight 42

//数字时间等补充信息（比如已添加，时间等）（林成鹏原话：就是原则上用24px，特殊情况下用22px，能用24px的都用24px就行了）
//数字时间等补充信息(通常情况)
#define SDAdditionalInformationNormalFont 12

//数字时间等补充信息(特殊情况)
#define SDAdditionalInformationSpecialFont 11

//导航栏按钮文字字号
#define SDNavigationBarButtonTitleLabelFont 16

//标签名字，成员等sectionTitle的字号
#define SDSectionTitleFont 14

//头像距离cell左侧的距离
#define SDHeadImageViewLeftSpacing 16

//除了我页面，其余cell的高度都为65
#define SDCellHeight 80

//我页面的cell高度
#define SDMeCellHeight 54

//我页面的文字距离左侧距离为26px
#define SDMeCellTextLeftSpacing 13

//头像宽和高
#define SDHeadWidth (SDCellHeight - SDHeadImageViewLeftSpacing * 2)

//菜单页面的cell高度
#define SDMenuCellHeight 80

//菜单页面的cell文字大小
#define SDMenuCellTitleFontSize 16.0

//菜单页面的cell文字左间距
#define SDMenuCellTitleLeftMargin 10.0

//大小－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

// 没有数据的提示
#define MAKE_TOAST_NODATA TTAlert(@"暂无数据")

#define MAKE_TOAST(_text) TTAlert(_text)

//// 提示
//#define TTAlert(_text) MAKE_TOAST_D(_text, kNetWorkPromptLongTime)
//// 数据校验提示
#define MAKE_TOAST_V(_text) MAKE_TOAST_D(_text, kNetWorkPromptShortTime)

// 自定时长的提示
#define MAKE_TOAST_D(_text, _duration)                                \
    {                                                                 \
        [CXShareAlertView showViewWithMessage:_text];    \
        /*UIView* view = KEY_WINDOW.rootViewController.view;*/            \
        /*[view makeToast:_text duration:_duration position:@"center"];*/ \
    }

#define kShareEmptyTips @"分享功能暂未开放，敬请期待！"
#define kShareEmptyTipsAtCreate @"分享功能暂未开放，敬请期待！"
#define kSeparateVal 0.125f

// Alert
#define CXAlert(text) TTAlert(text);

#define CXAlertExt(text, block) TTAlertExt(text,block);

// 引导
#define kCXGuideFlagKey @"guided"
#define kHasGuided ([[NSUserDefaults standardUserDefaults] boolForKey:kCXGuideFlagKey])

// 是否允许使用叮当享聊天
#define kAllowChatKey @"allowChat"
#define kAllowChat ([[NSUserDefaults standardUserDefaults] boolForKey:kAllowChatKey])

#define kCXCustomerModelNotifi @"CXCustomerModelNSNotification"

#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify(x) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify(x) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif
