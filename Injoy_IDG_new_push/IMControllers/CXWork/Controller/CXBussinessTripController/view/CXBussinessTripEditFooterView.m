//
//  CXBussinessTripEditFooterView.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/17.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXBussinessTripEditFooterView.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "NSDate+YYAdd.h"
#define margin 5.0f
#define arrowImagWidth  20.f
@interface CXBussinessTripEditFooterView()
@property(nonatomic, strong)CXEditLabel *startTimeLabel;
@property(nonatomic, strong)CXEditLabel *endTimeLabel;
@property(nonatomic, strong)CXEditLabel *preMoneyLabel;
@property(nonatomic, strong)CXEditLabel *remarkLabel;
@property(nonatomic, strong)CXEditLabel *reasonLabel;
@property(nonatomic, strong)UILabel *unitLabel;
@end
@implementation CXBussinessTripEditFooterView
- (id)initWithFrame:(CGRect)frame dataModel:(CXBusinessTripEditDataManager *)dataManager andType:(VCType)type approvalStatue:(NSUInteger )approvalStatue{
    if(self = [super initWithFrame:frame]){
        self.dataManager = dataManager;
        self.type = type;
        self.approvalStatue = approvalStatue;
        [self addSubview:self.startTimeLabel];
        UIImageView *startTimeImage = [self arrowImage];
        startTimeImage.frame = CGRectMake(self.startTimeLabel.right, self.startTimeLabel.top, arrowImagWidth, kCellHeight);
        [self addSubview:startTimeImage];
        UIView *line1 = [self createLineView];
        line1.frame = CGRectMake(0, self.startTimeLabel.bottom, Screen_Width, 1.0);
        [self addSubview:line1];
        [self addSubview:self.endTimeLabel];
        UIImageView *endTimeImage = [self arrowImage];
        endTimeImage.frame = CGRectMake(self.endTimeLabel.right, self.endTimeLabel.top, arrowImagWidth, kCellHeight);
        [self addSubview:endTimeImage];
        UIView *line2 = [self createLineView];
        line2.frame = CGRectMake(0, self.endTimeLabel.bottom, Screen_Width, 1.0);
        [self addSubview:line2];
        [self addSubview:self.preMoneyLabel];
        [self addSubview:self.unitLabel];
        if (type == 0) {//新建
            
        } else {
            /*
            UIView *line4 = [self createLineView];
            NSLog(@"备注=====%@",self.remarkLabel.content);
            line4.frame = CGRectMake(0, self.remarkLabel.frame.origin.y + self.remarkLabel.frame.size.height, Screen_Width, 1.0);
            [self addSubview:line4];
            NSLog(@"底部=====%f",line4.bottom);
            [self addSubview:self.reasonLabel];//审批理由
             */
        }
             
//        [self addSubview:self.reasonLabel];//审批理由
        UIView *line3 = [self createLineView];
        line3.frame = CGRectMake(0, self.preMoneyLabel.bottom, Screen_Width, 1.0);
        [self addSubview:line3];
        [self addSubview:self.remarkLabel];
        
        if(type != isCreate){
            startTimeImage.hidden = YES;
            endTimeImage.hidden = YES;
            self.startTimeLabel.placeholder = @"";
            self.startTimeLabel.content = dataManager.model.startDate?:@"";
            self.startTimeLabel.allowEditing = NO;
            self.endTimeLabel.placeholder = @"";
            self.endTimeLabel.content = dataManager.model.endDate?:@"";
            self.endTimeLabel.allowEditing = NO;
            self.preMoneyLabel.placeholder = @"";
            self.preMoneyLabel.content = dataManager.model.budget?:@"";
            self.preMoneyLabel.allowEditing = NO;
            self.remarkLabel.placeholder = @"";
            self.remarkLabel.content = dataManager.model.remark?:@"";
            self.remarkLabel.allowEditing = NO;
            //
//            UIView *line4 = [self createLineView];
//            NSLog(@"备注=====%@",self.remarkLabel.content);
//            line4.frame = CGRectMake(0, self.remarkLabel.frame.origin.y + self.remarkLabel.frame.size.height, Screen_Width, 1.0);
//            [self addSubview:line4];
//            NSLog(@"底部=====%f",line4.bottom);
            if (self.approvalStatue == 3) {//驳回
                UIView *line4 = [self createLineView];
                NSLog(@"备注=====%@",self.remarkLabel.content);
                
                NSString* str = [NSString stringWithFormat:@"备        注：%@",self.remarkLabel.content];
                const float kFontSize = 16.f;
                NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                CGRect rect = [str boundingRectWithSize:CGSizeMake(Screen_Width - 30,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]} context:nil];
                CGFloat realHeight = ceilf(rect.size.height) + 10;
                self.remarkLabel.height = realHeight < kCellHeight ? kCellHeight: realHeight;
                line4.frame = CGRectMake(0, self.remarkLabel.bottom + 1, Screen_Width, 1.0);
                [self addSubview:line4];
                [self addSubview:self.reasonLabel];//审批理由,不需要了
            }
            
            self.reasonLabel.frame = CGRectMake(margin, self.remarkLabel.bottom + 1, Screen_Width, self.reasonLabel.bottom - self.remarkLabel.bottom);
        }
        
        self.height = self.remarkLabel.bottom - self.startTimeLabel.top;
    }
    return self;
}
#pragma mark - 响应方法
- (void)updateFrameWithHeight:(CGFloat)height{
    self.remarkLabel.height = height;
    self.height = self.remarkLabel.bottom - self.startTimeLabel.top;
    if(self.updateFrame){
        self.updateFrame();
    }
}
- (UIView *)createLineView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColorWithRGB(242, 242, 242);
    return line;
}
- (UIImageView *)arrowImage {
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrow.contentMode = UIViewContentModeCenter;
    return arrow;
}
- (bool)checkData{
    if(!trim(self.startTimeLabel.content).length){
        CXAlert(@"请选择出发日期");
        return false;
    }else if (!trim(self.endTimeLabel.content).length){
        CXAlert(@"请选择结束日期");
        return false;
    }
    NSTimeInterval startTimeInterval = [[NSDate dateWithString:self.startTimeLabel.content format:@"yyyy-MM-dd"] timeIntervalSinceNow];
    
    NSTimeInterval endTimeInterval = [[NSDate dateWithString:self.endTimeLabel.content format:@"yyyy-MM-dd"] timeIntervalSinceNow];
    
    if (startTimeInterval > endTimeInterval + 1.f) {
        MAKE_TOAST_V(@"出发日期不能大于结束日期");
        return false;
    } if (!trim(self.remarkLabel.content).length){
        CXAlert(@"请填写备注");
        return false;
    }

    self.dataManager.model.startDate = self.startTimeLabel.content;
    self.dataManager.model.endDate = self.endTimeLabel.content;
    self.dataManager.model.budget = self.preMoneyLabel.content?:@"";
    self.dataManager.model.remark = self.remarkLabel.content;
 
    self.dataManager.model.approveReason = self.reasonLabel.content;//审批意见
   
    return true;
}
#pragma mark - 数据懒加载
- (CXEditLabel *)startTimeLabel{
    if(nil == _startTimeLabel){
        _startTimeLabel = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, 0, Screen_Width-2*margin-arrowImagWidth, kCellHeight)];
        _startTimeLabel.title = @"出发日期：";
        _startTimeLabel.placeholder = @"请选择出发日期";
        _startTimeLabel.inputType = CXEditLabelInputTypeDate;
    }
    return _startTimeLabel;
}
- (CXEditLabel *)endTimeLabel{
    if(nil == _endTimeLabel){
        _endTimeLabel = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, self.startTimeLabel.bottom+1, Screen_Width-2*margin-arrowImagWidth, kCellHeight)];
        _endTimeLabel.title = @"结束日期：";
        _endTimeLabel.placeholder = @"请选择结束日期";
        _endTimeLabel.inputType = CXEditLabelInputTypeDate;
    }
    return _endTimeLabel;
}
- (CXEditLabel *)preMoneyLabel{
    if(nil == _preMoneyLabel){
        _preMoneyLabel = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, self.endTimeLabel.bottom+1, Screen_Width-3*margin - self.unitLabel.width, kCellHeight)];
        _preMoneyLabel.title = @"预计费用：";
        _preMoneyLabel.placeholder = @"请输入预计费用";
        _preMoneyLabel.inputType = CXEditLabelInputTypeNumber;
    }
    return _preMoneyLabel;
}
- (CXEditLabel *)remarkLabel{
    if(nil == _remarkLabel){
        _remarkLabel = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, self.preMoneyLabel.bottom+1, Screen_Width-2*margin, kCellHeight)];
        _remarkLabel.title = @"备        注：";
        _remarkLabel.placeholder = @"请输入出差事由";
        _remarkLabel.allowEditing = YES;
        _remarkLabel.numberOfLines = 0;
