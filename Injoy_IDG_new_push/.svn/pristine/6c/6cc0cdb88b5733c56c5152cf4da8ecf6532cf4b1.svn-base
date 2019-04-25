//
//  CXMailDetailController.m
//  InjoyYJ1
//
//  Created by admin on 17/8/15.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMailDetailController.h"

#import <QuickLook/QuickLook.h>
#import "STMCOPOPSession.h"
#import "STMCOIMAPSession.h"
#import "MailParse.h"
#import "MCOMessageParser.h"
#import "MCOCIDURLProtocol.h"
#import "CXNewsCommonCell.h"

@interface CXMailDetailController ()
<UITableViewDataSource,
UITableViewDelegate,
UIWebViewDelegate,
QLPreviewControllerDataSource,
QLPreviewControllerDelegate>
{
    NSIndexPath *currentIndex;
}

// 导航条
@property (nonatomic, strong) SDRootTopView *rootTopView;

// 计算cell高度Label
@property (nonatomic, strong) UILabel *calulationLabel;

// 表格
@property (nonatomic, strong) UITableView *tableView;
// 表格数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataTitleArray;

/// 邮箱
@property (strong, nonatomic) UIWebView *mainWebView;
@property (nonatomic, strong) NSString *emailAccount;
@property (nonatomic, strong) NSString *emailPassword;
@property (nonatomic, strong) NSString *emailReceiveProtocol;
@property (nonatomic, strong) NSString *emailProtocolType;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) MCOMessageParser *msgPaser;
// 发件人邮箱
@property (nonatomic, strong) NSString *senderEmailAddress;
// 邮件内容
@property (nonatomic, strong) NSData *messageData;

@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *fileNameArray;
@property (nonatomic, strong) NSString *clickAttchmentName;

@end

@implementation CXMailDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置头部导航栏
    [self setUpTopView];
    // 创建公共界面视图
    [self setupContent];
    [self setupInterfaceView];
    [self requestDetailDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"邮件管理"];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(leftBtnClick)];
    //[self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"chat_logo"] addTarget:AppDelegate.class action:@selector(jumpToIMModule)];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)setupContent
{
    if (self.dataTitleArray == nil) {
        self.dataTitleArray = [NSMutableArray arrayWithObjects:
                               [NSMutableArray arrayWithObjects:@"收件人：",@"抄送人：",nil],
                               [NSMutableArray arrayWithObjects:@"邮件标题：",nil],
                               nil];
    }
    if (self.dataArray == nil){
        self.dataArray = [NSMutableArray arrayWithObjects:
                          [NSMutableArray arrayWithObjects:@"",@"",nil],
                          [NSMutableArray arrayWithObjects:@"",nil],
                          nil];
    }
}
-(void)setupInterfaceView
{
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh)];
        //_mainView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_mainView];
    }
    
    // 表格
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-navHigh) style:UITableViewStylePlain];
        _tableView.rowHeight = kCellHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //_tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_mainView addSubview:self.tableView];
    }
}

