//
//  CXIMMembersView.m
//  SDMarketingManagement
//
//  Created by lancely on 4/26/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXIMMembersView.h"
#import "UIView+Category.h"

#define kMarginTop 10.0
#define kMarginBottom 10.0

@interface CXIMMembersView ()

@property (nonatomic, strong) NSMutableArray<CXIMMemberItem *> *memberItems;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation CXIMMembersView

#pragma mark - 懒加载
- (NSMutableArray<CXIMMemberItem *> *)memberItems {
    if (_memberItems == nil) {
        _memberItems = [NSMutableArray array];
    }
    return _memberItems;
}

#pragma mark - set方法
- (void)setMembers:(NSArray<SDCompanyUserModel *> *)members {
    self->_members = members;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.memberItems removeAllObjects];
    
    NSInteger colCount = Screen_Width / kItemWidth;
    CGFloat height = kItemWidth;
    CGFloat marginLeft = (Screen_Width - (colCount * kItemWidth)) / (colCount + 1);
    [self->_members enumerateObjectsUsingBlock:^(SDCompanyUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXIMMemberItem *item = [[CXIMMemberItem alloc] init];
        [item addTarget:self action:@selector(memberItemTapped:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger rowIndex = idx / colCount; // 当前按钮行号
        NSInteger colIndex = idx % colCount; // 当前按钮列号
        CGFloat x = colIndex * kItemWidth + marginLeft * (colIndex + 1) ;
        CGFloat y = rowIndex * height + kMarginTop * (rowIndex + 1);
        item.frame = CGRectMake(x, y, kItemWidth, height);
        item.userModel = obj;
        [self.memberItems addObject:item];
        [self addSubview:item];
    }];
    
    // 添加
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"im-members-add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    NSInteger rowIndex = members.count / colCount; // 当前按钮行号
    NSInteger colIndex = members.count % colCount; // 当前按钮列号
    CGFloat x = colIndex * kItemWidth + marginLeft * (colIndex + 1) ;
    CGFloat y = rowIndex * height + kMarginTop * (rowIndex + 1);
    addBtn.frame = CGRectMake(x , y, kItemWidth, height);
    addBtn.tag = 10086;
    [self addSubview:addBtn];
    self.addBtn = addBtn;
    
    // 删除
    if (self.deleteButtonEnable) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"im-members-delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        rowIndex = (members.count + 1) / colCount; // 当前按钮行号
        colIndex = (members.count + 1) % colCount; // 当前按钮列号
        x = colIndex * kItemWidth + marginLeft * (colIndex + 1) ;
        y = rowIndex * height + kMarginTop * (rowIndex + 1);
        deleteBtn.frame = CGRectMake(x , y, kItemWidth, height);
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    
    self->_viewHeight = CGRectGetMaxY(self.subviews.lastObject.frame) + kMarginBottom;
}

#pragma mark - Action

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //    // 控制链处理优先级: removeBtns > memberItems > 其他subviews > self
    //    for (UIView *view in self.removeBtns) {
    //        if (CGRectContainsPoint(view.frame, point)) {
    //            return view;
    //        }
    //    }
    //    for (UIView *view in self.memberItems) {
    //        if (CGRectContainsPoint(view.frame, point)) {
    //            return view;
    //        }
    //    }
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, point)) {
            return view;
        }
    }
    return self;
}

- (void)memberItemTapped:(CXIMMemberItem *)item {
    if ([self.delegate respondsToSelector:@selector(imMembersView:didTappedMemberItem:)]) {
        [self.delegate imMembersView:self didTappedMemberItem:item];
    }
}

- (void)addBtnTapped:(UIButton *)addBtn {
    if ([self.delegate respondsToSelector:@selector(imMembersView:didTappedAddButton:)]) {
        [self.delegate imMembersView:self didTappedAddButton:NULL];
    }
}

- (void)deleteBtnTapped:(UIButton *)deleteBtn {
    if ([self.delegate respondsToSelector:@selector(imMembersView:didTappedDeleteButton:)]) {
        [self.delegate imMembersView:self didTappedDeleteButton:NULL];
    }
}

- (void)setIsSystemGroup:(BOOL)isSystemGroup
{
    if(isSystemGroup){
        UIView * addBtn = [self viewWithTag:10086];
        [addBtn removeFromSuperview];
        self->_viewHeight = CGRectGetMaxY(self.subviews.lastObject.frame) + kMarginBottom;
    }
}

@end
