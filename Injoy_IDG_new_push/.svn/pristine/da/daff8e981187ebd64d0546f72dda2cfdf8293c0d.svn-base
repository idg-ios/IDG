//
//  CXBussinessTripEditViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/16.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXBussinessTripEditViewController.h"
#import "CXEditLabel.h"
#import "HttpTool.h"
#import "UIView+YYAdd.h"
#import "CXBottomSubmitView.h"
#import "CXBussinessTripEditFooterView.h"
#import "CXBusinessTripEditHeaderView.h"
#import "CXBusinessTripCityModel.h"
#import "CXBusinessTripDetailModel.h"
#import "CXBusinessTripEditDataManager.h"
#import "CXApprovalAlertView.h"

#import "MBProgressHUD+CXCategory.h"

#define bottomViewHeight 57.f
#define margin 8.f
@interface CXBussinessTripEditViewController ()
@property(nonatomic, strong)SDRootTopView *rootTopView;
@property(nonatomic, strong)UIScrollView *contentScrollView;
@property(nonatomic, strong)CXBusinessTripEditHeaderView *headerView;
@property(nonatomic, strong)CXBussinessTripEditFooterView *footerView;
@property(nonatomic, strong)CXBottomSubmitView *submitView;
@property(nonatomic, strong)UIButton *addbtn;
@property(nonatomic, strong)UIView *zwView;
@property(nonatomic, strong)NSMutableArray *listItemArray;
@property(nonatomic, strong)NSArray *cityArray;
@property(nonatomic, strong)CXBusinessTripDetailModel *detaiModel;
@property(nonatomic, strong)CXBusinessTripEditDataManager *dataManager;
@end

@implementation CXBussinessTripEditViewController{
    UIView *line1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWithRGB(240, 240, 247);//差旅审批
    [self requestCitiesForTrip];
    [self.view addSubview:self.rootTopView];
    if(!self.eid){
        [self setUpUI];
    }
    
    // Do any additional setup after loading the view.
}
#pragma mark - 业务逻辑
- (void)setUpUI{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh-bottomViewHeight*2)];
    _contentScrollView.backgroundColor = kColorWithRGB(255, 255, 255);
    [_contentScrollView addSubview:self.headerView];
    [_contentScrollView addSubview:self.zwView];
    [_contentScrollView addSubview:self.footerView];
    [_contentScrollView bringSubviewToFront:self.footerView];
    _contentScrollView.contentSize = CGSizeMake(Screen_Width, self.footerView.bottom);
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.submitView];//底部点击
    if(self.type == isDetail){
        self.submitView.hidden = YES;
    }
}
- (void)requestDetaiData{
    NSString *url = [NSString stringWithFormat:@"%@travel/detail/%zd",urlPrefix, self.eid];
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool getWithPath:url params:nil success:^(id JSON){
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if([JSON[@"status"]integerValue] == 200){
            self.detaiModel = [CXBusinessTripDetailModel yy_modelWithJSON:JSON[@"data"]];
             self.dataManager.model = self.detaiModel;
            [self setUpUI];
        }
        else{
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
    }];
}

- (void)approvalActionWithAgree:(BOOL)agree remark:(NSString *)remark {
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    NSString *url = [NSString stringWithFormat:@"%@travel/doApprove",urlPrefix];
    NSString *applyId = [self.applyId componentsSeparatedByString:@"."].firstObject;
    NSDictionary *params = @{@"eid":applyId ? : @"",
                             @"isApprove":agree ? @(2) : @(3),
                             @"reason": remark ? : @""};
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:2];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        CXAlert(KNetworkFailRemind);
    }];
    /*
    NSString *applyId = [self.applyId componentsSeparatedByString:@"."].firstObject;
    CXApprovalAlertView *approvalAlertView = [[CXApprovalAlertView alloc]
                                              initWithBid:applyId
                                              btype:self.eid andTitle:@"出差"];
    @weakify(self);
    approvalAlertView.callBack = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        if (self.callBack) {
            self.callBack();
        }
    };
    [approvalAlertView show];
     */
}

