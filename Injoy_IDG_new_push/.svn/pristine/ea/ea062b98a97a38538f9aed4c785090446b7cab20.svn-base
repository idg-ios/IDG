//
//  SDUserCurrentLocation.m
//  SDMarketingManagement
//
//  Created by huihui on 15/12/24.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDUserCurrentLocation.h"
//#import <BaiduMapAPI/BMapKit.h>
#import "HttpTool.h"
#import "AppDelegate.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface SDUserCurrentLocation()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKLocationService *locService;
//编码成功
@property (nonatomic, assign) BOOL isSuccess;
//地图编码
@property(nonatomic, strong)BMKGeoCodeSearch *codeSearch;

@end

@implementation SDUserCurrentLocation

-(id)initWithSignIn
{
    if (self = [super init])
    {
        
//            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//            NSLog(@"dict = %@",dict);
            _locService = [[BMKLocationService alloc] init];
            _locService.delegate = self;
            [_locService startUserLocationService];
            
            //地理编码
            _codeSearch = [[BMKGeoCodeSearch alloc] init];
            _codeSearch.delegate = self;
    }
    
    return self;
 
}

-(id)init
{
    if (self = [super init]) {
        
       NSString *locationKey = [NSString stringWithFormat:@"%@_%@",[AppDelegate getCompanyID],[AppDelegate getUserID]];
       NSDictionary *locationDict = [[NSUserDefaults standardUserDefaults]objectForKey:kUserLocationSave];
       BOOL saveLocaion = [[locationDict objectForKey:locationKey] boolValue];
        
        if (saveLocaion == YES ) {
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        NSLog(@"dict = %@",dict);
            _locService = [[BMKLocationService alloc] init];
            _locService.delegate = self;
            [_locService startUserLocationService];
            
            //地理编码
            _codeSearch = [[BMKGeoCodeSearch alloc] init];
            _codeSearch.delegate = self;
        }
    }
    
    return self;
}

#pragma mark 用户位置更新后，调用此方法
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //关闭定位服务
    [_locService stopUserLocationService];
    BMKReverseGeoCodeOption* reverse = [[BMKReverseGeoCodeOption alloc] init];
    reverse.reverseGeoPoint = userLocation.location.coordinate;
    _isSuccess = [_codeSearch reverseGeoCode:reverse];
    if (_isSuccess) {
        NSLog(@"编码成功");
        _locService.delegate = nil;
    }
    else {
        //关闭定位服务
        [_locService stopUserLocationService];
        NSLog(@"编码失败");
        _locService = nil;
        _codeSearch = nil;
        _codeSearch.delegate = nil;
        _locService.delegate = nil;
        if (self.signFail) {
            self.signFail();
        }
    }
}

#pragma mark -- 接收地理位置反编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //关闭定位服务
        [_locService stopUserLocationService];
        self.userCurrentLocation = [NSString stringWithFormat:@"%@,%f,%f", result.address,result.location.longitude, result.location.latitude];
        
//        NSString *cityAndDistrict = [NSString stringWithFormat:@"%@%@",result.addressDetail.city,result.addressDetail.district];
//        self.userCurrentLocation = [NSString stringWithFormat:@"%@,%f,%f", cityAndDistrict,result.location.longitude, result.location.latitude];
        
        //记录最近一次使用定位功能
        [[NSUserDefaults standardUserDefaults] setObject:@(result.location.longitude) forKey:@"loginLongitude"];
        [[NSUserDefaults standardUserDefaults] setObject:@(result.location.latitude) forKey:@"loginLatitude"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"userCurrentLocation = %@",self.userCurrentLocation);
        
        if (self.signSuccess) {
            self.signSuccess(self.userCurrentLocation);
        }
        
        if (self.detailCallback) {
            self.detailCallback(result.location, result.address);
        }
        
        //来自登陆界面
        NSString *locationKey = [NSString stringWithFormat:@"%@_%@",[AppDelegate getCompanyID],[AppDelegate getUserID]];
        NSDictionary *locationDict = [[NSUserDefaults standardUserDefaults]objectForKey:kUserLocationSave];
        BOOL saveLocaion = [[locationDict objectForKey:locationKey] boolValue];
        if (self.isLoginView && saveLocaion) {
            
            [HttpTool saveTrajectoryDataByLocation:self.userCurrentLocation];
        }
        
        if (self.locationSuccess) {
            self.locationSuccess();
        }
        
        _codeSearch.delegate = nil;
        _locService = nil;
        _codeSearch = nil;
        
    }else{
        //关闭定位服务
        
        if (self.signFail) {
            self.signFail();
        }
        
        [_locService stopUserLocationService];
        _locService = nil;
        _codeSearch = nil;
    }
}

- (void)dealloc
{
    _codeSearch.delegate = nil;
    _locService.delegate = nil;
    _locService = nil;
    _codeSearch = nil;
}

@end
