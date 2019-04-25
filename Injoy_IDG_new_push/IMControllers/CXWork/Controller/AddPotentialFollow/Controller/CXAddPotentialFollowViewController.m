//
//  CXAddPotentialFollowViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAddPotentialFollowViewController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "NSDate+YYAdd.h"
#import "CXAddPotentialFollowVIew.h"
#import "CXYMNormalListCell.h"
#import "CXYMTextViewCell.h"
#import "CXYMPlaceholderTextView.h"
#import "ActionSheetDatePicker.h"
#import "CXYMActionSheetView.h"
#import "CXYMAppearanceManager.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXAddPotentialFollowViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

/** 接触时间 */
@property (nonatomic, strong) CXEditLabel *jcsjLabel;
/** 与会者 */
@property (nonatomic, strong) CXEditLabel *gjrLabel;
/** 跟进状态 */
@property (nonatomic, strong) CXEditLabel *gjztLabel;
/** keyNote */
@property (nonatomic, strong) CXEditLabel *keyNoteLabel;
/** keyNote */
@property (nonatomic, strong) UIView *s5;
/** 滚动区域 */
@property (nonatomic, strong) UIScrollView *contentView;
/** model */
@property (nonatomic, strong) CXPotentialFollowListModel * model;
/** CXPEPotentialProjectModel */
@property (nonatomic, strong) CXPEPotentialProjectModel * PEPotentialProjectModel;

@property (nonatomic, strong) CXAddPotentialFollowVIew *addView;

//
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *const normalCellIdentity = @"normalCellIdentity";
static NSString *const textViewCellIdentity = @"textViewCellIdentity";

@implementation CXAddPotentialFollowViewController

#define kSeperateLineColor RGBACOLOR(227.0, 227.0, 227.0, 1.0)
#define kBoldSeperateLineHeight 10.0
#define kApprovalViewBottomSpace 20.0

- (instancetype)initWithFormType:(CXFormType)formType AndModel:(CXPotentialFollowListModel *)model AndCXPEPotentialProjectModel:(CXPEPotentialProjectModel *)PEPotentialProjectModel; {
    if (self = [super init]) {
        self.formType = formType;
        if(model.devDate){
            model.devDate = [self subDateWithTimeString:model.devDate];
        }
        self->_model = model;
        self->_PEPotentialProjectModel = PEPotentialProjectModel;
    }
    return self;
}

- (NSString *)subDateWithTimeString:(NSString *)dateTimeString{
    if(dateTimeString && [dateTimeString length] > 9){
        NSString * year = [dateTimeString substringToIndex:4];
        NSString * month = [dateTimeString substringWithRange:NSMakeRange(5, 2)];
        NSString * day = [dateTimeString substringWithRange:NSMakeRange(8, 2)];
        return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }
    return @" ";
}

- (CXAddPotentialFollowVIew *)addView{
    if(nil == _addView){
        _addView = [[CXAddPotentialFollowVIew alloc]init];
    }
    return _addView;
}
- (CXPotentialFollowListModel *)model{
    if(!_model){
        _model = [[CXPotentialFollowListModel alloc] init];
    }
    return _model;
}

