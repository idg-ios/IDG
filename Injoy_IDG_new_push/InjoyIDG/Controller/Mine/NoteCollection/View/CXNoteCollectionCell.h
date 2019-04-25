//
//  CXNoteCollectionCell.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/25.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXNoteCollectionConst.h"

@interface CXNoteCollectionCell : UITableViewCell

/** 对应行的label */
@property (readonly) NSArray<UILabel *> *labels;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier listType:(CXNoteCollectionListType)listType;

+ (CGFloat)heightOfListType:(CXNoteCollectionListType)listType;

@end
