//
//  CXListTableViewCell.h
//  InjoyDDXWBG
//
//  Created by ^ on 2017/10/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXListTableViewCell : UITableViewCell
/**< 左上角文本 */
@property(strong, nonatomic) UILabel *leftTopLabel;
/**< 左下角文本 */
@property(strong, nonatomic) UILabel *leftBottomLabel;
/**< 右上角文本 */
@property(strong, nonatomic) UILabel *rightTopLabel;
/**< 右下角文本 */
@property(strong, nonatomic) UILabel *rightBottomLabel;
@end
