//
//  CXProjectSearchItemCell.h
//  InjoyIDG
//
//  Created by cheng on 2017/12/18.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXProjectSearchItemCell : UICollectionViewCell

/** 内容 */
@property (nonatomic, copy) NSString *text;
/** 是否选中 */
@property (nonatomic, assign) BOOL checked;

@end
