//
//  CXSearchTableView.h
//  InjoyIDG
//
//  Created by ^ on 2018/6/4.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXSearchTableView;
@protocol CXSearchTableViewDelegate<NSObject>
-(void)CXSearchTableView:(CXSearchTableView *)tableView text:(NSString *)text andPageNumber:(NSInteger)pageNumber block:(void (^)(NSArray *))block;
@end
@interface CXSearchTableView : UIView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^searchInputEnd)(NSString *text);
@property (nonatomic, copy) void(^searchInputCancel)();
@property (nonatomic, copy) void(^pagePlus)();
@property (nonatomic, weak) id <CXSearchTableViewDelegate>delegate;
- (void)show;
- (void)hide;
@end
