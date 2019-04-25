//
//  CXFormLabel.m
//  SDMarketingManagement
//
//  Created by huashao on 16/4/12.
//  Copyright © 2016年 slovelys. All rights reserved.
//  表单的标签


#import "CXFormLabel.h"
#import "SDAppearMap.h"
#import "NSString+TextHelper.h"

@interface CXFormLabel()

@end

@implementation CXFormLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.numberOfLines = 0;
        self.font = kFontSizeForForm;
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentLeft;
        self.backgroundColor = [UIColor clearColor];
        
        //添加一个点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

-(void)setTitile:(NSString *)titile
{
    _titile = titile;
    //打开此行出现*号
//    if (self.isRequired) {
//        _titile = [NSString stringWithFormat:@"*%@",titile];
//    }
    self.attributedText = [self attributedWithTitle:_titile content:_content];
//    NSString *string = [NSString stringWithFormat:@"%@",_titile];
//    self.attributedText = [[NSAttributedString alloc] initWithString:string];
}

-(void)setContent:(NSString *)content
{
    _content = content;
    //如果内容属于申请人名，并且需要显示位置，只显示4个字
    if ([self containSpecialCharacterSet:@[@"审",@"抄",@"阅"] isPosition:self.isPotionView])
    {
        _content = [NSString stringWithFormat:@"%@...",[content substringToIndex:4]];
    }
    
    self.attributedText = [self attributedWithTitle:_titile content:_content];
    
    if (!_titile.length && !_content.length) {
        return;
    }
    
    CGFloat height =[self heightForInputContent:[NSString stringWithFormat:@"%@%@",_titile,_content]];
    if (height > kLineHeight)
    {
        
        //重新设置frame的高度
        CGRect frame = self.frame;
        frame.size.height = [self heightForInputContent:[NSString stringWithFormat:@"%@%@",_titile,_content]];
        self.frame = frame;
    }else
    {
//        NSString *string;
//        if (_content.length) {
//            string = [NSString stringWithFormat:@"%@%@",_titile,_content];
//        }else
//        {
//          string = [NSString stringWithFormat:@"%@",_titile];
//        }
//        self.attributedText = [[NSAttributedString alloc] initWithString:string];
    }
    
}

#pragma mark -- 审批人，送阅人，抄送，统一截取前面四个字后加三个点
-(BOOL)containSpecialCharacterSet:(NSArray *)strArray isPosition:(BOOL)isPosition
{
    if (_content.length > 4) {
        for (NSString *string in strArray) {
            if ([NSString containWithSelectedStr:_titile contain:string]){
                return YES;
            }
        }
        
        if (isPosition) {
            return YES;
        }
    }
    
    return NO;
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    if (_placeHolder.length && _titile.length) {
       self.attributedText = [self labelTitle:_titile placeHolder:placeHolder];
    }
}

#pragma mark -- placeHolder
-(NSAttributedString *)labelTitle:(NSString *)title placeHolder:(NSString *)placeHolder
{
    NSString *content = [NSString stringWithFormat:@"%@%@",title,placeHolder];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    [mutableAttributedString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeValueForForm]} range:NSMakeRange(0, title.length)];
    [mutableAttributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f],NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(title.length, placeHolder.length)];
    
    return mutableAttributedString;
}

#pragma mark -- 计算输入内容的高度
-(CGFloat)heightForInputContent:(NSString *)text
{
    return 0;
    return [text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFontSizeForForm} context:nil].size.height;
}

#pragma mark -- 富文本
-(NSAttributedString *)attributedWithTitle:(NSString *)title content:(NSString *)content
{
    if (!title.length && !content.length) {
        return nil;
    }
    
    NSString *string = title;
    if (content.length) {
        string = [NSString stringWithFormat:@"%@%@",title,content];
    }else{
        if (_placeHolder.length) {
            return [self labelTitle:title placeHolder:_placeHolder];
        }
    }
    
    NSMutableAttributedString *mutableAttribetedString = [[NSMutableAttributedString alloc] initWithString:string];
    [mutableAttribetedString setAttributes:@{NSFontAttributeName:kFontSizeForDetail} range:NSMakeRange(0, title.length)];
    
    if ([NSString containWithSelectedStr:title contain:@"*"])
    {
         [mutableAttribetedString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
    }
    
    return mutableAttribetedString;
}

#pragma mark -- 弹出位置视图
-(void)setIsPotionView:(BOOL)isPotionView
{
    _isPotionView = isPotionView;
    if (isPotionView) {
        
        //添加一个地图图标
        UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 13.f - 8.f, 15.5f, 13.f, 13.f)];
        mapImageView.image = [UIImage imageNamed:@"location"];
        mapImageView.userInteractionEnabled = YES;
        [self addSubview:mapImageView];
    }
}

#pragma mark -- 点击显示地图小图标，显示申请人位置
-(void)showApplyLocation
{
    //地图定位功能
    SDAppearMap* appearMap = [[SDAppearMap alloc] init];
    appearMap.location = self.location;
    [self.getNavgationController pushViewController:appearMap animated:YES];
    if ([self.getNavgationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.getNavgationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark --  bai
-(void)changeContentFont:(CGFloat)contentSize
{
    if (!self.content.length) {
        return;
    }
    NSMutableAttributedString *mutableAttribute = [[NSMutableAttributedString alloc] initWithString:self.text];
    [mutableAttribute setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} range:NSMakeRange(self.titile.length, self.text.length - self.titile.length)];
    self.attributedText = mutableAttribute;
}

#pragma mark -- 获取导航控制器
-(UINavigationController *)getNavgationController
{
    for (UIView *view = self; view; view = view.superview) {
        if ([view.nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)view.nextResponder;
        }
    }
    
    return nil;
}

#pragma mark -- labe按钮点击事件
-(void)tapAction
{
    if (self.location.length) {
        
        if ([[self.location componentsSeparatedByString:@","] count] != 3) {
            return;
        }
        //显示申请人位置
        [self showApplyLocation];
    }else{
        if ([self.formLabelDelegate respondsToSelector:@selector(formLabel:keyboardType:)]) {
            [self.formLabelDelegate formLabel:self keyboardType:self.keyboardType];
        }
    }
}

#pragma mark - 清空内容
- (void)clean
{
    self.content = nil;
}
@end