- (void)dataSubmitToServer{
    bool sucess = [self.headerView checkData];
    if(!sucess){
        return;
    }else{
       sucess =  [self.footerView checkData];
        if(!sucess){
            return;
        }
    }
    NSString *url = [NSString stringWithFormat:@"%@travel/save.json",urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.dataManager.model.tripType?:@"" forKey:@"tripType"];
    [params setValue:self.dataManager.startCityJsonString?:@"" forKey:@"startCity"];
    [params setValue:self.dataManager.targetCitiesJsonString?:@"" forKey:@"targetCitys"];
    [params setValue:self.dataManager.model.startDate?:@"" forKey:@"startDate"];
    [params setValue:self.dataManager.model.endDate?:@"" forKey:@"endDate"];
    if(self.dataManager.model.budget){
        [params setValue:self.dataManager.model.budget forKey:@"budget"];
    }
    //处理备注是空格或者换行开始结尾的bug,导致对齐样式错误
    [params setValue:[self.dataManager.model.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ? : @" " forKey:@"remark"];
    HUD_SHOW(nil)
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool postWithPath:url params:params success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        HUD_HIDE
        if([JSON[@"status"]integerValue] == 200){
            CXAlertExt(@"提交成功", ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
//        else if ([JSON[@"status"] intValue] == 400) {
//            [self.contentScrollView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//        }
        else{
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        HUD_HIDE
        CXAlert(KNetworkFailRemind);
    }];
}
- (void)requestCitiesForTrip{
    NSString *url = [NSString stringWithFormat:@"%@travel/cityList.json",urlPrefix];
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool getWithPath:url params:nil success:^(id JSON){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if([JSON[@"status"]integerValue] == 200){
            self.cityArray = [NSArray yy_modelArrayWithClass:[CXBusinessTripCityModel class] json:JSON[@"data"]];
            self.dataManager.cityArray = self.cityArray.copy;
            if(self.eid){
                [self requestDetaiData];
            }else{
                self.headerView.cityArray = self.cityArray;
            }
        }else{
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error){
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        CXAlert(@"出差城市列表获取失败");
    }];
}
- (void)updateFooterView{

    self.contentScrollView.contentSize = CGSizeMake(Screen_Width, self.footerView.bottom);;
    
}
- (void)updateHeaderView{
    self.zwView.top = self.headerView.bottom;
    self.footerView.top = self.zwView.bottom;
    self.contentScrollView.contentSize = CGSizeMake(Screen_Width, self.footerView.bottom);
}

#pragma mark - 懒加载
- (SDRootTopView *)rootTopView{
    if(nil == _rootTopView){
        _rootTopView = [self getRootTopView];
        [_rootTopView setNavTitle:@"差旅申请"];
        [_rootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    }
    return _rootTopView;
}
//- (UIScrollView *)contentScrollView{
//    if(nil == _contentScrollView){
//        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh-bottomViewHeight*2)];
//        _contentScrollView.backgroundColor = kColorWithRGB(255, 255, 255);
//        [_contentScrollView addSubview:self.headerView];
//        [_contentScrollView addSubview:self.zwView];
//        [_contentScrollView addSubview:self.footerView];
//        [_contentScrollView bringSubviewToFront:self.footerView];
//        _contentScrollView.contentSize = CGSizeMake(Screen_Width, self.footerView.bottom);
//    }
//    return _contentScrollView;
//}

- (CXBusinessTripEditHeaderView *)headerView{
    if(nil == _headerView){
        _headerView = [[CXBusinessTripEditHeaderView alloc]initWithFrame:CGRectZero dataModel:self.dataManager andType:self.type];
        CXWeakSelf(self)
        _headerView.viewUpdate = ^{
            [weakself updateHeaderView];
        };
    }
    return _headerView;
}

- (CXBussinessTripEditFooterView *)footerView{
    if(nil == _footerView){
    
        _footerView = [[CXBussinessTripEditFooterView alloc]initWithFrame:CGRectMake(0, self.zwView.bottom, Screen_Width, 0) dataModel:self.dataManager andType:self.type approvalStatue:self.approvalStatue];
        _footerView.approvalStatue = self.approvalStatue;
        CXWeakSelf(self)
        _footerView.updateFrame = ^{
            [weakself updateFooterView];
        };
    }
    return _footerView;
}
- (CXBottomSubmitView *)submitView{
    if(nil == _submitView){
        CXWeakSelf(self)
        _submitView = [[CXBottomSubmitView alloc]initWithFrame:CGRectMake(0, Screen_Height-bottomViewHeight, Screen_Width, bottomViewHeight) andType:(CXFormType)self.type];
        _submitView.callBack = ^(NSString *title){
            if([title isEqualToString:@"提  交"]){
                [weakself dataSubmitToServer];
            }else if ([title isEqualToString:@"同  意"]){
//                [weakself approvalAction];
                [weakself approvalActionWithAgree:YES remark:nil];
            }else if ([title isEqualToString:@"不同意"]){
                [weakself showActionController];
            }
        };
    }
    return _submitView;
}
- (void)showActionController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"批审" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 通过数组拿到textTF的值
        NSString *remark = [[alertController textFields] objectAtIndex:0].text;
        NSLog(@"ok, %@", [[alertController textFields] objectAtIndex:0].text);
        if (remark.length == 0 || [remark isEqualToString:@""]) {
            [MBProgressHUD toastAtCenterForView:self.view text:@"批审意见不能为空" duration:2];
//            [self showActionController];
            [self performSelector:@selector(showActionController) withObject:nil afterDelay:3.0];
        }else{
            [self approvalActionWithAgree:NO remark:remark];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action2];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}

//输入内容为空
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *remark = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        if (remark.text == nil || remark.text.length == 0) {
            [MBProgressHUD toastAtCenterForView:self.view text:@"批审意见不能为空" duration:2];
            return;
        }else{
            okAction.enabled = YES;
            [self approvalActionWithAgree:NO remark:remark.text];
        }
    }
}
- (NSMutableArray *)listItemArray{
    if(nil == _listItemArray){
        _listItemArray = [NSMutableArray array];
    }
    return _listItemArray;
}
- (UIView *)zwView{
    if(nil == _zwView){
        _zwView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom, Screen_Width, 10)];
        _zwView.backgroundColor = kColorWithRGB(240, 240, 247);
    }
    return _zwView;
}

- (NSArray *)cityArray{
    if(nil == _cityArray){
        _cityArray = @[].copy;
    }
    return _cityArray;
}
- (CXBusinessTripDetailModel *)detaiModel{
    if(nil == _detaiModel){
        _detaiModel = [[CXBusinessTripDetailModel alloc]init];
    }
    return _detaiModel;
}
- (CXBusinessTripEditDataManager *)dataManager{
    if(nil == _dataManager){
        _dataManager = [[CXBusinessTripEditDataManager alloc]init];
    }
    return _dataManager;
}


@end
