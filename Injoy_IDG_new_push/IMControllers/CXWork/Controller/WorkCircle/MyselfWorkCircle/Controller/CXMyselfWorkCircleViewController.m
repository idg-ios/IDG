//
//  CXMyselfWorkCircleViewController.m
//  InjoyERP
//
//  Created by wtz on 16/11/23.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXMyselfWorkCircleViewController.h"
#import "AppDelegate.h"
#import "CXIMHelper.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"
#import "UIView+Category.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXAllPeoplleWorkCircleModel.h"
#import "CXMyselfWorkTableViewCell.h"
#import "CXWorkCircleDetailViewController.h"
#import "IBActionSheet.h"
#import "UIImageView+EMWebCache.h"
#import "CXLoaclDataManager.h"
#import "SDIMPersonInfomationViewController.h"
#import "AliImageReshapeController.h"

#define kTableHeaderViewHeight ((Screen_Width*384.0/1242.0) + 35)

#define kRightImageSpace 15

#define kHeadImageWidth 65

#define kTimeLeftSpace 10
#define kTimeTopSpace 15
#define kDayLabelFontSize 16.0
#define kMonthLabelFontSize 12.0
#define kTypeLabelFontSize 15.0
#define kTitleLabelFontSize 14.0
#define kTextColor [UIColor blackColor]
#define kGrayBackGroundViewTopSpace 3
#define kTypeImageLeftSpace 10
#define kTypeImageWidth 25
#define kGrayBackGroundViewMoveLeft 3
#define kGrayBackGroundViewBottomSpace 15
#define kMyselfWorkCellHeight (kTimeTopSpace + kTypeLabelFontSize + kGrayBackGroundViewTopSpace + kTypeImageLeftSpace + kTypeImageWidth + kTypeImageLeftSpace + kGrayBackGroundViewBottomSpace)

#define kImageIconPath @"imageIconPath"

@interface CXMyselfWorkCircleViewController ()<UITableViewDataSource, UITableViewDelegate,IBActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ALiImageReshapeDelegate>

//导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView * tableHeaderView;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic) NSInteger page;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) IBActionSheet* standardIBAS;

@property (nonatomic, strong) UIImageView * tableHeaderImageView;

@end

@implementation CXMyselfWorkCircleViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView
{
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT];
    
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(userModel.name)];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    self.page = 1;
    
    self.tableHeaderView = [[UIView alloc] init];
    self.tableHeaderView.frame = CGRectMake(0, 0, Screen_Width, kTableHeaderViewHeight);
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _tableHeaderImageView = [[UIImageView alloc] init];
    _tableHeaderImageView.image = [UIImage imageNamed:@"workCircleTopBackImage"];
    _tableHeaderImageView.highlightedImage = [UIImage imageNamed:@"workCircleTopBackImage"];
    _tableHeaderImageView.frame = CGRectMake(0, 0, Screen_Width, kTableHeaderViewHeight - 20);
    _tableHeaderImageView.userInteractionEnabled = YES;
    [self.tableHeaderView addSubview:_tableHeaderImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeaderImageViewClick)];
    [_tableHeaderImageView addGestureRecognizer:tap];
    
    UILabel * nameLabel = [[UILabel alloc] init];
    nameLabel.text = userModel.name;
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(Screen_Width - kRightImageSpace - kHeadImageWidth - kRightImageSpace - nameLabel.size.width, Screen_Width<=321?70:90, nameLabel.size.width, 15.0);
    [self.tableHeaderView addSubview:nameLabel];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + kRightImageSpace, CGRectGetMinY(nameLabel.frame), kHeadImageWidth, kHeadImageWidth);
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[userModel.icon isKindOfClass:[NSNull class]]?@"":userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    _headImageView.userInteractionEnabled = YES;
    [self.tableHeaderView addSubview:_headImageView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableHeaderView;
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
    
    [self downloadData];
    
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(downloadData)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableHeaderImageViewClick
{
    self.standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"请选择操作方式" otherButtonTitles:@"照相", @"相册", nil];
    [self.standardIBAS setFont:[UIFont systemFontOfSize:17.f]];
    [self.standardIBAS setButtonTextColor:[UIColor blackColor]];
    [self.standardIBAS setButtonBackgroundColor:[UIColor redColor] forButtonAtIndex:3];
    [self.standardIBAS setButtonTextColor:[UIColor lightGrayColor] forButtonAtIndex:0];
    [self.standardIBAS showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)headImageViewClick
{
    SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
    pivc.canPopViewController = YES;
    pivc.imAccount = VAL_HXACCOUNT;
    [self.navigationController pushViewController:pivc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)downloadData
{
    self.page = 1;
    NSString *url = [NSString stringWithFormat:@"%@workRecord/findPageMyWord/%zd",urlPrefix,self.page];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [HttpTool multipartPostFileDataWithPath:url params:nil dataAry:nil success:^(id JSON) {
        [weakSelf hideHud];
        [_tableView.legendHeader endRefreshing];
        [self.dataSource removeAllObjects];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            self.page = [JSON[@"page"] integerValue];
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL hasNextPage = pageCount > self.page;
            [self.tableView.footer setHidden:!hasNextPage];
            [_tableHeaderImageView sd_setImageWithURL:[NSURL URLWithString:(!JSON[@"otherData"][@"workImg"] || [JSON[@"otherData"][@"workImg"] isKindOfClass:[NSNull class]])?@"":JSON[@"otherData"][@"workImg"]] placeholderImage:[UIImage imageNamed:@"workCircleTopBackImage"] options:EMSDWebImageRetryFailed];
            self.dataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXAllPeoplleWorkCircleModel.class json:JSON[@"data"]]];
            if ([self.dataSource count] <= 0) {
                [self.view makeToast:@"暂无数据" duration:1 position:@"center"];
            }
            [self.tableView reloadData];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        [_tableView.legendHeader endRefreshing];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)loadMoreData
{
    NSString *url = [NSString stringWithFormat:@"%@workRecord/findPageMyWord/%zd",urlPrefix,self.page + 1];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [HttpTool multipartPostFileDataWithPath:url params:nil dataAry:nil success:^(id JSON) {
        [weakSelf hideHud];
        [_tableView.legendFooter endRefreshing];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            self.page = [JSON[@"page"] integerValue];
            [_tableHeaderImageView sd_setImageWithURL:[NSURL URLWithString:(!JSON[@"otherData"][@"workImg"] || [JSON[@"otherData"][@"workImg"] isKindOfClass:[NSNull class]])?@"":JSON[@"otherData"][@"workImg"]] placeholderImage:[UIImage imageNamed:@"workCircleTopBackImage"] options:EMSDWebImageRetryFailed];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick)];
            _headImageView.userInteractionEnabled = YES;
            [_headImageView addGestureRecognizer:tap];
            
            NSMutableArray * moreData = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXAllPeoplleWorkCircleModel.class json:JSON[@"data"]]];
            [self.dataSource addObjectsFromArray:moreData];
            if ([moreData count] <= 0) {
                [self.view makeToast:@"没有更多了" duration:1 position:@"center"];
                self.page--;
            }
            [self.tableView reloadData];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        [_tableView.legendFooter endRefreshing];
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"CXMyselfWorkTableViewCell";
    CXMyselfWorkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[CXMyselfWorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    [cell setCXAllPeoplleWorkCircleModel:self.dataSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kMyselfWorkCellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXWorkCircleDetailViewController * workCircleDetailViewController = [[CXWorkCircleDetailViewController alloc] init];
    workCircleDetailViewController.model = (CXAllPeoplleWorkCircleModel *)self.dataSource[indexPath.row];
    workCircleDetailViewController.model.userId = VAL_USERID;
    [self.navigationController pushViewController:workCircleDetailViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(IBActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self takePhoto];
            }
            else {
                
                [self.view makeToast:@"模拟其中无法打开照相机,请在真机中使用" duration:2 position:@"center"];
            }
            
        } break;
        case 2: {
            //相册选取
            [self chooseImageFromLibary];
        } break;
        default:
            break;
    }
}

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)chooseImageFromLibary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ALiImageReshapeDelegate

- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
    [self requestWithHeadImage:image];
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
    vc.sourceImage = image;
    vc.reshapeScale = 1242./384.;
    vc.delegate = self;
    [picker pushViewController:vc animated:YES];
}

#pragma mark 压缩图片
- (UIImage*)compressImage:(UIImage*)compressImage
{
    const CGFloat compressRate = 1.0;
    CGFloat width = compressImage.size.width * compressRate;
    CGFloat height = compressImage.size.height * compressRate;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [compressImage drawInRect:CGRectMake(0, 0, width, height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)requestWithHeadImage:(UIImage *)headImage
{
    headImage = [self compressImage:headImage];
    NSData* imageData = UIImageJPEGRepresentation(headImage, 0.5);
    NSString* url = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", url, kImageIconPath];
    //获取整个程序所在目录
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString* imagePath = [NSString stringWithFormat:@"%@/myicon.jpg", filePath];
    
    if ([imageData writeToFile:imagePath atomically:YES])
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        long fileNameNumber = [str longLongValue];
        NSString* fileName = [NSString stringWithFormat:@"%ld.jpg", fileNameNumber];
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        SDUploadFileModel *uploadFileModel = [[SDUploadFileModel alloc] init];
        uploadFileModel.fileData = data;
        uploadFileModel.fileName = fileName;
        uploadFileModel.mimeType = @"image/jpg";
        [self showHudInView:self.view hint:@"更改中..."];
        
        [HttpTool multipartPostWithPath:[NSString stringWithFormat:@"%@workRecord/file", urlPrefix] params:nil files:@{@"img":@[uploadFileModel]} success:^(id JSON) {
            [self hideHud];
            if ([JSON[@"status"] intValue] == 200)
            {
                [self.view makeToast:@"修改成功" duration:2 position:@"center"];
                [_tableHeaderImageView sd_setImageWithURL:[NSURL URLWithString:JSON[@"data"]] placeholderImage:[UIImage imageNamed:@"workCircleTopBackImage"] options:EMSDWebImageRetryFailed];
            }
            
        } failure:^(NSError *error) {
            [self hideHud];
            
            [self.view makeToast:[error localizedFailureReason] duration:2 position:@"center"];
        }];
    }
}

@end
