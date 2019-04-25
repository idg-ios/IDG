//
//  CXIDGSmallBusinessAssistantViewController.m
//  InjoyIDG
//
//  Created by wtz on 2017/11/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGSmallBusinessAssistantViewController.h"
#import "Masonry.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "CXProjectCollaborationMessageModel.h"
#import "CXProjectCollaborationChattingCell.h"
#import "CXIDGAnnualLuckyDrawViewController.h"
#import <AVFoundation/AVFoundation.h>

// 动画时长
#define kAnimationDuration .25

//toolView的高度
#define kToolViewHeight 45

//13位时间戳
#define kTimestamp ((long long)([[NSDate date] timeIntervalSince1970] * 1000))

@interface CXIDGSmallBusinessAssistantViewController ()<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,CXProjectCollaborationChattingCellDelegate>

/** 聊天tableView */
@property(strong, nonatomic) UITableView *tableView;
/** 是聊天键盘弹起 */
@property (nonatomic,assign) BOOL isTalkTextView;
/** 底部操作栏 */
@property (nonatomic,strong) UIView *toolView;
/** 弹起键盘按钮 */
@property (nonatomic,strong) UIButton * showKeyBoardBtn;
/** firstLineView */
@property (nonatomic, strong) UIView * firstLineView;
/** 文本输入 */
@property (nonatomic,strong) UITextView *textView;
/** 发送按钮 */
@property (nonatomic,strong) UIButton *sendBtn;
/** 消息数组 */
@property (nonatomic, strong) NSMutableArray * messagesArray;
/** cellHeights */
@property (nonatomic,strong) NSMutableDictionary *cellHeights;
/** 模板cell */
@property (nonatomic, strong) CXProjectCollaborationChattingCell *templateCell;

@end

@implementation CXIDGSmallBusinessAssistantViewController

#pragma mark - LazyLoad
- (NSMutableDictionary *)cellHeights{
    if (_cellHeights == nil) {
        _cellHeights = [NSMutableDictionary dictionary];
    }
    return _cellHeights;
}

- (UIView *)toolView{
    if(!_toolView){
        // 底部操作栏
        _toolView = [[UIView alloc] init];
        _toolView.backgroundColor = [UIColor whiteColor];
        _toolView.hidden = NO;
        [self.view addSubview:_toolView];
        
        UIView * topLineView = [[UIView alloc] init];
        topLineView.frame = CGRectMake(0, 0, Screen_Width, 0.5);
        topLineView.backgroundColor = [UIColor lightGrayColor];
        [_toolView addSubview:topLineView];
        
//        // 图片
//        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//        [self.sendBtn setTitle:@"发送" forState:UIControlStateHighlighted];
//        [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        self.sendBtn.layer.borderWidth = 0.5;
//        self.sendBtn.layer.borderColor = RGBACOLOR(104.0, 104.0, 104.0, 1.0).CGColor;
//        self.sendBtn.layer.cornerRadius = 2;
//        [self.sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        self.sendBtn.hidden = NO;
//        self.sendBtn.backgroundColor = RGBACOLOR(42.0, 168.0, 37.0, 1.0);
//        [_toolView addSubview:self.sendBtn];
//        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(self.toolView).offset(-8);
//            make.size.mas_equalTo(CGSizeMake(65, 35));
//            make.centerY.equalTo(self.toolView);
//        }];
        
        // 弹起键盘按钮
        self.showKeyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.showKeyBoardBtn setImage:[UIImage imageNamed:@"keyboardUp"] forState:UIControlStateNormal];
        [self.showKeyBoardBtn setImage:[UIImage imageNamed:@"keyboardDown"] forState:UIControlStateSelected];
        [self.showKeyBoardBtn addTarget:self action:@selector(showKeyBoardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.showKeyBoardBtn.selected = NO;
        [_toolView addSubview:self.showKeyBoardBtn];
        [self.showKeyBoardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.toolView).offset(0);
            make.size.mas_equalTo(CGSizeMake(kLeftShowKeyBoardBtnWidth, kToolViewHeight));
            make.centerY.equalTo(self.toolView);
        }];
        
        self.firstLineView = [[UIView alloc] init];
        self.firstLineView.backgroundColor = RGBACOLOR(195.0, 195.0, 195.0, 1.0);
        [_toolView addSubview:self.firstLineView];
        [self.firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.showKeyBoardBtn.mas_trailing).offset(-0.5);
            make.size.mas_equalTo(CGSizeMake(0.5, kToolViewHeight));
            make.centerY.equalTo(self.toolView);
        }];
        
        // 输入框
        self.textView = [[UITextView alloc] init];
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.scrollEnabled = NO;
        self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.delegate = self;
        self.textView.enablesReturnKeyAutomatically = YES;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.borderColor = RGBACOLOR(104.0, 104.0, 104.0, 1.0).CGColor;
        self.textView.layer.cornerRadius = 2;
        [_toolView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolView).offset(5);
            make.bottom.equalTo(self.toolView).offset(-5);
            make.leading.equalTo(self.showKeyBoardBtn.mas_trailing).offset(8);
            make.trailing.equalTo(self.toolView).offset(-8);
        }];
    }
    return _toolView;
}

