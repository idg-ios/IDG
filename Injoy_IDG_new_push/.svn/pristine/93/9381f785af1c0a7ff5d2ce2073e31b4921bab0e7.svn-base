//
//  CXAnnexCell.m
//  SDMarketingManagement
//
//  Created by admin on 16/4/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXAnnexCell.h"

@interface CXAnnexCell()

@property (nonatomic, weak) UIView *lineView;

@end

@implementation CXAnnexCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        NSString *jobRole = VAL_JobRole;
        if ([jobRole isEqualToString:@"normal_user"])
        {
            self.backgroundColor = KSelectedBackgroudColor;
        }
        else if ([jobRole isEqualToString:@"management_layer"] || [jobRole isEqualToString:@"secretary"])
        {
            self.backgroundColor = kMangermentTableColor;
        }
        else if ([jobRole isEqualToString:@"company_manager"])
        {
            self.backgroundColor = kLeaderColor1;
        }
        // 创建视图
        [self setupUI];
    }
    return self;
}

// 创建视图
-(void)setupUI
{
    if (_hiddenTheKey)
    {
        /// 不需要标题
        //审批附件
        self.annexView = [[CXAnnexOneView alloc] init];
        self.annexView.hidden = YES;
        [self.contentView addSubview:self.annexView];
        
        //审批关联信息
        self.approvalContactsView = [[SDContactInfoView alloc] init];
        self.approvalContactsView.hidden = YES;
        [self.contentView addSubview:self.approvalContactsView];
    }
    else
    {
        /// 需要标题
        self.theKey = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 70, 20)];
        //self.theKey.backgroundColor = [UIColor lightGrayColor];
        self.theKey.font = kFontSizeForDetail;
        //self.theKey.textAlignment = NSTextAlignmentRight;
        self.theKey.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.theKey];
        
        // 缩略图视图
        self.annexView = [[CXAnnexOneView alloc] init];
        self.annexView.isMinSizeImage = YES;
        self.annexView.hidden = YES;                                        // 没有数据时隐藏
        //self.annexView.backgroundColor = [UIColor darkGrayColor];
        //[self.annexView.layer setBorderColor:[UIColor redColor].CGColor];
        //[self.annexView.layer setBorderWidth:1];
        [self.contentView addSubview:self.annexView];
        
        //审批关联信息
        self.approvalContactsView = [[SDContactInfoView alloc] init];
        self.approvalContactsView.hidden = YES;
        [self.contentView addSubview:self.approvalContactsView];
    }

    self.theLine = [[UILabel alloc] init];
    self.theLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.theLine];
}

// 重新调整子视图
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.theLine.frame = CGRectMake(5, self.frame.size.height-0.5, Screen_Width-20, 0.5);
}

#pragma mark 缩略图的高度
-(void)setThumbImageViewHeight:(CGFloat)thumbImageViewHeight
{
    _thumbImageViewHeight = thumbImageViewHeight;
    CGFloat selfWidth = self.frame.size.width;
    [self.annexView setFrame:CGRectMake(70, 10, selfWidth - 80, thumbImageViewHeight)];
}
@end
