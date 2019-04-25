//
//  CXMineFormBuilder.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMineFormBuilder.h"
#import "CXERPAnnexView.h"
#import "HttpTool.h"
#import "UIView+YYAdd.h"
#import "UIImage+YYAdd.h"

@interface CXMineFormBuilder ()

/** 表单 */
@property (nonatomic, strong) NSMutableArray<CXMineFormItem *> *formItems;
/** 附件 */
@property (nonatomic, weak) CXERPAnnexView *annexView;

@end

@implementation CXMineFormBuilder {
    BOOL _needAnnexView;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerViewDidLoad:) name:SDRootViewControllerViewDidLoadNotification object:nil];
        _viewController = [[SDRootViewController alloc] init];
        _formItems = @[].mutableCopy;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    kLogFunc;
}

- (CXMineFormItem *)addFormItem:(CXMineFormItem *)formItem {
    [self.formItems addObject:formItem];
    return formItem;
}

- (void)addAnnexItem {
    _needAnnexView = YES;
}

- (void)viewControllerViewDidLoad:(NSNotification *)noti {
    if (noti.object != self.viewController) {
        return;
    }
    [self.viewController.RootTopView setNavTitle:self.title];
    [self.viewController.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(goBack)];
//    [self.viewController.RootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(submit)];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, navHigh, GET_WIDTH(self.viewController.view), GET_HEIGHT(self.viewController.view) - navHigh)];
    [self.viewController.view addSubview:containerView];
    
    // 分割线yanse
    UIColor *dividingLineColor = kColorWithRGB(218, 218, 218);
    NSMutableArray<UIView *> *dividingLines = @[].mutableCopy;
    for (NSInteger i = 0; i < self.formItems.count; i++) {
        CXMineFormItem *formItem = self.formItems[i];
        CGFloat x = kFormViewMargin;
        CGFloat y = i != 0 ? GET_MAX_Y(dividingLines.lastObject) : 0;
        CGFloat w = GET_WIDTH(self.viewController.view) - 2 * kFormViewMargin;
        CGFloat h = kCellHeight;
        CXEditLabel *label = [[CXEditLabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        label.inputType = formItem.inputType;
        label.title = formItem.title;
        label.placeholder = formItem.placeholder;
        label.tag = 1000 + i;
        formItem.editLabel = label;
        [containerView addSubview:label];
        
        UIView *s = [[UIView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(label), GET_WIDTH(self.viewController.view), 1)];
        s.backgroundColor = dividingLineColor;
        [dividingLines addObject:s];
        [containerView addSubview:s];
    }
    
    // 附件
    if (_needAnnexView) {
        CXERPAnnexView *annexView = [[CXERPAnnexView alloc] initWithFrame:CGRectMake(0, GET_MAX_Y(dividingLines.lastObject), Screen_Width, CXERPAnnexView_height)];
        annexView.title = @"　　附件：";
        self.annexView = annexView;
        [containerView addSubview:annexView];
    }
    
    containerView.height = GET_MAX_Y(containerView.subviews.lastObject);
    containerView.backgroundColor = kColorWithRGB(249, 249, 249);
    self.viewController.view.backgroundColor = kColorWithRGB(242, 241, 247);
    
    UIView *submitView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 58, Screen_Width, 58)];
        view.backgroundColor = kColorWithRGB(249, 249, 249);
        [self.viewController.view addSubview:view];
        view;
    });
    
    UIButton *submitButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"提 交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(236, 72, 73)] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        CGFloat offset = Screen_Width / 360;
        btn.frame = CGRectMake(20 * offset, 0, Screen_Width - 2 * (20 * offset), 38);
        btn.centerY = GET_HEIGHT(submitView) / 2;
        [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [submitView addSubview:btn];
        btn;
    });
    [submitButton hash];
    
    if (self.formType == CXFormTypeModify || self.formType == CXFormTypeDetail) {
        [self getDetail];
    }
}

- (void)getDetail {
    HUD_SHOW(nil);
    [HttpTool getWithPath:self.detailUrl params:nil success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            [self setDetail:JSON[@"data"]];
        }
        else {
            CXAlert(JSON[@"msg"]);
            CXAlertExt(JSON[@"msg"], ^{
                [self.viewController.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlertExt(KNetworkFailRemind, ^{
            [self.viewController.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)setDetail:(NSDictionary *)data {
    NSMutableDictionary *newData = @{}.mutableCopy;
    newData[@"annexList"] = data[@"annexList"];
    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull k, id  _Nonnull v, BOOL * _Nonnull stop) {
        if ([v isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = (NSDictionary *)v;
            [d enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull k2, id  _Nonnull v2, BOOL * _Nonnull stop) {
                newData[k2] = v2;
            }];
        }
    }];
    self.annexView.detailAnnexDataArray = newData[@"annexList"];
    
    for (CXMineFormItem *item in self.formItems) {
        NSString *value = newData[item.filedName];
        if (![value isKindOfClass:NSNull.class]) {
            item.editLabel.content = value;
        }
    }
}

#pragma mark - Event
- (void)goBack {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

- (void)submit {
    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.formType == CXFormTypeModify) {
        params[@"eid"] = @(self.eid);
    }
    
    for (CXMineFormItem *item in self.formItems) {
        NSString *paramName = item.filedName;
        NSString *paramValue = trim(item.editLabel.content);
        if (item.required && paramValue.length <= 0) {
            NSString *titleWithoutSpace = [[trim(item.title) stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"：" withString:@""];
            NSString *alertMsg = [NSString stringWithFormat:@"%@不能为空", titleWithoutSpace];
            CXAlert(alertMsg);
            return;
        }
        params[paramName] = paramValue;
    }
    
    if (self.formType == CXFormTypeCreate) {
        if (self.annexView.addAnnexDataArray.count) {
            self.annexView.annexUploadCallBack = ^(NSString *annex) {
                params[@"annex"] = annex;
                [self saveForm:params];
            };
            [self.annexView annexUpLoad];
        }
        else {
            [self saveForm:params];
        }
    }
    else {
        [self saveForm:params];
    }
}

- (void)saveForm:(NSDictionary *)params {
    HUD_SHOW(nil);
    [HttpTool postWithPath:self.submitUrl params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            [self.viewController.navigationController popViewControllerAnimated:YES];
            !self.onPostSuccess ?: self.onPostSuccess();
        }
//        else if ([JSON[@"status"] intValue] == 400){
//            [self.viewController.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
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

@implementation CXMineFormItem

- (instancetype)initWithTitle:(NSString *)title filedName:(NSString *)filedName inputType:(CXEditLabelInputType)inputType {
    if (self = [super init]) {
        self.title = title;
        self.filedName = filedName;
        self.value = nil;
        self.inputType = inputType;
        self.required = YES;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder filedName:(NSString *)filedName inputType:(CXEditLabelInputType)inputType {
    if (self = [super init]) {
        self.title = title;
        self.placeholder = placeholder;
        self.filedName = filedName;
        self.value = nil;
        self.inputType = inputType;
        self.required = YES;
    }
    return self;
}

@end
