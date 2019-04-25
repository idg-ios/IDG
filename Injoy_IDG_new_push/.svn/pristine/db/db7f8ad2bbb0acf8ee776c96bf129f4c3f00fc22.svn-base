//
//  SDUserCurrentLocation.h
//  SDMarketingManagement
//
//  Created by huihui on 15/12/24.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

typedef void (^locationSuccessCallBack)();
typedef void (^locationSignSuccess)(NSString *location);
typedef void (^locationSignFail)();
typedef void (^locationDetailCallback)(CLLocationCoordinate2D location, NSString *address);

#import <Foundation/Foundation.h>

@interface SDUserCurrentLocation : NSObject

@property (nonatomic, strong) NSString *userCurrentLocation;

//来自登陆界面
@property (nonatomic, assign) BOOL isLoginView;


@property (nonatomic, copy)locationSuccessCallBack  locationSuccess;

@property (nonatomic, copy)locationSignSuccess signSuccess;

@property (nonatomic, copy)locationSignFail signFail;

@property (nonatomic, copy) locationDetailCallback detailCallback;

-(id)initWithSignIn;

@end
