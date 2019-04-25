//
//  CXMailEditController.m
//  InjoyYJ1
//
//  Created by admin on 17/7/31.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMailEditController.h"
#import "CXAnnexCell.h"
#import "CXNewsCommonCell.h"
#import "CXFormHeaderView.h"
#import "CXTextView.h"
#import "CXERPAnnexView.h"

#import "MailCore/MailCore.h"
#import "SDDockImageModel.h"

#import "CXMailAnnexView.h"
#import "CXEditLabel.h"

#import "SDDetailInfoViewController.h"
#import "SDUploadFileModel.h"

@interface CXMailEditController ()
<UITableViewDataSource,
UITableViewDelegate,
CXTextViewDelegate,
ZYQAssetPickerControllerDelegate,
UINavigationControllerDelegate,
UIAlertViewDelegate>
{
    int currentPageNumber;              // 当前页码
    CGFloat submitViewHeight;           // 提交按钮视图的高
    NSIndexPath *currentIndex;
    float selectViewHeight;
    UIButton *imageBtn;
}

// 导航条
@property (nonatomic, strong) SDRootTopView *rootTopView;
/** 头部 */
@property (nonatomic, strong) CXFormHeaderView *headerView;
/** 附件栏 */
//@property (nonatomic, strong) CXERPAnnexView *annexView;
@property (nonatomic, strong) CXMailAnnexView *mailAnnexView;
// 提交按钮
@property (nonatomic, strong) NSMutableArray* submitNameArray;
// 表格
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataTitleArray;
// 表格数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

// 计算cell高度Label
@property (nonatomic, strong) UILabel *calulationLabel;

// 收件人数组
@property (nonatomic, strong) NSMutableArray* receiverArray;
// 抄送人数组
@property (nonatomic, strong) NSMutableArray* ccArray;

@property (nonatomic, strong) NSString *emailAccount;
@property (nonatomic, strong) NSString *emailPassword;
@property (nonatomic, strong) NSString *emailSendProtocol;

@property (copy , nonatomic) NSMutableArray *mutableListTo;
@property (copy , nonatomic) NSMutableArray *mutableListCc;
@property (copy , nonatomic) NSMutableArray *mutableListBcc;

/// 已选图片数组
@property (nonatomic, strong) NSMutableArray* selectImageArr;
@property (nonatomic, strong) NSMutableArray* selectImageModelArr;
/// 已选中的照片对象
@property (nonatomic, copy) NSMutableArray *selectedAssetArray;
/// 拍照时的照片对象
@property (nonatomic, strong) ALAssetsLibrary* assetsLibrary;

@property (nonatomic, strong) NSMutableArray* assets;
@property (nonatomic, strong) NSMutableArray* groups;

/**
 *  图片、声音、文件等 (详情时必须传进来)
 */
@property(nonatomic, strong) NSMutableArray *detailAnnexDataArray;
/**
 *  图片、声音、文件等 (创建时获取)
 */
@property(nonatomic, strong) NSMutableArray *addAnnexDataArray;

/// 相册图片数组
@property(nonatomic, strong) NSMutableArray *albumImageArray;

@end

