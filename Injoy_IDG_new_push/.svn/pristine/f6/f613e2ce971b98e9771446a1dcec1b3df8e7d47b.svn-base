//
//  SDIMMyselfViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/5/3.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMMyselfViewController.h"
#import "SDMenuView.h"
#import "SDIMSearchVIewController.h"
#import "AppDelegate.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "SDIMChatViewController.h"
#import "CXIMHelper.h"
#import "SDIMAddFriendsViewController.h"
#import "CXScanViewController.h"
#import "SDIMReceiveAndPayMoneyViewController.h"
#import "CXMysugestListViewController.h"
#import "UIImageView+EMWebCache.h"
#import "QRCodeGenerator.h"
#import "QLPreviewItemCustom.h"
#import "SDDataBaseHelper.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDIMMySettingViewController.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDWebSocketManager.h"
#import "SDCreateZbarImageViewController.h"
#import "CXLoaclDataManager.h"


#define kHeightOfHeadCell 65
#define kImageLeftSpacing 20
#define kImageHeight 36
#define kQRCodeWidth 25
#define kTitleSpacing (((kHeightOfHeadCell - SDHeadImageViewLeftSpacing*2) - (SDSectionTitleFont*2 + SDMainMessageFont) - 6)/2)
#define kFilePath [NSString stringWithFormat:@"%@/Documents/QR", NSHomeDirectory()]

@interface SDIMMyselfViewController()<UITableViewDataSource, UITableViewDelegate, SDMenuViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>

//导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) UITableView* tableView;
//选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
@property (strong, nonatomic) NSMutableArray* chatContactsArray;
//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;
@property (nonatomic, strong) UIAlertView* alertView;
@property (nonatomic, strong) NSString * imageName;

//接收新消息通知开关
@property (nonatomic, strong) UISwitch * enableGetNewMesssageNotificationSwich;
//声音开关
@property (nonatomic, strong) UISwitch * enableMakeSoundSwitch;
//震动开关
@property (nonatomic, strong) UISwitch * enableShockSwitch;
//扬声器开关
@property (nonatomic, strong) UISwitch * enableLoudSpeakerSwitch;
//定位开关
@property (nonatomic, strong) UISwitch * enableGetLocationSwitch;

@end

@implementation SDIMMyselfViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
    if (VAL_SHOW_ADD_FRIENDS) {
        [vc.tabBar.items[2] setBadgeValue:@" "];
    }
    else {
        [vc.tabBar.items[2] setBadgeValue:@""];
    }
    [self loadWorkCircleUnReadComments];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isSelectMenuSelected = NO;
    [self setupView];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
}

#pragma mark - 内部方法
- (void)loadWorkCircleUnReadComments
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSString * lastCommentCreateTime = [ud objectForKey:[NSString stringWithFormat:@"LSAT_COMMENT_CREATETIME_%@",VAL_HXACCOUNT]];
    NSArray * unReadComments;
    if(lastCommentCreateTime){
        unReadComments = [[SDDataBaseHelper shareDB]  getUnReadWorkCircleCommentPushModelArrayWithLastReadCommetCreateTime:@([lastCommentCreateTime longLongValue])];
    }else{
        unReadComments = [[SDDataBaseHelper shareDB] getWorkCircleCommentPushModelArray];
    }
    RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
    if((unReadComments && [unReadComments count] > 0) || VAL_HAVE_UNREAD_WORKCIRCLE_MESSAGE){
        //[vc.tabBar.items[2] setBadgeValue:@" "];
    }else{
        //[vc.tabBar.items[2] setBadgeValue:@""];
    }
}

