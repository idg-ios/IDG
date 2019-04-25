//
//  SDIMMySettingViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMMySettingViewController.h"
#import "SDCreateZbarImageViewController.h"
#import "AppDelegate.h"
#import "SDWebSocketManager.h"
#import "SDDataBaseHelper.h"
#import "CXAnnexDownLoadManager.h"
#define FJPath [NSString stringWithFormat:@"%@FJPath",VAL_USERID]
@interface SDIMMySettingViewController()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

//导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
//内容视图
@property (nonatomic, strong) UITableView* tableView;
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

@implementation SDIMMySettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"homeDictory = %@",NSHomeDirectory());
    unsigned long long size = [self getCachesForVoice];
    NSLog(@"fdsafdsa = %llu",size);
    
    [self setupView];
}

- (void)setupView
{
    self.view.backgroundColor = SDBackGroudColor;
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"设置")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.tableView.backgroundColor = SDBackGroudColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.bounces = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)logoutBtnClick
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = 2;
    [alertView show];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
       return 9;
    }
    return 7;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        if(indexPath.row == 4 || indexPath.row == 7){
            return 15;
        }
        else if(indexPath.row == 0){
            return 0;
        }
        else if(indexPath.row == 9){
            return 60 + SDMeCellHeight;
        }
        return SDMeCellHeight;
    }else{
        if(indexPath.row == 2 || indexPath.row == 5){
            return 15;
        }
        else if(indexPath.row == 0){
            return 0;
        }
        else if(indexPath.row == 7){
            return 60 + SDMeCellHeight;
        }
        return SDMeCellHeight;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString * cellName = @"SDSettingCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        if(indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 9 ){
            cell.contentView.backgroundColor = SDBackGroudColor;
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
    }else{
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 7 ){
            cell.contentView.backgroundColor = SDBackGroudColor;
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        if(indexPath.row == 1){
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
        else if(indexPath.row == 2){
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
        else if(indexPath.row == 3){
            [self setCellLabelWithText:@"震动" AndCell:cell];
            
            _enableShockSwitch = [[UISwitch alloc] init];
            _enableShockSwitch.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableShockSwitch.on = VAL_ENABLE_SHOCK;
            [_enableShockSwitch addTarget:self action:@selector(enableShockSwitchChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableShockSwitch];
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
            cacheSize += [self getCachesForFuJian];
            cacheSize += [[CXAnnexDownLoadManager sharedManager]getToatalCacheSize];
            cacheSize += [self getSPAnnexCache];
            CGFloat cacheKB = cacheSize/1024;
            
            if(cacheKB < 1024){
                [self setCellLabelWithText:[NSString stringWithFormat:@"清除本地缓存%.0fKB",cacheKB] AndCell:cell];
            }else{
                [self setCellLabelWithText:[NSString stringWithFormat:@"清除本地缓存%.2fMB",cacheKB/1024] AndCell:cell];
            }
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 9){
            UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutBtn.frame = CGRectMake(0, 30, Screen_Width, SDMeCellHeight);
            logoutBtn.backgroundColor = [UIColor whiteColor];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateHighlighted];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            logoutBtn.titleLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
            [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:logoutBtn];
            
            UIView * coverView = [[UIView alloc] init];
            coverView.frame = CGRectMake(0, SDMeCellHeight + 58, Screen_Width, 4);
            coverView.backgroundColor = SDBackGroudColor;
            [cell.contentView addSubview:coverView];
        }
    }else{
        if(indexPath.row == 1){
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
        else if(indexPath.row == 3){
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
        else if(indexPath.row == 4){
            [self setCellLabelWithText:@"定位" AndCell:cell];
            
            _enableGetLocationSwitch = [[UISwitch alloc] init];
            _enableGetLocationSwitch.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 50, 9, 50, 15);
            _enableGetLocationSwitch.on = VAL_ENABLE_GET_LOCATION;
            [_enableGetLocationSwitch addTarget:self action:@selector(enableGetLocationSwitchChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:_enableGetLocationSwitch];
        }
        else if(indexPath.row == 6){
            unsigned long long cacheSize = [[CXIMService sharedInstance].cacheManager getCacheSize];
            cacheSize += [self getCachesForVoice];
            cacheSize += [self getCachesForFuJian];
            cacheSize += [[CXAnnexDownLoadManager sharedManager]getToatalCacheSize];
            cacheSize += [self getSPAnnexCache];
            CGFloat cacheKB = cacheSize/1024;
            if(cacheKB < 1024){
                [self setCellLabelWithText:[NSString stringWithFormat:@"清除本地缓存%.0fKB",cacheKB] AndCell:cell];
            }else{
                [self setCellLabelWithText:[NSString stringWithFormat:@"清除本地缓存%.2fMB",cacheKB/1024] AndCell:cell];
            }
            cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 7){
            UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutBtn.frame = CGRectMake(0, 30, Screen_Width, SDMeCellHeight);
            logoutBtn.backgroundColor = [UIColor whiteColor];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateHighlighted];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            logoutBtn.titleLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
            [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:logoutBtn];
            
            UIView * coverView = [[UIView alloc] init];
            coverView.frame = CGRectMake(0, SDMeCellHeight + 58, Screen_Width, 4);
            coverView.backgroundColor = SDBackGroudColor;
            [cell.contentView addSubview:coverView];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - 获取录音文件的大小
- (unsigned long long)getSPAnnexCache{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"costOf%@", VAL_USERID]];
    NSEnumerator *filPaths = [filemanager enumeratorAtPath:filePath];
    unsigned long long fileSize = 0;
    NSString *path = nil;
    while ((path = [filPaths nextObject]) != nil) {
        path = [filePath stringByAppendingPathComponent:path];
        NSEnumerator *subFilePaths= [filemanager enumeratorAtPath:path];
        NSString *subPath = nil;
        while ((subPath = [subFilePaths nextObject]) != nil) {
            if ([filemanager fileExistsAtPath:subPath]) {
                fileSize += [[filemanager attributesOfItemAtPath:subPath error:nil] fileSize];
            }
        }
    }
    return fileSize;
}
-(unsigned long long)getCachesForFuJian{
    NSString *fjPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:FJPath];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if(![filemanager fileExistsAtPath:fjPath]){
        return 0;
    }
    NSEnumerator *childFileEnumrator = [filemanager subpathsAtPath:fjPath].objectEnumerator;
    unsigned long long fileSize = 0;
    NSString *filePath = nil;
    while ((filePath = [childFileEnumrator nextObject]) != nil) {
        NSString *fileAbsolutePath = [NSString stringWithFormat:@"%@/%@",fjPath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fileAbsolutePath]) {
            fileSize += [[[NSFileManager defaultManager]attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
    }
    return fileSize;

}
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

#pragma mark -- 清楚录音文件
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
-(void)clearFJFile{
    NSString *fjPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:FJPath];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if(![filemanager fileExistsAtPath:fjPath]){
        return;
    }
    NSEnumerator *childFileEnumrator = [filemanager subpathsAtPath:fjPath].objectEnumerator;
    NSString *filePath = nil;
    while ((filePath = [childFileEnumrator nextObject]) != nil) {
        NSString *fileAbsolutePath = [NSString stringWithFormat:@"%@/%@",fjPath,filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:fileAbsolutePath]) {
            [filemanager removeItemAtPath:fileAbsolutePath error:nil] ;
        }
    }

}
- (void)clearSPAnnexCache{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"costOf%@", VAL_USERID]];
    NSEnumerator *filPaths = [filemanager enumeratorAtPath:filePath];
    NSString *path = nil;
    while ((path = [filPaths nextObject]) != nil) {
        path = [filePath stringByAppendingPathComponent:path];
        NSEnumerator *subFilePaths= [filemanager enumeratorAtPath:path];
        NSString *subPath = nil;
        while ((subPath = [subFilePaths nextObject]) != nil) {
            if ([filemanager fileExistsAtPath:subPath]) {
                [filemanager removeItemAtPath:subPath error:nil];
            }
        }
        [filemanager removeItemAtPath:path error:nil];
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
        if(indexPath.row == 8){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除本地缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [alertView show];
        }
    }else{
        if(indexPath.row == 6){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除本地缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [alertView show];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            [self showHudInView:self.view hint:@"清理中。。。"];
            __weak typeof(self) weakSelf = self;
            [[CXIMService sharedInstance].cacheManager clearCache:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:8 inSection:0];
                    if(!VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION){
                        indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
                    }
                    [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [weakSelf hideHud];
                });
            }];
            
            //清楚录音文件
            [self clearVoiceFile];
            [self clearFJFile];
            [[CXAnnexDownLoadManager sharedManager]clearCacheData];
        }
    }
    else if(alertView.tag == 2){
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
        }
    }
}

@end
