//
//  ICEFORCEIndustryCollectionViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/24.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEIndustryCollectionViewCell.h"

@interface ICEFORCEIndustryCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end
@implementation ICEFORCEIndustryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [MyPublicClass layerMasksToBoundsForAnyControls:self.baseView cornerRadius:5 borderColor:nil borderWidth:0];
    
}

@end
