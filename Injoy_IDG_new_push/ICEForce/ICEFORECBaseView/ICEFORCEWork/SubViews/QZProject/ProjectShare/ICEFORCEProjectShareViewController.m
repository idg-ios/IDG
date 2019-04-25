//
//  ICEFORCEProjectShareViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/17.
//  Copyright © 2019 Injoy. All rights reserved.
// 项目分享

#import "ICEFORCEProjectShareViewController.h"

#import "CXTextView.h"
#import "YYText.h"
#import "HttpTool.h"
#import "MBProgressHUD+CXCategory.h"


#import "ICEFORCEPersonListViewController.h"

@interface ICEFORCEProjectShareViewController ()<UITextViewDelegate,CXTextViewDelegate>
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UILabel *recommendLabel;
@property (nonatomic ,strong) UILabel *remindLabel;
@property (nonatomic ,strong) UILabel *scorLabel;

#pragma mark - 需要的上传的参数

/** 跟进的用户 必须*/
@property (nonatomic ,strong) NSString *followOnUsers;
/** 推荐的用户 必须*/
@property (nonatomic ,strong) NSString *recommendUsers;
/** 打分的用户 必须*/
@property (nonatomic ,strong) NSString *scoreUsers;
/** 评论 非必须*/
@property (nonatomic ,strong) NSString *comments;

@property (nonatomic ,strong) NSArray *recommendArray;
@property (nonatomic ,strong) NSArray *remindArray;
@property (nonatomic ,strong) NSArray *scorArray;




@end

@implementation ICEFORCEProjectShareViewController

-(UILabel *)recommendLabel{
    if (!_recommendLabel) {
        _recommendLabel = [[UILabel alloc]init];
    }
    return _recommendLabel;
}

-(UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc]init];
    }
    return _remindLabel;
}

-(UILabel *)scorLabel{
    if (!_scorLabel) {
        _scorLabel = [[UILabel alloc]init];
    }
    return _scorLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
}
-(void)loadSubView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"@"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"ICEFORCESend"] addTarget:self action:@selector(sharePerson:)];
    
    self.textView = [[UITextView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, 120))];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.textView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"你想说点什么";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.font = [UIFont systemFontOfSize:15];
    [placeHolderLabel sizeToFit];
    [self.textView addSubview:placeHolderLabel];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    UIView *messageView = [[UIView alloc]initWithFrame:(CGRectMake(15, CGRectGetMaxY(self.textView.frame), self.view.frame.size.width-30, 50))];
    messageView.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:messageView];
    
    YYLabel *attLabel = [[YYLabel alloc]initWithFrame:(CGRectMake(15, (CGRectGetHeight(messageView.frame)-20)/2, messageView.frame.size.width-30, 20))];
    attLabel.font = [UIFont systemFontOfSize:15];
    [messageView addSubview:attLabel];

    NSString *test =[NSString stringWithFormat:@"#%@#",self.pjName];
    
    NSString *allTest = [NSString stringWithFormat:@"你正在分享%@项目的相关信息",test];
    
    NSMutableAttributedString *stateAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",allTest]];
    
    NSRange range_state = [allTest rangeOfString:test];
    
    [stateAtt yy_setTextHighlightRange:range_state color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
    }];

    attLabel.attributedText = stateAtt;
    
    UIView *lineView = [[UIView alloc]initWithFrame:(CGRectMake(15, CGRectGetMaxY(messageView.frame)+50, self.view.frame.size.width-30, 1))];
    lineView.backgroundColor = RGBA(242, 242, 242, 1);
    [self.view addSubview:lineView];
    
    UIView *recommendView = [self loadSubViewsForRect:(CGRectMake(0, CGRectGetMaxY(lineView.frame), self.view.frame.size.width, 50)) imageName:@"icon_email" titleText:@"推荐给谁看" contentLabel:self.recommendLabel selectButtonTag:101];
    [self.view addSubview:recommendView];

    UIView *remindView = [self loadSubViewsForRect:(CGRectMake(0, CGRectGetMaxY(recommendView.frame), self.view.frame.size.width, 50)) imageName:@"icon_email" titleText:@"提醒谁跟进" contentLabel:self.remindLabel selectButtonTag:102];
    [self.view addSubview:remindView];

    UIView *scorView = [self loadSubViewsForRect:(CGRectMake(0, CGRectGetMaxY(remindView.frame), self.view.frame.size.width, 50)) imageName:@"icon_email" titleText:@"给项目打分" contentLabel:self.scorLabel selectButtonTag:103];
    [self.view addSubview:scorView];

}

