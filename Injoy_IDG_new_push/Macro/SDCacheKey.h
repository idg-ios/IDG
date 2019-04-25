//
//  SDCacheKey.h
//  SDMarketingManagement
//
//  Created by Rao on 15-5-23.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#ifndef InjoyXP_SDCacheKey_h
#define InjoyXP_SDCacheKey_h

#define KOurCompanyAccount @"cx"    // 我们超享公司的公司账号

#define HXACCOUNT @"HXACCOUNT" // 环信用户名
#define VAL_HXACCOUNT [[NSUserDefaults standardUserDefaults] valueForKey:HXACCOUNT]

#define annexWay @"annexWay"
#define VAL_annexWay [[NSUserDefaults standardUserDefaults] valueForKey:annexWay] != nil ? [[NSUserDefaults standardUserDefaults] valueForKey:annexWay] : @"1" // 附件上传方式.2:上传到后台 1:上传到oss

#define mailInfo @"mailInfo"

#define key_token @"token"
#define VAL_token [[NSUserDefaults standardUserDefaults] valueForKey:key_token]

#define COMPANYID @"companyId"
#define VAL_companyId [[NSUserDefaults standardUserDefaults] valueForKey:COMPANYID]

#define COMPANYACCOUNT @"companyAccount"
#define VAL_companyAccount [[NSUserDefaults standardUserDefaults] valueForKey:COMPANYACCOUNT]

#define KUserID @"userId"
#define VAL_USERID [[NSUserDefaults standardUserDefaults] valueForKey:KUserID]

#define KIsSuper @"isSuper"
#define VAL_IsSuper [[NSUserDefaults standardUserDefaults] integerForKey:KIsSuper]

#define KSuperStatus @"superStatus"
#define VAL_SuperStatus [[NSUserDefaults standardUserDefaults] integerForKey:KSuperStatus]

#define kUserName @"userName"
#define VAL_USERNAME [[NSUserDefaults standardUserDefaults] valueForKey:kUserName]

#define kAccount @"account"
#define VAL_Account [[NSUserDefaults standardUserDefaults] valueForKey:kAccount]

#define kCreateTime @"createTime"
#define VAL_CreateTime [[NSUserDefaults standardUserDefaults] valueForKey:kCreateTime]

#define kIcon @"icon"
#define VAL_Icon [[NSUserDefaults standardUserDefaults] valueForKey:kIcon]

#define kEmail @"email"
#define VAL_Email [[NSUserDefaults standardUserDefaults] valueForKey:kEmail]

#define kSex @"sex"
#define VAL_Sex [[NSUserDefaults standardUserDefaults] valueForKey:kSex]

#define kTelephone @"telephone"
#define VAL_Telephone [[NSUserDefaults standardUserDefaults] valueForKey:kTelephone]

#define kUpdateTime @"updateTime"
#define VAL_UpdateTime [[NSUserDefaults standardUserDefaults] valueForKey:kUpdateTime]

#define YAOURL @"yaoUrl"
#define VAL_YAOURL [[NSUserDefaults standardUserDefaults] valueForKey:YAOURL]

#define IOS_DOWNLOAD @"ios_download"
#define VAL_IOS_DOWNLOAD [[NSUserDefaults standardUserDefaults] valueForKey:IOS_DOWNLOAD]

#define KImStatus @"imStatus"
#define VAL_ImStatus [[NSUserDefaults standardUserDefaults] valueForKey:KImStatus]

#define kStaticDepartmentData @"kStaticDepartmentData"
#define VAL_kStaticDepartmentData [[NSUserDefaults standardUserDefaults] valueForKey:kStaticDepartmentData]

#define KDpId @"dpId"
//当前登陆用户部门ID
#define VAL_DpId [[NSUserDefaults standardUserDefaults] valueForKey:KDpId]
#define KDpName @"dpName"
//当前登陆用户部门名称
#define VAL_DpName [[NSUserDefaults standardUserDefaults] valueForKey:KDpName]
#define KChildrenUser @"childrenUser"
//当前登陆用户的下属
#define VAL_ChildrenUser [[NSUserDefaults standardUserDefaults] valueForKey:KChildrenUser]
// 分管部门
#define KChargeDpCode @"inChargeDpCode"
#define VAL_ChargeDept [[NSUserDefaults standardUserDefaults] valueForKey:KChargeDpCode]

