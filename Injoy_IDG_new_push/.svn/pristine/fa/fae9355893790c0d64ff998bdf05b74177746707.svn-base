//
//  CXSearchBar.m
//  CusSearchBarDemo
//
//  Created by HelloIOS on 2018/6/21.
//  Copyright © 2018年 HelloIOS. All rights reserved.
//

#import "CXSearchBar.h"

@implementation CXSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}



-(void)layout{
    
    self.placeholder = @"请输入关键词";
    
    self.backgroundImage = [[UIImage alloc] init];
    self.barTintColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    UITextField *searchField = [self valueForKey:@"searchField"];
    
        if (searchField) {
            searchField.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            
            searchField.layer.cornerRadius = 14;
            searchField.layer.masksToBounds = YES;
            searchField.layer.borderWidth = 1.0;
            searchField.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
            searchField.frame = CGRectMake(0, 12, self.frame.size.width, 60-24);
            searchField.layer.borderColor = [UIColor whiteColor].CGColor;
            searchField.layer.borderWidth = 1.0;
            searchField.font = [UIFont systemFontOfSize:14];
            
    
    
        }
}

@end