@implementation CXMailEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // 设置头部导航栏
    [self setUpTopView];
    [self setupContent];
    [self setupInterfaceView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"邮件管理"];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self.rootTopView setUpRightBarItemTitle:@"发送" addTarget:self action:@selector(sendEmail)];
}
- (void)setupContent
{
    if (self.submitNameArray == nil) {
        self.submitNameArray = [NSMutableArray  arrayWithObjects:@"发  送",@"设  置",nil];
    }
    if (self.dataTitleArray == nil) {
        self.dataTitleArray = [NSMutableArray arrayWithObjects:@"收件人：",@"抄送人：",@"邮件标题：",@"邮件内容：",nil];
    }
    // 0、收件人、抄送人、时间、
    // 1、邮件标题、图片、邮件内容
    if (self.dataArray == nil)
    {
        self.dataArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",nil];
    }
    
    self.headerView = ({
        CXFormHeaderView *headerView = [[CXFormHeaderView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, CXFormHeaderViewHeight)];
        if (self.formType == CXFormTypeCreate) {
            headerView.avatar = VAL_Icon;
            headerView.name = VAL_USERNAME;
            headerView.dept = VAL_DpName;
            headerView.displayNumber = NO;
        }
        headerView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:headerView];
        headerView;
    });
    
    //self.annexView = ({
    //    CGFloat y = Screen_Height - kApprovalViewHeight;
    //    CXERPAnnexView *view = [[CXERPAnnexView alloc] initWithFrame:CGRectMake(0, y, Screen_Width, 45)];
    //    [self.view addSubview:view];
    //    view;
    //});
    
    self.mailAnnexView = ({
        CGFloat y = Screen_Height - kApprovalViewHeight;
        CXMailAnnexView *view = [[CXMailAnnexView alloc] initWithFrame:CGRectMake(0, y, Screen_Width, 45)];
        [self.view addSubview:view];
        view;
    });
    
    //CXApprovalView *approvalView = [CXApprovalView view];
    //// 初始高亮的索引
    //approvalView.index = 2;
    //[approvalView setFrame:CGRectMake(0, Screen_Height-kApprovalViewHeight, Screen_Width, kApprovalViewHeight)];
    //[self.view addSubview:approvalView];
    
    _mutableListTo = [[NSMutableArray alloc]init];
    _mutableListCc = [[NSMutableArray alloc]init];
    _mutableListBcc = [[NSMutableArray alloc]init];
}
- (void)setupInterfaceView
{
    // 表格
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh-kApprovalViewHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    
    [self creatViews];
}

- (UILabel *)calulationLabel
{

    if (!_calulationLabel) {
        _calulationLabel = [[UILabel alloc]  init];
        _calulationLabel.numberOfLines = 0;
        _calulationLabel.font = kFontSizeForForm;
    }
    return _calulationLabel;
}
- (NSMutableArray*)selectImageArr
{
    if (nil == _selectImageArr) {
        _selectImageArr = [[NSMutableArray alloc] init];
    }
    return _selectImageArr;
}
- (NSMutableArray*)selectImageModelArr
{
    if (nil == _selectImageModelArr) {
        _selectImageModelArr = [[NSMutableArray alloc] init];
    }
    return _selectImageModelArr;
}
- (NSMutableArray*)selectedAssetArray
{
    if (nil == _selectedAssetArray) {
        _selectedAssetArray = [[NSMutableArray alloc] init];
    }
    return _selectedAssetArray;
}

