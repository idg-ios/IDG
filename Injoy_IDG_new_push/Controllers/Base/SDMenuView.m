//
//  SDMenuView.m
//  SDMarketingManagement
//
//  Created by admin on 15/12/17.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDMenuView.h"
#import "NSString+TextHelper.h"

#import "SDDataBaseHelper.h"
#import "SDIMChatViewController.h"
#import "SDIMKefuListViewController.h"

#define kCellH 42//cell的高度
#define topjuli 5//上端留出的间隙

@interface SDMenuView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation SDMenuView

- (void)setFrame:(CGRect)frame
{
    //    CGRect fra = CGRectMake(Screen_Width * 40/100, navHigh-5, Screen_Width * 60/100, _dataArray.count * kCellH + topjuli * 2);
    CGRect fra = CGRectMake(Screen_Width - topjuli *2 - 150, navHigh, 150, _dataArray.count * kCellH + topjuli * 2);
    //CGRect fra = CGRectMake(Screen_Width/2, navHigh-5, Screen_Width/2, _dataArray.count * kCellH + topjuli * 2);
    [super setFrame:fra];
}

#pragma mark - 初始化
- (instancetype)initWithDataArray:(NSArray*)dataArray andImageNameArray:(NSArray*)imageArray
{
    self = [super init];
    
    _dataArray = [self dealWithMenuTitleArray:dataArray];
    _imageArray = imageArray;
    //    self.frame = CGRectMake(Screen_Width * 40/100, navHigh, Screen_Width * 60/100, _dataArray.count * kCellH + topjuli * 2);
    self.frame = CGRectMake(Screen_Width - topjuli *2 - 150, navHigh, 125, _dataArray.count * kCellH + topjuli * 2);
    
    if (self) {
        //        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(topjuli, topjuli + 10, self.frame.size.width-topjuli*2, self.frame.size.height-topjuli*2) style:UITableViewStylePlain];
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, topjuli * 2, 150, self.frame.size.height-topjuli*2) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.backgroundColor = [UIColor blackColor];
        _tableview.rowHeight = kCellH;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.scrollEnabled = NO;
        _tableview.layer.cornerRadius = 5;
        _tableview.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableview];
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context,120,5);//设置起点
    CGContextAddLineToPoint(context,115,10);
    CGContextAddLineToPoint(context,125,10);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [self.tableview.backgroundColor setFill]; //设置填充色
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
}

#pragma mark -- 处理传进来的标题数据源
-(NSArray *)dealWithMenuTitleArray:(NSArray *)titleDataArray
{
    NSMutableArray * mutableArray = [NSMutableArray arrayWithArray:titleDataArray];
    NSInteger index = 0;
    
    for (NSMutableString *menuTitle in titleDataArray) {
        
        if ([NSString containWithSelectedStr:menuTitle contain:@"查找"]
            && ![NSString containWithSelectedStr:menuTitle contain:@"日期查找"]
            && ![NSString containWithSelectedStr:menuTitle contain:@"内容查找"])
        {
            [mutableArray replaceObjectAtIndex:index withObject:@"查找"];
        }
        
        if ([NSString containWithSelectedStr:menuTitle contain:@"添加"]
            && ![NSString containWithSelectedStr:menuTitle contain:@"添加日报"]
            && ![NSString containWithSelectedStr:menuTitle contain:@"添加周报"]
            && ![NSString containWithSelectedStr:menuTitle contain:@"添加月报"] && ![menuTitle isEqualToString:@"添加朋友"])
        {
            [mutableArray replaceObjectAtIndex:index withObject:@"添加"];
        }
        index ++;
    }
    
    return mutableArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"chatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = kColorWithRGB(46, 50, 62);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCellH -1, Screen_Width/3 * 2, 1)];
        //UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCellH -1, Screen_Width/2, 1)];
        lineLabel.backgroundColor = kColorWithRGB(40, 43, 53);
        [cell.contentView addSubview:lineLabel];
    }
    
    //    if ([[_dataArray objectAtIndex:indexPath.row] isEqualToString:@"叮当享团队"]) {
    //        cell.textLabel.textColor = [UIColor colorWithRed:244/255.f green:158/255.f blue:49/255.f alpha:1];
    //    }else{
    cell.textLabel.textColor  = [UIColor whiteColor];
    //    }
    if ([[_dataArray objectAtIndex:indexPath.row] isEqualToString:@"外出"])
    {
        CGFloat yPoint = cell.imageView.frame.origin.y;
        UILabel *detailText = [[UILabel alloc] initWithFrame:CGRectMake(100, yPoint, 60, kCellH)];
        detailText.text = @"(启动)";
        detailText.font = [UIFont systemFontOfSize:15.0];
        detailText.textColor = kColorWithRGB(170, 170, 170);
        [cell.contentView addSubview:detailText];
    }
    if ([[_dataArray objectAtIndex:indexPath.row] isEqualToString:@"返回"])
    {
        CGFloat yPoint = cell.imageView.bounds.origin.y;
        UILabel *detailText = [[UILabel alloc] initWithFrame:CGRectMake(100, yPoint, 60, kCellH)];
        detailText.text = @"(关闭)";
        detailText.font = [UIFont systemFontOfSize:15.0];
        detailText.textColor = kColorWithRGB(170, 170, 170);
        [cell.contentView addSubview:detailText];
    }
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    NSString *imageName = [_imageArray objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_dataArray objectAtIndex:indexPath.row] isEqualToString:@"叮当享服务"])
    {
        /// 判断是不是点击客服
        if ([_delegate isKindOfClass:[UIViewController class]])
        {
            if([VAL_UserType integerValue] == 3){
                TTAlert(@"您自己就是客服");
                return;
            }
            //            NSMutableArray *kefuArray = [[SDDataBaseHelper shareDB] getKeFuArr];
            NSMutableArray *kefuArray = [[[CXLoaclDataManager sharedInstance]getKefuArray] mutableCopy];
            if(kefuArray == nil || (kefuArray != nil && [kefuArray count] == 0)){
                TTAlert(@"暂时没有客服");
                return;
            }
            
            UIViewController *controller = (UIViewController *)self.delegate;
            SDIMKefuListViewController* kefuListVC = [[SDIMKefuListViewController alloc] init];
            [controller.navigationController pushViewController:kefuListVC animated:YES];
            if ([controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                controller.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
            
            //            SDCompanyUserModel *userModel = [kefuArray firstObject];
            //            UIViewController *controller = (UIViewController *)self.delegate;
            //
            //            SDIMChatViewController *chatVC = [[SDIMChatViewController alloc] init];
            //            chatVC.isGroupChat = NO;
            //            chatVC.chatter = userModel.hxAccount;
            //            chatVC.chatterDisplayName = userModel.realName;
            //            [controller.navigationController pushViewController:chatVC animated:YES];
            //            if ([controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            //                controller.navigationController.interactivePopGestureRecognizer.delegate = nil;
            //            }
            
        }
    }
    else if ([_delegate respondsToSelector:@selector(returnCardID:withCardName:)])
    {
        [_delegate returnCardID:indexPath.row withCardName:_dataArray[indexPath.row]];
    }
    
    else if ([_delegate respondsToSelector:@selector(menuView:returnCardID:withCardName:)]) {
        [_delegate menuView:self returnCardID:indexPath.row withCardName:_dataArray[indexPath.row]];
    }
}


@end
