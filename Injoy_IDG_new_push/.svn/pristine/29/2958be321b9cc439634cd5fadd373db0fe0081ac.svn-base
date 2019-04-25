//
//  SDIMNewFriendsApplicationCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/6/2.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMNewFriendsApplicationCell.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "HttpTool.h"
#import "SDDataBaseHelper.h"
#import "SDIMNewFriendsApplicationListViewController.h"
#import "SDIMChatViewController.h"
#import "SDContactsDetailController.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

#define kWidthOfBtn 60
#define kHeightOfBtn 30
//13位时间戳
#define kTimestamp ((long long)([[NSDate date] timeIntervalSince1970] * 1000))

@interface SDIMNewFriendsApplicationCell()

@property (nonatomic, strong) SDIMAddFriendApplicationModel * model;
@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel *conversationLabel;

@end

@implementation SDIMNewFriendsApplicationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _headImageView.layer.cornerRadius = CornerRadius;
    _headImageView.clipsToBounds = YES;
    
    if(_nameLabel){
        [_nameLabel removeFromSuperview];
        _nameLabel = nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, CGRectGetMinY(_headImageView.frame) + 4, Screen_Width - CGRectGetMaxX(_headImageView.frame) - SDHeadImageViewLeftSpacing - kWidthOfBtn - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDChatterDisplayNameFont);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    
    if(_conversationLabel){
        [_conversationLabel removeFromSuperview];
        _conversationLabel = nil;
    }
    _conversationLabel = [[UILabel alloc] init];
    _conversationLabel.font = [UIFont systemFontOfSize:SDCellLastMessageFont];
    _conversationLabel.textColor = SDCellLastMessageColor;
    [self.contentView addSubview:_conversationLabel];
    _conversationLabel.frame = CGRectMake(_nameLabel.x, CGRectGetMaxY(_headImageView.frame) - SDCellLastMessageFont - 4, Screen_Width - CGRectGetMaxX(_headImageView.frame) - SDHeadImageViewLeftSpacing - kWidthOfBtn - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDCellLastMessageFont);
}

- (void)setNewFriendsApplication:(SDIMAddFriendApplicationModel *)addFriendApplicationModel
{
    _model = addFriendApplicationModel;
    [self layoutUI];
}

- (void)layoutUI
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.contentView addSubview:_headImageView];
    
    _nameLabel.text = _model.applicantName;
    [self.contentView addSubview:_nameLabel];
    
    _conversationLabel.text = _model.attached;
    [self.contentView addSubview:_conversationLabel];
    
    if([_model.status isEqualToString:@"3"]){
        //        UIButton * refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        refuseBtn.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - kHeightOfBtn)/2, kWidthOfBtn, kHeightOfBtn);
        //        [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        //        [refuseBtn setTitle:@"拒绝" forState:UIControlStateHighlighted];
        //        [refuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [refuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        //        refuseBtn.backgroundColor = [UIColor redColor];
        //        [refuseBtn addTarget:self action:@selector(refuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //        [self.contentView addSubview:refuseBtn];
        
        UIButton * agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        agreeBtn.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - kWidthOfBtn, (SDCellHeight - kHeightOfBtn)/2, kWidthOfBtn, kHeightOfBtn);
        [agreeBtn setTitle:@"接受" forState:UIControlStateNormal];
        [agreeBtn setTitle:@"接受" forState:UIControlStateHighlighted];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        agreeBtn.backgroundColor = SDBtnGreenColor;
        [agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        agreeBtn.layer.cornerRadius = 5;
        agreeBtn.clipsToBounds = YES;
        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
        [self.contentView addSubview:agreeBtn];
    }else if([_model.status isEqualToString:@"1"] || [_model.status isEqualToString:@"2"]){
        UILabel * statusLabel = [[UILabel alloc] init];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = SDCellLastMessageColor;
        if([_model.status isEqualToString:@"1"]){
            statusLabel.text = @"已添加";
        }else{
            statusLabel.text = @"已拒绝";
        }
        statusLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
        [statusLabel sizeToFit];
        statusLabel.textAlignment = NSTextAlignmentRight;
        statusLabel.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - statusLabel.size.width - 5, (SDCellHeight - SDChatterDisplayNameFont)/2, statusLabel.size.width, SDChatterDisplayNameFont);
        [self.contentView addSubview:statusLabel];
        
        _nameLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, CGRectGetMinY(_headImageView.frame) + 4, CGRectGetMinX(statusLabel.frame) - CGRectGetMaxX(_headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDChatterDisplayNameFont);
        
        _conversationLabel.frame = CGRectMake(_nameLabel.x, CGRectGetMaxY(_headImageView.frame) - SDCellLastMessageFont - 4, CGRectGetMinX(statusLabel.frame) - CGRectGetMaxX(_headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDCellLastMessageFont);
        
    }
}

