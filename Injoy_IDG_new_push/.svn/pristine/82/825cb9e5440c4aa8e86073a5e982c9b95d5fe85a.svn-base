//
//  SDLoginViewController.m
//  SDMarketingManagement
//
//  Created by Mac on 15-4-30.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "HttpTool.h"
#import "NSString+TextHelper.h"
#import "SDDataBaseHelper.h"
#import "SDLoginViewController.h"
#import "SDRegisterPhoneController.h"
#import "SDSocketCacheManager.h"
#import "SDSubLoginView.h"
#import "SDUserCurrentLocation.h"
#import "SDWebSocketManager.h"
#import "YYModel.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+YYAdd.h"
#import "CXStaticDataHelper.h"
#import "CXLoaclDataManager.h"
#import "CXDepartmentUtil.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SDLoginViewController () {
    //保存之前的登录界面的frame
    CGRect _loginViewFrame;
}

/// 初始化数值
- (void)setupValue;

//用户名
@property(nonatomic, strong) NSString *rememberUserName;
//logo
@property(nonatomic, weak) UIImageView *logoImageView;
@property(nonatomic, strong) SDUserCurrentLocation *userLocation;

@end

@implementation SDLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    // 修改密码后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"dismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];

    //检查版本更新没问题 ，自动登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoginSoftware) name:@"autoLoginSoftware" object:nil];
}

- (void)autoLoginSoftware {
    //自动登录功能
    NSUserDefaults *loginDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pwd = [loginDefaults valueForKey:@"pwd"];
    NSString *account = [loginDefaults valueForKey:@"account"];
    //打开应用直接登录,用户名和密码存在，直接登录
    if (pwd.length && account.length) {
        [self login:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


#pragma mark--初始化界面

- (void)creatUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height + kTabbarSafeBottomMargin)];
    [backgroundImageView setImage:Image(@"bg")];
    [self.view addSubview:backgroundImageView];


    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SDSubLoginView" owner:self options:nil];
    _subLoginView = array[0];
    
    //弹一下
    _subLoginView.frame = CGRectMake(20, 40, Screen_Width - 40, _subLoginView.frame.size.height > Screen_Height / 1.3 ? _subLoginView.frame.size.height : Screen_Height / 1.3);

    CGFloat offSize = 75;
    [UIView animateWithDuration:.66 animations:^{
        _subLoginView.frame = CGRectMake(20, 40 - offSize, Screen_Width - 40, _subLoginView.frame.size.height > Screen_Height / 1.3 ? _subLoginView.frame.size.height : Screen_Height / 1.3);
    } completion:^(BOOL finished) {
        _subLoginView.alpha = 1;
    }];

    _subLoginView.backgroundColor = [UIColor clearColor];
    // 手机号码
    _subLoginView.myAccount.delegate = self;
    // 密码
    _subLoginView.password.delegate = self;
    _loginViewFrame = _subLoginView.frame;
    [self.view addSubview:_subLoginView];

    
//    UIImageView *logo = [[UIImageView alloc] init];
//    logo.frame = CGRectMake(self.view.center.x-(187/2),(self.view.frame.size.height-56)/3 , 187, 56);
////    logo.centerX = self.view.center.x-187;
////    logo.centerY = self.view.frame.size.height/3;
//    logo.image = [UIImage imageNamed:@"logo"];
//    [self.view addSubview:logo];

    //处理iphone 4s  键盘遮挡输入框
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealKeyBoardShow:) name:UIKeyboardWillShowNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealKeyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    [self setupValue];
}

#pragma mark 键盘显示
- (void)dealKeyBoardShow:(NSNotification *)notification {
    if (_subLoginView.frame.origin.y < 0) {
        return;
    }

    NSValue *keyBoardFrameValue = notification.userInfo[UIKeyboardFrameBeginUserInfoKey];
    CGRect keyBoardFrame;
    _subLoginView.frame = _loginViewFrame;

    [keyBoardFrameValue getValue:&keyBoardFrame];

    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect frame = _subLoginView.frame;
                         frame.origin.y -= keyBoardFrame.size.height / 1.9;
                         _subLoginView.frame = frame;

                         //图片同时上移
                         [self.logoImageView setTransform:CGAffineTransformMakeTranslation(0, -keyBoardFrame.size.height / 1.9)];
                     }];
}

#pragma mark 键盘隐藏
- (void)dealKeyBoardHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25
                     animations:^{
                         _subLoginView.frame = _loginViewFrame;
                         //logo图片恢复形变
                         [self.logoImageView setTransform:CGAffineTransformIdentity];

                     }];
}