- (void)tapGestureEvent:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGestureRecognizer locationInView:nil];
        //由于这里获取不到右上角的按钮，所以用location来获取到按钮的范围，把它排除出去
        if (![_selectMemu pointInside:[_selectMemu convertPoint:location fromView:self.view.window] withEvent:nil] && !(location.x > Screen_Width - 50 && location.y < navHigh)) {
            [self selectMenuViewDisappear];
        }
    }
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"我")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(goBack)];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(Screen_Width - 90, 20 + 7, 40, 40);
    [searchBtn setImage:[UIImage imageNamed:@"msgSearch"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"msgSearch"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.rootTopView addSubview:searchBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - TabBar_Height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = SDBackGroudColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.bounces = YES;
    
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = SDBackGroudColor;
}

- (void)searchBtnClick
{
    SDIMSearchVIewController * searchVIewController = [[SDIMSearchVIewController alloc] init];
    [self.navigationController pushViewController:searchVIewController animated:YES];
}

- (void)selectMenuViewDisappear
{
    _isSelectMenuSelected = NO;
    [_selectMemu removeFromSuperview];
    _selectMemu = nil;
}

- (void)sendMsgBtnEvent:(UIButton*)sender
{
    if (!_isSelectMenuSelected) {
        _isSelectMenuSelected = YES;
        NSArray* dataArray = @[ @"发起群聊"];
        NSArray* imageArray = @[ @"addGroupMessage"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    else {
        [self selectMenuViewDisappear];
    }
}

- (void)setCellWithImageName:(NSString *)imageName Text:(NSString *)text AndCell:(UITableViewCell *)cell
{
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(kImageLeftSpacing, (SDMeCellHeight - kImageHeight)/2, kImageHeight, kImageHeight);
    imageView.image = [UIImage imageNamed:imageName];
    imageView.highlightedImage = [UIImage imageNamed:imageName];
    [cell.contentView addSubview:imageView];
    
    UILabel * cellLabel = [[UILabel alloc] init];
    cellLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + kImageLeftSpacing, (SDMeCellHeight - SDMainMessageFont)/2, 300, SDMainMessageFont);
    cellLabel.textColor = [UIColor blackColor];
    cellLabel.backgroundColor = [UIColor clearColor];
    cellLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    cellLabel.text = text;
    cellLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:cellLabel];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setQRInviteImage
{
    _imageName = [NSString stringWithFormat:@"%@_邀请二维码_%@.png",VAL_companyId,VAL_USERID];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", kFilePath, _imageName];
    
    // 判断该路径是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // 判断该文件夹存不存在
        if (![[NSFileManager defaultManager] fileExistsAtPath:kFilePath])
        {
            // 新建文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:kFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    NSString * codeString = [NSString stringWithFormat:@"%@register/bsRegister.htm",urlPrefix];
    
    /// 生成二维码并保存
    UIImage * codeImage = [QRCodeGenerator qrImageForString:codeString imageSize:200.0];
    codeImage = [self combine:codeImage];
    BOOL finishyet = [UIImagePNGRepresentation(codeImage) writeToFile:filePath atomically:YES];
    
    if (finishyet) {
        QLPreviewController* previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        [self presentViewController:previewController animated:YES completion:nil];
    }
    
}

- (void)setCellLabelWithText:(NSString *)text AndCell:(UITableViewCell *)cell
{
    UILabel * textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing, (SDMeCellHeight - SDMainMessageFont)/2, 300, SDMainMessageFont);
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = text;
    textLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    [cell.contentView addSubview:textLabel];
}

- (void)enableGetNewMesssageNotificationSwichChanged
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_enableGetNewMesssageNotificationSwich.on forKey:ENABLE_GET_NEW_MESSAGE_NOTIFICATION];
    [ud synchronize];
    [_tableView reloadData];
}

- (void)enableMakeSoundSwitchChanged
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_enableMakeSoundSwitch.on forKey:ENABLE_MAKE_SOUND];
    [ud synchronize];
}

- (void)enableShockSwitchChanged
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_enableShockSwitch.on forKey:ENABLE_SHOCK];
    [ud synchronize];
}

- (void)enableLoudSpeakerSwitchChanged
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_enableLoudSpeakerSwitch.on forKey:ENABLE_LOUD_SPEAKER];
    [ud synchronize];
}