- (NSMutableArray *)messagesArray{
    if (_messagesArray == nil) {
        _messagesArray = @[].mutableCopy;
    }
    return _messagesArray;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kColorWithRGB(232,232,232);
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self setUpNavBar];
    
    self.tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - kToolViewHeight);
    
    [self addBottomBar];
    
    CXIMMessage * message = [[CXIMMessage alloc] init];
    message.type = CXIMProtocolTypeSingleChat;
    message.ID = [NSString stringWithFormat:@"%lld",kTimestamp];
    message.sender = @"企业小助手";
    message.receiver = VAL_HXACCOUNT;
    CXIMTextMessageBody *body = [[CXIMTextMessageBody alloc] init];
    body.textContent = @"输入公司名称即可查询该公司的信息";
    message.body = body;
    long firstStamp = (kTimestamp);
    message.sendTime = @(firstStamp);
    message.status = CXIMMessageStatusSendSuccess;
    message.readFlag = CXIMMessageReadFlagReaded;
    message.openFlag = CXIMMessageReadFlagReaded;
    message.readAsk = CXIMMessageReadFlagReaded;
    [self.messagesArray addObject:message];
    [self.tableView reloadData];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 内部方法
- (void)showKeyBoardBtnClick
{
    self.showKeyBoardBtn.selected = !self.showKeyBoardBtn.selected;
    [self setToolViewSubviewHidden];
    if(self.showKeyBoardBtn.selected){
        [self.textView becomeFirstResponder];
    }
}

- (void)setToolViewSubviewHidden
{
    if(!self.showKeyBoardBtn.selected){
        [self collapseAll];
    }
}

- (void)scrollToBottom
{
    NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
    if (row > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messagesArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)collapseAll{
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    if(point.y > CGRectGetMinY(_toolView.frame)){
        [self.view bringSubviewToFront:_toolView];
        self.isTalkTextView = YES;
    }else{
        [self collapseAll];
        self.isTalkTextView = NO;
    }
}

#pragma mark - setUpUI
- (void)setUpNavBar {
    
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"发票信息"];
    
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

//添加BottomBar
-(void)addBottomBar
{
    self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight, Screen_Width, kToolViewHeight);
    self.toolView.hidden = NO;
}

#pragma mark - 键盘伸缩通知
-(void)keyboardWillShow:(NSNotification *)aNotification{
    if(self.isTalkTextView){
        self.showKeyBoardBtn.selected = YES;
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat height = [aValue CGRectValue].size.height;
        self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight - height + kTabbarSafeBottomMargin, Screen_Width, kToolViewHeight);
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }else{
        [self collapseAll];
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    self.showKeyBoardBtn.selected = NO;
    self.textView.inputView = nil;
    self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight, Screen_Width, kToolViewHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 发送文本
- (void)sendBtnClick
{
    if(!self.textView.text || (self.textView.text && [self.textView.text length] <= 0)){
        return;
    }else{
        [self sendTextMessage];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self sendTextMessage];
        return NO;
    }
    return YES;
}

