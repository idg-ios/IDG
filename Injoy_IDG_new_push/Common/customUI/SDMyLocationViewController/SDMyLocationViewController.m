//
//  SDMyLocationViewController.m
//  SDMarketingManagement

//  Created by fanzhong on 15/5/21.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//
//

#import "AppDelegate.h"
#import "HttpTool.h"
#import "SDDataBaseHelper.h"
#import "SDLocModel.h"
#import "SDMyLocationViewController.h"
#import "SDSelectAdress.h"

#define kBottomH 44

@interface SDMyLocationViewController ()
@property (nonatomic, copy) NSString* dingWeiLocation;
@property (assign) BOOL isSuccess; //地址编码是否成功
@property (nonatomic, strong) NSMutableArray* locArray;
@property (nonatomic, copy) NSString* locAdress;
@property (nonatomic, strong) UILabel* sendRangeLabel;
@property (nonatomic, strong) NSArray* sendRangeArray;
@property (nonatomic, copy) NSString* sendRangeSring;
/// 已选联系人ID
@property (nonatomic, strong) NSMutableArray* contactArray;
/// 已选部门
@property (nonatomic, strong) NSMutableArray* deptArray;
/// 部门ID
@property (nonatomic, strong) NSMutableArray* deptId;

@end

@implementation SDMyLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sendRangeSring = @"抄送 :";
    self.locArray = [NSMutableArray array];
    self.sendRangeArray = [NSArray array];
    _isSuccess = NO;
    [self setUpTopView];
    [self creatMapView];
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - kBottomH, Screen_Width, kBottomH)];
    self.bottomView.backgroundColor = kColorWithRGB(34, 38, 50);
    [self.view addSubview:self.bottomView];
    UIImage* positionImage = [UIImage imageNamed:@"mapPosition.png"];

    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(positionImage.size.width, 0, self.bottomView.bounds.size.width, kBottomH)];
    self.bottomLabel.font = [UIFont systemFontOfSize:15];
    self.bottomLabel.text = @"我所在的位置";
    self.bottomLabel.numberOfLines = 0;
    self.bottomLabel.textColor = [UIColor whiteColor];
    [self.bottomView addSubview:self.bottomLabel];

    UIImageView* positionImageView = [[UIImageView alloc] initWithImage:positionImage];
    positionImageView.frame = CGRectMake(0, 0, positionImage.size.width, positionImage.size.height);
    CGPoint positionCenter = positionImageView.center;
    positionCenter.y = self.bottomLabel.center.y;
    positionImageView.center = positionCenter;
    [self.bottomView addSubview:positionImageView];
}

#pragma mark - sendRangeLabel
- (UILabel*)sendRangeLabel
{
    if (!_sendRangeLabel) {
        UIImage* sendRangeImage = [UIImage imageNamed:@"mapSendRange.png"];
        _sendRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(sendRangeImage.size.width, kBottomH, self.bottomView.bounds.size.width - 30, kBottomH)];
        _sendRangeLabel.textAlignment = NSTextAlignmentLeft;
        _sendRangeLabel.font = [UIFont systemFontOfSize:15];
        [self.bottomView addSubview:_sendRangeLabel];

        UIImageView* sendRangeImageView = [[UIImageView alloc] initWithImage:sendRangeImage];
        sendRangeImageView.frame = CGRectMake(0, kBottomH, sendRangeImage.size.width, sendRangeImage.size.height);
        [self.bottomView addSubview:sendRangeImageView];
        CGPoint sendRangeImageViewCenter = sendRangeImageView.center;
        sendRangeImageViewCenter.y = _sendRangeLabel.center.y;
        sendRangeImageView.center = sendRangeImageViewCenter;

        UIImageView* imgv = [[UIImageView alloc] initWithFrame:CGRectMake(self.bottomView.bounds.size.width - sendRangeImage.size.width * 2, kBottomH / 4, kBottomH * .5, kBottomH * .5)];
        imgv.image = Image(@"common_icon_arrow.png");
        [_sendRangeLabel addSubview:imgv];
        UIView* vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 1)];
        vi.backgroundColor = [UIColor grayColor];
        [_sendRangeLabel addSubview:vi];
        _sendRangeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSendRange)];
        [_sendRangeLabel addGestureRecognizer:tap];
    }
    return _sendRangeLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    if (_isattendance) {
        CGRect frame = self.bottomView.frame;
        frame.origin.y = Screen_Height - 2 * kBottomH;
        frame.size.height = 2 * kBottomH;
        self.bottomView.frame = frame;
        CGRect mapFrame = _mapView.frame;
        mapFrame.size.height = Screen_Height - navHigh - 2 * kBottomH;
        _mapView.frame = mapFrame;
        self.sendRangeLabel.text = self.sendRangeSring;
        self.sendRangeLabel.textColor = [UIColor whiteColor];
    }

    _mapView.showsUserLocation = YES;

    //地理编码
    _codeSearch = [[BMKGeoCodeSearch alloc] init];

    //搜索
    _poisearch = [[BMKPoiSearch alloc] init];

    _locService.delegate = self;
    _codeSearch.delegate = self;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self;
}


#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    [_locService stopUserLocationService];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _codeSearch.delegate = nil;
    _poisearch.delegate = nil;
    self.mapView = nil;
    _isSuccess = NO;
}

#pragma mark--地图初始化
- (void)creatMapView
{
    BMKMapView* mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - kBottomH)];
    [self.view addSubview:mapView];
    self.mapView = mapView;

    //**定位服务
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:50.f];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc] init];
    //启动LocationService
    [_locService startUserLocationService];

    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.showsUserLocation = YES;
}
#pragma mark--设置导航栏
//设置导航栏
- (void)setUpTopView
{
    SDRootTopView* rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"位置信息"];

    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];

    [rootTopView setUpRightBarItemTitle:@"确定" addTarget:self action:@selector(rightBtnClick)];
}