//        _remarkLabel.fitSize = YES;
        _remarkLabel.scale = YES;
//        CXWeakSelf(self)
//        _remarkLabel.needUpdateFrameBlock = ^(CXEditLabel *editLabel, CGFloat height){
//            [weakself updateFrameWithHeight:height];
//        };
        NSLog(@"底部====%f",_remarkLabel.bottom);
    }
    return _remarkLabel;
}
- (CXEditLabel *)reasonLabel{
    if(nil == _reasonLabel){
        _reasonLabel = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, self.remarkLabel.bottom+1, Screen_Width-2*margin, kCellHeight)];
        _reasonLabel.title = @"审批意见：";
        _reasonLabel.content = self.dataManager.model.approveReason;
//        _reasonLabel.placeholder = @"请输入审批意见";
    }
    return _reasonLabel;
}
- (UILabel *)unitLabel{
    if(nil == _unitLabel){
        _unitLabel = [[UILabel alloc]init];
        _unitLabel.text  =@"元";
        _unitLabel.font = kFontSizeForDetail;
        [_unitLabel sizeToFit];
        _unitLabel.frame = CGRectMake(Screen_Width - _unitLabel.frame.size.width - 2*margin, self.endTimeLabel.bottom+1, _unitLabel.frame.size.width, kCellHeight);
    }
    return _unitLabel;
}
@end
