//
//  ICEFORCESelectListView.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/15.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCESelectListView : UIView

/** 数据回调 */
@property (nonatomic,copy) void (^selectListData)(NSDictionary *dataSource);

/** 是否显示线条  default YES  */
@property (nonatomic ,assign,getter=isShowLine) BOOL showLine;

@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) NSString *dataKey;
@property (nonatomic ,strong) UIColor *changeColor;

-(void)reloadData;
@end

NS_ASSUME_NONNULL_END
