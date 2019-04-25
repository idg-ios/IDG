//
//  SingaporeTabBarViewController.m
//  injoy_XJPDC
//
//  Created by 念念不忘必有回响 on 2018/8/28.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "SingaporeTabBarViewController.h"
#import "SingaporeNavViewController.h"

#import "ICEFORCEWorkViewController.h"
#import "ICEFORCEProjectViewController.h"
#import "ICEFORCEEventViewController.h"
#import "ICEFORCEFileLibraryViewController.h"
#import "ICEFORCEMySelfViewController.h"
@interface SingaporeTabBarViewController ()

@end

@implementation SingaporeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ICEFORCEWorkViewController *work = [[ICEFORCEWorkViewController alloc]init];
    [self addChildVc:work title:@"工作台" imageName:@"tab_work" selectedImage:@"tab_work"];
    
    ICEFORCEProjectViewController *poject = [[ICEFORCEProjectViewController alloc]init];
    [self addChildVc:poject title:@"工作圈" imageName:@"tab_work" selectedImage:@"tab_work"];
    
    ICEFORCEEventViewController *event = [[ICEFORCEEventViewController alloc]init];
    [self addChildVc:event title:@"事项" imageName:@"tab_work" selectedImage:@"tab_work"];
    
    ICEFORCEFileLibraryViewController *file = [[ICEFORCEFileLibraryViewController alloc]init];
    [self addChildVc:file title:@"项目库" imageName:@"tab_work" selectedImage:@"tab_work"];

    ICEFORCEMySelfViewController *mySelf = [[ICEFORCEMySelfViewController alloc]init];
    [self addChildVc:mySelf title:@"我的" imageName:@"tab_work" selectedImage:@"tab_work"];

    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.tabBar.barTintColor = [UIColor whiteColor];
        [self.tabBar setBackgroundColor:[UIColor whiteColor]];
//        [self.tabBar setBackgroundColor:[UIColor redColor]];
    }
    return self;
}
- (void)addChildVc:(UIViewController *)Vc title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage
{
    Vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
    attrSelected[NSForegroundColorAttributeName] = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:100/255.0 alpha:1];
    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    [[UITabBarItem appearance]setTitleTextAttributes:attr forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
    
    SingaporeNavViewController *nav = [[SingaporeNavViewController alloc]initWithRootViewController:Vc];
    Vc.tabBarItem.title = title;
    [self addChildViewController:Vc];
}

@end