- (CXPEPotentialProjectModel *)PEPotentialProjectModel{
    if(!_PEPotentialProjectModel){
        _PEPotentialProjectModel = [[CXPEPotentialProjectModel alloc] init];
    }
    return _PEPotentialProjectModel;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = SDBackGroudColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        if (@available(iOS 11.0, *)) {
            
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        [_tableView registerClass:[CXYMNormalListCell class] forCellReuseIdentifier:normalCellIdentity];
        [_tableView registerClass:[CXYMTextViewCell class] forCellReuseIdentifier:textViewCellIdentity];
        _tableView.tableFooterView = [UIView new];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
    [self.view addSubview:self.addView];
//    [self setup];
    [self getDetailInfo];
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(navHigh);
//        make.left.bottom.right.mas_equalTo(0);
//    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (NSString *)flowStatueWithKey:(NSString *)key{
//    label.pickerTextArray = @[@"继续跟进", @"放弃", @"观望"];
//    label.pickerValueArray = @[@"flowUp", @"abandon", @"WS"];
    NSDictionary *dictionary = @{@"flowUp":@"继续跟进",
                                                        @"abandon":@"观望",
                                                        @"WS":@"放弃"};
    return dictionary[key];
}
- (NSString *)deleteEmptyWithString:(NSString *)string{
    NSString *str = string;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return  str;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *titleArray = @[@"日期",@"与会者",@"跟进状态",@"Keynote"];
    NSArray *contentArray = @[self.model.devDate ? : [self currerntDate],[self deleteEmptyWithString:self.model.followPerson]  ? : @"",self.model.invFlowUp ? : @"",[self deleteEmptyWithString:self.model.keyNote] ? : @""];
    if (indexPath.row == 0 || indexPath.row == 2) {//下拉框
        CXYMNormalListCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentity forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 120, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isChange = YES;
        cell.titleLabel.text = titleArray[indexPath.row];
        cell.contentLabel.text = contentArray[indexPath.row];
        return cell;
    } else {//文本输入
        CXYMTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textViewCellIdentity forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 120, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = titleArray[indexPath.row];
        if (indexPath.row == 1) {
            cell.textView.placeholder = @"与会者";
        } else {
            cell.textView.placeholder = @"Keynote";
        }
        cell.textView.placeholderColor = [CXYMAppearanceManager textLightGrayColor];
        cell.textView.textMaxLength = 100;
        cell.textView.textDidChangedBlock = ^(CXYMPlaceholderTextView *textView) {
            textView.layoutManager.allowsNonContiguousLayout = NO;
            if ([textView.text containsString:@"\n"]){
                [textView resignFirstResponder];
            }
        };
        cell.textView.text = contentArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    switch (indexPath.row) {
        case 0:
            {
                [self.tableView endEditing:YES];
                [self selecteDate];
            }
            break;
        case 1:
        {
            CXYMTextViewCell *cell = (CXYMTextViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"与会者==%@",cell.textView.text);
        }
            break;
        case 2:
        {
            [self.tableView endEditing:YES];
            [self selecteFlowStatue];
        }
            break;
        case 3:
        {
            CXYMTextViewCell *cell = (CXYMTextViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"keynote==%@",cell.textView.text);        }
            break;
            
        default:
            break;
    }
   
}

- (void)selecteDate{
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"请选择日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSLog(@"selectedDate == %@", selectedDate);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [formatter stringFromDate:selectedDate];
        self.model.devDate = date;
        [self.tableView reloadData];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];
    [datePicker showActionSheetPicker];
}


- (void)selecteFlowStatue{
    CXYMActionSheetView *actionSheet = [[CXYMActionSheetView alloc] initWithTitle:@"请选择跟进状态" sheetArray:@[@"继续跟进", @"放弃", @"观望"]];
    [actionSheet show];
    actionSheet.block = ^(NSInteger index, NSString *title) {
        NSLog(@"选择的状态是%ld == %@",index,title);
        self.model.invFlowUp = title;
        [self.tableView reloadData];
    };
}
- (NSString *)currerntDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}
- (void)setupNavView {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"跟进情况"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    if (self.formType == CXFormTypeCreate || self.formType == CXFormTypeModify) {
        [rootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(submitOnTap)];
    }
}

