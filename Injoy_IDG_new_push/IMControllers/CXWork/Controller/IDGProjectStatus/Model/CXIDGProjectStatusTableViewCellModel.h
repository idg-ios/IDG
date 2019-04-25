//
//  CXIDGProjectStatusTableViewCellModel.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGProjectStatusTableViewCellModel : NSObject

/** title */
@property (nonatomic, copy) NSString * title;
/** content */
@property (nonatomic, copy) NSString * content;
/** isExpand */
@property (nonatomic) BOOL isExpand;

@end