- (void)refuseBtnClick
{
    NSString * path = [NSString stringWithFormat:@"%@sysUserCus/accept",urlPrefix];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:@((long)2) forKey:@"accept"];
    [params setValue:@((long)[self.model.applicantId integerValue]) forKey:@"selfId"];
    [params setValue:self.model.applicantName forKey:@"selfName"];
    
    __weak __typeof(self)weakSelf = self;
    [[self viewController] showHudInView:[self viewController].view hint:@"正在加载数据"];
    [HttpTool postWithPath:path params:params success:^(NSDictionary *JSON) {
        [[weakSelf viewController] hideHud];
        if ([JSON[@"status"] integerValue] == 200) {
            SDIMAddFriendApplicationModel * model = [[SDIMAddFriendApplicationModel alloc] init];
            model.applicantName = _model.applicantName;
            model.applicantId = _model.applicantId;
            model.applicantTime = _model.applicantTime;
            model.applicantMsgId = _model.applicantMsgId;
            model.attached = _model.attached;
            model.status = @"2";
            model.operateTime = [NSString stringWithFormat:@"%lld",kTimestamp];
            model.icon = _model.icon;
            model.companyId = _model.companyId;
            
            [[SDDataBaseHelper shareDB]updateNewFriendApplicationWith:model];
            
            TTAlert(@"已拒绝好友申请");
        }
//        else if ([JSON[@"status"] intValue] == 400) {
//            [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//        }
        else{
            [[weakSelf viewController].view makeToast:JSON[@"msg"] duration:2 position:@"center"];
        }
    } failure:^(NSError *error) {
        [[weakSelf viewController] hideHud];
        [[weakSelf viewController].view makeToast:KNetworkFailRemind duration:2 position:@"center"];
    }];
}

- (void)agreeBtnClick
{
    NSString * path = [NSString stringWithFormat:@"%@friend/accept",urlPrefix];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:@((long)[self.model.applicantId integerValue]) forKey:@"friendId"];
    [params setValue:self.model.hxAccount forKey:@"friendImaccount"];
    [params setValue:@((long)1) forKey:@"accept"];
    
    __weak __typeof(self)weakSelf = self;
    [[self viewController] showHudInView:[self viewController].view hint:@"正在加载数据"];
    [HttpTool postWithPath:path params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            SDIMAddFriendApplicationModel * model = [[SDIMAddFriendApplicationModel alloc] init];
            model.applicantName = _model.applicantName;
            model.applicantId = _model.applicantId;
            model.applicantTime = _model.applicantTime;
            model.applicantMsgId = _model.applicantMsgId;
            model.attached = _model.attached;
            model.status = @"1";
            model.hxAccount = _model.hxAccount;
            model.operateTime = @(kTimestamp).stringValue;
            model.icon = _model.icon;
            model.companyId = _model.companyId;
            [[SDDataBaseHelper shareDB]updateNewFriendApplicationWith:model];
        
            SDDataBaseHelper* helper = [SDDataBaseHelper shareDB];
            
            if ([helper deleteAllTable]) {
                
                NSString* url = [NSString stringWithFormat:@"%@sysuser/findMailList", urlPrefix];
                NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                [HttpTool postWithPath:url
                                params:params
                               success:^(id JSON) {
                                   if (200 == [[JSON valueForKey:@"status"] intValue]) {
                                       // 保存到本地
                                       dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                           NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                                           
//                                           [[CXLoaclDataManager sharedInstance] saveLocalFriendsDataWithFriends:JSON[@"data"]];
                                           for (NSDictionary* userDic in JSON[@"data"]) {
                                               SDCompanyUserModel* userModel = [SDCompanyUserModel yy_modelWithDictionary:userDic];
                                               userModel.userId = @([userDic[@"userId"] integerValue]);
                                               [helper insertCompanyUser:userModel];
                                           }
                                           
                                           [userDefaults synchronize];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [userDefaults synchronize];
                                               CXIMMessage *message = [[CXIMMessage alloc] init];
                                               message.type = CXIMMessageTypeChat;
                                               message.sender = VAL_HXACCOUNT;
                                               message.receiver = _model.hxAccount;
                                               message.readAsk = CXIMMessageReadFlagUnRead;
                                               message.body = [CXIMTextMessageBody bodyWithTextContent:[NSString stringWithFormat:@"我通过了你的好友验证请求，现在我们可以开始聊天了"]];
                                               NSDictionary * ext = [NSDictionary dictionaryWithObjects:@[VAL_HXACCOUNT,[[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT].name?[[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT].name:VAL_HXACCOUNT,[AppDelegate getUserID],[[[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT].userType stringValue],[[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT].icon] forKeys:@[@"hxAccount",@"realName",@"userId",@"userType",@"icon"]];
                                               message.ext = ext;
                                               [[CXIMService sharedInstance].chatManager sendMessage:message onProgress:nil completion:nil];
                                               
                                               [[weakSelf viewController] hideHud];
                                               //刷新通讯录之后进入信息页面
                                               SDContactsDetailController * dvc = [[SDContactsDetailController alloc] init];
                                               SDCompanyUserModel * newModel = [CXIMHelper getUserByIMAccount:_model.hxAccount];
                                               dvc.userModel = newModel;
                                               [[weakSelf viewController].navigationController pushViewController:dvc animated:YES];
                                               if ([[weakSelf viewController].navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                                                   [weakSelf viewController].navigationController.interactivePopGestureRecognizer.delegate = nil;
                                               }
                                               
                                           });
                                           
                                       });
                                   }
                               }
                               failure:^(NSError* error) {
                                   [[weakSelf viewController] hideHud];
                                   TTAlertNoTitle([error debugDescription]);
                               }];
            }
        }
//        else if ([JSON[@"status"] intValue] == 400) {
//            [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//        }
        else{
            [[weakSelf viewController] hideHud];
            [[weakSelf viewController].view makeToast:JSON[@"msg"] duration:2 position:@"center"];
        }
    } failure:^(NSError *error) {
        [[weakSelf viewController] hideHud];
        [[weakSelf viewController].view makeToast:KNetworkFailRemind duration:2 position:@"center"];
    }];
    
}

- (SDIMNewFriendsApplicationListViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[SDIMNewFriendsApplicationListViewController class]]) {
            return (SDIMNewFriendsApplicationListViewController*)nextResponder;
        }
    }
    return nil;
}


@end
