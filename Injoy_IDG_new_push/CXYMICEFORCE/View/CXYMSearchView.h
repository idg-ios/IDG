//
//  CXYMSearchView.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchResultBlock)(NSString *searchRusult);///<返回搜索的文本内容

@interface CXYMSearchView : UIView

@property (nonatomic, copy) SearchResultBlock block;
- (instancetype)initWithSearchPlaceholder:(NSString *)placeholder;
- (void)showWithView:(UIView *)view;
- (void)dismiss;
@end

typedef void(^SearchItemBlock)(NSInteger index,NSString *itemTitle,NSString *searchText);
@interface CXYMItemSearchView: CXYMSearchView

@property (nonatomic, copy) SearchItemBlock itemBlock;///<选择的item,回调
@property (nonatomic, strong) NSArray <NSString *>*ItemArray;///<item的数据源

@end;
