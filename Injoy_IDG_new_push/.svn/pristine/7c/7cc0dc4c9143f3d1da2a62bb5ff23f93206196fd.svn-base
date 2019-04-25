//
//  CXHouseProjectBaseInfoViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectBaseInfoViewController.h"
#import "CXHouseProjectInfoView.h"
#import "HttpTool.h"
#import "CXHousProjectBaseInfoModel.h"
#import "MBProgressHUD+CXCategory.h"

@interface CXHouseProjectBaseInfoViewController ()
@property (nonatomic, strong) CXHouseProjectInfoView *infoView;
@property (nonatomic, strong) CXHousProjectBaseInfoModel *model;
@end

@implementation CXHouseProjectBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestServerData];
    self.view.backgroundColor = SDBackGroudColor;
}

- (void)requestServerData{
    NSString *url = [NSString stringWithFormat:@"%@/project/house/detail/%zd/base.json", urlPrefix, self.projId];
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:nil success:^(id JSON){
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if([JSON[@"status"]integerValue] == 200){
            self.model = [CXHousProjectBaseInfoModel yy_modelWithJSON:JSON[@"data"]];
            if(self.model){
                if(nil == _infoView){
                    [self.view addSubview:self.infoView];
                }
                self.infoView.model = self.model;
            }
        }
//        else if ([JSON[@"status"] intValue] == 400) {
//            [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//        }
        else{
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - 数据懒加载
- (CXHouseProjectInfoView *)infoView{
    if(nil == _infoView){
        _infoView = [[CXHouseProjectInfoView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, CGRectGetHeight(self.view.frame))];
    }
    return _infoView;
}
- (CXHousProjectBaseInfoModel *)model{
    if(nil == _model){
        _model = [[CXHousProjectBaseInfoModel alloc]init];
    }
    return _model;
}
@end