#define KCompanyLogo @"s_logo" // 公司启动页
#define VAL_CompanyLogo [[NSUserDefaults standardUserDefaults] valueForKey:KCompanyLogo]

#define KFingerprintLogin @"s_fingerprintLogin" // 指纹登陆
#define VAL_FingerprintLogin [[NSUserDefaults standardUserDefaults] valueForKey:KFingerprintLogin]

#define KCompanyName @"CompanyName" // 公司名字
#define VAL_CompanyName [[NSUserDefaults standardUserDefaults] valueForKey:KCompanyName]

#define KStaticData @"StaticData" //静态数据的key
#define VAL_StaticData [[NSUserDefaults standardUserDefaults] valueForKey:KStaticData]
#define KContactsData @"ContactsData" //通讯录的key
#define VAL_ContactsData [[NSUserDefaults standardUserDefaults] valueForKey:KContactsData]

#define KLogisticsCompanyDataKey @"LogisticsCompanyData" // 物流公司静态数据key
#define VAL_LogisticsCompanyData [[NSUserDefaults standardUserDefaults] arrayForKey:KLogisticsCompanyDataKey] // 物流公司静态数据key

#define KBrandStatic @"BrandStatic" //货品品牌（静态数据）
#define VAL_BrandStaticData [[NSUserDefaults standardUserDefaults] valueForKey:KBrandStatic]
#define KTypeStatic @"TypeStatic" //货品类别（静态数据）
#define VAL_TypeStaticData [[NSUserDefaults standardUserDefaults] valueForKey:KTypeStatic]
#define KCusLevelStatic @"CusLevelStatic" //基础数据－客户级别（静态数据）
#define VAL_CusLevelStaticData [[NSUserDefaults standardUserDefaults] valueForKey:KCusLevelStatic]
#define KCusTypeStatic @"CusTypeStatic" //基础数据－客户类别（静态数据）
#define VAL_CusTypeStaticData [[NSUserDefaults standardUserDefaults] valueForKey:KCusTypeStatic]

#define KUserType @"UserType" // 用户类型 1是内部 2是外部
#define VAL_UserType [[NSUserDefaults standardUserDefaults] valueForKey:KUserType]
#define KUserlevel @"level" // 用户层级归属 1是公司管理 2是部门干部 3是员工
#define VAL_UserLevel [[NSUserDefaults standardUserDefaults] valueForKey:KUserlevel]
#define KCompanylevel @"companyLevel" // 公司级别，用来判断权限
#define VAL_CompanyLevel [[NSUserDefaults standardUserDefaults] valueForKey:KCompanylevel]
#define KJob @"job"   // 职务
#define VAL_Job [[NSUserDefaults standardUserDefaults] valueForKey:KJob]
#define KMenuList @"menuList"   // 权限菜单
#define VAL_Menulist [[NSUserDefaults standardUserDefaults] valueForKey:KMenuList]

#define kMailNumber 100 // 从服务器抓取邮件的数量
#define KMailAccount @"MailAccount" // 用户邮箱账号
#define KMailPassword @"MailPassword" // 用户邮箱密码
#define kMailReceiveProtocol @"MailReceiveProtocol" // 邮箱接收协议
#define kMailSendProtocol @"MailSendProtocol" // 邮箱接收协议
// 邮件数据归档文件夹
#define kMailFilePath [NSString stringWithFormat:@"%@/Documents/Email", NSHomeDirectory()]

#define kSandBoxPath [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()]

#define KKefu @"KKefuVal"
#define VAL_Kefu [[NSUserDefaults standardUserDefaults] valueForKey:KKefu]

// 网络访问失败提醒
#define KNetworkFailRemind @"您当前的网络不稳定"
// 个人应用链接url(测试环境)
#define KPrivateApplyURL @"http://omsc.chinacloudapp.cn"
// 通讯录个人信息广告链接
#define KContactInfoADURL @"http://em.injoy365.cn/wwwroot/advertisement.html"
// 当前app在苹果商店上的连接(如果没有用公司在苹果商店上的链接)
#define KAppleStoreURL @"https://itunes.apple.com/cn/app/idg-capital/id1315954559?mt=8"



