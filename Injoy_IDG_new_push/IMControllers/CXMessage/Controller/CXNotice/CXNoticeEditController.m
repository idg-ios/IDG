 //
//  CXNoticeEditController.m
//  InjoyDDXWBG
//
//  Created by admin on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNoticeEditController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "NSDate+YYAdd.h"
#import "CXCompanyNoticeModel.h"
#import "CXERPAnnexView.h"

@interface CXNoticeEditController ()
{
    NSInteger theEid;
}

/** 标题 */
@property (nonatomic, strong) CXEditLabel *timeLabel;
/** 标题 */
@property (nonatomic, strong) CXEditLabel *titleLabel;
/** 内容 */
@property (nonatomic, strong) CXEditLabel *contentLabel;
/** 附件栏 */
@property (nonatomic, strong) CXERPAnnexView *annexView;
/** 滚动区域 */
@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) UIButton *submitBtn;


@end

@implementation CXNoticeEditController

- (instancetype)initWithFormType:(CXFormType)formType Id:(NSInteger)Id {
    if (self = [super init]) {
        self->_theFormType = formType;
        self->_ID = Id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
    [self setup];
    if (self.theFormType != CXFormTypeCreate) {
        [self getDetailInfo];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *datenow = [NSDate date];
        NSString *nowtimeStr = [formatter stringFromDate:datenow];
        _timeLabel.content = nowtimeStr;
    }
}

- (void)setupNavView {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"公告通知"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    //[rootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(submitOnTap)];
}

- (void)setup {
    self.annexView = ({
        CGFloat y = Screen_Height - CXERPAnnexView_height*6;
        CXERPAnnexView *view = [[CXERPAnnexView alloc] initWithFrame:CGRectMake(0, y, Screen_Width, CXERPAnnexView_height)];
        [self.view addSubview:view];
        view;
    });
    
    // 滚动区域
    self.contentView = ({
        CGFloat h = GET_MIN_Y(self.annexView) - navHigh;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, h-15)];
        scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:scrollView];
        scrollView;
    });
    
    self.timeLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, 0, Screen_Width - 2 * kFormViewMargin, kLineHeight)];
        label.title = @"日期：";
        label.allowEditing = NO;
        [self.contentView addSubview:label];
        label;
    });
    
    UIView *s1 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.timeLabel), Screen_Width, 1)];
        view.backgroundColor = kColorWithRGB(163, 163, 163);
        [self.contentView addSubview:view];
        view;
    });
    
    self.titleLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MIN_Y(s1), Screen_Width - 2 * kFormViewMargin, kLineHeight)];
        label.title = @"标题：";
        label.placeholder = @"请输入公告标题";
        [self.contentView addSubview:label];
        label;
    });
    
    UIView *s2 = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(self.titleLabel), Screen_Width, 1)];
        view.backgroundColor = kColorWithRGB(192, 192, 192);
        [self.contentView addSubview:view];
        view;
    });
    
    self.contentLabel = ({
        CGFloat titleUpDownMargin = (kLineHeight - kFontSizeForDetail.lineHeight) * 0.5;
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin, GET_MAX_Y(s2) + titleUpDownMargin, Screen_Width - 2 * kFormViewMargin, kFontSizeForDetail.lineHeight)];
        label.numberOfLines = 0;
        label.scale = YES;
        label.title = @"内容：";
        label.placeholder = @"请输入公告内容";
        @weakify(self);
        label.needUpdateFrameBlock = ^(CXEditLabel *editLabel, CGFloat height) {
            @strongify(self);
            self.contentView.contentSize = CGSizeMake(GET_WIDTH(self.contentView), GET_MAX_Y(editLabel) + 5);
        };
        [self.contentView addSubview:label];
        label;
    });
    
    if (!self.ID) {
        self.submitBtn = ({
            UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height-55, Screen_Width, 55)];
            btnView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:btnView];
            UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [submitBtn setFrame:CGRectMake(25, (btnView.frame.size.height-40)/2, Screen_Width-50, 40)];
            submitBtn.layer.cornerRadius = 4;
            [submitBtn setBackgroundColor:[UIColor redColor]];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [submitBtn addTarget:self action:@selector(submitOnTap) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:submitBtn];
            submitBtn;
        });
    } else {
        self.titleLabel.allowEditing = NO;
        self.contentLabel.allowEditing = NO;
    }
}

