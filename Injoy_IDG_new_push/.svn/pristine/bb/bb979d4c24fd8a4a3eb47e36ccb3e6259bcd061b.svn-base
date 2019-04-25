//
//  SDShowPicController.m
//  SDMarketingManagement
//
//  Created by fanzhong on 15/4/27.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDShowPicController.h"
#import "SDRootTopView.h"
#import "UIImageView+WebCache.h"
#import "SDDockImageModel.h"

@interface SDShowPicController ()<UIScrollViewDelegate>
{
    NSInteger _imageIndex;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *imageLabel;
@property(nonatomic,strong)NSMutableArray *totalImageArray;
@property(nonatomic,strong)NSMutableArray *totalAssetsArray;
//照相对象和照片数一样的情况，数据从发送页面传过来的值
@property(nonatomic,assign)BOOL isEqualCount;

//删除按钮
@property (nonatomic, weak) UIButton *deleteButton;

@end

@implementation SDShowPicController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.index,(long)self.imageArray.count];
    [self.scrollView setContentOffset:CGPointMake((self.index-1)*Screen_Width, 0)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageIndex = self.index;
    
    self.isEqualCount = NO;
    if (self.imageArray.count == self.assetsArray.count) {
        self.isEqualCount = YES;
    }
    
    [self addTopView];
    [self createUIScrollView];
}

-(NSMutableArray *)totalImageArray
{
    if (!_totalImageArray) {
        _totalImageArray = [NSMutableArray arrayWithArray:self.imageArray];
    }
    
    return _totalImageArray;
}

-(void)setHideDeleteButton:(BOOL)hideDeleteButton
{
    _hideDeleteButton = hideDeleteButton;
    if (hideDeleteButton) {
        self.deleteButton.hidden = YES;
    }
}

#pragma  -- mark 相册图片
-(NSMutableArray *)totalAssetsArray
{
    if (!_totalAssetsArray) {
        _totalAssetsArray = [NSMutableArray arrayWithArray:self.assetsArray];
    }
    
    return _totalAssetsArray;
}

- (void)addTopView
{
    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
    sView.backgroundColor = [UIColor blackColor];
    sView.alpha = 0.7;
    [self.view addSubview:sView];
    
    UIButton *btn=[[UIButton alloc] init];
    btn.frame=CGRectMake(Screen_Width - 50, 22, 40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"Session_Multi_Delete"] forState:UIControlStateNormal];
    [sView addSubview:btn];
    self.deleteButton = btn;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width/2-30, 20, 60, 44)];
    _imageLabel.textAlignment = NSTextAlignmentCenter;
    _imageLabel.textColor = [UIColor whiteColor];
    [sView addSubview:_imageLabel];
}

- (void)btnClick
{
    if (self.totalImageArray.count) {
        [self.totalImageArray removeObjectAtIndex:(_imageIndex-1)];
        
        //删除照相库中的图片
        if (self.isEqualCount) {
            [self.totalAssetsArray removeObjectAtIndex:(_imageIndex-1)];
        }
        
        if (self.totalImageArray.count < _imageIndex) {
            _imageIndex = self.totalImageArray.count;
        }
    }
    
    [self reloadImagesByImageArrayToScrollView];
    
    if (_isTravels) {
        //差旅数据回调
        if ([_delegate respondsToSelector:@selector(removeImageByClickImageModelArray:)]) {
            [_delegate removeImageByClickImageModelArray:self.totalImageArray];
        }
        
    }else{
        //其他页面数据回调
        if ([_delegate respondsToSelector:@selector(removeImageByClickTrashBtn:)]) {
            [_delegate removeImageByClickTrashBtn:self.totalImageArray];
        }
        
        //相片和相册对象一起回调
        if ([_delegate respondsToSelector:@selector(removeImageByClickTrashBtn:assetsArray:)]) {
            [_delegate removeImageByClickTrashBtn:self.totalImageArray assetsArray:self.totalAssetsArray];
        }
        
        if ([_delegate respondsToSelector:@selector(removeImageIndex:)]) {
            if (self.totalImageArray.count) {
                [_delegate removeImageIndex:_imageIndex-1];
            }else{
                [_delegate removeImageIndex:0];
            }
        }
        
    }
    [self updateImageLabel];
}

#pragma mark - 创建滚动视图
-(void)createUIScrollView
{
    //实例化滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    //位置和大小
    self.scrollView.frame = CGRectMake(0,64, Screen_Width, Screen_Height - 64);
    //设置是否开启分页显示
    self.scrollView.pagingEnabled = YES;
    //设置拖拽的弹簧效果
    self.scrollView.bounces =NO;
    
    [self reloadImagesByImageArrayToScrollView];
    //设置委托
    self.scrollView.delegate = self;
    //添加到父视图上
    [self.view addSubview:self.scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backto)];
    [self.scrollView addGestureRecognizer:tap];
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark 滚动视图加载图片
-(void)reloadImagesByImageArrayToScrollView
{
    //清空子视图
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    //载入图片
    for(int i = 0 ; i < self.totalImageArray.count ; i++)
    {
        UIImageView *imgView = nil;
        
        //UIImageView显示图片
        if (_isTravels) {
            //从差旅单中加载图片
            SDDockImageModel *imageModel = self.totalImageArray[i];
            imgView = [[UIImageView alloc] initWithImage:imageModel.selectImage];
        }else if (self.isFromDetail){
            [imgView setImageWithURL:[NSURL URLWithString:self.totalImageArray[i]]];
        }else{
          imgView = [[UIImageView alloc] initWithImage:self.totalImageArray[i]];
        }
        
        //设置每一个imgView的frame
        imgView.frame = CGRectMake(Screen_Width*i , 0, Screen_Width, self.scrollView.frame.size.height);
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        imgView.userInteractionEnabled = YES;
        imgView.backgroundColor = [UIColor blackColor];
        //把imgView添加到scrollView上
        [self.scrollView addSubview:imgView];
    }
    
    //设置滚动视图的滚动范围
    self.scrollView.contentSize =CGSizeMake(Screen_Width*self.totalImageArray.count, 0);
 
}

#pragma mark - 使用委托方法更新页码
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _imageIndex = self.scrollView.contentOffset.x/Screen_Width +1;
    [self updateImageLabel];
}

#pragma  mark 更新顶部的label显示
-(void)updateImageLabel
{
    if (!self.totalImageArray.count) {
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    self.imageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_imageIndex,(long)self.totalImageArray.count];
}

#pragma mark - 手势事件
- (void)backto
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
