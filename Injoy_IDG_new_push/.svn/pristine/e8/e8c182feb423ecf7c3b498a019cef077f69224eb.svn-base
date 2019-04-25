//
//  SDInviteViewController.m
//  InjoySOHO
//
//  Created by admin on 15/12/25.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//  邀请同事

#import "SDInviteViewController.h"
#import "SDMenuView.h"
#import "QRCodeGenerator.h"
#import "QLPreviewItemCustom.h"
#import "SDCreateZbarImageViewController.h"
#import "SDInvitePictureViewController.h"

#define kFilePath [NSString stringWithFormat:@"%@/Documents/QR", NSHomeDirectory()]

@interface SDInviteViewController () <UITableViewDataSource,UITableViewDelegate,SDMenuViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) UITableView* myTableView;
@property (nonatomic, strong) NSString * imageName;
@end

@implementation SDInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTopView];
    [self setupTableView];
}

#pragma mark - UI
///// 导航条
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"邀请加入"];
    
    // 返回按钮
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

///// 表格
- (void)setupTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.rowHeight = 55.f;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_myTableView];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inviteCell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inviteCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        for(UIView * view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
    }
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _myTableView.rowHeight-1, Screen_Width, 1)];
    lineLabel.tag = 103;
    lineLabel.backgroundColor = RGBACOLOR(218.0, 218.0, 218.0, 1.0);
    [cell.contentView addSubview:lineLabel];
    cell.textLabel.font = kFontForAppFunction;
    if(indexPath.row == 0){
        cell.textLabel.text = @"二维码";
        cell.imageView.image = [UIImage imageNamed:@"invite_qr"];
    }else{
        cell.textLabel.text = @"复制文本";
        cell.imageView.image = [UIImage imageNamed:@"invite_copy"];
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        SDInvitePictureViewController* pivc = [[SDInvitePictureViewController alloc] init];
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 1){
        [self textInvite];
    }
}

///// 复制邀请
- (void)textInvite
{
    /// 生成复制文本
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:VAL_YAOURL];
    if (pab == nil)
    {
        TTAlert(@"复制失败");
    }
    else
    {
        TTAlert(@"邀请内容已经复制到剪切板");
    }
}

#pragma mark - 生成二维码
- (void)setQrImage
{
    _imageName = [NSString stringWithFormat:@"邀请二维码_%@.png",VAL_USERID];
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
    //生成二维码的字符串，userId&imAccount&userName&cx:injoy365.cn
    NSString * codeString = VAL_YAOURL;
    
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
    
    rect = CGRectMake(100, 10, 300, 300);
    [innerImage drawInRect:rect];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imagez;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

