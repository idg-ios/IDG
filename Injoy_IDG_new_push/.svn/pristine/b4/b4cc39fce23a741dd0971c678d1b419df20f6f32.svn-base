//
// Created by ^ on 2017/10/27.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXApprovalListView.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXApprovalListCell.h"
#import "CXBaseRequest.h"
#import "CXApprovalListModel.h"

@interface CXApprovalListView ()
        <
        UITableViewDelegate,
        UITableViewDataSource
        >
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) BusinessType btype;
@end

@implementation CXApprovalListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.listTableView];
        if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
        }

        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - get & set

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.clipsToBounds = YES;
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.estimatedRowHeight = 0.f;
        _listTableView.estimatedSectionHeaderHeight = 0.f;
        _listTableView.estimatedSectionFooterHeight = 0.f;
        [_listTableView registerClass:[CXApprovalListCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)setBid:(NSString *)bid bType:(BusinessType)btype {
    _btype = btype;
    NSString *url = [NSString stringWithFormat:@"%@approvalset/getApprovalList", urlPrefix];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:2];
    param[@"l_bid"] = bid;
    param[@"i_type"] = [NSString stringWithFormat:@"%d", btype];

    [self.dataSourceArr removeAllObjects];
    @weakify(self);
    [CXBaseRequest postResultWithUrl:url
                               param:param
                             success:^(id responseObj) {
                                 CXApprovalListModel *model = [CXApprovalListModel yy_modelWithDictionary:responseObj];
                                 if (HTTPSUCCESSOK == model.status) {
                                     [self.dataSourceArr addObjectsFromArray:model.data];
                                     [self.listTableView reloadData];
                                 }
                                 @strongify(self);
                                 [self.listTableView reloadData];
                             } failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
}

- (void)btnEvent:(UIButton *)sender {
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    CXApprovalListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXApprovalListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAction:self.dataSourceArr[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"cellID" cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell setAction:self.dataSourceArr[indexPath.row]];
    }];
    if (height < SDCellHeight) {
        height = SDCellHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (![self.dataSourceArr count]) {
        return CGFLOAT_MIN;
    }
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, GET_WIDTH(tableView), 30.f)];
    headView.backgroundColor = kColorWithRGB(242.f, 241.f, 247.f);

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kColorWithRGB(59.f, 58.f, 63.f);

    NSString *title = nil;
    if (self.btype == BusinessType_JK) {
        title = @"借支批阅";
    }
    if (self.btype == BusinessType_QJ) {
        title = @"请假批阅";
    }
    if (self.btype == BusinessType_SW) {
        title = @"报告批阅";
    }
    if (self.btype == BusinessType_OW) {
        title = @"外出批阅";
    }

    titleLabel.text = title;

    titleLabel.font = kFontSizeForDetail;
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headView);
    }];

    if (![self.dataSourceArr count]) {
        return nil;
    }
    return headView;
}

@end
