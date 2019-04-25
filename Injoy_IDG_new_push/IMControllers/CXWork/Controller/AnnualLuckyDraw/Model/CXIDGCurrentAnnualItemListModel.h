//
//  CXIDGCurrentAnnualItemListModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/1/8.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGCurrentAnnualItemListModel : NSObject

/** eid Long */
@property (nonatomic, strong) NSNumber * eid;
/** itemIndex 节目序号 int */
@property (nonatomic, strong) NSNumber * itemIndex;
/** name 节目名称 String */
@property (nonatomic, copy) NSString * name;
/** voteCount 已经投票总数 Long */
@property (nonatomic, strong) NSNumber * voteCount;

@end