- (void)leftBtnClick
{
    __weak typeof(self) weakSelf = self;
    if (weakSelf.operateSuccessReturnBlock) {
        weakSelf.operateSuccessReturnBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UILabel *)calulationLabel
{
    if (!_calulationLabel) {
        _calulationLabel = [[UILabel alloc]  init];
        _calulationLabel.numberOfLines = 0;
        _calulationLabel.font = kFontSizeForForm;
    }
    return _calulationLabel;
}

- (void)requestDetailDataFromServer
{
    [self showHudInView:_mainView hint:@"正在加载"];
    if ([_messageProtocolType isEqualToString:@"pop"])
    {
        [[STMCOPOPSession getSessionInstanct] loadMailDetailWithIndex:[_messageInfoIndex intValue] andEmailDataBlock:^(NSData *messageData)
         {
             [self getEmailDetail:messageData];
             [self hideHudWithView:_mainView];
         }];
    }
    else
    {
        [[STMCOIMAPSession getSessionInstanct] loadMailDetailWithIndex:[_messageInfoIndex intValue] andEmailDataBlock:^(NSData *messageData)
         {
             [self getEmailDetail:messageData];
             [self hideHudWithView:_mainView];
         }];
    }
}

- (void)getEmailDetail:(NSData *)messageData
{
    _messageData = messageData;
    _msgPaser =[MCOMessageParser messageParserWithData:messageData];
    _senderEmailAddress = _msgPaser.header.from.mailbox;
    NSArray *toArray = _msgPaser.header.to;
    NSString *toAddress = @"";
    for (MCOAddress *address in toArray) {
        if ([toAddress isEqualToString:@""]) {
            toAddress = [NSString stringWithFormat:@"%@",address.mailbox?:@""];
        } else {
            NSString *add = [NSString stringWithFormat:@"%@",address.mailbox?:@""];
            toAddress = [NSString stringWithFormat:@"%@ %@",toAddress,add];
        }
    }
    [[_dataArray objectAtIndex:0] replaceObjectAtIndex:0 withObject:toAddress];
    NSArray *ccArray = _msgPaser.header.cc;
    NSString *ccAddress;
    for (MCOAddress *address in ccArray) {
        if (ccAddress == nil) {
            ccAddress = [NSString stringWithFormat:@"%@",address.mailbox?:@""];
        } else {
            NSString *add = [NSString stringWithFormat:@"%@",address.mailbox?:@""];
            ccAddress = [NSString stringWithFormat:@"%@ %@",ccAddress,add];
        }
    }
    [[_dataArray objectAtIndex:0] replaceObjectAtIndex:1 withObject:ccAddress == nil?@"无":ccAddress];
    _mailSubject = _msgPaser.header.subject;
    [[_dataArray objectAtIndex:1] replaceObjectAtIndex:0 withObject:_msgPaser.header.subject];
    _fileNameArray = [NSMutableArray array];
    _attachments =[[NSMutableArray alloc] initWithArray:_msgPaser.attachments];
    if (_attachments.count > 0)
    {
        for (MCOAttachment *attachment in _attachments)
        {
            [_fileNameArray addObject:attachment.filename];
            NSString *filePath=[kMailFilePath stringByAppendingPathComponent:attachment.filename];
            NSFileManager *fileManger =[NSFileManager defaultManager];
            if (![fileManger fileExistsAtPath:filePath]) {
                NSData *attachmentData=[attachment data];
                [attachmentData writeToFile:filePath atomically:YES];
                //NSLog(@"资源：%@已经下载至%@", attachment.filename,filePath);
            }
        }
    }

    NSString *htmlString =[_msgPaser htmlBodyRendering];
    if([htmlString rangeOfString:@"<hr/>"].location !=NSNotFound)
    {
        htmlString =[htmlString componentsSeparatedByString:@"<hr/>"][0];
    }
    _mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, _mainView.frame.size.height/2+50)];
    [_mainWebView setDelegate:self];
    _mainWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (htmlString == nil) {
        [_mainWebView loadHTMLString:@"" baseURL:nil];
        return;
    }
    
    NSMutableString * html = [NSMutableString string];
    [html appendFormat:@"<html><head><script>%@</script><style>%@</style></head>"
     @"<body>%@</body><iframe src='x-mailcore-msgviewloaded:' style='width: 0px; height: 0px; border: none;'>"
     @"</iframe></html>", mainJavascript, mainStyle, htmlString];
    [_mainWebView loadHTMLString:html baseURL:nil];
    _tableView.tableFooterView = _mainWebView;
    [self hideHudWithView:_mainView];
    [self.tableView reloadData];
}

- (void)handleClick:(UIButton *)sender
{
    _clickAttchmentName = sender.titleLabel.text;
    
    QLPreviewController* previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    [self presentViewController:previewController animated:YES completion:nil];
}
- (void) _loadImages
{
    NSString * result = [_mainWebView stringByEvaluatingJavaScriptFromString:@"findCIDImageURL()"];
    if (result==nil || [result isEqualToString:@""]) {
        return;
    }
    
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray * imagesURLStrings = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    for(NSString * urlString in imagesURLStrings)
    {
        MCOAbstractPart * part =nil;
        NSURL * url;
        url = [NSURL URLWithString:urlString];
        if ([MCOCIDURLProtocol isCID:url]) {
            part = [self _partForCIDURL:url];
        }
        else if ([MCOCIDURLProtocol isXMailcoreImage:url])
        {
            NSString * specifier = [url resourceSpecifier];
            NSString * partUniqueID = specifier;
            part = [self _partForUniqueID:partUniqueID];
            
        }
        if (part == nil)
            continue;
        NSString * partUniqueID = [part uniqueID];
        MCOAttachment * attachment = (MCOAttachment *)[_msgPaser partForUniqueID:partUniqueID];
        NSData * data =[attachment data];
        if (data!=nil) {

            NSString *filePath=[kMailFilePath stringByAppendingPathComponent:attachment.filename];
            NSFileManager *fileManger =[NSFileManager defaultManager];
            
            if (![fileManger fileExistsAtPath:filePath]) {
                NSData *attachmentData=[attachment data];
                [attachmentData writeToFile:filePath atomically:YES];
                NSLog(@"资源：%@已经下载至%@", attachment.filename,filePath);
            }
            
            NSURL * cacheURL = [NSURL fileURLWithPath:filePath];
            NSDictionary * args =@{@"URLKey": urlString,@"LocalPathKey": cacheURL.absoluteString};
            NSString * jsonString = [self _jsonEscapedStringFromDictionary:args];
            NSString * replaceScript = [NSString stringWithFormat:@"replaceImageSrc(%@)", jsonString];
            [_mainWebView stringByEvaluatingJavaScriptFromString:replaceScript];
        }
    }
}
- (MCOAbstractPart *) _partForCIDURL:(NSURL *)url
{
    return [_msgPaser partForContentID:[url resourceSpecifier]];
}
- (MCOAbstractPart *) _partForUniqueID:(NSString *)partUniqueID
{
    return [_msgPaser partForUniqueID:partUniqueID];
}
- (NSString *)_jsonEscapedStringFromDictionary:(NSDictionary *)dictionary
{
    NSData * json = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString * jsonString = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    return jsonString;
}


