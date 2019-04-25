//
//  CXAnnexViewController.m
//  SDMarketingManagement
//
//  Created by haihualai on 16/6/17.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXAnnexViewController.h"
#import <QuickLook/QuickLook.h>
#import "CXAnnexModel.h"

#define AnnexFile [NSString stringWithFormat:@"%@/Documents/annexFile",NSHomeDirectory()]
@interface CXAnnexViewController()<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate,NSURLConnectionDataDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>

//头部导航栏
@property (nonatomic, strong) SDRootTopView *rootTopView;

//表格视图
@property (nonatomic, weak) UITableView *myTableView;

@property (nonatomic, strong) NSURLConnection *connection;

//存储下载数据
@property (nonatomic, strong) NSMutableData *downloadData;

//文件地址
@property (nonatomic, strong) NSString *fileString;

//存放附件对象
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CXAnnexViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置头部导航栏
    [self setUpTopView];
    
    //创建表格视图
    [self setUpTableView];
}

#pragma mark -- 创建头部导航栏
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"附件"];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

#pragma mark -- 设置附件数据
-(void)setAnnexDataArray:(NSArray *)annexDataArray
{
    _annexDataArray = annexDataArray;
    [self.dataArray removeAllObjects];
    for (NSDictionary *dict  in annexDataArray) {
        CXAnnexModel *annexModel = [[CXAnnexModel alloc] init];
        [annexModel setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:annexModel];
    }
    
    [self.myTableView reloadData];
}

#pragma mark -- 附件对象数组
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark -- 创建表格视图
-(void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.myTableView = tableView;
}


#pragma mark -- 表格视图代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CXAnnexModel *annexModel = self.dataArray[indexPath.row];
    cell.textLabel.text = annexModel.srcName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //显示附件
    CXAnnexModel *annexModel = self.dataArray[indexPath.row];
    [self dealAnnexFileWithFileName:annexModel.name urlString:annexModel.path];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark -- 处理附件下载
-(void)dealAnnexFileWithFileName:(NSString *)fileName urlString:(NSString *)urlString
{
    self.fileString = [NSString stringWithFormat:@"%@/%@",AnnexFile,fileName];
    
    //创建文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:AnnexFile]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:AnnexFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:self.fileString]) {
    
        self.downloadData = [NSMutableData data];
        
        //根据url 网址下载数据
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }else{
        //显示下载的文件
        [self showAnnexFile];
    }
    
}

#pragma mark -- 显示下载文件
-(void)showAnnexFile
{
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    [self presentViewController:previewController animated:YES completion:nil];
}

#pragma mark -- 网络下载的代理方法
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //完成下载，写入文件中
    [self.downloadData writeToFile:self.fileString atomically:NO];
    //文件预览器，显示下载文件
    [self showAnnexFile];
}

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

-(void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    
    return [NSURL fileURLWithPath:self.fileString];
}

@end
