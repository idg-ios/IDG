//
//  ICEFORCEProjectScoreViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/21.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEProjectScoreViewController.h"

#import "HttpTool.h"
#import "MBProgressHUD+CXCategory.h"

#import "LEEStarRating.h"

@interface ICEFORCEProjectScoreViewController ()<UITextViewDelegate>


@property (nonatomic ,strong) UILabel *descLabel;
@property (nonatomic ,strong) UILabel *teamLabel;
@property (nonatomic ,strong) NSString *teamString;
@property (nonatomic ,strong) UILabel *businessLabel;
@property (nonatomic ,strong) NSString *businessString;
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) LEEStarRating *teamStar;
@property (nonatomic ,strong) LEEStarRating *businessStar;

@property (nonatomic ,strong) NSDictionary *scoreDic;

@end

@implementation ICEFORCEProjectScoreViewController
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.font = [UIFont systemFontOfSize:14];
    }
    return _descLabel;
}
-(UILabel *)teamLabel{
    if (!_teamLabel) {
        _teamLabel = [[UILabel alloc]init];
        _teamLabel.textColor = [UIColor orangeColor];
        _teamLabel.font = [UIFont systemFontOfSize:12];
        _teamLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _teamLabel;
}
-(UILabel *)businessLabel{
    if (!_businessLabel) {
        _businessLabel = [[UILabel alloc]init];
        _businessLabel.textColor = [UIColor orangeColor];
        _businessLabel.font = [UIFont systemFontOfSize:12];
        _businessLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _businessLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadService];
}

-(void)loadSubView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"项目评分"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    
    UIScrollView *baseView = [[UIScrollView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, self.view.frame.size.height- CGRectGetMaxY(rootTopView.frame)))];
    [self.view addSubview:baseView];
    
#pragma mark - 设置手势收回键盘
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollDismisskeyboard:)];
    tapGeature.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [baseView addGestureRecognizer:tapGeature];
    
    if (@available(iOS 11.0, *)) {
        
        baseView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    UILabel *projectJS = [[UILabel alloc]initWithFrame:(CGRectMake(30, 15, 100, 20))];
    projectJS.text = @"项目介绍";
    projectJS.textAlignment = NSTextAlignmentLeft;
    projectJS.font = [UIFont systemFontOfSize:15];
    [baseView addSubview:projectJS];
    
    NSString *projBusiness = [NSString stringWithFormat:@"%@",[self.scoreDic objectForKey:@"projBusiness"]];
    
    CGSize size = [MyPublicClass boundingRectWithSize:(CGSizeMake(self.view.frame.size.width-45, MAXFLOAT)) withTextFont:[UIFont systemFontOfSize:14] content:projBusiness];
    
    self.descLabel.frame = CGRectMake(30, CGRectGetMaxY(projectJS.frame)+15, self.view.frame.size.width-45, size.height);
    self.descLabel.text = projBusiness;
    [baseView addSubview:self.descLabel];
    
    UIView *lineViewJS = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.descLabel.frame)+15, self.view.frame.size.width, 2))];
    lineViewJS.backgroundColor = RGBA(242, 242, 242, 1);
    [baseView addSubview:lineViewJS];
    
    UILabel *projectPF = [[UILabel alloc]initWithFrame:(CGRectMake(30, CGRectGetMaxY(lineViewJS.frame)+20,200 , 20))];
    projectPF.textAlignment = NSTextAlignmentLeft;
    projectPF.font = [UIFont systemFontOfSize:15];
    projectPF.text = @"请对团队评分";
    [baseView addSubview:projectPF];
    
    self.teamStar = [[LEEStarRating alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, CGRectGetMaxY(projectPF.frame)+20, CGRectGetWidth(self.view.frame)/2, 0) Count:5];
    
    self.teamStar.spacing = 10.0f;
    
    self.teamStar.checkedImage = [UIImage imageNamed:@"star_orange"];
    
    self.teamStar.uncheckedImage = [UIImage imageNamed:@"star_gray"];
    
    self.teamStar.type = RatingTypeHalf;
    
    self.teamStar.touchEnabled = YES;
    
    self.teamStar.slideEnabled = YES;
    
    self.teamStar.maximumScore = 5.0f;
    
    self.teamStar.minimumScore = 0.0f;
    
    [baseView addSubview: self.teamStar];
    
    CXWeakSelf(self);
    self.teamStar.currentScoreChangeBlock = ^(CGFloat score){
        
        weakself.teamString = [NSString stringWithFormat:@"%0.1f",score];
        weakself.teamLabel.text = [NSString stringWithFormat:@"%@分", weakself.teamString];
    };
    
    self.teamLabel.frame = CGRectMake(15, CGRectGetMaxY(self.teamStar.frame)+10, self.view.frame.size.width-30, 20);
    [baseView addSubview:self.teamLabel];
    
    UIView *lineViewPF = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.teamLabel.frame)+15, self.view.frame.size.width, 2))];
    lineViewPF.backgroundColor = RGBA(242, 242, 242, 1);
    [baseView addSubview:lineViewPF];
    
    
    UILabel *projectYW = [[UILabel alloc]initWithFrame:(CGRectMake(30, CGRectGetMaxY(lineViewPF.frame)+20,200 , 20))];
    projectYW.textAlignment = NSTextAlignmentLeft;
    projectYW.font = [UIFont systemFontOfSize:15];
    projectYW.text = @"请对业务评分";
    [baseView addSubview:projectYW];
    
    self.businessStar = [[LEEStarRating alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, CGRectGetMaxY(projectYW.frame)+20, CGRectGetWidth(self.view.frame)/2, 0) Count:5];
    
    self.businessStar.spacing = 10.0f;
    
    self.businessStar.checkedImage = [UIImage imageNamed:@"star_orange"];
    
    self.businessStar.uncheckedImage = [UIImage imageNamed:@"star_gray"];
    
    self.businessStar.type = RatingTypeHalf;
    
    self.businessStar.touchEnabled = YES;
    
    self.businessStar.slideEnabled = YES;
    
    self.businessStar.maximumScore = 5.0f;
    
    self.businessStar.minimumScore = 0.0f;
    
    [baseView addSubview: self.businessStar];
    
    self.businessStar.currentScoreChangeBlock = ^(CGFloat score){
        
        weakself.businessString = [NSString stringWithFormat:@"%0.1f",score];
        weakself.businessLabel.text = [NSString stringWithFormat:@"%@分", weakself.businessString];
    };
    
    self.businessLabel.frame = CGRectMake(15, CGRectGetMaxY(self.businessStar.frame)+10, self.view.frame.size.width-30, 20);
    [baseView addSubview:self.businessLabel];
    
    UIView *lineViewYW = [[UIView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.businessLabel.frame)+15, self.view.frame.size.width, 2))];
    lineViewYW.backgroundColor = RGBA(242, 242, 242, 1);
    [baseView addSubview:lineViewYW];
    
    
    self.textView = [[UITextView alloc]initWithFrame:(CGRectMake(30, CGRectGetMaxY(lineViewYW.frame)+20, self.view.frame.size.width-60, 150))];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:self.textView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"写下您的评论";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    [placeHolderLabel sizeToFit];
    [self.textView addSubview:placeHolderLabel];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    UIButton *button = [[UIButton alloc]initWithFrame:(CGRectMake( self.view.frame.size.width/4, CGRectGetMaxY(self.textView.frame)+50, self.view.frame.size.width/2, 40))];
    button.backgroundColor = RGBA(88, 172, 239, 1);
    [button setTitle:@"完成" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:button];
    [button addTarget:self action:@selector(submitScore:) forControlEvents:(UIControlEventTouchUpInside)];
    [MyPublicClass layerMasksToBoundsForAnyControls:button cornerRadius:button.frame.size.height/2 borderColor:nil borderWidth:0];
    
    baseView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(button.frame)+50);
    
}

