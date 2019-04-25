//
//  CXXJSPListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/4/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXXJSPListViewController.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXWDXJListCell.h"
#import "CXVacationApplicationEditViewController.h"
#import "CXBaseRequest.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"
#import "CXTopSwitchView.h"
#import "CXWDXJListModel.h"
#import "HttpTool.h"
#import "CXXJSPListApprovalAlertView.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXXJSPListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

/** 审批状态 */
typedef NS_ENUM(NSInteger, CXApprovalType) {
    /** 批审中 */
    CXApprovalTypeStart = 1,
    /** 同意 */
    CXApprovalTypeAgree = 2,
    /** 拒绝 */
    CXApprovalTyperefuse = 3
};

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) int pageNumber;
@property(strong, nonatomic) CXVacationApplicationModel *vacationApplicationModel;
@property(weak, nonatomic) CXTopSwitchView *topSwitchView;
@property(assign, nonatomic) CXApprovalType approvalType;


@end

@implementation CXXJSPListViewController

static NSString * const m_cellID = @"cellID";

#pragma mark - get & set

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [@[] mutableCopy];
    }
    return _dataSourceArr;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.estimatedRowHeight = 100.f;
        [_listTableView registerClass:[CXWDXJListCell class] forCellReuseIdentifier:m_cellID];
    }
    return _listTableView;
}
- (void)submitWithReason:(NSString *)reason agree:(BOOL)agree model:(CXWDXJListModel*)model{
    /*
     //此处销假审批的请求
     NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
     param[@"applyId"] = _applyId;//model.kid
     param[@"applyUser"] = _applyUser;//model.userName
     param[@"signed"] = [self.suggestion isEqualToString:@"同意"] ? @(2) : @(3);
     //        param[@"comments"] = trim(self.textView.text);
     param[@"reason"] = reason ? : @"";
     */
    [MBProgressHUD showHUDForView:self.view text:@"数据处理中,请稍候..."];
    NSString *url = [NSString stringWithFormat:@"%@holiday/resumption/approve", urlPrefix];
    NSDictionary *params = @{@"applyId":model.kid,
                             @"applyUser":model.userName,
                             @"signed":agree ? @(2) : @(3),
                             @"reason":reason ? : @""
                             };
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
        } else {
            
        }
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        [MBProgressHUD toastAtCenterForView:self.view text:@"成功" duration:3.0];
        //重新请求
        self.pageNumber = 1;
        [self.dataSourceArr removeAllObjects];
        [self findListRequest:self.approvalType];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        CXAlert(KNetworkFailRemind);
    }];
}
- (void)showActionControllerWithModel:(CXWDXJListModel *)model{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"批审" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *remark = [[alertController textFields] objectAtIndex:0].text;
        NSLog(@"ok, %@", [[alertController textFields] objectAtIndex:0].text);
        if (remark.length == 0 || [remark isEqualToString:@""]) {
            NSLog(@"点击的是==%@",model.kid);
            [MBProgressHUD toastAtCenterForView:self.view text:@"批审意见不能为空!" duration:3.0];
            [self performSelector:@selector(showActionControllerWithModel:) withObject:model afterDelay:2.0];
        }else{
            NSLog(@"点击的是==%@",model.kid);
//            [self submitWithReason:remark];
            [self submitWithReason:remark agree:NO model:model];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];

}


#pragma mark - instance function
- (void)findListRequest:(int)type {
    self.approvalType = type;
    
    NSString *url = [NSString stringWithFormat:@"%@holiday/resumption/approve/list", urlPrefix];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(type) forKey:@"signed"];
    [self.dataSourceArr removeAllObjects];
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            [self.dataSourceArr removeAllObjects];
            [self.listTableView.footer setHidden:YES];
            NSArray<CXWDXJListModel *> *data = [NSArray yy_modelArrayWithClass:[CXWDXJListModel class] json:JSON[@"data"]];
            [self.dataSourceArr addObjectsFromArray:data];
            [self.listTableView reloadData];
            
            NSLog(@"审批====数量%ld",self.dataSourceArr.count);
        } else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }              failure:^(NSError *error) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"销假审批"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
}