- (void)sendEmail {
    /// 反归档获取发件人账号密码
    NSString *userID = [AppDelegate getUserID];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@emailArchiver.data",kMailFilePath,userID];
    NSData *unarchiverData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:unarchiverData];
    _emailAccount = [unarchiver decodeObjectForKey:KMailAccount];
    _emailPassword = [unarchiver decodeObjectForKey:KMailPassword];
    _emailSendProtocol = [unarchiver decodeObjectForKey:kMailSendProtocol];
    [unarchiver finishDecoding];
    
    if (_emailAccount.length == 0) {
        //TTAlert(@"请先设置您的邮箱账号");
        [self.view makeToast:@"请先设置您的邮箱账号" duration:2 position:@"center"];
        return;
    }
    
    // 0、收件人、抄送人、时间、
    // 1、邮件标题、图片、邮件内容
    
    if (_receiverArray.count) {
        for (NSString *isAccount in _receiverArray) {
            if (![NSString isEmail:isAccount]) {
                //TTAlert(@"收件人邮箱账号格式不正确，请重新输入");
                [self.view makeToast:@"收件人邮箱账号格式不正确，请重新输入" duration:1 position:@"center"];
                return;
            }
        }
    }
    else {
        MAKE_TOAST(@"请输入收件人帐号");
        return;
    }
    if (_ccArray.count) {
        for (NSString *isAccount in _ccArray) {
            if (![NSString isEmail:isAccount]) {
                //TTAlert(@"抄送人邮箱账号格式不正确，请重新输入");
                [self.view makeToast:@"抄送人邮箱账号格式不正确，请重新输入" duration:1 position:@"center"];
                return;
            }
        }
    }
    if ([self.dataArray[2] length] == 0) {
        //TTAlertNoTitle(@"邮件标题不能为空!");
        [self.view makeToast:@"邮件标题不能为空" duration:1 position:@"center"];
        return;
    }
    if ([self.dataArray[3] length] == 0) {
        //TTAlertNoTitle(@"邮件内容不能为空!");
        [self.view makeToast:@"邮件内容不能为空" duration:1 position:@"center"];
        return;
    }
    
    //----－－－－
    MCOSMTPSession* smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.username = _emailAccount;                   // 邮箱账号
    smtpSession.password = _emailPassword;                  // 邮箱密码
    smtpSession.hostname = _emailSendProtocol;              // 发件服务器
    smtpSession.port = 587;//465;                                 // 端口
    smtpSession.connectionType = MCOConnectionTypeStartTLS;
    
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    // 发件人地址
    MCOAddress *fromAdd = [MCOAddress addressWithDisplayName:nil mailbox:_emailAccount];
    
    // 注意这里区分回复和转发
    // 收件人
    for (int to = 0 ; to < _receiverArray.count ; to++) {
        NSString *toSender = [_receiverArray objectAtIndex:to];
        MCOAddress *toAdd = [MCOAddress addressWithDisplayName:nil mailbox:toSender];
        [_mutableListTo addObject:toAdd];
    }
    // 抄送人
    for (int cc = 0 ; cc < _ccArray.count ; cc ++) {
        NSString *ccSender = [_ccArray objectAtIndex:cc];
        MCOAddress *ccAdd = [MCOAddress addressWithDisplayName:nil mailbox:ccSender];
        [_mutableListCc addObject:ccAdd];
    }
    
    [[builder header] setFrom:fromAdd];
    [[builder header] setTo:_mutableListTo];
    [[builder header] setCc:_mutableListCc];
    [[builder header] setBcc:_mutableListBcc];
    [[builder header] setSubject:_dataArray[2]];
    
    if ([_sendtype isEqualToString:@"reply"] || [_sendtype isEqualToString:@"reward"]) {
        /// 回复邮件 或 转发邮件
        // 我回复邮件的内容
        NSString *body = _dataArray[3];
        
        // 原邮件内容
        MCOMessageParser *msgPaser =[MCOMessageParser messageParserWithData:_messageData];
        NSString *bodyHtml =[msgPaser htmlBodyRendering];//获取邮件html正文
        // 判断是否有<hr/>, 删除html中的附件
        if([bodyHtml rangeOfString:@"<hr/>"].location !=NSNotFound)
        {
            bodyHtml =[bodyHtml componentsSeparatedByString:@"<hr/>"][0];
        }
        // 合并后的邮件正文
        NSMutableString *fullBodyHtml = [NSMutableString stringWithFormat:@"%@<br/><br/>-------------下文是原始邮件-------------<br/>%@",[body stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"],bodyHtml];
        
        [builder setHTMLBody:fullBodyHtml];
    }
    else {
        /// 新建邮件
        // 我邮件的内容
        NSString *body = _dataArray[3];
        [builder setHTMLBody:body];
    }
    
    //添加邮件附件
    NSMutableArray *mocattachmentList = [[NSMutableArray alloc]initWithCapacity:_selectImageModelArr.count];
    if (_selectImageModelArr.count > 0) {
        for (SDDockImageModel* imageModel in _selectImageModelArr)
        {
            NSString *fileName = imageModel.imageName;
            NSData* fileData = nil;
            if ([imageModel.imageName rangeOfString:@"jpg" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                fileData = UIImageJPEGRepresentation(imageModel.selectImage, 0.5f);
            }
            else {
                fileData = UIImagePNGRepresentation(imageModel.selectImage);
            }
            MCOAttachment *mocattachment = [MCOAttachment attachmentWithData:fileData filename:fileName];
            [mocattachmentList addObject:mocattachment];
        }
    }
    builder.attachments = mocattachmentList;
    
    NSData * rfc822Data =[builder data];
    MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:rfc822Data];
    [self showHudInView:self.view hint:@"正在发送"];
    [sendOperation start:^(NSError *error) {
        if(error) {
            [self hideHud];
            TTAlertNoTitle(@"邮件发送失败");
            return;
        } else {
            [self hideHud];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}
- (void)setupEmailData
{
    // 0、收件人、抄送人、时间、
    // 1、邮件标题、图片、邮件内容
    if ([_sendtype isEqualToString:@"reply"])
    {
        /// 回复
        // 收件人
        [self.dataArray replaceObjectAtIndex:0 withObject:_mailAddress];
        [_receiverArray addObject:_mailAddress];
        // 邮件主题
        [self.dataArray replaceObjectAtIndex:2 withObject:_mailSubject];
    }
    else
    {
        /// 转发
        // 邮件主题
        [[self.dataArray objectAtIndex:1] replaceObjectAtIndex:0 withObject:_mailSubject];
    }
}

/**
 *  UITableView Delegate
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataTitleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0、发件人、收件人、抄送人、时间、
    // 1、邮件标题、图片、邮件内容
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CXNewsCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"annAdd"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[CXNewsCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"annAdd"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.theKey.text = self.dataTitleArray[indexPath.row];
        
        if (![self.dataArray[indexPath.row] isEqualToString:@""])
        {
            cell.theValue.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
        } else {
            cell.theValue.attributedText = [self getTitleAttributedStringByTitle:@"如需添加多个账号请用分号“ ; “间隔" length:19];
        }
        
    }
    else
    {
        cell.theKey.text = self.dataTitleArray[indexPath.row];
        cell.theValue.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    }
    
    if (indexPath.row == 3) {
        cell.theLine.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndex = indexPath;

    CXTextView *keyboard = [[CXTextView alloc] initWithKeyboardType:UIKeyboardTypeDefault];
    keyboard.textString = self.dataArray[indexPath.row];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        keyboard.maxLengthOfString = 100;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        keyboard.maxLengthOfString = 1000;
    }
    
    keyboard.delegate = self;
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:keyboard];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.calulationLabel.frame = CGRectMake(0, 0, Screen_Width-100, 20);
    self.calulationLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    [self.calulationLabel sizeToFit];
    if (self.calulationLabel.frame.size.height + 29 > kCellHeight) {
        return self.calulationLabel.frame.size.height + 29;
    }else{
        return kCellHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 5)];
    label.backgroundColor = [UIColor lightGrayColor];
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

/**
 *  富文本
 */
- (NSAttributedString*)getTitleAttributedStringByTitle:(NSString*)cellTitle length:(int)length
{
    NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc] initWithString:cellTitle];
    [attributeStr setAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor],
                                   NSFontAttributeName : [UIFont fontWithName:@"Arial" size:10.f] }
                          range:NSMakeRange(cellTitle.length - length, length)];
    return attributeStr;
}

