//
//  CXInternalBulletinListViewController.h
//  InjoyIDG
//
//  Created by ^ on 2018/1/30.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CXInternalBulletinListViewController : SDRootViewController
typedef NS_ENUM(NSInteger, type){
    isInternalButin = 0,
    isTool,
    isFJListH5
};
typedef NS_ENUM(NSInteger, kind){
    GZZD = 1,
    XZBG,
    CYMB///<常用模板
};
@property(nonatomic, copy)NSString *searchText;
@property (nonatomic, assign)kind i_kind;
-(id)initWithType:(type)type;
@end