- (void)setUpTopView {
    CXTopSwitchView *topSwitchView = [[CXTopSwitchView alloc] init];
    @weakify(self);
    topSwitchView.callBack = ^(NSString *string) {
        @strongify(self);
        if ([@"审批中" isEqualToString:string]) {
            [self findListRequest:CXApprovalTypeStart];
        }
        if ([@"同意" isEqualToString:string]) {
            [self findListRequest:CXApprovalTypeAgree];
        }
        if ([@"驳回" isEqualToString:string]) {
            [self findListRequest:CXApprovalTyperefuse];
        }
    };
    self.topSwitchView = topSwitchView;
    [self.view addSubview:topSwitchView];
    [topSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(CXTopSwitchView_height);
        make.top.equalTo(self.rootTopView.mas_bottom);
    }];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.equalTo(self.topSwitchView.mas_bottom);
    }];
    
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.approvalType == CXApprovalTyperefuse ? UITableViewAutomaticDimension : 120;
    return UITableViewAutomaticDimension;
    CGFloat height = [tableView fd_heightForCellWithIdentifier:m_cellID cacheByIndexPath:indexPath configuration:^(id cell) {
        [((CXWDXJListCell *) cell) setAction:self.dataSourceArr[indexPath.row]];
    }];
    if (height < SDCellHeight + 20) {
        height = SDCellHeight + 20;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(self.approvalType == CXApprovalTypeStart){
        CXWDXJListModel * model = self.dataSourceArr[indexPath.row];
        CXXJSPListApprovalAlertView *approvalAlertView = [[CXXJSPListApprovalAlertView alloc] initWithWDXJListModel:model];
        [approvalAlertView show];
        approvalAlertView.back = ^(BOOL agree) {
            if (agree) {
                [self submitWithReason:nil agree:YES model:model];
            }else{
                [self showActionControllerWithModel:model];
            }
        };
    }
//        CXXJSPListApprovalAlertView *approvalAlertView = [[CXXJSPListApprovalAlertView alloc] initWithApplyId:model.kid applyUser:model.userName];
//        approvalAlertView.vc = self;
//        @weakify(self);
//        approvalAlertView.callBack = ^{////销假审批完成的回调
//            @strongify(self);
//            [self findListRequest:self.approvalType];
////            [self loadApproveNumberWithType:@"resumption"];//重新获取销假审批的数量
//        };
//        [approvalAlertView show];
//    }
}
////>>>>>>>>>>>>>>>mine
#pragma mark --更新对应类型的数量
- (void)loadApproveNumberWithType:(NSString *)type{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/%@",urlPrefix,type];
    NSDictionary *parmars = @{@"type":type};
    [HttpTool getWithPath:path params:parmars success:^(id JSON) {
        NSLog(@"获取带审批类型的数量==销假%@",JSON);//
        NSInteger status = [JSON[@"status"] integerValue];
        NSInteger data = [JSON[@"data"] integerValue];
        if (status == 200) {
            
            
            NSDictionary * textMsg = @{@"销假推送":@"销假推送"};
            NSMutableDictionary *pushes = [VAL_PUSHES mutableCopy];
            if (!pushes) {
                pushes = [NSMutableDictionary dictionary];
                VAL_PUSHES_RESET(pushes);
            }
            NSMutableArray *textMsgs;
//            textMsgs = [VAL_PUSHES_MSGS(IM_PUSH_XIAO) mutableCopy];//此处不需要之前的数据,这里返回多少条就是多少条
            if (!textMsgs) {
                textMsgs = [NSMutableArray array];
            }
            for(NSInteger i = 0; i < data; i++){
                [textMsgs addObject:textMsg];
            }
            pushes[IM_PUSH_XIAO] = textMsgs;
            VAL_PUSHES_RESET(pushes);
        }else if(data == 0){
            NSMutableDictionary * psh = [VAL_PUSHES mutableCopy];
            [psh removeObjectForKey:IM_PUSH_XIAO];
            VAL_PUSHES_RESET(psh);
        }
            
//
//
//            NSMutableArray *dataArray = [NSMutableArray array];
//            for (int i = 0; i<data; i ++) {//构建多条销假记录
//                NSDictionary *dictionary = @{@"销假推送":@"销假推送"};
//                [dataArray addObject:dictionary];
//            }
//            NSMutableDictionary *pushes = [VAL_PUSHES mutableCopy];
//            if (!pushes) {
//                pushes = [NSMutableDictionary dictionary];
//                VAL_PUSHES_RESET(pushes);
//            }
//            NSMutableArray *textMsgs;
//            textMsgs = [VAL_PUSHES_MSGS(IM_PUSH_XIAO) mutableCopy];
//            if (!textMsgs) {
//                textMsgs = [NSMutableArray array];
//            }
//            [textMsgs addObjectsFromArray:dataArray];
//            pushes[IM_PUSH_XIAO] = textMsgs;
//            VAL_PUSHES_RESET(pushes);
//
//
        
            
//        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSourceArr.count) {
//        CXWDXJListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID];
//        if (nil == cell) {
//            cell = [[CXWDXJListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_cellID];
//        }
        CXWDXJListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setAction:self.dataSourceArr[indexPath.row]];
        cell.model = self.dataSourceArr[indexPath.row];
        return cell;
    }
    return [[CXWDXJListCell alloc] init];
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   //页面返回,重新请求数据
    self.pageNumber = 1;
    [self.dataSourceArr removeAllObjects];
    [self findListRequest:self.approvalType];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpTableView];
    
    self.approvalType = CXApprovalTypeStart;
    
    @weakify(self);
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber = 1;
        [self.dataSourceArr removeAllObjects];
        [self findListRequest:self.approvalType];
    }];
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber++;
        if (self.pageNumber > self.vacationApplicationModel.totalPage) {
            self.pageNumber = self.vacationApplicationModel.totalPage;
            [self.listTableView.footer endRefreshing];
            return;
        }
        [self findListRequest:self.approvalType];
    }];
    self.listTableView.footer.hidden = YES;
    [self.listTableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
