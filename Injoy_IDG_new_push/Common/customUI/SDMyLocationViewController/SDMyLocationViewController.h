//
//  SDMyLocationViewController.h
//  SDMarketingManagement
//
//  Created by fanzhong on 15/5/21.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"
//#import <BaiduMapAPI/BMapKit.h>

//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@protocol SDMyLocationViewControllDelegate<NSObject>
/**
 *  回调地址
 *
 *  @param adress "地名,longitude,latitude"
 */
@optional
- (void)sendAdress:(NSString *)adress;
@end

@interface SDMyLocationViewController : SDRootViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    BMKLocationService* _locService;
    
}

@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)UIView *bottomView;//底部显示地址
@property(nonatomic,strong)UILabel *bottomLabel;
@property(nonatomic,strong)BMKGeoCodeSearch *codeSearch;
@property(nonatomic,strong)BMKPoiSearch *poisearch;//搜索
@property(nonatomic,weak)id <SDMyLocationViewControllDelegate>delegate;
@property(nonatomic,assign)BOOL isattendance;//是否是签到需要抄送
@end
