//
//  CXNewIDGSearchViewController.h
//  InjoyIDG
//
//  Created by wtz on 2018/5/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

//搜索类型
typedef NS_ENUM(NSInteger, SDIMIDGSearchType) {
    SDIMIDGSearchTypeAll                      = 0,
    SDIMIDGSearchTypeGroupChat                = 1,
    SDIMIDGSearchTypeSingleChat               = 2,
    SDIMIDGSearchTypeContactConference        = 3,
    SDIMIDGSearchTypeVoiceConference          = 4
};

#import "SDRootViewController.h"
#import "SDIMSearchVIewController.h"

@interface CXNewIDGSearchViewController : SDRootViewController

@end