//叮当享设置
//用来判断是否已经存了权限设置，如果取出为nil则未保存权限
#define HAD_SAVE_PERMISSION_SETTINGS @"HAD_SAVE_PERMISSION_SETTINGS"
#define VAL_HAD_SAVE_PERMISSION_SETTINGS [[NSUserDefaults standardUserDefaults] valueForKey:HAD_SAVE_PERMISSION_SETTINGS]

//接收新消息通知开关
#define ENABLE_GET_NEW_MESSAGE_NOTIFICATION @"ENABLE_GET_NEW_MESSAGE_NOTIFICATION"
#define VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION [[NSUserDefaults standardUserDefaults] boolForKey:ENABLE_GET_NEW_MESSAGE_NOTIFICATION]

//声音开关
#define ENABLE_MAKE_SOUND @"ENABLE_MAKE_SOUND"
#define VAL_ENABLE_MAKE_SOUND [[NSUserDefaults standardUserDefaults] boolForKey:ENABLE_MAKE_SOUND]

//震动开关
#define ENABLE_SHOCK @"ENABLE_SHOCK"
#define VAL_ENABLE_SHOCK [[NSUserDefaults standardUserDefaults] boolForKey:ENABLE_SHOCK]

//扬声器开关
#define ENABLE_LOUD_SPEAKER @"ENABLE_LOUD_SPEAKER"
#define VAL_ENABLE_LOUD_SPEAKER [[NSUserDefaults standardUserDefaults] boolForKey:ENABLE_LOUD_SPEAKER]

//定位开关
#define ENABLE_GET_LOCATION @"ENABLE_GET_LOCATION"
#define VAL_ENABLE_GET_LOCATION [[NSUserDefaults standardUserDefaults] boolForKey:ENABLE_GET_LOCATION]

//专属定制
#define ISZHUAN_SHU_DING_ZHI @"ISZHUAN_SHU_DING_ZHI"
#define VAL_ISZHUAN_SHU_DING_ZHI [[NSUserDefaults standardUserDefaults] boolForKey:ISZHUAN_SHU_DING_ZHI]

//是否开启年会
#define ISSHOW_ANNUALMEETING @"ISSHOW_ANNUALMEETING"
#define VAL_ISSHOW_ANNUALMEETING [[NSUserDefaults standardUserDefaults] boolForKey:ISSHOW_ANNUALMEETING]

//是否已经强制改密
#define IS_Update_Pwd @"isUpdatePwd"
#define VAL_IS_Update_Pwd [[NSUserDefaults standardUserDefaults] boolForKey:IS_Update_Pwd]

//是否是临时人员，只有年会
#define IS_AnnualTem @"isAnnualTem"
#define VAL_IS_AnnualTem [[NSUserDefaults standardUserDefaults] boolForKey:IS_AnnualTem]

//开启定位
#define OPEN_GET_LOCATION @"OPEN_GET_LOCATION"
#define VAL_OPEN_GET_LOCATION [[NSUserDefaults standardUserDefaults] boolForKey:OPEN_GET_LOCATION]

//开启已阅未阅
#define OPEN_READ_FLAG @"OPEN_READ_FLAG"
#define VAL_OPEN_READ_FLAG [[NSUserDefaults standardUserDefaults] boolForKey:OPEN_READ_FLAG]

//是否有销假批审功能
#define HAS_RIGHT_XJPS @"HAS_RIGHT_XJPS"
#define VAL_HAS_RIGHT_XJPS [[NSUserDefaults standardUserDefaults] boolForKey:HAS_RIGHT_XJPS]

//是否有请假批审功能
#define HAS_RIGHT_QJPS @"HAS_RIGHT_QJPS"
#define VAL_HAS_RIGHT_QJPS [[NSUserDefaults standardUserDefaults] boolForKey:HAS_RIGHT_QJPS]

//是否有报销批审功能
#define HAS_RIGHT_BXPS @"HAS_RIGHT_BXPS"
#define VAL_HAS_RIGHT_BXPS [[NSUserDefaults standardUserDefaults] boolForKey:HAS_RIGHT_BXPS]

//是否有出差批审功能
#define HAS_RIGHT_CCPS @"HAS_RIGHT_CCPS"
#define VAL_HAS_RIGHT_CCPS [[NSUserDefaults standardUserDefaults] boolForKey:HAS_RIGHT_CCPS]