/**
 *  UITableView Delegate
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else //if (section == 1)
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CXNewsCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"annAdd"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[CXNewsCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"annAdd"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.theKey.text = self.dataTitleArray[indexPath.section][indexPath.row];
    cell.theValue.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][indexPath.row]];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.theLine.hidden = YES;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndex = indexPath;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.calulationLabel.frame = CGRectMake(0, 0, Screen_Width-100, 20);
    self.calulationLabel.text = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.calulationLabel sizeToFit];
    if (self.calulationLabel.frame.size.height + 29 > kCellHeight) {
        return self.calulationLabel.frame.size.height + 29;
    }else{
        return kCellHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 2)];
        lineView.backgroundColor = kLightGrayColor;
        return lineView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    return 0;
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[request URL];
    
    NSURLRequest *responseRequest = [self webView:webView resource:nil willSendRequest:request redirectResponse:nil fromDataSource:nil];
    
    if (([[requestURL scheme] isEqualToString: @"http"] || [[requestURL scheme] isEqualToString:@"https"] || [[requestURL scheme] isEqualToString: @"mailto" ]) && (navigationType == UIWebViewNavigationTypeLinkClicked))
    {
        return ![[UIApplication sharedApplication] openURL:requestURL];
    }
    else if(responseRequest == request) {
        return YES;
    } else {
        [webView loadRequest:responseRequest];
        return NO;
    }
}

- (NSURLRequest *)webView:(UIWebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(id)dataSource
{
    if ([[[request URL] scheme] isEqualToString:@"x-mailcore-msgviewloaded"]) {
        [self _loadImages];
    }
    return request;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat hight = webView.scrollView.contentSize.height;
    CGFloat width = webView.scrollView.contentSize.width;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,20)];
    label.text = [NSString stringWithFormat:@"  共有%lu个附件",(unsigned long)_fileNameArray.count];
    label.font = [UIFont systemFontOfSize:11.0f];
    UIView *attchmentView = [[UIView alloc] initWithFrame:CGRectMake(0, hight, width,_fileNameArray.count*27 + 40)];
    attchmentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [attchmentView addSubview:label];

    for (int i = 0; i < _fileNameArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:_fileNameArray[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(2, 20 + i*27, Screen_Width-4, 25);
        [attchmentView addSubview:button];
    }
    _mainWebView.scrollView.contentSize = CGSizeMake(width, hight + attchmentView.frame.size.height);
    [_mainWebView.scrollView addSubview:attchmentView];
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController*)previewController
{
    /// 文件名数量
    return 1; //[_dataArray count];
}

- (void)previewControllerDidDismiss:(QLPreviewController*)controller {}

///// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController*)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL* fileURL = nil;
    // 文件名
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", kMailFilePath, _clickAttchmentName];
    NSLog(@"%@",filePath);
    fileURL = [NSURL fileURLWithPath:filePath];
    return fileURL;
}

























































#pragma mark - javaScript
static NSString * mainJavascript = @"\
var imageElements = function() {\
var imageNodes = document.getElementsByTagName('img');\
return [].slice.call(imageNodes);\
};\
\
var findCIDImageURL = function() {\
var images = imageElements();\
\
var imgLinks = [];\
for (var i = 0; i < images.length; i++) {\
var url = images[i].getAttribute('src');\
if (url.indexOf('cid:') == 0 || url.indexOf('x-mailcore-image:') == 0)\
imgLinks.push(url);\
}\
return JSON.stringify(imgLinks);\
};\
\
var replaceImageSrc = function(info) {\
var images = imageElements();\
\
for (var i = 0; i < images.length; i++) {\
var url = images[i].getAttribute('src');\
if (url.indexOf(info.URLKey) == 0) {\
images[i].setAttribute('src', info.LocalPathKey);\
break;\
}\
}\
};\
";
static NSString * mainStyle = @"\
body {\
font-family: Helvetica;\
font-size: 14px;\
word-wrap: break-word;\
-webkit-text-size-adjust:none;\
-webkit-nbsp-mode: space;\
}\
\
pre {\
white-space: pre-wrap;\
}\
";


@end
