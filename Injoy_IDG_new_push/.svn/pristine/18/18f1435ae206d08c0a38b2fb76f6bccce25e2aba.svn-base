//
//  CXNoteCollectionCell.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/25.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNoteCollectionCell.h"
#import "Masonry.h"

/** 2行的高度 */
#define kCXNoteCollectionCellHeight2 60
/** 3行的高度 */
#define kCXNoteCollectionCellHeight3 85

@implementation CXNoteCollectionCell {
    CXNoteCollectionListType _listType;
    NSMutableArray<UILabel *> *_labels;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier listType:(CXNoteCollectionListType)listType {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _listType = listType;
        [self setup];
    }
    return self;
}

- (void)setup {
    NSUInteger rowNumber;
    // 【证件号码】和【其他】 只有2行
    if (_listType == CXNoteCollectionListTypeIdNumber || _listType == CXNoteCollectionListTypeOther) {
        rowNumber = 2;
    }
    else {
        rowNumber = 3;
    }
    
    _labels = @[].mutableCopy;
    for (NSInteger i = 0; i < rowNumber; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(45, 45, 45);
        [_labels addObject:label];
        [self.contentView addSubview:label];
    }
    
    // 间距
    CGFloat rowMargin = 2;
    
    if (rowNumber == 2) {
        [_labels[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-rowMargin);
        }];
        [_labels[1] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labels[0]);
            make.top.equalTo(self.contentView.mas_centerY).offset(rowMargin);
        }];
    }
    else if (rowNumber == 3) {
        [_labels[1] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.centerY.equalTo(self.contentView);
        }];
        [_labels[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labels[1]);
            make.bottom.equalTo(_labels[1].mas_top).offset(-rowMargin);
        }];
        
        [_labels[2] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_labels[1]);
            make.top.equalTo(_labels[1].mas_bottom).offset(rowMargin);
        }];
    }
}

+ (CGFloat)heightOfListType:(CXNoteCollectionListType)listType {
    if (listType == CXNoteCollectionListTypeIdNumber || listType == CXNoteCollectionListTypeOther) {
        return kCXNoteCollectionCellHeight2;
    }
    else {
        return kCXNoteCollectionCellHeight3;
    }
}

@end
