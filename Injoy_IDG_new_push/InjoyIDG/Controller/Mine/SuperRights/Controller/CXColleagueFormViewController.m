//
//  CXColleagueFormViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXColleagueFormViewController.h"
#import "CXEditLabel.h"
#import "HttpTool.h"
#import "CXMineDialogView.h"
#import "CXDeptSelectCell.h"
#import "UIView+CXCategory.h"
#import "UITableView+YYAdd.h"
#import "NSString+YYAdd.h"
#import "NSString+TextHelper.h"
#import "CXUserSelectController.h"
#import "NSDictionary+CXCategory.h"

@interface CXColleagueFormViewController () <CXMineDialogViewContentSource, UITableViewDataSource, UITableViewDelegate, CXMineDialogViewDelegate>

/** 名字 */
@property (nonatomic, strong) CXEditLabel *nameLabel;
/** 部门 */
@property (nonatomic, strong) CXEditLabel *deptLabel;
/** 职务 */
@property (nonatomic, strong) CXEditLabel *jobLabel;
/** 账号 */
@property (nonatomic, strong) CXEditLabel *accountLabel;
/** 上级 */
@property (nonatomic, strong) CXEditLabel *superiorLabel;
/** 密码 */
@property (nonatomic, strong) CXEditLabel *pwdLabel;
/** 选择部门的视图 */
@property (nonatomic, strong) CXMineDialogView *deptSelectView;
/** 创建部门的视图 */
@property (nonatomic, strong) CXMineDialogView *deptCreateView;
/** 部门数据 */
@property (nonatomic, copy) NSArray<CXDeptModel *> *depts;

@end

static NSString *const kSelectCellId = @"CXDeptSelectCelld";

@implementation CXColleagueFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    if (self.formType == CXFormTypeModify || self.formType == CXFormTypeDetail) {
        [self getUserDetail];
    }
}

- (void)setup {
    [self.RootTopView setNavTitle:@"新同事"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(onLeftBarItemTap)];
    [self.RootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(onRightBarItemTap)];
    
    self.deptSelectView = ({
        CXMineDialogView *dialogView = [[CXMineDialogView alloc] init];
        dialogView.title = @"所有部门";
        dialogView.contentSource = self;
        dialogView.delegate = self;
        dialogView;
    });
    
    self.deptCreateView = ({
        CXMineDialogView *dialogView = [[CXMineDialogView alloc] init];
        dialogView.title = @"新增部门";
        dialogView.contentSource = self;
        dialogView.delegate = self;
        dialogView;
    });
    
    self.nameLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, navHigh, Screen_Width - 2 * kFormViewMargin, kCellHeight)];
        label.title = @"姓　名：";
        [self.view addSubview:label];
        label;
    });
    
    UIView *line1 = [self createDividingLineBelowView:self.nameLabel];
    
    self.deptLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(line1), Screen_Width - 2 * kFormViewMargin, kCellHeight)];
        label.title = @"部　门：";
        @weakify(self);
        label.customActionBlock = ^(CXEditLabel *editLabel) {
            @strongify(self);
            self.depts = @[];
            UITableView *tableView = (UITableView *)self.deptSelectView.contentView;
            [tableView reloadData];
            [self.deptSelectView show];
            [self getDeptList];
        };
        [self.view addSubview:label];
        label;
    });
    
    UIView *line2 = [self createDividingLineBelowView:self.deptLabel];
    
    self.jobLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(line2), Screen_Width - 2 * kFormViewMargin, kCellHeight)];
        label.title = @"职　务：";
        [self.view addSubview:label];
        label;
    });
    
    UIView *line3 = [self createDividingLineBelowView:self.jobLabel];
    
    self.superiorLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(line3), Screen_Width - 2 * kFormViewMargin, kCellHeight)];
        label.title = @"上　级：";
        @weakify(self);
        label.customActionBlock = ^(CXEditLabel *editLabel) {
            @strongify(self);
            CXUserSelectController *vc = [[CXUserSelectController alloc] init];
            vc.title = @"选择上级";
            vc.multiSelect = NO;
            vc.displayOnly = NO;
            vc.selectType = SuperiorType;
            if (self.formType == CXFormTypeModify) {
                vc.selectSuperior_eid = self.eid;
            }
            vc.didSelectedCallback = ^(NSArray<CXUserModel *> *users) {
                editLabel.content = @"";
                editLabel.data = nil;
                if (users.count) {
                    editLabel.content = users.firstObject.name;
                    editLabel.data = @(users.firstObject.eid);
                }
            };
            vc.selectedUsers = @[];
            if (editLabel.data) {
                NSInteger eid = [(NSNumber *)editLabel.data integerValue];
                NSString *name = editLabel.content;
                CXUserModel *user = [[CXUserModel alloc] init];
                user.eid = eid;
                user.name = name;
                vc.selectedUsers = @[user];
            }
            [self.navigationController pushViewController:vc animated:YES];
        };
        [self.view addSubview:label];
        label;
    });
    
    UIView *line4 = [self createDividingLineBelowView:self.superiorLabel];
    
    self.accountLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(line4), Screen_Width - 2 * kFormViewMargin, kCellHeight)];
        label.inputType = CXEditLabelInputTypeNumber;
        label.title = @"账　号：";
        [self.view addSubview:label];
        label;
    });
    
    UIView *line5 = [self createDividingLineBelowView:self.accountLabel];
    
    self.pwdLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(line5), Screen_Width - 2 * kFormViewMargin, kCellHeight)];
        label.inputType = CXEditLabelInputTypeASCII;
        label.title = @"密　码：";
        [self.view addSubview:label];
        label;
    });
    
    UIView *line6 = [self createDividingLineBelowView:self.pwdLabel];
    [line6 hash];
}

