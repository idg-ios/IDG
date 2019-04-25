//
//  CXSendMsgAndTelView.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2018/6/4.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXSendMsgAndTelView.h"
#import <ContactsUI/CNContactViewController.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import <AddressBookUI/ABNewPersonViewController.h>
#import "SDCompanyUserModel.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXSendMsgAndTelView() <CNContactViewControllerDelegate,CNContactPickerDelegate,ABNewPersonViewControllerDelegate>

@property (nonatomic, strong) UIView *basicView;

@property (nonatomic ,assign) ShowAnimationOptions option;
@property (nonatomic ,assign) DisMissAnimationOptions dismiss;

@property (nonatomic ,strong) NSString *phone;

@property (nonatomic, strong) CNContactStore *contactStore;

@end

@implementation CXSendMsgAndTelView


#define kDurationTime 0.3

-(instancetype)initWithFrame:(CGRect)frame andTelPhone:(NSString *)phone showAnimationOption:(ShowAnimationOptions)showOption disMissAnimationOption:(DisMissAnimationOptions)disMissOption{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.option = showOption;
        self.dismiss = disMissOption;
        self.phone = phone;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return self;
    
}

-(void)loadAnimateView{

    switch (self.option) {
        case ShowAnimationOptionNome:{
            [self showNomeView];

        }
            break;
        case ShowAnimationOptionTop:{
            
            [self showTopView];
        }
            break;
            
        case ShowAnimationOptionBottom:{
            [self showBottomView];

        }
            break;
        case ShowAnimationOptionGradient:{
             [self showGradient];
        }
            break;
        default:
            break;
    }
    
}
-(void)disMissAnimateView{
    
    switch (self.dismiss) {
        case DisMissAnimationOptionNome:{
            [self disMissNomeView];
            
        }
            break;
        case DisMissAnimationOptionTop:{
            
            [self disMissTopView];
        }
            break;
            
        case DisMissAnimationOptionBottom:{
            [self disMissBottomView];
            
        }
            break;
        case DisMissAnimationOptionGradient:{
            [self dismissGradient];
        }
            break;
        default:
            break;
    }
}



- (void)drawRect:(CGRect)rect {
   _basicView = [[UIView alloc]initWithFrame:(CGRectMake(40, (Screen_Height-109)/2, Screen_Width-80, 109 + 55))];
    _basicView.layer.cornerRadius = 5.0;
    _basicView.clipsToBounds = YES;
    _basicView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_basicView];
  
    UIButton *tel = [[UIButton alloc]initWithFrame:(CGRectMake(0, 0, _basicView.frame.size.width, 54))];
    [tel setTitle:@"  呼叫号码" forState:(UIControlStateNormal)];
    tel.titleLabel.font =  [UIFont systemFontOfSize:16];
    tel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [tel setTitleColor: [UIColor colorWithRed:31/255.0 green:34/255.0 blue:40/255.0 alpha:1/1.0] forState:(UIControlStateNormal)];
    [tel addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    tel.tag = 1;
    [_basicView addSubview:tel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(tel.frame), _basicView.frame.size.width, 1))];
    lineView.backgroundColor = RGBACOLOR(243, 244, 245, 1);
    [_basicView addSubview:lineView];
    
    UIButton *sendMsg = [[UIButton alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(lineView.frame), _basicView.frame.size.width, 54))];
    [sendMsg setTitle:@"  发送短信" forState:(UIControlStateNormal)];
    sendMsg.titleLabel.font =  [UIFont systemFontOfSize:16];
    sendMsg.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [sendMsg setTitleColor: [UIColor colorWithRed:31/255.0 green:34/255.0 blue:40/255.0 alpha:1/1.0] forState:(UIControlStateNormal)];
    [sendMsg addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    sendMsg.tag = 2;
    [_basicView addSubview:sendMsg];
    //
    UIView *line = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(sendMsg.frame), _basicView.frame.size.width, 1))];
    line.backgroundColor = RGBACOLOR(243, 244, 245, 1);
    [_basicView addSubview:line];
    //
    UIButton *saveBoutton = [[UIButton alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(sendMsg.frame), _basicView.frame.size.width, 54))];
    [saveBoutton setTitle:@"  保存到通讯录" forState:(UIControlStateNormal)];
    saveBoutton.titleLabel.font =  [UIFont systemFontOfSize:16];
    saveBoutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [saveBoutton setTitleColor: [UIColor colorWithRed:31/255.0 green:34/255.0 blue:40/255.0 alpha:1/1.0] forState:(UIControlStateNormal)];
    [saveBoutton addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    saveBoutton.tag = 3;
    [_basicView addSubview:saveBoutton];
    
    [self loadAnimateView];

}