/**
 *  CXTextViewDelegate 键盘输入
 */
-(void)textView:(CXTextView *)textView textWhenTextViewFinishEdit:(NSString *)text
{
    if (currentIndex.row == 0) {
        _receiverArray = (NSMutableArray *)[text componentsSeparatedByString:@";"];
        NSLog(@"收件人:%@",_receiverArray);
        for (NSString *isAccount in _receiverArray) {
            if (![NSString isEmail:isAccount]) {
                //TTAlert(@"收件人邮箱账号格式不正确，请重新输入");
                [self.view makeToast:@"收件人邮箱账号格式不正确，请重新输入" duration:1 position:@"center"];
            }
        }
    } else if (currentIndex.row == 1) {
        _ccArray = (NSMutableArray *)[text componentsSeparatedByString:@";"];
        NSLog(@"抄送人:%@",_ccArray);
        for (NSString *isAccount in _ccArray) {
            if (![NSString isEmail:isAccount]) {
                //TTAlert(@"抄送人邮箱账号格式不正确，请重新输入");
                [self.view makeToast:@"抄送人邮箱账号格式不正确，请重新输入" duration:1 position:@"center"];
            }
        }
    }
    
    [self.dataArray replaceObjectAtIndex:currentIndex.row withObject:text];
    NSLog(@"%@",self.dataArray);
    
    [self.tableView reloadData];
}

