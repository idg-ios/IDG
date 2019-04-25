//
//  SDChatMapViewController.m
//  SDMarketingManagement
//
//  Created by Rao on 16/2/2.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDChatMapViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h> //引入base相关所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h> //引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> //引入地图功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h> //只引入所需的单个头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h> //引入检索功能所有的头文件

@interface SDChatMapViewController () <BMKMapViewDelegate,
    BMKLocationServiceDelegate,
    BMKPoiSearchDelegate,
    BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) SDRootTopView* rootTopView;
/// 百度地图
@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKLocationService* locService;
@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate;
/// 搜索
@property (nonatomic, strong) BMKPoiSearch* poisearch;
/// 地理编码
@property (strong, nonatomic) BMKGeoCodeSearch* codeSearch;

/// 地址编码是否成功
@property (assign, nonatomic) BOOL isSuccess;
- (void)setNavBar;
- (void)setupBMKMapView;
- (void)appearMapWithLocation:(CLLocationCoordinate2D)LocationCoordinate2D;
@end

@implementation SDChatMapViewController {
    BOOL _isSendLocation; // 是否发送地址
    /// 获取的地址
    CLLocationCoordinate2D _locationCoordinate2D;
    BMKPointAnnotation* pointAnnotation;
    NSString* address;
}

- (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSendLocation = YES;
    }

    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _locationCoordinate = locationCoordinate;
    }

    return self;
}

/// 设置百度地图
- (void)setupBMKMapView
{
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh)];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

/// 发送地理位置
- (void)sendLocation
{
    if (_isSuccess && [self.delegate respondsToSelector:@selector(sendLocationLatitude:longitude:andAddress:)]) {
        [self.delegate sendLocationLatitude:_locationCoordinate2D.latitude longitude:_locationCoordinate2D.longitude andAddress:address];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        TTAlertNoTitle(@"定位失败!");
    }
}

- (void)setNavBar
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"位置信息"];

    // 返回
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];

    if (_isSendLocation) {
        [self.rootTopView setUpRightBarItemTitle:@"发送" addTarget:self action:@selector(sendLocation)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBar];
    [self setupBMKMapView];

    [self locService];
    [self poisearch];
    [self codeSearch];
}

- (void)appearMapWithLocation:(CLLocationCoordinate2D)LocationCoordinate2D
{
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    float longitude = LocationCoordinate2D.longitude;
    float latitude = LocationCoordinate2D.latitude;
    BMKCoordinateRegion region;
    region.center.latitude = latitude;
    region.center.longitude = longitude;

    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;

    [_mapView setRegion:region];

    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    annotation.coordinate = coor;
    if (self.showAddressAnnotation) {
        annotation.title = self.address;
    }
    [self.mapView addAnnotation:annotation];
}

- (BMKLocationService*)locService
{
    if (nil == _locService) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        _locService.distanceFilter = 50.f;
        _locService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _locService;
}

- (BMKPoiSearch*)poisearch
{
    if (nil == _poisearch) {
        _poisearch = [[BMKPoiSearch alloc] init];
        _poisearch.delegate = self;
    }
    return _poisearch;
}

- (BMKGeoCodeSearch*)codeSearch
{
    if (nil == _codeSearch) {
        _codeSearch = [[BMKGeoCodeSearch alloc] init];
        _codeSearch.delegate = self;
    }
    return _codeSearch;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isSendLocation) {
        // 发送地理位置
        [self.locService startUserLocationService];
    }
    else {
        [self appearMapWithLocation:self.locationCoordinate];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    [self.locService stopUserLocationService];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
    self.codeSearch.delegate = nil;
    self.poisearch.delegate = nil;
    self.mapView = nil;
    _isSuccess = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BMKMapViewDelegate
- (BMKOverlayView*)mapView:(BMKMapView*)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation*)userLocation
{
    [self.mapView updateLocationData:userLocation];
    BMKCoordinateRegion region;
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;

    if (_mapView) {
        _mapView.region = region;
        userLocation.title = @"您当前的位置";

        BMKReverseGeoCodeOption* reverse = [[BMKReverseGeoCodeOption alloc] init];
        reverse.reverseGeoPoint = userLocation.location.coordinate;
        _isSuccess = [_codeSearch reverseGeoCode:reverse];
        if (_isSuccess) {
            NSLog(@"编码成功");
            _locationCoordinate2D = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
            if (nil == pointAnnotation) {
                pointAnnotation = [[BMKPointAnnotation alloc] init];
                CLLocationCoordinate2D coor;
                coor.latitude = _locationCoordinate2D.latitude;
                coor.longitude = _locationCoordinate2D.longitude;
                pointAnnotation.coordinate = coor;
            }
            [self.mapView removeAnnotation:pointAnnotation];
            [self.mapView addAnnotation:pointAnnotation];
        }
        else {
            NSLog(@"编码失败");
        }

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

//接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:
            (BMKGeoCodeSearch*)searcher
                           result:(BMKReverseGeoCodeResult*)result
                        errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        address = result.address;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

@end