-(void)clickButton:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1:{
            if (!self.companyUser.telephone || self.companyUser.telephone.length == 0) {
                [MBProgressHUD toastAtCenterForView:self text:@"对方未录入电话" duration:3];
                return;
            }
            UIWebView* callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phone]];
            [callWebView loadRequest:[NSURLRequest requestWithURL:url]];
            [self addSubview:callWebView];
            
        }
            break;
            
        case 2:{
            if (!self.companyUser.telephone || self.companyUser.telephone.length == 0) {
                [MBProgressHUD toastAtCenterForView:self text:@"对方未录入电话" duration:3];
                return;
            }
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", self.phone]];
            [[UIApplication sharedApplication]openURL:url];
        }
            break;
            
        case 3:{//保存到通讯录
            UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"" message:@"这可能是一个手机号,您可以" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *saveNewContactAction =[UIAlertAction actionWithTitle:@"创建新联系人"
                                                               style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                                                   if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {//9.0以前
                                                                       [self saveNewContactUnderIOS9];
                                                                       return ;
                                                                   }
                                                                   [self saveNewContact];
                                                               }];
            UIAlertAction *saveExitContactAction=[UIAlertAction actionWithTitle:@"添加到现有联系人"
                                                               style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                                                   // 请求授权
                                                                   CNContactStore *contactStore = [[CNContactStore alloc] init];
                                                                   [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                                       if (granted) {
                                                                           NSLog(@"授权成功");
                                                                           CNContactPickerViewController *contactPickerViewController = [[CNContactPickerViewController alloc] init];
                                                                           contactPickerViewController.delegate = self.viewController;
                                                                           [self.viewController presentViewController:contactPickerViewController animated:YES completion:nil];
                                                                       } else {
                                                                           NSLog(@"授权失败,error:%@",error);
                                                                       }
                                                                   }];
                                              
                                                               }];
            UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:saveNewContactAction];
            [alertController addAction:saveExitContactAction];
            [alertController addAction:cancelAction];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    [self disMissAnimateView];

}
- (void)saveNewContactUnderIOS9{
    ABNewPersonViewController  *picker = [[ABNewPersonViewController alloc]init];
    picker.newPersonViewDelegate = self;
    UINavigationController  *navigation = [[UINavigationController alloc]initWithRootViewController:picker];
    [self.viewController presentViewController:navigation animated:YES completion:^{
        
    }];
}

#pragma mark -- 通讯录是否存在该人
- (BOOL)addressBookIsExistContacterWithName:(NSString *)name{
    return YES;
}
#pragma mark -- 新建联系人
- (void)saveNewContact{
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    // 请求授权
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"授权成功!");
            CNLabeledValue *labelValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile
                                                                         value:[CNPhoneNumber phoneNumberWithStringValue:self.companyUser.telephone ? : @""]];
            contact.phoneNumbers = @[labelValue];//手机号
            contact.familyName = self.companyUser.name ? : @"";//昵称
            CNLabeledValue *mail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:self.companyUser.email ? : @""];
            contact.emailAddresses = @[mail];//email
            contact.organizationName = @"idgcapital";
            CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:contact];
            contactController.delegate = self.viewController ;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactController];
            [self.viewController presentViewController:nav animated:YES completion:^{
                NSLog(@"presentViewController");
            }];
        } else {
            NSLog(@"授权失败,error:%@",error);
        }
    }];
}
#pragma mark - CNContactViewControllerDelegate
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    
    if (contact) {
        NSLog(@"完成通讯录保存");
    } else {
        NSLog(@"点击了取消");
    }
   
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - CNContactPickDelegate
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    NSLog(@"取消");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    NSLog(@"通讯录,选择%@",contact);
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.allObjects.lastObject;
    CGPoint location = [touch locationInView:nil];
    if (![_basicView pointInside:[_basicView convertPoint:location fromView:_basicView.window] withEvent:nil]) {
        
        [self disMissAnimateView];
    }
    
    
}


-(void)showNomeView{
    self.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
}
-(void)showTopView{
    
    self.frame =  CGRectMake(0, Screen_Height + kTabbarSafeBottomMargin, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
    [UIView animateWithDuration:2 animations:^{
        
        self.frame =  CGRectMake(0, 0, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
        
    } completion:^(BOOL finished) {
        
        
    }];
}
-(void)showBottomView{
    
    self.frame =  CGRectMake(0, -Screen_Height - kTabbarSafeBottomMargin, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
    [UIView animateWithDuration:kDurationTime animations:^{
        
        self.frame =  CGRectMake(0, 0, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
        
    } completion:^(BOOL finished) {
        
        
    }];
}


-(void)showGradient{
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    self.alpha = 0;
    
    [UIView animateWithDuration:2 animations:^{
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}


-(void)disMissNomeView{
    
    self.alpha = 1;
    [UIView animateWithDuration:1 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}
-(void)disMissTopView{
    
    self.frame =  CGRectMake(0, 0, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
    self.alpha = 1;
    [UIView animateWithDuration:2 animations:^{
        
        self.frame =  CGRectMake(0, Screen_Height, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];

    }];
}
-(void)disMissBottomView{
    
    self.frame =  CGRectMake(0, 0, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
    self.alpha = 1;
    [UIView animateWithDuration:2 animations:^{
        
        self.frame =  CGRectMake(0, -Screen_Height - kTabbarSafeBottomMargin, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];

    }];
}

-(void)dismissGradient{
    
    self.transform = CGAffineTransformMakeScale(1, 1);
    
    self.alpha = 1;
    
    [UIView animateWithDuration:kDurationTime animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

@end
