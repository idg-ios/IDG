//
//  CXBussinessTripListCellFrame.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/18.
//  Copyright © 2018年 Injoy. All rights reserved.
//
#define margin 10.f
#define hmargin 8.f
#define cellWidth (Screen_Width-margin-(titleLabel.frame.size.width))
#import "CXBussinessTripListCellFrame.h"

@implementation CXBussinessTripListCellFrame
- (void)setDataModel:(CXBussinessTripListModel *)dataModel{
    _dataModel = dataModel;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    UILabel *testLabel = [[UILabel alloc]init];
    testLabel.numberOfLines = 0;

    
    CGFloat namLabelWidth = cellWidth - 80;
    testLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@的出差",dataModel.realName] andFont:kFontSizeForDetail];
//    CGSize nameLabelSize = [self sizeWithString:[NSString stringWithFormat:@"%@的出差",dataModel.apply] font:kFontSizeForDetail maxSize:CGSizeMake(namLabelWidth, MAXFLOAT)];
    CGSize nameLabelSize = [self sizeWithLabel:testLabel andMaxSize:CGSizeMake(namLabelWidth, MAXFLOAT)];
    self.nameLabelF = CGRectMake(margin, margin, namLabelWidth, nameLabelSize.height);
    
    self.approvalLabelF = CGRectMake(namLabelWidth+margin*2, margin, 80-margin, nameLabelSize.height);
    
    titleLabel.text = @"申请日期：";
    titleLabel.font = kFontTimeSizeForForm;
    [titleLabel sizeToFit];
    testLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@",dataModel.applyDate] andFont:kFontTimeSizeForForm];
    CGSize approvalDateSize = [self sizeWithLabel:testLabel andMaxSize:CGSizeMake(cellWidth,MAXFLOAT)];//[self sizeWithString:[NSString stringWithFormat:@"申请日期：%@",dataModel.applyDate] font:kFontTimeSizeForForm maxSize:CGSizeMake(cellWidth,MAXFLOAT)];
    self.approvalDateLabelF = CGRectMake(margin+titleLabel.frame.size.width, CGRectGetMaxY(self.nameLabelF), cellWidth, approvalDateSize.height);
    
    titleLabel.text = @"出差预算金额(元)：";
    [titleLabel sizeToFit];
    testLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@",dataModel.budget.stringValue] andFont:kFontTimeSizeForForm];
    CGSize preMoneySize = [self sizeWithLabel:testLabel andMaxSize:CGSizeMake(cellWidth, MAXFLOAT)];//[self sizeWithString:[NSString stringWithFormat:@"出差预算金额(元)：%@",dataModel.budget.stringValue] font:kFontTimeSizeForForm maxSize:CGSizeMake(cellWidth, MAXFLOAT)];
    self.preMoneyLabelF = CGRectMake(margin+titleLabel.frame.size.width, CGRectGetMaxY(self.approvalDateLabelF)+hmargin, cellWidth, preMoneySize.height);
    
    titleLabel.text = @"出差城市：";
    [titleLabel sizeToFit];
    testLabel.attributedText = [self setString:[NSString stringWithFormat:@"%@", dataModel.cityName] andFont:kFontTimeSizeForForm];
    CGSize citySize = [self sizeWithLabel:testLabel andMaxSize:CGSizeMake(cellWidth, MAXFLOAT)];//[self sizeWithString:[NSString stringWithFormat:@"出差城市：%@", dataModel.city] font:kFontTimeSizeForForm maxSize:CGSizeMake(cellWidth, MAXFLOAT)];
    self.cityLabelF = CGRectMake(margin+titleLabel.frame.size.width, CGRectGetMaxY(self.preMoneyLabelF)+hmargin, cellWidth, citySize.height);
    
    titleLabel.text = @"出差事由：";
    [titleLabel sizeToFit];
    //处理空格和换行引起的样式问题
    NSString *remark = [dataModel.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"备注===%@===%@",dataModel.remark,remark);
    testLabel.attributedText = [self setString:remark andFont:kFontTimeSizeForForm];
    //计算文本的size
    CGSize reasonSize = [self sizeWithLabel:testLabel andMaxSize:CGSizeMake(cellWidth, MAXFLOAT)];//[self sizeWithString:[NSString stringWithFormat:@"出差事由：%@", dataModel.remark] font:kFontTimeSizeForForm maxSize:CGSizeMake(cellWidth, MAXFLOAT)];
    self.reasonLabelF = CGRectMake(margin+titleLabel.frame.size.width, CGRectGetMaxY(self.cityLabelF) + hmargin, cellWidth, reasonSize.height);
    
    self.lineF = CGRectMake(0, CGRectGetMaxY(self.reasonLabelF)+margin, Screen_Width, 1.0f);
    self.cellHeight = CGRectGetMaxY(self.lineF);
    
    
}
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
- (CGSize)sizeWithLabel:(UILabel *)label andMaxSize:(CGSize)maxSize{
    CGSize size = [label sizeThatFits:maxSize];
    return size;
}
- (NSMutableAttributedString *)setString:(NSString *)str andFont:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *dic = @{NSFontAttributeName:font};
    
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc]initWithString:str attributes:dic];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    return setString;
}
@end
