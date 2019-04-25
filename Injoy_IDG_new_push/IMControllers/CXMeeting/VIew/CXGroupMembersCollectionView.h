//
//  CXGroupMembersCollectionView.h
//  SDMarketingManagement
//
//  Created by haihualai on 16/4/18.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 会议成员
@interface CXGroupMembersCollectionView : UIView
- (instancetype)initWithFrame:(CGRect)frame groupMembers:(NSArray*)groupMembers;
@property (weak, nonatomic) UINavigationController* navigationController_;
@end
