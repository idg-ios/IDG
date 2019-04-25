//
//  SDAppearMap.m
//  SDMarketingManagement
//
//  Created by fanzhong on 15/5/21.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDAppearMap.h"
#import "HttpTool.h"
#import "SDJsonManager.h"
//#import <BaiduMapAPI/BMapKit.h>
#import "SDAttendanceModel.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface SDAppearMap () <BMKMapViewDelegate>
@property (nonatomic, strong) SDRootTopView* topView;
@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) UILabel* bottomLabel;
@property (copy, nonatomic) NSArray* mapArr;
/// 发送请求
- (void)sendRequest;
@end

@implementation SDAppearMap

- (void)dealloc
{
    self.mapView.delegate = nil;
    self.mapView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self sendRequest];

    self.topView = [self getRootTopView];
    self.topView.navTitleLabel.text = @"地图";

    if (_isFromTrack) {
        self.topView.navTitleLabel.text = @"轨迹";
    }

    UIButton* customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* backImage = [UIImage imageNamed:@"back.png"];
    [customLeftBtn setImage:backImage forState:UIControlStateNormal];
    UseAutoLayout(customLeftBtn);
    [customLeftBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:customLeftBtn];

    // cancelBtn宽度
    NSDictionary* metrics = @{ @"btnWidth" : @(backImage.size.width),
        @"btnHeight" : @(backImage.size.height) };
    [_topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[customLeftBtn(btnWidth)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(customLeftBtn)]];
    // cancelBtn高度
    [_topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[customLeftBtn(btnHeight)]-5-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(customLeftBtn)]];
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh)];
    [self.view addSubview:self.mapView];

    if (!_isFromTrack) {
        [self addBottomView];
    }
}

/// 发送请求
- (void)sendRequest
{
    if (NO == [self isFromRequest]) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"%@attendance/show", urlPrefix];

    NSDictionary* params = @{
        @"companyid" : VAL_companyId,
        @"userid" : VAL_USERID,
        @"id" : self.attendanceID
    };

    __weak typeof(self) weakSelf = self;

    [weakSelf showHint:@"正在加载"];
    [HttpTool postWithPath:url
        params:params
        success:^(id JSON) {
            if (200 == [[JSON valueForKey:@"status"] intValue]) {
                weakSelf.mapArr = [SDJsonManager modelAryFromSourceAry:[JSON valueForKey:@"attendances"] withModelClassName:@"SDAttendanceModel"];
            }
            [weakSelf hideHud];
        }
        failure:^(NSError* error) {
            TTAlertNoTitle(error.debugDescription);
            [weakSelf hideHud];
        }];
}

- (void)addBottomView
{
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Screen_Height - 44, Screen_Height, 44)];
    self.bottomLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bottomLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.bottomLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self isFromRequest]) {
        return;
    }

    if (!_isFromTrack && [self.location length]) {
        [self appearMapWithLocation:self.location];
        NSArray* arr = [self.location componentsSeparatedByString:@","];
        self.bottomLabel.text = [NSString stringWithFormat:@"  %@", arr[0]];
        self.bottomLabel.textColor = [UIColor blackColor];
    }
    else if (self.isFromTrack) {
        for (NSString* locationString in self.locationArray) {
            [self appearMapWithLocation:locationString];
            [self showTrackDetailLineWhenInterterfaceIsFromTrack];
        }
    }
}

#pragma mark - get set

- (void)setMapArr:(NSArray*)mapArr
{
    if (_mapArr != mapArr) {
        _mapArr = mapArr;
        SDAttendanceModel* oneModel = [mapArr firstObject];
        [self appearMapWithLocation:oneModel.location];
        NSArray* arr = [oneModel.location componentsSeparatedByString:@","];
        self.bottomLabel.text = [NSString stringWithFormat:@"  %@", arr[0]];
        self.bottomLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark 添加轨迹的折叠线
- (void)showTrackDetailLineWhenInterterfaceIsFromTrack
{
    self.mapView.delegate = self;
    NSInteger count = self.locationArray.count;
    CLLocationCoordinate2D coors[count];

    for (NSInteger i = 0; i < self.locationArray.count; i++) {
        NSString* location = self.locationArray[i];
        NSArray* array = [location componentsSeparatedByString:@","];

        if (array.count != 3) {
            continue;
        }

        coors[i].longitude = [array[1] floatValue];
        coors[i].latitude = [array[2] floatValue];
    }

    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:count];
    [self.mapView addOverlay:polyline];
}

- (void)appearMapWithLocation:(NSString*)location
{
    NSArray* arr = [location componentsSeparatedByString:@","];
    if (arr.count == 2) {
        return;
    }

    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    float longitude = [arr[1] floatValue];
    float latitude = [arr[2] floatValue];
    BMKCoordinateRegion region;
    region.center.latitude = latitude;
    region.center.longitude = longitude;

    region.span.latitudeDelta = 0.004;
    region.span.longitudeDelta = 0.004;

    [_mapView setRegion:region];

    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    annotation.coordinate = coor;
    annotation.title = arr[0];
    [_mapView addAnnotation:annotation];
}

#pragma mark 实现百度地图的代理方法
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

@end
