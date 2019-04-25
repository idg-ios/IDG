//
//  ICEFORCEFileLibraryTableViewCell.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEFORCEFileLibraryModel.h"
NS_ASSUME_NONNULL_BEGIN
@class ICEFORCEFileLibraryTableViewCell;
@protocol ICEFORCELibraryDelegate<NSObject>
- (void)showAlreadyRootCell:(ICEFORCEFileLibraryTableViewCell *)cell selectModel:(ICEFORCEFileLibraryModel *)model selectButton:(UIButton *)sender;
@end

@interface ICEFORCEFileLibraryTableViewCell : UITableViewCell
@property (nonatomic ,strong) ICEFORCEFileLibraryModel *model;
@property (nonatomic ,assign) id <ICEFORCELibraryDelegate>delegateCell;
@end

NS_ASSUME_NONNULL_END
