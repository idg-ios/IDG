//
//  WMSegmentViewController.h
//  InjoyYZDZ
//
//  Created by 念念不忘必有回响 on 2018/5/23.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WMbuttonHeight 48
@protocol WMSegmentDelegate <NSObject>

@optional
/**
 标签被选中 0++
 @param index 下标 0为基数 需要一直被调用
 */
-(void)selectTopTitleForIndex:(NSInteger)index;

@end

@interface WMSegmentViewController : UIViewController

@property (nonatomic ,assign) id <WMSegmentDelegate> delegate;

#pragma mark - 子视图是否有动画
@property (nonatomic,assign) BOOL isChildScollAnimal;


-(void)segmentWithTitles:(NSArray <NSString *>*)titles images:(NSArray <NSString *>*)images selectImages:(NSArray <NSString *>*)selectImages;
-(void)segmentWithChildViewArrays:(NSArray <UIViewController *>*)childControllerArray;

@end