#pragma mark--导航栏按钮点击

- (void)rightBtnClick
{
    NSString* str = [NSString stringWithFormat:@"%@,%@", self.bottomLabel.text, self.dingWeiLocation];
    NSString* urlStr = [NSString stringWithFormat:@"%@attendance/save", urlPrefix];
    if (_isSuccess) {
        if (_isattendance) {
            NSString* myId = [AppDelegate getUserID];
            NSString* companyId = [AppDelegate getCompanyID];
            if (self.sendRangeArray.count) {
                NSMutableArray* arr = [NSMutableArray array];

                for (int i = 0; i < self.sendRangeArray.count; i++) {
                    NSInteger userId = [[[self.sendRangeArray valueForKey:@"userId"] objectAtIndex:i] integerValue];
                    [arr addObject:@(userId)];
                }

                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
                NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary* dic = @{ @"userid" : myId,
                    @"companyid" : companyId,
                    @"location" : str,
                    @"cc" : jsonStr,
                    @"fromwhere" : @"iPhone"
                };
                [HttpTool postWithPath:urlStr
                    params:dic
                    success:^(id JSON) {
                        NSLog(@"打卡成功");
                        //[self.view makeToast:@"打卡成功" duration:0.5 position:@"center"];
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"签到成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    failure:^(NSError* error) {
                        NSLog(@"打卡失败");
                        NSLog(@"%@", error);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //[self.view makeToast:@"打卡失败" duration:0.5 position:@"center"];
                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"签到失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        });
                    }];
            }
            else {
                TTAlert(@"请选择抄送!");
                return;
            }
        }

        if ([self.delegate respondsToSelector:@selector(sendAdress:)]) {
            [self.delegate sendAdress:str];
        }
    }
    else {
        TTAlert(@"定位失败!");
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--实现相关delegate 处理位置信息更新
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation*)userLocation
{
    //        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    BMKCoordinateRegion region;
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.004;
    region.span.longitudeDelta = 0.004;

    if (_mapView) {
        _mapView.region = region;
        userLocation.title = @"您当前的位置";

        BMKReverseGeoCodeOption* reverse = [[BMKReverseGeoCodeOption alloc] init];
        reverse.reverseGeoPoint = userLocation.location.coordinate;
        _isSuccess = [_codeSearch reverseGeoCode:reverse];
        if (_isSuccess) {
            NSLog(@"编码成功");
        }
        else {
            NSLog(@"编码失败");
        }

        //                NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        //                [_mapView removeAnnotations:_mapView.annotations];
        //                BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        //                annotation.coordinate =  userLocation.location.coordinate;
        //
        //                [self.mapView addAnnotation:annotation];

        BMKNearbySearchOption* nearSearchOption = [[BMKNearbySearchOption alloc] init];
        nearSearchOption.location = userLocation.location.coordinate;
        nearSearchOption.radius = 300;
        nearSearchOption.keyword = @"房屋";

        BOOL flag = [_poisearch poiSearchNearBy:nearSearchOption];

        if (flag) {
            NSLog(@"附近检索发送成功");
        }
        else {
            NSLog(@"附近检索发送失败!!");
        }
    }
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    NSLog(@"poiresult:%lu", poiResult.poiInfoList.count);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];

    if (errorCode == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < poiResult.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
            item.coordinate = poi.pt;
            item.title = poi.address;

            [_mapView addAnnotation:item];
        }
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
        NSLog(@"起始点有歧义");
    }
    else {
        // 各种情况的判断。。。
    }
}

- (void)mapView:(BMKMapView*)mapView annotationViewForBubble:(BMKAnnotationView*)view
{
    NSLog(@"点击annotation view弹出的泡泡  %@", view.annotation);
    //    SDSelectAdress *selectAdress = [[SDSelectAdress alloc]init];
    //    selectAdress.adressArray = self.locArray;
    //    [self presentViewController:selectAdress animated:YES completion:nil];
    BMKPointAnnotation* annotation = view.annotation;
    NSLog(@"title: %@", annotation.title);
}

- (void)mapView:(BMKMapView*)mapView didSelectAnnotationView:(BMKAnnotationView*)view
{

    NSLog(@"选中一个annotation views:%@,%f,%f", view, view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
    BMKPointAnnotation* annotation = view.annotation;
    if ([annotation.title isEqualToString:@"您当前的位置"]) {
        self.bottomLabel.text = self.locAdress;
    }
    else {
        self.bottomLabel.text = annotation.title;
    }
    self.dingWeiLocation = [NSString stringWithFormat:@"%f,%f", annotation.coordinate.longitude, annotation.coordinate.latitude];
}

#pragma mark - 反向编码
//接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch*)searcher result:
                                                                  (BMKReverseGeoCodeResult*)result
                        errorCode:(BMKSearchErrorCode)error
{

    if (error == BMK_SEARCH_NO_ERROR) {
        self.bottomLabel.text = [NSString stringWithFormat:@" %@", result.address];
        self.dingWeiLocation = [NSString stringWithFormat:@"%f,%f", result.location.longitude, result.location.latitude];
        self.locAdress = result.address;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (BMKAnnotationView*)mapView:(BMKMapView*)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString* AnnotationViewID = @"xidanMark";

    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];

    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }

    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation; //绑定对应的标点经纬度
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;

    //    annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow.png"]];

    return annotationView;
}
- (void)dealloc
{
    _isSuccess = NO;
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

@end
