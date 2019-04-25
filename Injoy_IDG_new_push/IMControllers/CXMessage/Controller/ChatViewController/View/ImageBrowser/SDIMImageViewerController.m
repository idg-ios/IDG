//
//  SDIMImageViewerController.m
//  SDMarketingManagement
//
//  Created by lancely on 5/3/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "SDIMImageViewerController.h"
#import "UIView+Category.h"
#import "VIPhotoView.h"
#import "SDImageCache.h"

@interface SDIMImageViewerController () <UIScrollViewDelegate>

@property (nonatomic, strong) VIPhotoView *photoView;

@end

@implementation SDIMImageViewerController

#pragma mark - initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearTmpPics];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupView];
}

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}

- (void)setupView {
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:self.image andHignIcon:self.hignIcon];
    [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    self.photoView = photoView;
    [self.view addSubview:photoView];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