#pragma mark - CXMineDialogViewContentSource
- (UIView *)contentViewOfDialogView:(CXMineDialogView *)dialogView {
    UITableView *deptTableView;
    CXEditLabel *deptLabel;
    if (dialogView == self.deptSelectView) {
        if (deptTableView == nil) {
            deptTableView = ({
                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
                [tableView disableTouchesDelay];
                [tableView registerClass:[CXDeptSelectCell class] forCellReuseIdentifier:kSelectCellId];
                tableView.rowHeight = 44;
                tableView.backgroundColor = [UIColor whiteColor];
                tableView.tableFooterView = [[UIView alloc] init];
                tableView.dataSource = self;
                tableView.delegate = self;
                tableView;
            });
        }
        return deptTableView;
    }
    else {
        if (deptLabel == nil) {
            deptLabel = ({
                CXEditLabel *label = [[CXEditLabel alloc] init];
                label.title = @"  部门名称：";
                label;
            });
        }
        return deptLabel;
    }
}

- (CGFloat)heightForContentView:(UIView *)contentView ofDialogView:(CXMineDialogView *)dialogView {
    if (dialogView == self.deptSelectView) {
        NSInteger maxRowCount = 4;
        UITableView *tableView = (UITableView *)contentView;
        return maxRowCount * tableView.rowHeight;
    }
    else {
        return 60;
    }
}

