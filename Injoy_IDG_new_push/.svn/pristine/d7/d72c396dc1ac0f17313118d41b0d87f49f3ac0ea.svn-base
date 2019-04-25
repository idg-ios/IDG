//
//  CXNormalCell.h
//  SDMarketingManagement
//
//  Created by lancely on 5/9/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+CXCategory.h"

@class CXNormalCell;
@class CXNormalCellLabel;

@protocol CXNormalCellDelegate <NSObject>

@optional
/** cell的tap回调 */
- (void)normalCell:(CXNormalCell *)cell tappedAtIndexPath:(NSIndexPath *)indexPath;

/** cell的tap回调 */
- (void)normalCell:(CXNormalCell *)cell tappedAtIndexPath:(NSIndexPath *)indexPath currentColumn:(int)column;
@end

/** 通用的普通文字cell */
@interface CXNormalCell : UITableViewCell

/**
 *  初始化方法
 *
 *  @param widthRatios     宽度比例数组
 *  @param reuseIdentifier 重用标识符
 *
 *  @return cell对象
 */
- (instancetype)initWithWidthRatios:(NSArray<NSNumber *> *)widthRatios reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  初始化方法
 *
 *  @param widths     宽度数组
 *  @param reuseIdentifier 重用标识符
 *
 *  @return cell对象
 */
- (instancetype)initWithWidths:(NSArray<NSNumber *> *)widths reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  初始化方法
 *
 *  @param widthRatios     宽度比例数组
 *  @param reuseIdentifier 重用标识符
 *
 *  @return cell对象
 */
+ (instancetype)cellWithWidthRatios:(NSArray<NSNumber *> *)widthRatios reuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  初始化方法
 *
 *  @param widthRatios     宽度比例数组
 *  @param reuseIdentifier 重用标识符
 *
 *  @return cell对象
 */
+ (instancetype)cellWithWidths:(NSArray<NSNumber *> *)widths reuseIdentifier:(NSString *)reuseIdentifier;

/** 文本label数组 */
@property(nonatomic, strong) NSMutableArray<CXNormalCellLabel *> *textLabels;

/** 索引 */
@property(nonatomic, strong) NSIndexPath *indexPath;
/** 自定义线条颜色 */
@property(nonatomic, strong) UIColor *lineColor;
/** 扩展字段 */
@property(nonatomic, strong) NSMutableDictionary *ext;
/** 代理 */
@property(nonatomic, weak) id <CXNormalCellDelegate> delegate;
@property(weak, nonatomic, readonly) UITableView *weakTableView;

/** 水平分割线高度（默认为1pt） */
@property (nonatomic, assign) CGFloat hLineHeight;
@end

@interface CXNormalCellLabel : UILabel
/// 当前所在列
@property(assign, nonatomic) int currentColumn;
/** 设置图片 */
@property(nonatomic, strong) UIImage *image;
@end