#pragma mark--初始化数值
- (void)setupValue {
    if ([urlPrefix rangeOfString:@"api_public"].location != NSNotFound) {
        return;
    }

    NSUserDefaults *loginDefaults = [NSUserDefaults standardUserDefaults];
    [_rememberPwd setOn:YES];
    NSString *pwd = [loginDefaults stringForKey:@"pwd"];
    _subLoginView.password.text = pwd;
    NSString *account = [loginDefaults stringForKey:@"account"];    // 手机号码
    _subLoginView.myAccount.text = account;
    
    [_subLoginView.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark--登录
- (void)login:(id)sender {
    //放下键盘
    [self.view endEditing:YES];

    if (![self isEmpty]) {
        //支持是否为中文
        if ([self.userName.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                    initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                          message:nil
                         delegate:nil
                cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                otherButtonTitles:nil];

            [alert show];
        }
        [self loginUser];
    }
}

#pragma mark--点击登录后的操作

- (void)loginUser {
    //点击登录后不能总是点击
    _subLoginView.loginBtn.enabled = NO;
    [[SDCommonDefine sharedInstance] systemUse];

    NSString *url = [NSString stringWithFormat:@"%@login", urlPrefix];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:_subLoginView.myAccount.text forKey:@"account"];
    [params setValue:[NSString md5:[NSString md5:_subLoginView.password.text]] forKey:@"password"];
    params[@"appOs"] = @"ios";
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];

    __weak typeof(self) weakSelf = self;
    
    [HttpTool postWithPath:url
                    params:params
                   success:^(id JSON) {
                       NSDictionary *dict = JSON;
                       NSDictionary *dataDict = dict[@"data"];
                       
                       NSDictionary *approveRight = dataDict[@"approveRight"];//获取审批的权限
                       [[NSUserDefaults standardUserDefaults] setBool:[approveRight[@"holidatApprove"] boolValue] forKey:HAS_RIGHT_QJPS];
                       [[NSUserDefaults standardUserDefaults] setBool:[approveRight[@"costApprove"] boolValue] forKey:HAS_RIGHT_BXPS];
                       [[NSUserDefaults standardUserDefaults] setBool:[approveRight[@"travelApprove"] boolValue] forKey:HAS_RIGHT_CCPS];
                       [[NSUserDefaults standardUserDefaults] synchronize];
             
                       //统计报表isShare为1，统计报表有分享，为0则没有分享
                       NSNumber *isShare = dict[@"data"][@"isShare"];
                       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                       [defaults setObject:isShare forKey:kShareForERPStatisticsType];
                       [defaults synchronize];

                       // 静态数据{staticList}
                       [defaults setValue:[dict valueForKeyPath:@"data.staticList"] forKey:KStaticData];

                       NSNumber *status = [dict objectForKey:@"status"];
                       if (status.intValue == 200) {
                           [weakSelf rememberUser];
                           // 公司id
                           NSString *companyId = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"companyId"]];
                           if ([companyId length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:companyId forKey:COMPANYID];
                           }
                           // 公司名称
                           NSString *companyName = [dataDict valueForKey:@"companyName"];
                           if ([companyName length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:companyName forKey:KCompanyName];
                           }
                           
                           // 定制启动页
                           NSString *s_logo = [dataDict valueForKey:@"iosLogo4"];
                           if ([s_logo length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@^%@",s_logo,VAL_companyId] forKey:KCompanyLogo];
                           } else {
                               [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:KCompanyLogo];
                           }
                           
                           // 部门名称
                           NSString *dpName = [dataDict valueForKey:@"dpName"];
                           if ([dpName length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:dpName forKey:KDpName];
                           }
                           // 用户名称
                           NSString *userName = [dataDict valueForKey:@"userName"];
                           if ([userName length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:userName forKey:kUserName];
                           }
                           // 账号
                           NSString *account = [dataDict valueForKey:@"account"];
                           if ([account length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:account forKey:kAccount];
                           }
                           // 职务
                           NSString *job = [dataDict valueForKey:@"job"];
                           if (![job isKindOfClass:[NSNull class]] && [job length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:job forKey:KJob];
                           }
                           // 下载链接或者官网链接
                           NSString *iosdownload = [dataDict valueForKey:@"ios_download"];
                           if ([iosdownload length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:iosdownload forKey:IOS_DOWNLOAD];
                           }
                           // 用户ID
                           NSNumber *userID = [dataDict valueForKey:@"eid"];// 用户ID
                           if ([userID.stringValue length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:userID forKey:KUserID];
                           }
                           
                           // 是否是超级用户
                           NSNumber *isSuper = [dataDict objectForKey:@"isSuper"];
                           [[NSUserDefaults standardUserDefaults] setInteger:isSuper.integerValue forKey:KIsSuper];
                           
                           // 超级用户状态
                           NSNumber *superStatus = [dataDict objectForKey:@"superStatus"];
                           [[NSUserDefaults standardUserDefaults] setInteger:superStatus.integerValue forKey:KSuperStatus];
                           
                           // 用户类型 1=公司管理员，2=普通用户
                           NSNumber *userType = [dataDict objectForKey:@"userType"];
                           [[NSUserDefaults standardUserDefaults] setObject:userType forKey:KUserType];

                           // dpId
                           NSNumber *dpId = [dataDict valueForKey:KDpId];
                           if (dpId) {
                               [[NSUserDefaults standardUserDefaults] setValue:dpId forKey:KDpId];
                           }
                           // 用户身份层次
                           NSString *userLevel = [NSString stringWithFormat:@"%@", [dataDict valueForKey:@"level"]];
                           if ([userLevel length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:userLevel forKey:KUserlevel];
                           }
                           // 公司level
                           NSString *companyLevel = [NSString stringWithFormat:@"%@", [dataDict valueForKey:@"companyLevel"]];
                           if ([companyLevel length] > 0) {
                               [[NSUserDefaults standardUserDefaults] setValue:companyLevel forKey:KCompanylevel];
                           }
                           // 头像路径
                           NSString *icon = [dataDict objectForKey:@"icon"];
                           if ([icon isKindOfClass:NSNull.class]) {
                               icon = nil;
                           }
                           [[NSUserDefaults standardUserDefaults] setValue:icon forKey:kIcon];
                           // im帐号
                           NSString *hUser = [dataDict objectForKey:@"imAccount"];
                           if ([hUser length] > 0) {
                               // 将IM用户名保存在本地
                               [[NSUserDefaults standardUserDefaults] setValue:hUser forKey:HXACCOUNT];
                           }
                           // im帐号是否启用：1:启用，0:停用
                           NSString *imStatus = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"imStatus"]];
                           if ([imStatus length] > 0) {
                               // 将IM用户名保存在本地
                               [[NSUserDefaults standardUserDefaults] setValue:imStatus forKey:KImStatus];
                           }

                           // 权限菜单
                           NSArray *menulist = [[dataDict objectForKey:@"menuList"] mutableCopy];
                           if ([menulist count] > 0) {
                               // 将IM用户名保存在本地
                               [[NSUserDefaults standardUserDefaults] setValue:menulist forKey:KMenuList];
                           }
                           
                           BOOL isZhuanShuDingZhi = ([[dataDict objectForKey:@"level"] integerValue] == 2)?YES:NO;
                           NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                           [ud setBool:isZhuanShuDingZhi forKey:ISZHUAN_SHU_DING_ZHI];
                           
                           BOOL isShowAnnualMeeting = ([[dataDict objectForKey:@"showAnnualMeeting"] integerValue] == 1)?YES:NO;
                           [ud setBool:isShowAnnualMeeting forKey:ISSHOW_ANNUALMEETING];
                           
                           BOOL isUpdatePwd = ([[dataDict objectForKey:IS_Update_Pwd] integerValue] == 1)?YES:NO;
                           [ud setBool:isUpdatePwd forKey:IS_Update_Pwd];
                           
                           //是否是临时人员,是否有年会
                           BOOL isAnnualTem;
                           if (isShowAnnualMeeting && [[dataDict objectForKey:IS_AnnualTem] integerValue] == 1) {
                               isAnnualTem = YES;
                           } else {
                               isAnnualTem = NO;
                           }
                           [ud setBool:isAnnualTem forKey:IS_AnnualTem];
                           
                           BOOL isOpenGetLocation = ([[dataDict objectForKey:@"s_location"] integerValue] == 1)?YES:NO;
                           [ud setBool:isOpenGetLocation forKey:OPEN_GET_LOCATION];
                           
                           // 是否开启已阅未阅
                           BOOL isOpenReadFlag = ([[dataDict objectForKey:@"s_read"] integerValue] == 1) ? YES : NO;
                           [ud setBool:isOpenReadFlag forKey:OPEN_READ_FLAG];

                           //如果未保存权限设置则需要保存权限设置
                           if (VAL_HAD_SAVE_RedViewShow == nil) {
                               NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                               [ud setValue:[NSString stringWithFormat:@"已经保存%@红点开关", VAL_HXACCOUNT] forKey:HAD_SAVE_RedViewShow];
                               [ud setBool:NO forKey:SHOW_ADD_FRIENDS];
                               [ud setBool:NO forKey:HAVE_UNREAD_WORKCIRCLE_MESSAGE];
                               [ud synchronize];
                           }

                           // token
                           [[NSUserDefaults standardUserDefaults] setValue:[dataDict valueForKey:@"token"] forKey:key_token];

                           NSString *updateTime = [dataDict objectForKey:@"updateTime"];
                           if ([updateTime length] > 0) {
                               // 将环信用户名保存在本地
                               [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:kUpdateTime];
                           }

                           NSString *yaoUrl = [dataDict objectForKey:YAOURL];
                           yaoUrl = [yaoUrl stringByReplacingOccurrencesOfString:@"{userId}" withString:[NSString stringWithFormat:@"%zd", [VAL_USERID integerValue]]];
                           [[NSUserDefaults standardUserDefaults] setValue:yaoUrl forKey:YAOURL];

                           //是否已经加入推广群
                           NSString *applyGroup = [dataDict objectForKey:@"applyGroup"];
                           if (applyGroup && [applyGroup isEqualToString:@"1"]) {
                               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IMUserHasdJoinExtensionGroupKey];
                           } else {
                               [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IMUserHasdJoinExtensionGroupKey];
                           }
                           [[NSUserDefaults standardUserDefaults] synchronize];

                           [[CXDepartmentUtil sharedInstance] getDepartmentDataFromServer];
                           
                           [weakSelf imLoginWithUsername:hUser password:weakSelf.subLoginView.password.text];
                       } else {
                           TTAlertNoTitle(JSON[@"msg"]);
                           [weakSelf hideHud];
                       }
                   }
                   failure:^(NSError *error) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                       [alert show];
                       //请求返回可以点击登录按钮
                       weakSelf.subLoginView.loginBtn.enabled = YES;
                       [weakSelf hideHud];
                   }];
}