#pragma mark - sendMessages
// 发送文本消息
-(void)sendTextMessage{
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length <= 0) {
        return;
    }
    CXIMMessage * message = [[CXIMMessage alloc] init];
    message.type = CXIMProtocolTypeSingleChat;
    message.ID = [NSString stringWithFormat:@"%lld",kTimestamp];
    message.sender = VAL_HXACCOUNT;
    message.receiver = @"企业小助手";
    CXIMTextMessageBody *body = [[CXIMTextMessageBody alloc] init];
    body.textContent = text;
    message.body = body;
    long firstStamp = (kTimestamp);
    message.sendTime = @(firstStamp);
    message.status = CXIMMessageStatusSendSuccess;
    message.readFlag = CXIMMessageReadFlagReaded;
    message.openFlag = CXIMMessageReadFlagReaded;
    message.readAsk = CXIMMessageReadFlagReaded;
    [self.messagesArray addObject:message];
    
    NSString *url = [NSString stringWithFormat:@"%@invoice/littleHelper", urlPrefix];
    NSMutableDictionary * params = @{}.mutableCopy;
    [params setValue:text forKey:@"companyName"];
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            self.textView.text = @"";
            NSArray * receiveArray = [NSArray yy_modelArrayWithClass:CXIDGSmallBusinessAssistantModel.class json:JSON[@"data"]];
            if(receiveArray && [receiveArray count] > 0){
                for(CXIDGSmallBusinessAssistantModel * model in receiveArray){
                    model.ID = @(kTimestamp);
                    [self.messagesArray addObject:model];
                }
            }else{
                CXIMMessage * message = [[CXIMMessage alloc] init];
                message.type = CXIMProtocolTypeSingleChat;
                message.ID = [NSString stringWithFormat:@"%lld",kTimestamp];
                message.sender = @"企业小助手";
                message.receiver = VAL_HXACCOUNT;
                CXIMTextMessageBody *body = [[CXIMTextMessageBody alloc] init];
                body.textContent = @"没有找到相关信息";
                message.body = body;
                long firstStamp = (kTimestamp);
                message.sendTime = @(firstStamp);
                message.status = CXIMMessageStatusSendSuccess;
                message.readFlag = CXIMMessageReadFlagReaded;
                message.openFlag = CXIMMessageReadFlagReaded;
                message.readAsk = CXIMMessageReadFlagReaded;
                [self.messagesArray addObject:message];
            }
            [self.tableView reloadData];
            [self scrollToBottom];
        }else if ([JSON[@"status"] intValue] == 400) {
            [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id message = self.messagesArray[indexPath.row];
    if([message isKindOfClass:[CXIMMessage class]]){
        NSString *ID = [CXProjectCollaborationChattingCell identifierForContentType:((CXIMMessage *)message).body.type];
        self.templateCell = [CXProjectCollaborationChattingCell createCellForIdentifier:ID];
        self.templateCell.indexPath = indexPath;
        NSInteger compareTime = 0;
        if(indexPath.row == 0){
            compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
        }
        else{
            id lastMessage = self.messagesArray[indexPath.row - 1];
            if([lastMessage isKindOfClass:[CXIMMessage class]]){
                compareTime = [(CXIMMessage *)lastMessage sendTime].integerValue;
            }else{
                compareTime = [((CXIDGSmallBusinessAssistantModel *)lastMessage).ID integerValue];
            }
        }
        self.templateCell.compareTime = compareTime;
        self.templateCell.tableView = tableView;
        self.templateCell.message = message;
        return self.templateCell.cellHeight + 5;
    }else if([message isKindOfClass:[CXIDGSmallBusinessAssistantModel class]]){
        NSString *ID = [CXProjectCollaborationChattingCell identifierForCXIDGSmallBusinessAssistantCellType];
        self.templateCell = [CXProjectCollaborationChattingCell createCellForIdentifier:ID];
        CXIDGSmallBusinessAssistantModel * model = (CXIDGSmallBusinessAssistantModel *)message;
        self.templateCell.model = model;
        self.templateCell.indexPath = indexPath;
        NSInteger compareTime = 0;
        if(indexPath.row == 0){
            compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
        }
        else{
            id lastMessage = self.messagesArray[indexPath.row - 1];
            if([lastMessage isKindOfClass:[CXIMMessage class]]){
                compareTime = [(CXIMMessage *)lastMessage sendTime].integerValue;
            }else{
                compareTime = [((CXIDGSmallBusinessAssistantModel *)lastMessage).ID integerValue];
            }
        }
        self.templateCell.compareTime = compareTime;
        self.templateCell.tableView = tableView;
        CXIMMessage * mess = [[CXIMMessage alloc] init];
        mess.sendTime = @(kTimestamp);
        mess.status = CXIMMessageStatusSendSuccess;
        mess.readFlag = CXIMMessageReadFlagReaded;
        mess.openFlag = CXIMMessageReadFlagReaded;
        mess.readAsk = CXIMMessageReadFlagReaded;
        self.templateCell.message = mess;
        return self.templateCell.cellHeight + 5;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id message = [self.messagesArray copy][indexPath.row];
    if([message isKindOfClass:[CXIMMessage class]]){
        NSString *ID = [CXProjectCollaborationChattingCell identifierForContentType:((CXIMMessage *)message).body.type];
        CXProjectCollaborationChattingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [CXProjectCollaborationChattingCell createCellForIdentifier:ID];
        }
        cell.delegate = self;
        cell.isNotNeedShowReadOrUnRead = NO;
        cell.indexPath = indexPath;
        NSInteger compareTime = 0;
        if(indexPath.row == 0){
            compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
        }
        else{
            id lastMessage = [self.messagesArray copy][indexPath.row - 1];
            if([lastMessage isKindOfClass:[CXIMMessage class]]){
                compareTime = [(CXIMMessage *)lastMessage sendTime].integerValue;
            }else{
                compareTime = [((CXIDGSmallBusinessAssistantModel *)lastMessage).ID integerValue];
            }
        }
        cell.compareTime = compareTime;
        cell.tableView = tableView;
        cell.message = message;
        self.cellHeights[indexPath] = @(cell.cellHeight);
        return cell;
    }else if([message isKindOfClass:[CXIDGSmallBusinessAssistantModel class]]){
        NSString *ID = [CXProjectCollaborationChattingCell identifierForCXIDGSmallBusinessAssistantCellType];
        CXProjectCollaborationChattingCell *cell = [CXProjectCollaborationChattingCell createCellForIdentifier:ID];
        cell.delegate = self;
        CXIDGSmallBusinessAssistantModel * model = (CXIDGSmallBusinessAssistantModel *)message;
        cell.model = model;
        cell.isNotNeedShowReadOrUnRead = NO;
        cell.indexPath = indexPath;
        NSInteger compareTime = 0;
        if(indexPath.row == 0){
            compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
        }
        else{
            id lastMessage = [self.messagesArray copy][indexPath.row - 1];
            if([lastMessage isKindOfClass:[CXIMMessage class]]){
                compareTime = [(CXIMMessage *)lastMessage sendTime].integerValue;
            }else{
                compareTime = [((CXIDGSmallBusinessAssistantModel *)lastMessage).ID integerValue];
            }
        }
        cell.compareTime = compareTime;
        cell.tableView = tableView;
        CXIMMessage * mess = [[CXIMMessage alloc] init];
        NSString * textbody = [NSString stringWithFormat:@"公司名称：%@，纳税号：%@，开票地址：%@，账户：%@，开户行：%@，电话：%@，公司传真：%@",model.companyName,model.taxNumber,model.invoiceAddress,model.account,model.openBank,model.telephone,model.fax];
        CXIMTextMessageBody * textBody = [CXIMTextMessageBody bodyWithTextContent:textbody];
        mess.body = textBody;
        mess.status = CXIMMessageStatusSendSuccess;
        mess.readFlag = CXIMMessageReadFlagReaded;
        mess.openFlag = CXIMMessageReadFlagReaded;
        mess.readAsk = CXIMMessageReadFlagReaded;
        mess.sendTime = @(kTimestamp);
        cell.message = mess;
        self.cellHeights[indexPath] = @(cell.cellHeight);
        return cell;
    }
    return nil;
}

#pragma mark - CXProjectCollaborationChattingCellDelegate
-(void)projectCollaborationChattingCell:(CXProjectCollaborationChattingCell *)cell didTapMenuItem:(CXProjectCollaborationChattingCellMenuItem)item message:(CXIMMessage *)message{
    switch (item) {
            // 复制
        case CXProjectCollaborationChattingCellMenuItemCopy:
        {
            CXIMTextMessageBody *textBody = (CXIMTextMessageBody *)message.body;
            [UIPasteboard generalPasteboard].string = textBody.textContent;
            break;
        }
        default:
            break;
    }
}

@end
