//
//  SDSelectMemberViewController.h
//  InjoyIDG
//
//  Created by HelloIOS on 2018/7/18.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXGroupMember.h"

@protocol SDSelectMemberDelegect <NSObject>

-(void)getTwoSelectMemberArray:(NSMutableArray *)memberArray;

@end

@interface SDSelectMemberViewController : SDRootViewController

/** 群组id */
@property (nonatomic,copy) NSString *groupId;
/** 已选中的索引 */
@property(nonatomic, strong) NSMutableArray<CXGroupMember *> *internalSelectedUsers;
/** 是否是第二次选择 */
@property (nonatomic, assign) BOOL isTwoSelect;

/** 第二次选人需要实现的代理 */
@property (nonatomic, assign) id<SDSelectMemberDelegect> delegate;
/** 是否视频通话，否则语音通话 */
@property (nonatomic, assign) BOOL isVideo;

@end
