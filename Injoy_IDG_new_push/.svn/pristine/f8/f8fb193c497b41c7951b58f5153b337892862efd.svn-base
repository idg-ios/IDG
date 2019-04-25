//
//  CXIMMembersView.h
//  SDMarketingManagement
//
//  Created by lancely on 4/26/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXIMMemberItem.h"
#import "SDCompanyUserModel.h"
@class CXIMMembersView;

/**
 *  协议方法
 */
@protocol CXIMMembersViewDelegate <NSObject>

@optional
/**
 *  点击了成员
 *
 *  @param membersView CXFocusSignMembersView对象
 *  @param memberItem  成员view
 */
- (void)imMembersView:(CXIMMembersView *)membersView didTappedMemberItem:(CXIMMemberItem *)memberItem;

/**
 *  点击了添加
 *
 *  @param membersView CXFocusSignMembersView对象
 *  @param none   空对象
 */
- (void)imMembersView:(CXIMMembersView *)membersView didTappedAddButton:(void *)none;

/**
 *  点击了删除
 *
 *  @param membersView CXFocusSignMembersView对象
 *  @param none   空对象
 */
- (void)imMembersView:(CXIMMembersView *)membersView didTappedDeleteButton:(void *)none;

@end

@interface CXIMMembersView : UIView

/**
 *  是否启用删除按钮
 */
@property (nonatomic, assign) BOOL deleteButtonEnable;

/**
 *  成员模型数组
 */
@property (nonatomic, copy) NSArray<SDCompanyUserModel *> *members;

/**
 *  代理
 */
@property (nonatomic, weak) id<CXIMMembersViewDelegate> delegate;

/**
 *  view的高度
 */
@property (nonatomic, assign, readonly) CGFloat viewHeight;

/**
 *  是否是系统群的头部View
 */
@property (nonatomic) BOOL isSystemGroup;

@end
