//
//  SDDetailInfoViewController.m
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/7/1.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDDetailInfoViewController.h"
#import "UIImageView+EMWebCache.h"
#import "XQPhotoView.h"
#import "NSString+TextHelper.h"
#import "IBActionSheet.h"

#define kFilePath [NSString stringWithFormat:@"%@/Documents/Annex", NSHomeDirectory()]
@interface SDDetailInfoViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate,IBActionSheetDelegate> {
    UIPageControl* _pageControl;
    NSMutableArray* _phontoViewArray;
    UIImageView *_sentImg;
}

@property (nonatomic, strong) IBActionSheet* standardIBAS;

@end

@implementation SDDetailInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //    [self setUpNavigationBar];
    self.view.backgroundColor = [UIColor blackColor];
    _phontoViewArray = [NSMutableArray arrayWithCapacity:_annexArray.count];

    //创建滚动视图
    [self creatScrollView];

    //创建页面控制器
    [self creatPageControl];
}

//-(void)setUpNavigationBar
//{
//    SDRootTopView *rootTopView  = [self getRootTopView];
//    [rootTopView setNavTitle:@"附件预览"];
//
//    /// 返回按钮
//    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage* backImage = [UIImage imageNamed:@"back.png"];
//    [backBtn setImage:backImage forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UseAutoLayout(backBtn);
//    [rootTopView addSubview:backBtn];
//
//    NSDictionary* leftVal = @{ @"wd" : [NSNumber numberWithFloat:backImage.size.width],
//                               @"ht" : [NSNumber numberWithFloat:backImage.size.height] };
//    // backBtn宽度
//    [rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backBtn(wd)]" options:0 metrics:leftVal views:NSDictionaryOfVariableBindings(backBtn)]];
//    // backBtn高度
//    [rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backBtn(ht)]-5-|" options:0 metrics:leftVal views:NSDictionaryOfVariableBindings(backBtn)]];
//}

//#pragma mark 返回上一控制器
//-(void)leftBtnClick:(UIButton *)button
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark 创建滚动视图
- (void)creatScrollView
{
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.tag = 100;
    scrollView.pagingEnabled = YES;

    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * _annexArray.count, scrollView.frame.size.height)];
    [self.view addSubview:scrollView];

    for (NSInteger i = 0; i < _annexArray.count; i++) {

        NSString* urlString = [NSString stringWithFormat:@"%@", _annexArray[i][@"path"]];
        NSString *name = _annexArray[i][@"srcName"];
        if ([NSString containWithSelectedStr:urlString contain:@"http"]) {
            XQPhotoView* phontoView = nil;
            phontoView = [XQPhotoView photoViewWithFrame:CGRectMake(Screen_Width * i, 0, Screen_Width, Screen_Height) atImageUrlString:urlString imageName:name];

            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backPrevInterface)];
            UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
            longTap.delegate = self;
            tapGesture.delegate = self;
            [phontoView addGestureRecognizer:tapGesture];
            [phontoView addGestureRecognizer:longTap];
            [_phontoViewArray addObject:phontoView];

            [scrollView addSubview:phontoView];
        }
        else {
//            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width * i, 0, Screen_Width, Screen_Height)];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImagePrefix, urlString]] placeholderImage:[UIImage imageNamed:@"loading"] options:EMSDWebImageRetryFailed];
//            imageView.userInteractionEnabled = YES;
//            [scrollView addSubview:imageView];
//
//            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backPrevInterface)];
//            tapGesture.delegate = self;
//            [imageView addGestureRecognizer:tapGesture];
//            [_phontoViewArray addObject:imageView];
            
            XQPhotoView* phontoView = nil;
            phontoView = [XQPhotoView photoViewWithFrame:CGRectMake(Screen_Width * i, 0, Screen_Width, Screen_Height) atImageUrlString:[NSString stringWithFormat:@"%@%@", kImagePrefix, urlString] imageName:name];
            
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backPrevInterface)];
            UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
            longTap.delegate = self;
            tapGesture.delegate = self;
            [phontoView addGestureRecognizer:tapGesture];
            [phontoView addGestureRecognizer:longTap];
            [_phontoViewArray addObject:phontoView];
            
            [scrollView addSubview:phontoView];
        }

        [scrollView setContentOffset:CGPointMake(_index * Screen_Width, 0)];
    }
}

-(void)imglongTapClick:(UILongPressGestureRecognizer *)gesture

{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
        
    {
        self.standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存图片" otherButtonTitles:@"保存图片到手机", nil];
        [self.standardIBAS setFont:[UIFont systemFontOfSize:17.f]];
        [self.standardIBAS setButtonTextColor:[UIColor blackColor]];
        [self.standardIBAS setButtonBackgroundColor:[UIColor redColor] forButtonAtIndex:2];
        [self.standardIBAS setButtonTextColor:[UIColor lightGrayColor] forButtonAtIndex:0];
        [self.standardIBAS showInView:[UIApplication sharedApplication].keyWindow];
        XQPhotoView *scrollViewImg = (XQPhotoView *)[gesture view];
        _sentImg = scrollViewImg.imageView;
        
    }
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(IBActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        UIImageWriteToSavedPhotosAlbum(_sentImg.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    
    NSString *message = @"保存失败";
    
    if (!error) {
        
        message = @"成功保存到相册";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        
        
    }else
        
    {
        
        message = [error description];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }
    
}


#pragma mark 返回上一个界面
- (void)backPrevInterface
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 创建页面控制器
- (void)creatPageControl
{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.numberOfPages = _annexArray.count;
    CGSize pageControlSize = [_pageControl sizeForNumberOfPages:_annexArray.count];
    [_pageControl setFrame:CGRectMake(0, 0, pageControlSize.width, pageControlSize.height)];
    _pageControl.currentPage = _index;
    _pageControl.center = CGPointMake(Screen_Width / 2.0, Screen_Height - 35.f);
    [self.view addSubview:_pageControl];

    //添加监听事件
    [_pageControl addTarget:self action:@selector(dealPageControl) forControlEvents:UIControlEventValueChanged];
}

#pragma mark 滚动视图代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    CGPoint offSet = scrollView.contentOffset;
    NSUInteger currentPage = offSet.x / scrollView.frame.size.width;
    _pageControl.currentPage = currentPage;

    for (id photoView in _phontoViewArray) {

        if ([photoView isKindOfClass:[XQPhotoView class]]) {
            XQPhotoView* xqPhotoView = (XQPhotoView*)photoView;
            xqPhotoView.zoomScale = 1;
        }
        else {
            return;
        }
    }
}

#pragma mark 处理页面控制器
- (void)dealPageControl
{
    NSUInteger index = _pageControl.currentPage;
    UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:100];

    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * index, 0);
}
@end