//登陆状态改变
- (void)loginStateChange:(NSNotification *)notification {
    BOOL loginSuccess = [notification.object boolValue];
    if (!loginSuccess) {
        [self hideHud];
        self.subLoginView.loginBtn.enabled = YES;
    }
}

#pragma mark IM登陆

- (void)imLoginWithUsername:(NSString *)username password:(NSString *)password {
//#ifdef DEBUG
//    // 屏蔽im登录
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//    [SDDataBaseHelper shareDB];
//    return;
//
//#endif
    //请求返回可以点击登录按钮
    self.subLoginView.loginBtn.enabled = YES;

    [SDWebSocketManager shareWebSocketManager]; // 初始化SDWebSocketManager添加代理
    [self showHudInView:self.view hint:@"正在加载信息"];
    __weak typeof(self) weakSelf = self;

    [[CXIMService sharedInstance] loginWithAccount:username password:password completion:^(NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *groups = [[CXIMService sharedInstance].groupManager loadGroupsFromDB];
                [[CXLoaclDataManager sharedInstance] saveLocalGroupDataWithGroups:groups];
                [self downloadTXL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CXPushHelper updateDeviceToken];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                    [SDDataBaseHelper shareDB];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil];
                    [weakSelf hideHud];
                    
                    ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer.fireDate = [NSDate distantPast];
                });
            });

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:KNetworkFailRemind delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [weakSelf hideHud];
            //请求返回可以点击登录按钮
            self.subLoginView.loginBtn.enabled = YES;
            [self hideHud];
            [weakSelf hideHud];
        }
    }];
}