#pragma mark - Private
- (void)getDetailInfo {
    HUD_SHOW(nil);
    NSString *url = [NSString stringWithFormat:@"comNotice/detail/%zd.json", self.ID];
    [HttpTool getWithPath:url params:nil success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            CXCompanyNoticeModel *notice = [CXCompanyNoticeModel yy_modelWithJSON:JSON[@"data"]];
            notice.title = [JSON[@"data"][@"comNotice"] valueForKey:@"title"];
            notice.eid = [[JSON[@"data"][@"comNotice"] valueForKey:@"eid"] integerValue];
            theEid = [[JSON[@"data"][@"comNotice"] valueForKey:@"eid"] integerValue];
            notice.remark = [JSON[@"data"][@"comNotice"] valueForKey:@"remark"];
            notice.createTime = [JSON[@"data"][@"comNotice"] valueForKey:@"createTime"];
            notice.createId = [[JSON[@"data"][@"comNotice"] valueForKey:@"createId"] integerValue];
            [self setDetailInfo:notice];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        [self.navigationController popViewControllerAnimated:YES];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)setDetailInfo:(CXCompanyNoticeModel *)notice {

    BOOL isCreator = [VAL_USERID integerValue] == notice.createId;
    //BOOL isApproval = [VAL_USERID integerValue] == notice.approvalUserId;
    BOOL allowEditing = isCreator;
    
    self.titleLabel.allowEditing = self.ID ? NO : allowEditing;
    self.titleLabel.content = notice.title;
    self.contentLabel.allowEditing = self.ID ? NO : allowEditing;
    self.contentLabel.content = notice.remark;
    self.timeLabel.content = notice.createTime;//此处时间比当前时间还将来,并且会每次提交都自动减少一天
    
    self.annexView.detailAnnexDataArray = [notice.annexList mutableCopy];
   
}

#pragma mark - Event
/** 创建/修改的提交 */
- (void)submitOnTap {
    [self submitFormWithSuccessCallback:^{
        !self.onPostSuccess ?: self.onPostSuccess();
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)submitFormWithSuccessCallback:(void(^)())callback  {
    NSString *title = trim(self.titleLabel.content);
    NSString *content = trim(self.contentLabel.content);
    if (!title.length) {
        CXAlert(@"标题不能为空");
        return;
    }
    if (title.length > 15) {
        CXAlert(@"标题最长15字");
        return;
    }
    if (!content.length) {
        CXAlert(@"内容不能为空");
        return;
    }
    if (content.length > 500) {
        CXAlert(@"内容最长500字");
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"title"] = title;
    params[@"remark"] = content;
    params[@"ygId"] = VAL_USERID;
    params[@"ygName"] = VAL_USERNAME;
    //params[@"ygDeptId"] = VAL_DpId;
    //params[@"ygDeptName"] = VAL_DpName;
    params[@"ygJob"] = VAL_Job;
    if (self.ID > 0) {
        params[@"eid"] = @(self.ID);
    }
    if (theEid > 0) {
        params[@"eid"] = @(theEid);
    }
    if (self.annexView.addAnnexDataArray.count) {
        HUD_SHOW(nil);
        @weakify(self);
        self.annexView.annexUploadCallBack = ^(NSString *annex) {
            HUD_HIDE;
            @strongify(self);
            if (annex) {
                params[@"annex"] = annex;
                [self saveWithParams:params successCallback:callback];
            }
            else {
                CXAlert(@"附件上传失败");
            }
        };
        [self.annexView annexUpLoad];
    }
    else {
        [self saveWithParams:params successCallback:callback];
    }
}

- (void)saveWithParams:(NSDictionary *)params successCallback:(void(^)())callback {
    HUD_SHOW(nil);
    [HttpTool postWithPath:@"/comNotice/save.json" params:params.copy success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            !callback ?: callback();
        }
//        else if ([JSON[@"status"] intValue] == 400) {
//            [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

@end
