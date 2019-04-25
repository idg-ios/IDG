//
//  CXProjectCollaborationImageViewController.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/11/2.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXProjectCollaborationImageViewController.h"
#import "UIView+Category.h"
#import "VIPhotoView.h"

@interface CXProjectCollaborationImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) VIPhotoView *photoView;

@end

@implementation CXProjectCollaborationImageViewController

#pragma mark - initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupView];
}

- (void)setupView {
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:self.image andHignIcon:nil];
    [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    self.photoView = photoView;
    [self.view addSubview:photoView];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.viewController){
        [self.viewController getMessageModelArrayTimer];
    }
    self.viewController = nil;
}

@end