- (void)enableGetLocationSwitchChanged
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_enableGetLocationSwitch.on forKey:ENABLE_GET_LOCATION];
    [ud synchronize];
}

#pragma mark - 获取录音文件的大小
-(unsigned long long)getCachesForVoice
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/voice",NSHomeDirectory()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        return 0;
    }
    
    NSEnumerator *childFileEnumrator = [[[NSFileManager defaultManager] subpathsAtPath:voicePath] objectEnumerator];
    
    unsigned long long fileSize = 0;
    NSString *filePath = nil;
    while ((filePath = [childFileEnumrator nextObject]) != nil) {
        NSString *fileAbsolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fileAbsolutePath]) {
            fileSize += [[[NSFileManager defaultManager]attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
    }
    
    return fileSize;
}

#pragma mark - 获取语音会议文件的大小
-(unsigned long long)getCachesForVoiceMeeting
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/voiceMeeting",NSHomeDirectory()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        return 0;
    }
    
    NSEnumerator *childFileEnumrator = [[[NSFileManager defaultManager] subpathsAtPath:voicePath] objectEnumerator];
    
    unsigned long long fileSize = 0;
    NSString *filePath = nil;
    while ((filePath = [childFileEnumrator nextObject]) != nil) {
        NSString *fileAbsolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fileAbsolutePath]) {
            fileSize += [[[NSFileManager defaultManager]attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
    }
    
    return fileSize;
}

#pragma mark - 获取项目协同图片发送目录文件的大小
-(unsigned long long)getCachesForProjectCollaborationPictureSendFile
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/ProjectCollaborationPictureSend",NSHomeDirectory()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        return 0;
    }
    
    NSEnumerator *childFileEnumrator = [[[NSFileManager defaultManager] subpathsAtPath:voicePath] objectEnumerator];
    
    unsigned long long fileSize = 0;
    NSString *filePath = nil;
    while ((filePath = [childFileEnumrator nextObject]) != nil) {
        NSString *fileAbsolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fileAbsolutePath]) {
            fileSize += [[[NSFileManager defaultManager]attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
    }
    
    return fileSize;
}

#pragma mark - 获取项目协同语音目录文件的大小
-(unsigned long long)getCachesForProjectCollaborationVoiceFile
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/ProjectCollaborationVoice",NSHomeDirectory()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        return 0;
    }
    
    NSEnumerator *childFileEnumrator = [[[NSFileManager defaultManager] subpathsAtPath:voicePath] objectEnumerator];
    
    unsigned long long fileSize = 0;
    NSString *filePath = nil;
    while ((filePath = [childFileEnumrator nextObject]) != nil) {
        NSString *fileAbsolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fileAbsolutePath]) {
            fileSize += [[[NSFileManager defaultManager]attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
    }
    
    return fileSize;
}

#pragma mark - 获取项目协同图片目录文件的大小
-(unsigned long long)getCachesForProjectCollaborationPictureFile
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/ProjectCollaborationPicture",NSHomeDirectory()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        return 0;
    }
    
    NSEnumerator *childFileEnumrator = [[[NSFileManager defaultManager] subpathsAtPath:voicePath] objectEnumerator];
    
    unsigned long long fileSize = 0;
    NSString *filePath = nil;
    while ((filePath = [childFileEnumrator nextObject]) != nil) {
        NSString *fileAbsolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fileAbsolutePath]) {
            fileSize += [[[NSFileManager defaultManager]attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
    }
    
    return fileSize;
}
#pragma mark - 清除附件文件
-(void)clearFJFile{
    
}
#pragma mark -- 清除录音文件
-(void)clearVoiceFile
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/voice",NSHomeDirectory()];
    
    
    NSEnumerator *childEnumerator = [[[NSFileManager defaultManager]contentsOfDirectoryAtPath:voicePath error:nil] objectEnumerator];
    NSString *filePath = nil;
    while(filePath = [childEnumerator nextObject]) {
        NSString *absolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:absolutePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:absolutePath error:nil];
        }
    }
}

