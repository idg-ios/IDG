//
//  SDIMChangeGroupNameViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/14.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMChangeGroupNameViewController.h"

@interface SDIMChangeGroupNameViewController()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CXGroupInfo* group;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) SDRootTopView* rootTopView;

@end

@implementation SDIMChangeGroupNameViewController
- (instancetype)initWithGroup:(CXGroupInfo*)group
{
    self = [self init];
    if (self) {
        _group = group;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"修改群名称")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(popViewController)];
    [self.rootTopView setUpRightBarItemTitle:@"保存" addTarget:self action:@selector(saveGroupName)];
    
    self.view.backgroundColor = SDBackGroudColor;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 40)];
    self.textField.delegate = self;
    self.textField.layer.cornerRadius = 5.0;
    self.textField.layer.borderWidth = 1.0;
    self.textField.placeholder = @"请输入群名称";
    self.textField.text = _group.groupName;
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
    if([_textField.text isEqualToString:_group.groupName]){
        TTAlert(@"您要修改的群名和原来的相同");
    }else if([_textField.text length] <= 0 || [NSString containBlankSpaceWithSelectedStr:_textField.text]){
        TTAlert(@"您要修改的群名不能为空");
    }
    if (_textField && _textField.text && [_textField.text length] > 0 && ![_textField.text isEqualToString:_group.groupName]) {
        [self showHudInView:self.view hint:@"修改中"];
        [[CXIMService sharedInstance].groupManager modifyGroupNameWithNewName:_textField.text groupId:_group.groupId completion:^(CXGroupInfo *group, NSError *error) {
            [self hideHud];
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:changeIMGroupNameNotification object:nil userInfo:@{@"groupInfo":group}];
                [self.navigationController popViewControllerAnimated:YES];
                TTAlert(@"修改成功");
            }
            else{
                TTAlert(@"修改失败");
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
