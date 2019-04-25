//
// Created by ^ on 2017/12/13.
// Copyright (c) 2017 Injoy. All rights reserved.
//

extern const CGFloat CXTopScrollView_height;

@interface CXTopScrollView : UIView

@property(copy, nonatomic) void (^callBack)(NSString *, int, BOOL);

/// 默认选中 {索引从0开始}
@property(assign, nonatomic) NSInteger currentSelectIndex;

- (instancetype)initWithTitles:(NSArray *)titlesArr;

@end