-(UIView *)loadSubViewsForRect:(CGRect)rect imageName:(NSString *)imageName titleText:(NSString *)titleText contentLabel:(UILabel *)contentLabel selectButtonTag:(NSInteger)tag{
    
    UIView *subView = [[UIView alloc]initWithFrame:rect];
    subView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(15, 0, 20, subView.frame.size.height-1))];
    leftImageView.contentMode = UIViewContentModeCenter;
    leftImageView.image = [UIImage imageNamed:imageName];
    [subView addSubview:leftImageView];
    
    UILabel *message = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(leftImageView.frame)+10, 0, 80, subView.frame.size.height-1))];
    message.font = [UIFont systemFontOfSize:14];
    message.text = titleText;
    message.textAlignment = NSTextAlignmentLeft;
    [subView addSubview:message];
    
    contentLabel.frame = CGRectMake(CGRectGetMaxX(message.frame)+4, 0, subView.frame.size.width- CGRectGetMaxX(message.frame) -4-20-15, subView.frame.size.height-1);
    contentLabel.textColor = [UIColor blueColor];
    contentLabel.font = [UIFont systemFontOfSize:14];
    [subView addSubview:contentLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(contentLabel.frame), 0, 20, subView.frame.size.height-1))];
    rightImageView.image = [UIImage imageNamed:@"arrow_right"];
    rightImageView.contentMode = UIViewContentModeCenter;
    [subView addSubview:rightImageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:(CGRectMake(15, CGRectGetHeight(subView.frame)-1, subView.frame.size.width-30, 1))];
    lineView.backgroundColor = RGBA(242, 242, 242, 1);
    [subView addSubview:lineView];
    
    UIButton *select = [[UIButton alloc]initWithFrame:(CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height))];
    select.tag = tag;
    [subView addSubview:select];
    [select addTarget:self action:@selector(selectPersonnel:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return subView;
}

#pragma mark - 推荐给谁/提醒跟进/项目打分
-(void)selectPersonnel:(UIButton *)sender{
    switch (sender.tag) {
        case 101:{
            ICEFORCEPersonListViewController *recommend = [[ICEFORCEPersonListViewController alloc]init];
            recommend.titleString = @"@";
            recommend.tempArray = [NSMutableArray arrayWithArray:self.recommendArray];
            recommend.selectPersonBlock = ^(NSArray<ICEFORCEPersonListModel *> * _Nonnull dataArry) {
                NSMutableArray *mutData = [[NSMutableArray alloc]init];
                NSMutableArray *mutName = [[NSMutableArray alloc]init];
                self.recommendArray = dataArry;
                for (ICEFORCEPersonListModel *model in dataArry) {
                    [mutData addObject:model.userAccount];
                    [mutName addObject:model.userName];
                }
                self.recommendUsers = [MyPublicClass stringTOjson:mutData];
                self.recommendLabel.text = [mutName componentsJoinedByString:@","];
            };
            
            [self.navigationController pushViewController:recommend animated:YES];
        }
            break;
        case 102:{
            ICEFORCEPersonListViewController *remind = [[ICEFORCEPersonListViewController alloc]init];
            remind.titleString = @"@";
            remind.tempArray = [NSMutableArray arrayWithArray:self.remindArray];
            remind.selectPersonBlock = ^(NSArray<ICEFORCEPersonListModel *> * _Nonnull dataArry) {
                NSMutableArray *mutData = [[NSMutableArray alloc]init];
                NSMutableArray *mutName = [[NSMutableArray alloc]init];
                self.remindArray = dataArry;
                for (ICEFORCEPersonListModel *model in dataArry) {
                    [mutData addObject:model.userAccount];
                    [mutName addObject:model.userName];
                }
                self.followOnUsers = [MyPublicClass stringTOjson:mutData];
                self.remindLabel.text = [mutName componentsJoinedByString:@","];
            };
            
            [self.navigationController pushViewController:remind animated:YES];
        }
            break;
        case 103:{
            ICEFORCEPersonListViewController *scor = [[ICEFORCEPersonListViewController alloc]init];
            scor.titleString = @"@";
            scor.tempArray = [NSMutableArray arrayWithArray:self.scorArray];
            scor.selectPersonBlock = ^(NSArray<ICEFORCEPersonListModel *> * _Nonnull dataArry) {
                NSMutableArray *mutData = [[NSMutableArray alloc]init];
                NSMutableArray *mutName = [[NSMutableArray alloc]init];
                self.scorArray = dataArry;
                for (ICEFORCEPersonListModel *model in dataArry) {
                    [mutData addObject:model.userAccount];
                    [mutName addObject:model.userName];
                }
                self.scoreUsers = [MyPublicClass stringTOjson:mutData];
                self.scorLabel.text = [mutName componentsJoinedByString:@","];
            };
            [self.navigationController pushViewController:scor animated:YES];
        }
            break;
        default:
            break;
    }
   
}

#pragma mark - 分享数据
-(void)sharePerson:(UIButton *)sender{
    
    if ([MyPublicClass stringIsNull:self.recommendUsers] && [MyPublicClass stringIsNull:self.followOnUsers] && [MyPublicClass stringIsNull:self.scoreUsers]) {
        CXAlert(@"推荐,提醒,评分人员不能为空");
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.textView.text forKey:@"comments"];
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:self.followOnUsers forKey:@"followOnUsers"];
    [dic setValue:self.recommendUsers forKey:@"recommendUsers"];
    [dic setValue:self.scoreUsers forKey:@"scoreUsers"];
    [dic setValue:self.projId forKey:@"projId"];
    [dic setValue:self.pjName forKey:@"projName"];

    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:POST_SNS_At params:dic success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:1.0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:2.0];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:2.0];
    }];
  

    
    
}
#pragma mark - textView代理
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view endEditing:NO];
    CXTextView *text = [[CXTextView alloc]initWithKeyboardType:(UIKeyboardTypeDefault)];
    text.delegate = self;
    text.textString = textView.text;
    [KEY_WINDOW addSubview:text];
}

-(void)textView:(CXTextView *)textView textWhenTextViewFinishEdit:(NSString *)text{
    self.textView.text = text;
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
