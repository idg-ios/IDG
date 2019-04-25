//
//  SDMySuggestViewController.m
//  SDMarketingManagement
//
//  Created by Longfei on 16/1/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDMySuggestViewController.h"
#import "SDDataBaseHelper.h"
#import "AppDelegate.h"
#import "HttpTool.h"


@interface SDMySuggestViewController ()<UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) SDRootTopView *rootTopView;

@property (nonatomic, strong) UIView *mainView;
//时间
@property (nonatomic, copy) NSString *time;

@property (nonatomic, weak) UITextView *titleTextView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) BOOL isTitleFirst;

@property (nonatomic, assign) BOOL iscontentFirst;


@end

@implementation SDMySuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSelect = NO;
    _isTitleFirst = NO;
    _iscontentFirst = NO;
    [self setUpTopView];
    [self setUpUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 添加头部导航栏
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"我的建议"];
    // 返回按钮
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [self.rootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(sendButtonClick)];
}

-(void)sendButtonClick
{
//    [self.view endEditing:YES];
    
    if (_isSelect == YES)
    {
        return;
    }
    if (self.titleTextView.text.length <= 0 || [NSString containBlankSpaceWithSelectedStr:self.titleTextView.text])
    {

        [self.view makeToast:@"建议标题不能为空" duration:2 position:@"center"];
        _isSelect = NO;
        return;
    }
    if (self.contentTextView.text.length <=0 || [NSString containBlankSpaceWithSelectedStr:self.contentTextView.text])
    {

        [self.view makeToast:@"建议内容不能为空" duration:2 position:@"center"];
        _isSelect = NO;
        return;
    }
    
    _isSelect = YES;
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:@([[AppDelegate getUserID] intValue])  forKey:@"userId"];
    [parmas setObject:[[SDDataBaseHelper shareDB] getUserName:[[AppDelegate getUserID] integerValue]] forKey:@"userName"];
    [parmas setObject:_time forKey:@"createTime"];
//    [parmas setObject:@([[AppDelegate getCompanyID] intValue]) forKey:@"companyId"];
    [parmas setObject:self.titleTextView.text forKey:@"name"];
    [parmas setObject:self.contentTextView.text forKey:@"remark"];
    [self hideHud];
    [self showHudInView:self.view hint:@"提交中..."];
    
    __weak typeof(self) weakSelf = self;
    NSString* urlStr = [NSString stringWithFormat:@"%@/advise/", urlPrefix];
    [HttpTool postWithPath:urlStr
                    params:parmas
                   success:^(id JSON) {
                       NSDictionary* dic = JSON;
                       NSNumber* status = dic[@"status"];
                       id msg = dic[@"msg"];
                       NSString* message = [NSString stringWithFormat:@"%@", msg];
                       if ([message isKindOfClass:[NSNull class]]) {
                           message = @"";
                       }
                       if ([status intValue] == 200) {
                           [weakSelf hideHud];
                           
                           //数据发送成功的回调方法
                           if (weakSelf.dataSuccess) {
                               weakSelf.dataSuccess();
                           }
                           
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [weakSelf.navigationController popViewControllerAnimated:YES];
                           });
                           
                           UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"建议已经提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                           [alert show];
                           
                       }
                       else {
                           [weakSelf hideHud];
                           UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                           [alert show];
                           _isSelect = NO;
                       }
                   }
                   failure:^(NSError* error) {
                       [weakSelf hideHud];
                       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:KNetworkFailRemind delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                       [alert show];
                       _isSelect = NO;
                   }];
    
}