- (void)downloadTXL{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"%@/sysuser/new/list", urlPrefix];
        
        [HttpTool getWithPath:url params:nil success:^(id JSON) {
            NSNumber *status = JSON[@"status"];
            if ([status intValue] == 200) {
                [[CXLoaclDataManager sharedInstance].depKJArray removeAllObjects];
                [[CXLoaclDataManager sharedInstance].allKJDicContactsArray removeAllObjects];
                [[CXLoaclDataManager sharedInstance].allKJDepDataArray removeAllObjects];
                [[CXLoaclDataManager sharedInstance].depArray removeAllObjects];
                [[CXLoaclDataManager sharedInstance].allDicContactsArray removeAllObjects];
                [[CXLoaclDataManager sharedInstance].allDepDataArray removeAllObjects];
                NSArray * contactsArray = JSON[@"data"][@"contacts"];
                for(NSDictionary * depDataDic in contactsArray){
                    [[CXLoaclDataManager sharedInstance].depKJArray addObject:depDataDic.allKeys[0]];
                    NSArray * depDataArray = depDataDic.allValues[0];
                    //用来保存每一组的userModelArray
                    NSMutableArray * depUsersArray = @[].mutableCopy;
                    for(NSDictionary * contactDic in depDataArray){
                        NSMutableDictionary * mutableDic = contactDic.mutableCopy;
                        if([mutableDic[@"icon"] isKindOfClass:[NSNull class]]){
                            mutableDic[@"icon"] = @"";
                        }
                        [[CXLoaclDataManager sharedInstance].allKJDicContactsArray addObject:mutableDic];
                        
                        SDCompanyUserModel *userModel = [SDCompanyUserModel yy_modelWithDictionary:contactDic];
                        userModel.userId = @([contactDic[@"userId"] integerValue]);
                        [depUsersArray addObject:userModel];
                    }
                    NSMutableDictionary * userDic = [NSMutableDictionary dictionary];
                    [userDic setValue:depUsersArray forKey:depDataDic.allKeys[0]];
                    [[CXLoaclDataManager sharedInstance].allKJDepDataArray addObject:userDic];
                }
                
                NSArray * allContactsArray = JSON[@"data"][@"allContacts"];
                for(NSDictionary * depDataDic in allContactsArray){
                    [[CXLoaclDataManager sharedInstance].depArray addObject:depDataDic.allKeys[0]];
                    NSArray * depDataArray = depDataDic.allValues[0];
                    //用来保存每一组的userModelArray
                    NSMutableArray * depUsersArray = @[].mutableCopy;
                    for(NSDictionary * contactDic in depDataArray){
                        NSMutableDictionary * mutableDic = contactDic.mutableCopy;
                        if([mutableDic[@"icon"] isKindOfClass:[NSNull class]]){
                            mutableDic[@"icon"] = @"";
                        }
                        [[CXLoaclDataManager sharedInstance].allDicContactsArray addObject:mutableDic];
                        
                        SDCompanyUserModel *userModel = [SDCompanyUserModel yy_modelWithDictionary:contactDic];
                        userModel.userId = @([contactDic[@"userId"] integerValue]);
                        [depUsersArray addObject:userModel];
                    }
                    NSMutableDictionary * userDic = [NSMutableDictionary dictionary];
                    [userDic setValue:depUsersArray forKey:depDataDic.allKeys[0]];
                    [[CXLoaclDataManager sharedInstance].allDepDataArray addObject:userDic];
                }
                [[CXLoaclDataManager sharedInstance] saveLocalFriendsDataWithFriends:[CXLoaclDataManager sharedInstance].allKJDicContactsArray];
                
                [[CXLoaclDataManager sharedInstance] saveSearchLocalFriendsDataWithFriends:[CXLoaclDataManager sharedInstance].allDicContactsArray];
            }else{
                
            }
        } failure:^(NSError *error) {
            
        }];
    });
}

