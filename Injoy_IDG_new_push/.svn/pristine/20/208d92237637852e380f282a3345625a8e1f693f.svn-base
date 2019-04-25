//
//  SDChatMapViewController.h
//  SDMarketingManagement
//
//  Created by Rao on 16/2/2.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h> //只引入所需的单个头文件

@protocol SDChatMapViewControllerDelegate <NSObject>
@optional
- (void)sendLocationLatitude:(double)latitude
                   longitude:(double)longitude
                  andAddress:(NSString*)address;
@end

@interface SDChatMapViewController : SDRootViewController
- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;
@property (weak, nonatomic) id<SDChatMapViewControllerDelegate> delegate;
/**
 *  是否显示地址的大头针
 */
@property (nonatomic, assign) BOOL showAddressAnnotation;
/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;
@end