//叮当享设置
//用来判断是否已经存了权限设置，如果取出为nil则未保存权限
#define HAD_SAVE_RedViewShow [NSString stringWithFormat:@"HAD_SAVE_RedViewShow_%@",VAL_HXACCOUNT]
#define VAL_HAD_SAVE_RedViewShow [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"HAD_SAVE_RedViewShow_%@",VAL_HXACCOUNT]]

//显示加好友或者新同事红点开关
#define SHOW_ADD_FRIENDS [NSString stringWithFormat:@"SHOW_ADD_FRIENDS_%@",VAL_HXACCOUNT]
#define VAL_SHOW_ADD_FRIENDS [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"SHOW_ADD_FRIENDS_%@",VAL_HXACCOUNT]]

//显示是否有未读的type是37的推送的工作圈消息
#define HAVE_UNREAD_WORKCIRCLE_MESSAGE [NSString stringWithFormat:@"HAVE_UNREAD_WORKCIRCLE_MESSAGE_%@",VAL_HXACCOUNT]
#define VAL_HAVE_UNREAD_WORKCIRCLE_MESSAGE [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"HAVE_UNREAD_WORKCIRCLE_MESSAGE_%@",VAL_HXACCOUNT]]

//商务推广分享店链接字典
#define ALL_SHARE_DIC [NSString stringWithFormat:@"AllShareUrl_%@",VAL_HXACCOUNT]
#define VAL_ALL_SHARE_DIC [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"AllShareUrl_%@",VAL_HXACCOUNT]]

#define KSocketNotify @"socketNotify" // 推送的内容
#define VAL_SocketNotify [[NSUserDefaults standardUserDefaults] valueForKey:KSocketNotify]
/** 超享+推送  (字典，key=type字符串, value=textMsg字典数组)*/
#define kPushesKey [@"cxp_push_" stringByAppendingString:([VAL_USERID stringValue] ?: @"unlogin")]
#define VAL_PUSHES [[NSUserDefaults standardUserDefaults] dictionaryForKey:kPushesKey]
#define VAL_PUSHES_MSGS(type) (VAL_PUSHES[type])
#define VAL_PUSHES_RESET(pushesDict) \
    [[NSUserDefaults standardUserDefaults] setObject:pushesDict forKey:kPushesKey]; \
    [[NSUserDefaults standardUserDefaults] synchronize];
#define VAL_PUSHES_HAVE_NEW(...) ([CXPushHelper haveNew:__VA_ARGS__, nil])
#define VAL_PUSHES_HAVEREAD_NEW(...) ([CXPushHelper haveRead:__VA_ARGS__, nil])
#define VAL_PUSHES_SET_READED(type) \
    NSMutableDictionary *temp_v_pushes = [VAL_PUSHES mutableCopy];\
    [temp_v_pushes removeObjectForKey:type];\
    VAL_PUSHES_RESET(temp_v_pushes);\
    [[NSNotificationCenter defaultCenter] postNotificationName:kReadPushNotificationKey object:nil userInfo:@{kPushTypeKey : type}];
#define VAL_AddNumBadge(...) ([cell.contentView addNumBadge:__VA_ARGS__, nil])
/** 收到推送的通知 */
#define kReceivePushNotificationKey @"cxp_push_notification"
/** 已读某类型的推送 */
#define kReadPushNotificationKey @"cxp_push_readed"
/** 推送类型key */
#define kPushTypeKey @"type"
/** 推送消息key */
#define kPushMsgKey @"textMsg"
/// 语音会议key
#define KIMVoiceGroup [@"IMVoiceGroup_" stringByAppendingString:[VAL_USERID stringValue]]


/** 当前用户是否已经加入推广群的Key */
#define IMUserHasdJoinExtensionGroupKey @"IMUserHasdJoinExtensionGroupKey"
/** 当前用户是否已经加入推广群 */
#define VAL_IMUserHasdJoinExtensionGroupKey YES


/** 显示注册帐号和忘记密码forgetStatusKey(2为隐藏) */
#define kForgetStatusKey @"kForgetStatusKey"
#define VAL_kForgetStatusKey [[NSUserDefaults standardUserDefaults] valueForKey:kForgetStatusKey]

#define CXIM_RefetchMessages_Notification @"refetchMesssages"

/** Device Token */
#define kDeviceTokenKey @"deviceToken"
#define VAL_DeviceToken [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceTokenKey]

#endif