#pragma mark--登录前操作

/// 记住帐号
- (void)rememberUser {
    NSUserDefaults *loginDefaults = [NSUserDefaults standardUserDefaults];
    [loginDefaults setObject:_subLoginView.password.text forKey:@"pwd"];
    [loginDefaults setObject:_subLoginView.myAccount.text forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 判断账号和密码是否为空
- (BOOL)isEmpty {
    BOOL ret = NO;
    NSString *username = _subLoginView.myAccount.text;
    NSString *password = _subLoginView.password.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.inputNameAndPswd", @"Please enter username and password") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
    }

    return ret;
}

#pragma mark--textfield 代理

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark--键盘处理

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _subLoginView.myAccount) {
        if (![textField.text isEqualToString:self.rememberUserName]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _subLoginView.password.text = nil;
        }
    }
    return YES;
}

// 返回登录界面后清除密码
- (void)dismiss {
    NSUserDefaults *loginDefaults = [NSUserDefaults standardUserDefaults];
    [loginDefaults removeObjectForKey:@"pwd"];
    [loginDefaults synchronize];
    _subLoginView.password.text = nil;
}

#pragma mark <--找回密码-->

- (void)findPassword {
    SDRegisterPhoneController *forgetVC = [[SDRegisterPhoneController alloc] init];
    forgetVC.type = forgetPassWordType;
    forgetVC.isForgetPassword = YES;
    [self presentViewController:forgetVC animated:NO completion:nil];
}

#pragma mark-- 注册

- (void)registerUser:(id)sender {
    SDRegisterPhoneController *registerVC = [[SDRegisterPhoneController alloc] init];
    registerVC.type = registerType;
    [self presentViewController:registerVC animated:NO completion:nil];
}

#pragma mark-- 进入体验

- (void)experiessAction {
    SDRegisterPhoneController *registerVC = [[SDRegisterPhoneController alloc] init];
    registerVC.type = expressType;
    [self presentViewController:registerVC animated:NO completion:nil];
}

@end