- (void)creatViews {
    UIView *annexView = [[UIView alloc] initWithFrame:CGRectMake(0,Screen_Height-kApprovalViewHeight,Screen_Width,kLineHeight)];
    annexView.backgroundColor =  kColorWithRGB(240, 240, 240);;
    [self.view addSubview:annexView];
    
    //按钮
    //NSArray *imageNameArr = @[ @"annex_image.png", @"annex_voice.png", @"annex_file.png",@"annex_cost_n.png"];
    CXEditLabel *title = [[CXEditLabel alloc] initWithFrame:CGRectMake(kFormViewMargin,
                                                                       0,
                                                                       Screen_Width / 3.0,
                                                                       kLineHeight)];
    title.title = @"附　件：";
    [annexView addSubview:title];
    

    imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setFrame:CGRectMake(Screen_Width / 3.0 , (kLineHeight - 30) / 2.0, 30, 30)];
    [imageBtn setImage:Image(@"annex_image") forState:UIControlStateNormal];
    [imageBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    [imageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [annexView addSubview:imageBtn];
//
//    //加上下的分割线
//    UIView *lineView1 = [[UIView alloc] init];
//    lineView1.frame = CGRectMake(0, 0, Screen_Width, kFormLineViewHeight);
//    lineView1.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineView1];
//    
//    UIView *lineView2 = [[UIView alloc] init];
//    lineView2.frame = CGRectMake(0, kLineHeight - kFormViewDividingLine, Screen_Width, kFormViewDividingLine);
//    lineView2.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineView2];
}

- (void)btnClick:(UIButton *)btn {
    if (_detailAnnexDataArray.count && self.albumImageArray.count) {
        // 详情
        SDDetailInfoViewController *detailVC = [[SDDetailInfoViewController alloc] init];
        detailVC.annexArray = self.albumImageArray;
        detailVC.index = 0;
        [self presentViewController:detailVC animated:YES completion:nil];
    } else if (!_detailAnnexDataArray.count) {
        [self LocalPhoto];
    }
}

//打开本地相册
- (void)LocalPhoto {
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset *) evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *) evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - 本地相册选择 ZYQAssetPickerController Delegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (NSInteger i = self.addAnnexDataArray.count - 1; i >= 0; i--) {
        SDUploadFileModel *model = self.addAnnexDataArray[i];
        if ([model.mimeType isEqualToString:@"image/jpg"]) {
            [self.addAnnexDataArray removeObjectAtIndex:i];
        }
    }
    // 获取照片、照片实体、照片对象
    NSMutableArray *imageModelAry = [[NSMutableArray alloc] init];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (int i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imageArray addObject:tempImg];
        
        SDDockImageModel *imageModel = [[SDDockImageModel alloc] init];
        imageModel.imageName = asset.defaultRepresentation.filename;
        imageModel.selectImage = tempImg;
        [imageModelAry addObject:imageModel];
    }
    // 保存相册选中图片图片
    [self.albumImageArray removeAllObjects];
    self.albumImageArray = imageArray;
    //NSLog(@"已选相片数：%lu",(unsigned long)[self.albumImageArray count]);
    
    // 保存相片对象
    [self.selectedAssetArray removeAllObjects];
    [self.selectedAssetArray addObjectsFromArray:assets];
    
    if (self.albumImageArray.count) {
        [imageBtn setImage:[UIImage imageNamed:@"annex_image_y"] forState:UIControlStateNormal];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        long fileNameNumber = [str longLongValue];
        
        for (int i = 0; i < _albumImageArray.count; i++) {
            SDDockImageModel *model = [[SDDockImageModel alloc] init];
            UIImage *compressedImage = [self compressedImage:_albumImageArray[i]];
            //NSData *data = UIImageJPEGRepresentation(compressedImage, kImageCompressRate);
            model.selectImage = compressedImage;
            fileNameNumber += i;
            NSString *fileName = [NSString stringWithFormat:@"%ld.jpg", fileNameNumber];
            model.imageName = fileName;
            //model.mimeType = @"image/jpg";
            [self.selectImageModelArr addObject:model];
        }
    }
    //    [self.annexDataDict setValue:_selectedAssetArray forKey:@"ImageAsset"];
}
#pragma  mark -- 本地相册选择 picker的代理方法 已选的图片

- (NSMutableArray *)assetPickerControllerWithSelectedAssetArray {
    //NSLog(@"相册对象：%@",self.selectedAssetArray);
    //NSLog(@"相册对象数：%lu",(unsigned long)[self.selectedAssetArray count]);
    return self.selectedAssetArray;
}
/**
 *  处理图片的压缩问题
 */
- (UIImage *)compressedImage:(UIImage *)image {
    const CGFloat scaleSize = kImageCompressRate;
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"发送成功"]) {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

@end
