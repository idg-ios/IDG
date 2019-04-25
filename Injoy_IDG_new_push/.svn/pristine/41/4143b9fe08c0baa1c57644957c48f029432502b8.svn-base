//
//  SDBackItemView.m
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/7/8.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDBackItemView.h"

@interface SDBackItemView()
{
    UIImageView *_imageView;
    UILabel *_detailInfoLabel;
}

//系列帧图片资源
@property (nonatomic, strong) NSMutableArray *animationArray;

@end

@implementation SDBackItemView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self creatBackItemView];
}

#pragma mark 加载图片资源
-(NSArray *)animationArray
{
    if (_animationArray == nil) {
        _animationArray = [NSMutableArray arrayWithCapacity:3];
        for (int i = 1; i < 4; i ++) {
            UIImage *annimationImage = [UIImage imageNamed:[NSString stringWithFormat:@"manager_recordBeta%d",i]];
            [_animationArray addObject:annimationImage];
            
        }
    }
    
    return _animationArray;
}

#pragma mark 创建视图
-(void)creatBackItemView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.height -10, self.frame.size.height -10)];
    [self addSubview:_imageView];
    
    _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height, 10, self.frame.size.width -self.frame.size.height-10, 20)];
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:_infoLabel];
    
    
    _detailInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_infoLabel.frame.origin.x, CGRectGetMaxY(_infoLabel.frame), _infoLabel.frame.size.width, _infoLabel.frame.size.height)];
    _detailInfoLabel.backgroundColor = [UIColor clearColor];
    _detailInfoLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_detailInfoLabel];
    
    //添加删除按钮
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *deleteImage = [UIImage imageNamed:@"approval_annex_delete"];
    _deleteButton.frame = CGRectMake(self.frame.size.width - 25.f, (self.frame.size.height - deleteImage.size.height * 0.7)/2.f, deleteImage.size.width * 0.7, deleteImage.size.height * 0.7);
    [_deleteButton setImage:deleteImage forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteCurrentItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteButton];
    
}

-(void)setIsOrderFinishTime:(BOOL)isOrderFinishTime
{
    _isOrderFinishTime = isOrderFinishTime;
    [self.deleteButton removeFromSuperview];
}

#pragma mark 删除按钮点击事件
-(void)deleteCurrentItem:(UIButton *)deleteButton
{
    if ([_delegate respondsToSelector:@selector(backItemView:selectCellModel:)]) {
        [_delegate backItemView:self selectCellModel:self.model];
    }
}

#pragma mark model的setter方法
-(void)setModel:(SDSendCellModel *)model
{
    _model = model;
    
    if (_model.modelType == SendCellModelTypeCotacts)
    {
        _infoLabel.text = @"关联联系人:";
        _model.imageString = @"annex_contacts";
    }else if (_model.modelType == SendCellModelTypeCustoms){
        _infoLabel.text = @"关联客户:";
        _model.imageString = @"annex_customs";
    }else if(_model.modelType == SendCellModelTypeLocation){
        _infoLabel.text = @"地理位置:";
        _model.imageString = @"annex_position";
    }else if(_model.modelType == SendCellModelTypeFinishTime){
        _infoLabel.text = @"任务完成时间";
        _model.imageString = @"annex_time";
    }else if(_model.modelType == SendCellModelTypePurseMoney){
        _infoLabel.text = @"采购金额";
        _model.imageString = @"annex_purchase";
    }else if (_model.modelType == SendCellModelTypePurseLeave){
        _infoLabel.text = @"请假单";
        _model.imageString = @"annex_holiday";
    }else if (model.modelType == SendCellModelTypeVoice){
        _infoLabel.text = @"录音时间:";
        _model.imageString = @"manager_recordBeta3";
    }else if (model.modelType == SendCellModelTypeTopicContact){
        _infoLabel.text = @"关联话题:";
        _model.imageString = @"annex_topic";
    }
    
    _imageView.image = [UIImage imageNamed:_model.imageString];
    //录音文件播放系列帧动画
    if (_model.modelType == SendCellModelTypeVoice) {
        _imageView.animationImages = self.animationArray;
        _imageView.animationDuration = 0.5f;
        _imageView.animationRepeatCount = 0;
    }
    
    _detailInfoLabel.text =  [self replaceUnicode:_model.introduce];
}

//开始播放声音动画
-(void)playRecordStartAnimation
{
    [_imageView startAnimating];
}

//结束播放录音动画
-(void)stopRecordPlayAnimation
{
    [_imageView stopAnimating];
}

#pragma mark unicode 转汉字
-(NSString *)replaceUnicode:(NSString *)unicodeStr {
   
    if (!unicodeStr.length) {
        return nil;
    }
    
    NSString *tempStr2 = [unicodeStr stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [ NSPropertyListSerialization  propertyListFromData:tempData
                                                             mutabilityOption:NSPropertyListImmutable
                                                                       format:NULL
                                                             errorDescription:NULL];
    
    
    [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    return  [returnStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

@end