- (void)scrollDismisskeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.textView resignFirstResponder];
}
-(void)submitScore:(UIButton *)sender{
    
    if ([self.teamString isEqualToString:@"0.0"] ) {
        CXAlert(@"请对团队进行评分");
        return;
    }
    if ([self.businessString isEqualToString:@"0.0"]) {
        CXAlert(@"请对业务进行评分");
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:self.teamString forKey:@"teamScore"];
    [dic setValue:self.businessString forKey:@"businessScore"];
    [dic setValue:self.textView.text forKey:@"comment"];
    [dic setValue:[self.scoreDic objectForKey:@"rateId"] forKey:@"rateId"];
    
    [self loadSubmitScoreService:dic];
    
}
-(void)loadSubmitScoreService:(NSDictionary *)dic {
    
    [MBProgressHUD showHUDForView:self.view text:@"项目评分提交中..."];
    
#pragma makr - 临时
    
    [HttpTool postWithPath:PUT_SNS_Score_Proj params:dic success:^(id JSON) {
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:1.0];
            if (self.SelectBlock) {
                self.SelectBlock(@"ok");
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
    }];
    
    //    [HttpTool putWithPath:PUT_SNS_Score_Proj params:dic success:^(id JSON) {
    //
    //        NSInteger status = [JSON[@"status"] integerValue];
    //        if (status == 200) {
    //
    //            [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:1.0];
    //            if (self.SelectBlock) {
    //                self.SelectBlock(@"ok");
    //            }
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                [self.navigationController popViewControllerAnimated:YES];
    //            });
    //        }else{
    //            [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
    //        }
    //
    //    } failure:^(NSError *error) {
    //
    //        [MBProgressHUD hideHUDInMainQueueForView:self.view];
    //        [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
    //    }];
}
#pragma mark - 初始化界面 并获取项目介绍数据
-(void)loadService{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:self.projId forKey:@"projId"];
    [dic setValue:VAL_Account forKey:@"username"];
    [HttpTool postWithPath:POST_SNS_Score_Proj params:dic success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            self.scoreDic = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            
            [self loadSubView];
            
        }
    } failure:^(NSError *error) {
        
    }];
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