-(void)setUpUI
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.mainView = [[UIView alloc] init];
    self.mainView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh-216);
    self.mainView.backgroundColor = [UIColor whiteColor];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Interval, 15, Screen_Width-Interval*2, 20)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    timeLabel.text = [NSString stringWithFormat:@"建议时间：%@",[dateFormatter stringFromDate:[NSDate date]]];
    _time = [dateFormatter stringFromDate:[NSDate date]];
    UILabel *timeLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, Screen_Width, 1)];
    timeLineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, Screen_Width-Interval*2, 50)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Interval,15, 90, 20)];
   titleLabel.text = @"建议标题:";
    UITextView *titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(90, 7, titleView.frame.size.width-80, 40)];
    titleTextView.delegate = self;
    titleTextView.tag = 101;
    titleTextView.font = [UIFont systemFontOfSize:17];
    [titleView addSubview:titleLabel];
    [titleView addSubview:titleTextView];
    self.titleTextView = titleTextView;
    
    UILabel *titleLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, Screen_Width, 1)];
    titleLineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [titleView addSubview:titleLineLabel];
    
    _contentView= [[UIView alloc] initWithFrame:CGRectMake(0, 50+50, Screen_Width,Screen_Height-navHigh-216-50-50)];
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(Interval, Interval, 80, 21)];
    contentLable.text = @"建议内容:";
    contentLable.font = [UIFont systemFontOfSize:17];
    [_contentView addSubview:contentLable];
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(Interval +80, Interval-7, Screen_Width-80-Interval*2, Screen_Height-navHigh-216-50-50-40)];
    _contentTextView.delegate = self;
    _contentTextView.tag = 102;
    _contentTextView.font = [UIFont systemFontOfSize:17];
    [_contentView addSubview:_contentTextView];
    
    [self.mainView addSubview:timeLabel];
    [self.mainView addSubview:timeLineLabel];
    
    [self.mainView addSubview:titleView];
    [self.mainView addSubview:_contentView];
    
    [self.view addSubview:self.mainView];
    [self.view bringSubviewToFront:self.rootTopView];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark  设置最大输入字数
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (!text.length)
    {
        return YES;
    }
    
    //允许客户删除内容
    NSInteger count = textView.text.length;
    if (textView.tag == 101)
    {
        if (count >= 20)
        {
            //显示提示框
            if (_isTitleFirst)
            {
                _isTitleFirst = NO;
               
                [self.view makeToast:@"输入内容已经达到20字" duration:2 position:@"center"];
                return NO;
            }else if( _isTitleFirst == NO)
            {
                
                if (text.length)
                {
                    return NO;
                }
                return YES;
            }
        }
        _isTitleFirst = YES;
    }else
    {
        if (count >= 200)
        {
            //显示提示框
            if (_iscontentFirst )
            {
                _iscontentFirst = NO;
                [self.view makeToast:@"输入内容已经达到200字" duration:2 position:@"center"];
                return NO;
            }else if( _iscontentFirst == NO)
            {
                
                if (text.length)
                {
                    return NO;
                }
                return YES;
            }
        }
        _iscontentFirst = YES;
    }
    
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //允许客户删除内容
    NSInteger count = textView.text.length;
    if (textView.tag == 101)
    {
        if (count >= 20)
        {
        textView.text = [textView.text substringToIndex:20];
        }
    }else
    {
        if (count >= 200)
        {
            textView.text = [textView.text substringToIndex:200];
        }
    }

}

#pragma mark 计算输入文字字数
-(NSInteger)calInputContentCount:(NSString *)content
{
    NSInteger count = content.length;
    
    for (NSInteger i = 0; i < content.length;i ++ ) {
        NSString *subStr = [content substringWithRange:NSMakeRange(i, 1)];
        
        if ([NSString isChineseCharactersJudge:subStr]) {
            count ++;
        }
    }
    
    return count;
}

- (void) keyboardWillShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if (Screen_Height <= 480)
    {
        self.mainView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-keyboardSize.height);
        self.contentView.frame = CGRectMake(0, 50+50, Screen_Width,Screen_Height-keyboardSize.height-50-50);
        self.contentTextView.frame = CGRectMake(Interval + 80, Interval-7, Screen_Width-80-Interval*2, _contentView.frame.size.height-10);
    }else
    {
        self.mainView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh-keyboardSize.height);
        self.contentView.frame = CGRectMake(0, 50+50, Screen_Width,Screen_Height-navHigh-keyboardSize.height-50-50);
        self.contentTextView.frame = CGRectMake(Interval + 80, Interval-7, Screen_Width-80-Interval*2, _contentView.frame.size.height-10);
    }
}
- (void) keyboardWillHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(Screen_Width-Interval*2-80, CGFLOAT_MAX)];
    if (size.height >=Screen_Height-navHigh-keyboardSize.height-50-50)
    {
        self.mainView.frame = CGRectMake(0, navHigh, Screen_Width, 50+50+size.height +10);
        self.contentView.frame = CGRectMake(0, 50+50, Screen_Width,size.height +10);
        self.contentTextView.frame = CGRectMake(Interval + 80, Interval-7, Screen_Width-80-Interval*2, size.height );
    }else
    {
        self.mainView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh-keyboardSize.height);
        self.contentView.frame = CGRectMake(0, 50+50, Screen_Width,Screen_Height-navHigh-keyboardSize.height-50-50);
        self.contentTextView.frame = CGRectMake(Interval +80, Interval-7, Screen_Width-Interval*2-80, Screen_Height-navHigh-keyboardSize.height-50-50-10);
    }
    
}

-(void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
