//
//  SDAnnexView.m
//  SDMarketingManagement
//
//  Created by admin on 16/4/28.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXAnnexOneView.h"

@interface CXAnnexOneView() <SDShowPicControllerDegate>
{
    CGFloat selfWidth;
    CGFloat imageWH;
}

//标题
@property (nonatomic, weak) UILabel *annexLabel;
//图片
@property (nonatomic, weak) UIImageView *iconImageView;

@end

@implementation CXAnnexOneView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 初始化缩略图视图
        self.thumbView = [[UIView alloc] init];
    }
    return self;
}

// 缩略图setframe
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    if (frame.size.height > 0)
    {
        selfWidth = frame.size.width;
        if (_isMinSizeImage) {
            imageWH = (selfWidth - 5*5)/4;
        } else {
            imageWH = 60;
        }
        
        [self.thumbView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        NSLog(@"%f,%f",frame.size.width,frame.size.height);
        
        [self addSubview:self.thumbView];
    }
}

// setter图片数组
-(void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    for (UIView *subView in self.thumbView.subviews) {
        [subView removeFromSuperview];
    }
    
    //显示缩略图
    int index = 0;
    CGFloat spaceHorize = (selfWidth - 4*imageWH) / 5;
    
    for (UIImage *image in imageArray) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                        spaceHorize+(spaceHorize+imageWH)*(index%4),
                                                        index/4*(imageWH+5.f),
                                                        imageWH,
                                                        imageWH)];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        imageView.tag = 100 + index;
        [imageView addGestureRecognizer:tap];
        [self.thumbView addSubview:imageView];
        imageView.image = image;
        
        index ++;
    }
}

// imagTap点击照片的操作
- (void)tapImageView:(UITapGestureRecognizer*)tap
{
    SDShowPicController* showPic = [[SDShowPicController alloc] init];
    if (_imageArray.count) {
        NSMutableArray* imageArray = [NSMutableArray arrayWithArray:_imageArray];
        showPic.imageArray = imageArray;
        showPic.index = tap.view.tag - 100 + 1;
        showPic.delegate = self;
        [self.window.rootViewController presentViewController:showPic animated:YES completion:nil];
    }
}

#pragma mark  实现删除照片和相册对象的回调代理
-(void)removeImageIndex:(NSInteger)deleteIndex
{
    if ([_delegate respondsToSelector:@selector(removeImageIndex:)]) {
        [_delegate removeImageIndex:deleteIndex];
    }
}

@end
