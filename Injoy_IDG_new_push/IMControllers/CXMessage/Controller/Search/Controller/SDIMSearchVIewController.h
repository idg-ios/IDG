//
//  SDIMSearchVIewController.h
//  SDMarketingManagement
//
//  Created by wtz on 16/4/20.
//  Copyright © 2016年 slovelys. All rights reserved.
//


//搜索类型
typedef NS_ENUM(NSInteger, SDIMSearchType) {
    SDIMSearchTypeAll                      = 0,
    SDIMSearchTypeGroupChat                = 1,
    SDIMSearchTypeSingleChat               = 2,
    SDIMSearchTypeVoiceConference          = 3
};

#import "SDRootViewController.h"
@interface SDIMSearchVIewController : SDRootViewController

@end
