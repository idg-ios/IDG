//
//  CXIDGSmallBusinessAssistantModel.h
//  InjoyDDXWBG
//
//  Created by wtz on 2017/11/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGSmallBusinessAssistantModel : NSObject

/** gsmc */
@property (nonatomic, copy) NSString * companyName;
/** nsh */
@property (nonatomic, copy) NSString * taxNumber;
/** kpdz */
@property (nonatomic, copy) NSString * invoiceAddress;
/** zh */
@property (nonatomic, copy) NSString * account;
/** khh */
@property (nonatomic, copy) NSString * openBank;
/** dh */
@property (nonatomic, copy) NSString * telephone;
/** gscz */
@property (nonatomic, copy) NSString * fax;
/** gscz */
@property (nonatomic, strong) NSNumber * eid;
/** ID */
@property (nonatomic, strong) NSNumber * ID;


@end
