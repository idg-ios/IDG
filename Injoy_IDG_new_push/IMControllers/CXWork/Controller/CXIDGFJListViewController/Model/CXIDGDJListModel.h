//
//  CXIDGDJListModel.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/9.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGDJListModel : NSObject
@property(nonatomic, strong)NSString *attaName; //项目名称
@property(nonatomic, strong)NSString *attaPath;
@property(nonatomic, strong)NSString *boxId;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)NSString *fileType;
@property(nonatomic, strong)NSString *isDir;
@property(nonatomic, strong)NSString *parentId;
@property(nonatomic, strong)NSString *uploadTime;
@property(nonatomic, strong)NSString *uploadUser;
@property(nonatomic, strong)NSString *uploadUserName;
@end