#pragma mark -- 清除语音会议文件
-(void)clearVoiceMeetingFile
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/voiceMeeting",NSHomeDirectory()];
    
    
    NSEnumerator *childEnumerator = [[[NSFileManager defaultManager]contentsOfDirectoryAtPath:voicePath error:nil] objectEnumerator];
    NSString *filePath = nil;
    while(filePath = [childEnumerator nextObject]) {
        NSString *absolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:absolutePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:absolutePath error:nil];
        }
    }
}

#pragma mark -- 清除项目协同图片发送目录文件
-(void)clearProjectCollaborationPictureSendFile
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/ProjectCollaborationPictureSend",NSHomeDirectory()];
    
    
    NSEnumerator *childEnumerator = [[[NSFileManager defaultManager]contentsOfDirectoryAtPath:voicePath error:nil] objectEnumerator];
    NSString *filePath = nil;
    while(filePath = [childEnumerator nextObject]) {
        NSString *absolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:absolutePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:absolutePath error:nil];
        }
    }
}

#pragma mark -- 清除项目协同语音目录文件
-(void)clearProjectCollaborationVoiceFile
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/ProjectCollaborationVoice",NSHomeDirectory()];
    
    
    NSEnumerator *childEnumerator = [[[NSFileManager defaultManager]contentsOfDirectoryAtPath:voicePath error:nil] objectEnumerator];
    NSString *filePath = nil;
    while(filePath = [childEnumerator nextObject]) {
        NSString *absolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:absolutePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:absolutePath error:nil];
        }
    }
}

#pragma mark -- 清除项目协同图片目录文件
-(void)clearProjectCollaborationPictureFile
{
    NSString *voicePath = [NSString stringWithFormat:@"%@/Documents/ProjectCollaborationPicture",NSHomeDirectory()];
    
    
    NSEnumerator *childEnumerator = [[[NSFileManager defaultManager]contentsOfDirectoryAtPath:voicePath error:nil] objectEnumerator];
    NSString *filePath = nil;
    while(filePath = [childEnumerator nextObject]) {
        NSString *absolutePath = [NSString stringWithFormat:@"%@/%@",voicePath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:absolutePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:absolutePath error:nil];
        }
    }
}