#pragma mark - CXMineDialogViewDelegate
- (void)dialogViewDidTapPrimaryButton:(CXMineDialogView *)dialogView {
    CXEditLabel *deptLabel = (CXEditLabel *)self.deptCreateView.contentView;
    if (dialogView == self.deptSelectView) {
        deptLabel.content = nil;
        [self.deptCreateView show];
    }
    else {
        NSString *deptName = trim(deptLabel.content);
        if (deptName.length <= 0) {
            CXAlert(@"部门名称不能为空");
            return;
        }
        HUD_SHOW(nil);
        [HttpTool postWithPath:@"/sysdept/save.json" params:@{@"name": deptName} success:^(NSDictionary *JSON) {
            HUD_HIDE;
            if ([JSON[@"status"] intValue] == 200) {
                [dialogView dismiss];
                [self getDeptList];
            }
            else {
                CXAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            HUD_HIDE;
            CXAlert(KNetworkFailRemind);
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.depts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXDeptSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectCellId];
    CXDeptModel *dept = self.depts[indexPath.row];
    cell.deptModel = dept;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CXDeptModel *dept = self.depts[indexPath.row];
    dept.selected = YES;
    [self.deptSelectView dismiss];
    self.deptLabel.content = dept.name;
    self.deptLabel.data = @(dept.eid);
}

#pragma mark - Event
- (void)onLeftBarItemTap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightBarItemTap {
    NSString *name = trim(self.nameLabel.content);
    NSNumber *deptId = self.deptLabel.data;
    NSString *deptName = trim(self.deptLabel.content);
    NSString *job = trim(self.jobLabel.content);
    NSNumber *pid = self.superiorLabel.data;
    NSString *account = trim(self.accountLabel.content);
    NSString *password = trim(self.pwdLabel.content);
    if (name.length <= 0) {
        CXAlert(@"姓名不能为空");
        return;
    }
    if (deptName.length <= 0) {
        CXAlert(@"请选择部门");
        return;
    }
    if (job.length <= 0) {
        CXAlert(@"职务不能为空");
        return;
    }
    if (pid == nil) {
        CXAlert(@"请选择上级");
        return;
    }
    if (account.length <= 0) {
        CXAlert(@"账号不能为空");
        return;
    }
    if ([account checkMobilePhone:account] == NO) {
        CXAlert(@"请输入正确的手机号");
        return;
    }
    if (self.formType == CXFormTypeCreate && password.length <= 0) {
        CXAlert(@"密码不能为空");
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"name"] = name;
    params[@"deptId"] = deptId;
    params[@"deptName"] = deptName;
    params[@"job"] = job;
    params[@"pid"] = pid;
    params[@"name"] = name;
    params[@"account"] = account;
    
    NSString *url;
    if (self.formType == CXFormTypeCreate) {
        NSString *md5Pwd = [[password md5String] md5String];
        params[@"password"] = md5Pwd;
        url = @"/sysuser/save.json";
    }
    else {
        params[@"eid"] = @(self.eid);
        if (password.length) {
            NSString *md5Pwd = [[password md5String] md5String];
            params[@"password"] = md5Pwd;
        }
        url = @"/sysuser/updateNewUser.json";
    }
    
    HUD_SHOW(nil);
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            !self.didPostSuccess ?: self.didPostSuccess();
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            CXAlert(JSON[@"msg"])
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - Private
- (UIView *)createDividingLineBelowView:(__kindof UIView *)view {
    UIView *dividingLine = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(view), Screen_Width, 1)];
    dividingLine.backgroundColor = kColorWithRGB(216, 216, 216);
    [view.superview addSubview:dividingLine];
    return dividingLine;
}

- (void)getDeptList {
    HUD_SHOW(nil);
    [HttpTool getWithPath:@"/sysdept/findDeptList.json" params:nil success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            self.depts = [NSArray yy_modelArrayWithClass:CXDeptModel.class json:JSON[@"data"]];
            if (self.deptLabel.data != nil) {
                NSInteger selectedDeptId = [(NSNumber *)self.deptLabel.data integerValue];
                [self.depts enumerateObjectsUsingBlock:^(CXDeptModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.eid == selectedDeptId) {
                        obj.selected = YES;
                    }
                }];
            }
            UITableView *tableView = (UITableView *)self.deptSelectView.contentView;
            [tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.depts.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            [tableView reloadData];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)getUserDetail {
    HUD_SHOW(nil);
    NSString *url = [NSString stringWithFormat:@"/sysuser/detail/%zd.json", self.eid];
    [HttpTool getWithPath:url params:nil success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            NSDictionary *data = JSON[@"data"];
            data = [data removeNSNull];
            [self setUserDetail:data];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)setUserDetail:(NSDictionary *)detail {
    self.nameLabel.content = detail[@"name"];
    self.deptLabel.data = detail[@"deptId"];
    self.deptLabel.content = detail[@"deptName"];
    self.jobLabel.content = detail[@"job"];
    self.superiorLabel.content = detail[@"pName"];
    self.superiorLabel.data = detail[@"pid"];
    self.accountLabel.content = detail[@"account"];
    self.accountLabel.allowEditing = NO;
//    self.pwdLabel.content = detail[@"password"];
}

@end