- (void)setup {
    CXWeakSelf(self)
    // 滚动区域
    self.contentView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh)];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:scrollView];
        scrollView;
    });
    
    self.jcsjLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, 0, (Screen_Width - 2 * kFormViewMargin), kLineHeight)];
        label.title = @"日　　期：";
        label.inputType = CXEditLabelInputTypeDate;
        if([self isDetail]){
            label.userInteractionEnabled = NO;
        }
        if(self.model.devDate){
            label.content = self.model.devDate;
        }
        label.showDropdown = YES;
        label.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.devDate = editLabel.content;
        };
        [self.contentView addSubview:label];
        label;
    });
    
    UIView *s2 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.jcsjLabel), Screen_Width, 1)];
        view.backgroundColor = kSeperateLineColor;
        [self.contentView addSubview:view];
        view;
    });
    
    self.gjrLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(s2), (Screen_Width - 2 * kFormViewMargin), kLineHeight)];
        label.title = @"与会者：";
        if([self isDetail]){
            label.userInteractionEnabled = NO;
        }
        label.content = self.model.followPerson;
        label.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.followPerson = editLabel.content;
        };
        [self.contentView addSubview:label];
        label;
    });
    
    UIView *s3 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.gjrLabel), Screen_Width, 1)];
        view.backgroundColor = kSeperateLineColor;
        [self.contentView addSubview:view];
        view;
    });
    
    self.gjztLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(s3), (Screen_Width - 2 * kFormViewMargin), kLineHeight)];
        label.title = @"跟进状态：";
        if([self isDetail]){
            label.userInteractionEnabled = NO;
        }
        label.inputType = CXEditLabelInputTypeCustomPicker;
        label.pickerTextArray = @[@"继续跟进", @"放弃", @"观望"];
        label.pickerValueArray = @[@"flowUp", @"abandon", @"WS"];
        if (![self isDetail]) {
            if([self.model.invFlowUp isEqualToString:@"flowUp"]){
                label.selectedPickerData = @{
                                                     CXEditLabelCustomPickerTextKey : @"继续跟进",
                                                     CXEditLabelCustomPickerValueKey : @"flowUp"
                                                     };
                label.content = @"继续跟进";
            }else if([self.model.invFlowUp isEqualToString:@"abandon"]){
                label.selectedPickerData = @{
                                                     CXEditLabelCustomPickerTextKey : @"放弃",
                                                     CXEditLabelCustomPickerValueKey : @"abandon"
                                                     };
                label.content = @"放弃";
            }else if([self.model.invFlowUp isEqualToString:@"WS"]){
                label.selectedPickerData = @{
                                             CXEditLabelCustomPickerTextKey : @"观望",
                                             CXEditLabelCustomPickerValueKey : @"WS"
                                             };
                label.content = @"观望";
            }
        }else{
            self.model.invFlowUp = label.pickerValueArray.firstObject;
            label.content = label.pickerTextArray.firstObject;
            label.selectedPickerData = @{
                                                 CXEditLabelCustomPickerTextKey : label.pickerTextArray.firstObject,
                                                 CXEditLabelCustomPickerValueKey : label.pickerValueArray.firstObject
                                                 };
        }
        label.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"继续跟进"]){
                self.gjztLabel.selectedPickerData = @{
                                             CXEditLabelCustomPickerTextKey : @"继续跟进",
                                             CXEditLabelCustomPickerValueKey : @"flowUp"
                                             };
                self.gjztLabel.content = @"继续跟进";
                self.model.invFlowUp = @"flowUp";
            }else if([editLabel.content isEqualToString:@"放弃"]){
                self.gjztLabel.selectedPickerData = @{
                                             CXEditLabelCustomPickerTextKey : @"放弃",
                                             CXEditLabelCustomPickerValueKey : @"abandon"
                                             };
                self.gjztLabel.content = @"放弃";
                self.model.invFlowUp = @"abandon";
            }else if([editLabel.content isEqualToString:@"观望"]){
                self.gjztLabel.selectedPickerData = @{
                                             CXEditLabelCustomPickerTextKey : @"观望",
                                             CXEditLabelCustomPickerValueKey : @"WS"
                                             };
                self.gjztLabel.content = @"观望";
                self.model.invFlowUp = @"WS";
            }
        };
        [self.contentView addSubview:label];
        label;
    });
    
    UIView *s4 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.gjztLabel), Screen_Width, 1)];
        view.backgroundColor = kSeperateLineColor;
        [self.contentView addSubview:view];
        view;
    });
    
    self.keyNoteLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(s4), (Screen_Width - 2 * kFormViewMargin), kLineHeight)];
        label.numberOfLines = 0;
        label.scale = YES;
        label.title = @"Keynote：";
        label.placeholder = @"";
        @weakify(self);
        label.needUpdateFrameBlock = ^(CXEditLabel *editLabel, CGFloat height) {
            @strongify(self);
            self.model.keyNote = editLabel.content;
            if(self.keyNoteLabel.textHeight < kLineHeight){
                self.keyNoteLabel.frame = CGRectMake(kFormViewMargin, GET_MAX_Y(s4), (Screen_Width - 2 * kFormViewMargin), kLineHeight);
            }else{
                self.keyNoteLabel.frame = CGRectMake(kFormViewMargin, GET_MAX_Y(s4), (Screen_Width - 2 * kFormViewMargin), self.keyNoteLabel.textHeight + self.keyNoteLabel.paddingTopBottom*2);
            }
            self.s5.frame = CGRectMake(0, GET_MAX_Y(self.keyNoteLabel), Screen_Width, 1);
            self.contentView.contentSize = CGSizeMake(GET_WIDTH(self.contentView), GET_MAX_Y(self.s5) + 5);
        };
        [self.contentView addSubview:label];
        label;
    });
    
    self.s5 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.keyNoteLabel), Screen_Width, 1)];
        view.backgroundColor = kSeperateLineColor;
        [self.contentView addSubview:view];
        view;
    });
    
    self.contentView.contentSize = CGSizeMake(GET_WIDTH(self.contentView), GET_MAX_Y(self.s5) + 5);
}

#pragma mark - Private
- (BOOL)isDetail{
    if(self.formType == CXFormTypeDetail){
        return YES;
    }
    return NO;
}

- (void)getDetailInfo {
    self.addView.model = self.model;
 //   [self setDetailInfo:self.model];
}

- (void)setDetailInfo:(CXPotentialFollowListModel *)model{
    self.jcsjLabel.content = model.devDate?model.devDate:@"";
    self.keyNoteLabel.content = model.keyNote?model.keyNote:@"";
}

#pragma mark - Event
- (void)submitOnTap {
    if(self.model.keyNote == nil || [self.model.keyNote length] <= 0){
        TTAlert(@"Keynote不能为空！");
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/project/potential/follow/save", urlPrefix];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:self.PEPotentialProjectModel.projId forKey:@"projId"];
    if (!self.model.devDate) {
        self.model.devDate = [self currerntDate];
    }
    [params setValue:self.model.devDate forKey:@"devDate"];
    [params setValue:self.model.followPerson forKey:@"followPerson"];
    [params setValue:self.model.invFlowUp forKey:@"invFlowUp"];
    [params setValue:self.model.keyNote forKey:@"keyNote"];
    [params setValue:self.model.devId forKey:@"eid"];
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏 loading

        if ([JSON[@"status"] intValue] == 200) {
            !self.onPostSuccess ?: self.onPostSuccess(self.model);
            [self.navigationController popViewControllerAnimated:YES];
            UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
            [mainWindow makeToast:@"提交成功!" duration:3.0 position:@"center"];
        }
        else if ([JSON[@"status"] intValue] == 400) {
            [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏 loading

        CXAlert(KNetworkFailRemind);
    }];
}

@end