- (void)logoutBtnClick
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = 2;
    [alertView show];
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    [self selectMenuViewDisappear];
    
    if (cardID == 0) {
        [self showHudInView:self.view hint:@"加载中"];
        __weak typeof(self) weakSelf = self;
        CXIDGGroupAddUsersViewController * selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
        selectColleaguesViewController.navTitle = @"发起群聊";
        selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[[CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]]]];
        selectColleaguesViewController.selectContactUserCallBack = ^(NSArray * selectContactUserArr){
            if (selectContactUserArr.count == 1) {
                //单聊
                NSMutableArray* hxAccount = [[selectContactUserArr valueForKey:@"hxAccount"] mutableCopy];
                
                SDIMChatViewController* chat = [[SDIMChatViewController alloc] init];
                chat.chatter = hxAccount[0];
                NSString* name = [CXIMHelper getRealNameByAccount:hxAccount[0]];
                chat.chatterDisplayName = name;
                chat.isGroupChat = NO;
                [weakSelf.navigationController pushViewController:chat animated:YES];
            }
            else {
                //群聊
                weakSelf.chatContactsArray = [selectContactUserArr mutableCopy];
                
                _alertView = [[UIAlertView alloc] initWithTitle:@"设置群聊名称" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                _alertView.tag = 3;
                [_alertView show];
            }
            
        };
        [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
        [self hideHud];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        return 15;
    }
    return 13;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"SDIMMyselfViewControllerCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
    }
    
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 9 || indexPath.row == 12 || indexPath.row == 14){
            cell.contentView.backgroundColor = SDBackGroudColor;
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        if(indexPath.row == 1 || indexPath.row == 10 || indexPath.row == 11){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 10 || indexPath.row == 12){
            cell.contentView.backgroundColor = SDBackGroudColor;
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        if(indexPath.row == 1 || indexPath.row == 8 || indexPath.row == 9){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if(indexPath.row == 1){
        UIImageView * headImageView = [[UIImageView alloc] init];
        headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, kHeightOfHeadCell - SDHeadImageViewLeftSpacing*2, kHeightOfHeadCell - SDHeadImageViewLeftSpacing*2);
        SDCompanyUserModel * userModel = [CXIMHelper getUserByIMAccount:VAL_HXACCOUNT];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[userModel.icon isKindOfClass:[NSNull class]]?@"":userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        [cell.contentView addSubview:headImageView];
        
        UIButton * theQRCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        theQRCodeBtn.frame = CGRectMake(Screen_Width - 20 - 15 - kQRCodeWidth, (kHeightOfHeadCell - kQRCodeWidth)/2, kQRCodeWidth, kQRCodeWidth);
        [theQRCodeBtn setBackgroundImage:[UIImage imageNamed:@"self_invition"] forState:UIControlStateNormal];
        [theQRCodeBtn setBackgroundImage:[UIImage imageNamed:@"self_invition"] forState:UIControlStateHighlighted];
        [theQRCodeBtn addTarget:self action:@selector(setQrWithPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
        //        [cell.contentView addSubview:theQRCodeBtn];
        
        UILabel * nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing,(kHeightOfHeadCell - SDMainMessageFont)/2, CGRectGetMinX(theQRCodeBtn.frame) - SDHeadImageViewLeftSpacing - (CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing), SDMainMessageFont);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = userModel.realName;
        [cell.contentView addSubview:nameLabel];
        
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        if(indexPath.row == 3){
            [self setCellLabelWithText:@"接收新消息通知" AndCell:cell];
            
            _enableGetNewMesssageNotificationSwich = [[UISwitch alloc] init];
            _enableGetNewMesssageNotificationSwich.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableGetNewMesssageNotificationSwich.on = VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION;
            [_enableGetNewMesssageNotificationSwich addTarget:self action:@selector(enableGetNewMesssageNotificationSwichChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableGetNewMesssageNotificationSwich];
            
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
        }
        else if(indexPath.row == 4){
            [self setCellLabelWithText:@"声音" AndCell:cell];
            
            _enableMakeSoundSwitch = [[UISwitch alloc] init];
            _enableMakeSoundSwitch.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableMakeSoundSwitch.on = VAL_ENABLE_MAKE_SOUND;
            [_enableMakeSoundSwitch addTarget:self action:@selector(enableMakeSoundSwitchChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableMakeSoundSwitch];
            
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
        }
        else if(indexPath.row == 5){
            [self setCellLabelWithText:@"震动" AndCell:cell];
            
            _enableShockSwitch = [[UISwitch alloc] init];
            _enableShockSwitch.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableShockSwitch.on = VAL_ENABLE_SHOCK;
            [_enableShockSwitch addTarget:self action:@selector(enableShockSwitchChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableShockSwitch];
        }
        
        else if(indexPath.row == 7){
            [self setCellLabelWithText:@"使用扬声器播放语音" AndCell:cell];
            cell.accessoryType =  UITableViewCellAccessoryNone;
            _enableLoudSpeakerSwitch = [[UISwitch alloc] init];
            _enableLoudSpeakerSwitch.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableLoudSpeakerSwitch.on = VAL_ENABLE_LOUD_SPEAKER;
            [_enableLoudSpeakerSwitch addTarget:self action:@selector(enableLoudSpeakerSwitchChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableLoudSpeakerSwitch];
            
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
        }
        else if(indexPath.row == 8){
            [self setCellLabelWithText:@"定位" AndCell:cell];
            
            _enableGetLocationSwitch = [[UISwitch alloc] init];
            _enableGetLocationSwitch.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableGetLocationSwitch.on = VAL_ENABLE_GET_LOCATION;
            [_enableGetLocationSwitch addTarget:self action:@selector(enableGetLocationSwitchChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableGetLocationSwitch];
        }
        else if(indexPath.row == 10){
            unsigned long long cacheSize = [[CXIMService sharedInstance].cacheManager getCacheSize];
            cacheSize += [self getCachesForVoice];
            cacheSize += [self getCachesForVoiceMeeting];
            cacheSize += [self getCachesForProjectCollaborationPictureSendFile];
            cacheSize += [self getCachesForProjectCollaborationVoiceFile];
            cacheSize += [self getCachesForProjectCollaborationPictureFile];
            CGFloat cacheKB = cacheSize/1024;
            
            if(cacheKB < 1024){
                [self setCellLabelWithText:[NSString stringWithFormat:@"清除本地缓存%.0fKB",cacheKB] AndCell:cell];
            }else{
                [self setCellLabelWithText:[NSString stringWithFormat:@"清除本地缓存%.2fMB",cacheKB/1024] AndCell:cell];
            }
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 11){
            [self setCellLabelWithText:@"发送客户端地址/二维码" AndCell:cell];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
        }
        else if(indexPath.row == 13){
            UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutBtn.frame = CGRectMake(0, 0, Screen_Width, SDMeCellHeight);
            logoutBtn.backgroundColor = [UIColor whiteColor];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateHighlighted];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            logoutBtn.titleLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
            [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:logoutBtn];
        }
        else if(indexPath.row == 14){
            UIView * coverView = [[UIView alloc] init];
            coverView.frame = CGRectMake(0, 13, Screen_Width, 4);
            coverView.backgroundColor = SDBackGroudColor;
            [cell.contentView addSubview:coverView];
        }
    }else{
        if(indexPath.row == 3){
            [self setCellLabelWithText:@"接收新消息通知" AndCell:cell];
            
            _enableGetNewMesssageNotificationSwich = [[UISwitch alloc] init];
            _enableGetNewMesssageNotificationSwich.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableGetNewMesssageNotificationSwich.on = VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION;
            [_enableGetNewMesssageNotificationSwich addTarget:self action:@selector(enableGetNewMesssageNotificationSwichChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableGetNewMesssageNotificationSwich];
            
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
        }
        else if(indexPath.row == 5){
            [self setCellLabelWithText:@"使用扬声器播放语音" AndCell:cell];
            
            _enableLoudSpeakerSwitch = [[UISwitch alloc] init];
            _enableLoudSpeakerSwitch.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableLoudSpeakerSwitch.on = VAL_ENABLE_LOUD_SPEAKER;
            [_enableLoudSpeakerSwitch addTarget:self action:@selector(enableLoudSpeakerSwitchChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableLoudSpeakerSwitch];
            
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
        }
        else if(indexPath.row == 6){
            [self setCellLabelWithText:@"定位" AndCell:cell];
            
            _enableGetLocationSwitch = [[UISwitch alloc] init];
            _enableGetLocationSwitch.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableGetLocationSwitch.on = VAL_ENABLE_GET_LOCATION;
            [_enableGetLocationSwitch addTarget:self action:@selector(enableGetLocationSwitchChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableGetLocationSwitch];
        }
        else if(indexPath.row == 8){
            unsigned long long cacheSize = [[CXIMService sharedInstance].cacheManager getCacheSize];
            cacheSize += [self getCachesForVoice];
            cacheSize += [self getCachesForVoiceMeeting];
            cacheSize += [self getCachesForProjectCollaborationPictureSendFile];
            cacheSize += [self getCachesForProjectCollaborationVoiceFile];
            cacheSize += [self getCachesForProjectCollaborationPictureFile];
            CGFloat cacheKB = cacheSize/1024;
            if(cacheKB < 1024){
                [self setCellLabelWithText:[NSString stringWithFormat:@"清除本地缓存%.0fKB",cacheKB] AndCell:cell];
            }else{
                [self setCellLabelWithText:[NSString stringWithFormat:@"清除本地缓存%.2fMB",cacheKB/1024] AndCell:cell];
            }
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 9){
            [self setCellLabelWithText:@"发送客户端地址/二维码" AndCell:cell];
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(8, SDMeCellHeight - 0.5, Screen_Width - 16, 0.5);
            lineView.backgroundColor = RGBACOLOR(226, 226, 226, 1.0);
            [cell.contentView addSubview:lineView];
        }
        else if(indexPath.row == 11){
            UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutBtn.frame = CGRectMake(0, 0, Screen_Width, SDMeCellHeight);
            logoutBtn.backgroundColor = [UIColor whiteColor];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateHighlighted];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            logoutBtn.titleLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
            [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:logoutBtn];
        }
        else if(indexPath.row == 12){
            UIView * coverView = [[UIView alloc] init];
            coverView.frame = CGRectMake(0, 13, Screen_Width, 4);
            coverView.backgroundColor = SDBackGroudColor;
            [cell.contentView addSubview:coverView];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        if(indexPath.row == 0){
            return 0;
        }
        if(indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 9 || indexPath.row == 12 || indexPath.row == 14){
            return 15;
        }
        else if(indexPath.row == 1){
            return kHeightOfHeadCell;
        }
        return SDMeCellHeight;
    }else{
        if(indexPath.row == 0){
            return 0;
        }
        if(indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 10 || indexPath.row == 12){
            return 15;
        }
        else if(indexPath.row == 1){
            return kHeightOfHeadCell;
        }
        return SDMeCellHeight;
    }
    return SDMeCellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1){
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.canPopViewController = YES;
        SDCompanyUserModel * userModel = [CXIMHelper getUserByIMAccount:VAL_HXACCOUNT];
        pivc.imAccount = userModel.imAccount;
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        if(indexPath.row == 10){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除本地缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [alertView show];
        }
        else if(indexPath.row == 11){
            SDCreateZbarImageViewController* czivc = [[SDCreateZbarImageViewController alloc] init];
            [self.navigationController pushViewController:czivc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
        else if(indexPath.row == 13){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            alertView.tag = 2;
            [alertView show];
        }
    }else{
        if(indexPath.row == 8){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除本地缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [alertView show];
        }
        else if(indexPath.row == 9){
            SDCreateZbarImageViewController* czivc = [[SDCreateZbarImageViewController alloc] init];
            [self.navigationController pushViewController:czivc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
        else if(indexPath.row == 11){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            alertView.tag = 2;
            [alertView show];
        }
    }
}

//此代理方法用来重置cell分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController*)previewController
{
    return 1;
}

- (id)previewController:(QLPreviewController*)previewController previewItemAtIndex:(NSInteger)idx
{
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", kFilePath, _imageName];
    QLPreviewItemCustom *obj = [[QLPreviewItemCustom alloc] initWithTitle:@"" url:[NSURL fileURLWithPath:filePath]];
    return obj;
}

#pragma mark - 生成二维码
- (void)setQrWithPhoneNumber
{
    _imageName = [NSString stringWithFormat:@"好友二维码_%@.png",VAL_USERID];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", kFilePath, _imageName];
    
    // 判断该路径是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // 判断该文件夹存不存在
        if (![[NSFileManager defaultManager] fileExistsAtPath:kFilePath])
        {
            // 新建文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:kFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    SDCompanyUserModel * user = [CXIMHelper getUserByIMAccount:VAL_HXACCOUNT];
    
    //生成二维码的字符串，userId&imAccount&userName&cx:injoy365.cn
    NSString * codeString = [NSString stringWithFormat:@"%@&%@&%@&%@",user.userId.stringValue,user.imAccount,user.realName,@"cx:injoy365.cn"];
    
    /// 生成二维码并保存
    UIImage * codeImage = [QRCodeGenerator qrImageForString:codeString imageSize:200.0];
    codeImage = [self combine:codeImage];
    BOOL finishyet = [UIImagePNGRepresentation(codeImage) writeToFile:filePath atomically:YES];
    
    if (finishyet) {
        QLPreviewController* previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        [self presentViewController:previewController animated:YES completion:nil];
    }
}

- (UIImage *) combine:(UIImage*)innerImage
{
    UIImage *outImage = [UIImage imageNamed:@"newqrSao"];
    
    CGSize offScreenSize = CGSizeMake(outImage.size.width, outImage.size.height);
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, offScreenSize.width, offScreenSize.height);
    [outImage drawInRect:rect];
    
    rect = CGRectMake(60, 80, 200, 200);
    [innerImage drawInRect:rect];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imagez;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (_isSelectMenuSelected == YES) {
        [self selectMenuViewDisappear];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2){
        if(buttonIndex == 1){
            //            [self showHudInView:self.view hint:@"正在退出..."];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
            [[CXIMService sharedInstance] logout];
            // 定位到企信
            RDVTabBarController* tabBarVC = [(AppDelegate*)[UIApplication sharedApplication].delegate getRDVTabBarController];
            tabBarVC.selectedIndex = 0;
            //隐藏状态栏
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            // 关闭socket
            [[SDWebSocketManager shareWebSocketManager] closeSocket];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            //            [self hideHud];
        }
    }else if(alertView.tag == 3){
        if (buttonIndex == 1) {
            UITextField* textField = [_alertView textFieldAtIndex:0];
            NSString* groupName = trim(textField.text);
            if (groupName.length <= 0) {
                TTAlert(@"群组名称不能为空");
                return;
            }
            if([_chatContactsArray count] > 49){
                [self.view makeToast:@"群聊人数最多50人，请重新选择！" duration:2 position:@"center"];
                return;
            }
            NSMutableArray* hxAccount = [[_chatContactsArray valueForKey:@"hxAccount"] mutableCopy];
            
            if (hxAccount.count) {
                NSMutableArray* members = [NSMutableArray array];
                [hxAccount enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL* stop) {
                    [members addObject:obj];
                }];
                [self showHudInView:self.view hint:@"正在创建群组"];
                __weak typeof(self) weakSelf = self;
                [[CXIMService sharedInstance].groupManager erpCreateGroupWithName:groupName type:CXGroupTypeNormal owner:[[CXLoaclDataManager sharedInstance] getGroupUserFromLocalContactsDicWithIMAccount:VAL_HXACCOUNT] members:[[CXLoaclDataManager sharedInstance]  getGroupUsersFromLocalContactsDicWithIMAccountArray:members] completion:^(CXGroupInfo *group, NSError *error) {
                    [weakSelf hideHud];
                    if (!error) {
                        SDIMChatViewController* chat = [[SDIMChatViewController alloc] init];
                        chat.chatter = group.groupId;
                        chat.chatterDisplayName = groupName;
                        chat.isGroupChat = YES;
                        [weakSelf.navigationController pushViewController:chat animated:YES];
                    }
                    else {
                        TTAlert(@"创建失败");
                    }
                    
                }];
            }
        }
        else {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }else{
        if(buttonIndex == 1){
            [self showHudInView:self.view hint:@"清理中。。。"];
            __weak typeof(self) weakSelf = self;
            [[CXIMService sharedInstance].cacheManager clearCache:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:10 inSection:0];
                    if(!VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
                        indexPath=[NSIndexPath indexPathForRow:8 inSection:0];
                    }
                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf hideHud];
                });
            }];
            //清除附件文件
            [self clearFJFile];
            //清除录音文件
            [self clearVoiceFile];
            //清除语音会议文件
            [self clearVoiceMeetingFile];
            //清除项目协同图片发送目录文件
            [self clearProjectCollaborationPictureSendFile];
            //清除项目协同语音目录文件
            [self clearProjectCollaborationVoiceFile];
            //清除项目协同图片目录文件
            [self clearProjectCollaborationPictureFile];
        }
    }
}

@end
