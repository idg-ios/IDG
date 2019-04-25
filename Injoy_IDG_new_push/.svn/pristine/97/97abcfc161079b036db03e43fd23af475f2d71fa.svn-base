//
//  CXIMLocationMessageBody.h
//  CXIMLib
//
//  Created by lancely on 2/18/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "CXIMMessageBody.h"
#import <CoreLocation/CoreLocation.h>

@interface CXIMLocationMessageBody : CXIMMessageBody

/**
 *  地址
 */
@property (nonatomic,copy) NSString *address;

/**
 *  纬度
 */
@property (nonatomic, assign) double latitude;

/**
 *  经度
 */
@property (nonatomic, assign) double longitude;

+ (instancetype)bodyWithLongitude:(double)lon latitude:(double)lat address:(NSString *)address;

- (CLLocationCoordinate2D)clLocationCoordinate2D;

@end


