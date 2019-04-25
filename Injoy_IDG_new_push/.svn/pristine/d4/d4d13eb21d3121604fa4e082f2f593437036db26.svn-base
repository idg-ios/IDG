//
//  GroupSubjectChangingViewController.m
//  ChatDemo-UI2.0
//
//  Created by Neil on 15-2-25.
//  Copyright (c) 2014年 Neil. All rights reserved.
//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>yaogai gaiwanle
//第五个要改的修改群名称
#import "GroupSubjectChangingViewController.h"
#import "RDVTabBarController.h"
#import "SVProgressHUD.h"

@interface GroupSubjectChangingViewController () <UITextFieldDelegate, UIAlertViewDelegate> {
    SDGroupInfo* _group;
    BOOL _isOwner;
    UITextField* _subjectField;
}
@property (nonatomic, strong) SDRootTopView* rootTopView;
@end

@implementation GroupSubjectChangingViewController

- (instancetype)initWithGroup:(SDGroupInfo*)group
{
    self = [self init];
    if (self) {
        _group = group;
        NSString* loginUsername  = VAL_HXACCOUNT;
        _isOwner = [_group.owner isEqualToString:loginUsername];
        self.view.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.rootTopView = [self getRootTopView];
     [self.rootTopView setNavTitle:LocalString(@"修改群名称")];

    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(backButton);
    [self.rootTopView addSubview:backButton];

    // backButton宽度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backButton(44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backButton)]];
    // backButton高度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backButton(44)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backButton)]];

    if (_isOwner) {
        UIButton* saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [self.rootTopView addSubview:saveBtn];
        UseAutoLayout(saveBtn);

        [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[saveBtn(40)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(saveBtn)]];
        [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[saveBtn(30)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(saveBtn)]];
    }

    CGRect frame = CGRectMake(20, 80, self.view.frame.size.width - 40, 40);
    _subjectField = [[UITextField alloc] initWithFrame:frame];
    _subjectField.layer.cornerRadius = 5.0;
    _subjectField.layer.borderWidth = 1.0;
    _subjectField.placeholder = @"请输入群名称";
    _subjectField.text = _group.groupName;
    if (!_isOwner) {
        _subjectField.enabled = NO;
    }
    frame.origin = CGPointMake(frame.size.width - 5.0, 0.0);
    frame.size = CGSizeMake(5.0, 40.0);
    UIView* holder = [[UIView alloc] initWithFrame:frame];
    _subjectField.rightView = holder;
    _subjectField.rightViewMode = UITextFieldViewModeAlways;
    frame.origin = CGPointMake(0.0, 0.0);
    holder = [[UIView alloc] initWithFrame:frame];
    _subjectField.leftView = holder;
    _subjectField.leftViewMode = UITextFieldViewModeAlways;
    _subjectField.delegate = self;
    [self.view addSubview:_subjectField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏
    SDRootNavigationController* rootVC = (SDRootNavigationController*)[[UIApplication sharedApplication].windows[0] rootViewController];
    RDVTabBarController* tabBarVC = (RDVTabBarController*)[rootVC viewControllers][0];
    [tabBarVC setTabBarHidden:YES animated:NO];

    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // 显示
    SDRootNavigationController* rootVC = (SDRootNavigationController*)[[UIApplication sharedApplication].windows[0] rootViewController];
    RDVTabBarController* tabBarVC = (RDVTabBarController*)[rootVC viewControllers][0];
    [tabBarVC setTabBarHidden:NO animated:NO];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
- (void)back
{
    if ([_subjectField isFirstResponder]) {
        [_subjectField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    [self saveSubject];
}

- (void)saveSubject
{
    if([_subjectField.text isEqualToString:_group.groupName]){
        [SVProgressHUD showSuccessWithStatus:@"您要修改的群名和原来的相同"];
    }else if([_subjectField.text length] <= 0){
        [SVProgressHUD showSuccessWithStatus:@"您要修改的群名不能为空"];
    }
    if (_subjectField && _subjectField.text && [_subjectField.text length] > 0 && ![_subjectField.text isEqualToString:_group.groupName]) {
        [SVProgressHUD showWithStatus:@"修改中"];
        [[SDIMService sharedInstance] modifyGroupNameWithNewName:_subjectField.text groupId:_group.groupId completion:^(BOOL success, SDGroupInfo *groupInfo, NSString *errMsg) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:changeIMGroupNameNotification object:nil userInfo:@{@"groupInfo":groupInfo}];
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }
        }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self back];
}

@end
