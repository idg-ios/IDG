//
//  CXDDXMeetingDetailInfoChangeMeetingNameViewController.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDDXMeetingDetailInfoChangeMeetingNameViewController.h"
#import "HttpTool.h"

@interface CXDDXMeetingDetailInfoChangeMeetingNameViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

/** 语音会议详情信息CXDDXVoiceMeetingDetailModel */
@property (nonatomic, strong) CXDDXVoiceMeetingDetailModel * model;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) SDRootTopView* rootTopView;

@end

@implementation CXDDXMeetingDetailInfoChangeMeetingNameViewController

- (instancetype)initWithCXDDXVoiceMeetingDetailModel:(CXDDXVoiceMeetingDetailModel *)model
{
    self = [self init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"修改会议议题")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(popViewController)];
    [self.rootTopView setUpRightBarItemTitle:@"保存" addTarget:self action:@selector(saveGroupName)];
    
    self.view.backgroundColor = SDBackGroudColor;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 40)];
    self.textField.delegate = self;
    self.textField.layer.cornerRadius = 5.0;
    self.textField.layer.borderWidth = 1.0;
    self.textField.placeholder = @"请输入会议议题";
    self.textField.text = self.model.vedioMeetModel.title;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:self.textField];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
- (void)popViewController
{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveGroupName
{
    if([_textField.text isEqualToString:self.model.vedioMeetModel.title]){
        TTAlert(@"您要修改的会议议题和原来的相同");
    }else if([_textField.text length] <= 0 || [NSString containBlankSpaceWithSelectedStr:_textField.text]){
        TTAlert(@"您要修改的会议议题不能为空");
    }
    if (_textField && _textField.text && [_textField.text length] > 0 && ![_textField.text isEqualToString:self.model.vedioMeetModel.title]) {
        [self showHudInView:self.view hint:@"修改中"];
        __weak typeof(self) weakSelf = self;
        NSString *url = [NSString stringWithFormat:@"%@vedioMeet/save",urlPrefix];
        NSMutableDictionary * params = @{}.mutableCopy;
        if(self.model.ccList && [self.model.ccList count] > 0){
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for(CXDDXVoiceMeetingDetailUserModel * userModel in self.model.ccList){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:[NSString stringWithFormat:@"%ld",(long)[userModel.userId integerValue]] forKey:@"eid"];
                [dic setValue:userModel.userName forKey:@"name"];
                [dataArray addObject:dic];
            }
            NSData *receiveData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:0];
            [params setValue:[[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding] forKey:@"cc"];
        }
        [params setValue:self.model.vedioMeetModel.ygId forKey:@"ygId"];
        [params setValue:self.model.vedioMeetModel.ygName forKey:@"ygName"];
        [params setValue:self.model.vedioMeetModel.eid forKey:@"eid"];
        [params setValue:_textField.text forKey:@"title"];
        [HttpTool postWithPath:url params:params success:^(id JSON) {
            [weakSelf hideHud];
            NSDictionary *jsonDict = JSON;
            if ([jsonDict[@"status"] integerValue] == 200) {
                [[NSNotificationCenter defaultCenter] postNotificationName:changeCXDDXMeetingTitleNotification object:nil userInfo:@{@"title":_textField.text}];
                [self.navigationController popViewControllerAnimated:YES];
                TTAlert(@"修改成功");
            }else{
                TTAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            [weakSelf hideHud];
            CXAlert(KNetworkFailRemind);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
