//
//  ICEFORCEScoreTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/21.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEScoreTableViewCell.h"

#import "WSStarRatingView.h"
#import "LEEStarRating.h"


@interface ICEFORCEScoreTableViewCell()

@property (nonatomic ,strong) LEEStarRating *teamStarView;
@property (nonatomic ,strong) UILabel *teamLabel;

@property (nonatomic ,strong) LEEStarRating *businessStarView;
@property (nonatomic ,strong) UILabel *businessLabel;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *teamView;
@property (weak, nonatomic) IBOutlet UIView *businessView;



@end

@implementation ICEFORCEScoreTableViewCell

-(UILabel *)teamLabel{
    if (!_teamLabel) {
        _teamLabel = [[UILabel alloc]init];
        _teamLabel.font = [UIFont systemFontOfSize:12];
        _teamLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _teamLabel;
}

-(UILabel *)businessLabel{
    if (!_businessLabel) {
        _businessLabel = [[UILabel alloc]init];
        _businessLabel.font = [UIFont systemFontOfSize:12];
        _businessLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _businessLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setModel:(ICEFORCEScoreRecordCellModel *)model{
    _model = model;
    
    self.teamView.frame = CGRectMake(0, 0, self.frame.size.width*0.4, self.frame.size.height);
    self.businessView.frame = CGRectMake(0, 0, self.frame.size.width*0.4, self.frame.size.height);
    
    self.teamStarView = [[LEEStarRating alloc] initWithFrame:CGRectMake(0, 0, self.teamView.frame.size.width-50, 0) Count:5];
    self.teamStarView.frame = CGRectMake(0, (self.teamView.frame.size.height-self.teamStarView.frame.size.height)/2, self.teamView.frame.size.width-50, 0);
    
    self.teamStarView.spacing = 0;
    self.teamStarView.checkedImage = [UIImage imageNamed:@"star_orange"];
    self.teamStarView.uncheckedImage = [UIImage imageNamed:@"star_gray"];
    self.teamStarView.type = RatingTypeHalf;
    self.teamStarView.touchEnabled = NO;
    self.teamStarView.slideEnabled = NO;
    self.teamStarView.maximumScore = 5.0f;
    self.teamStarView.minimumScore = 0.0f;
    
    
    self.teamLabel.frame = CGRectMake(CGRectGetMaxX(_teamStarView.frame), (self.teamView.frame.size.height-20)/2, 50, 20);
    
    [self.teamView addSubview:self.teamLabel];
    [self.teamView addSubview:self.teamStarView];
    
    
    
    self.businessStarView = [[LEEStarRating alloc] initWithFrame:CGRectMake(0, (self.businessView.frame.size.height-20)/2, self.businessView.frame.size.width-50, 0) Count:5];
    self.businessStarView.frame = CGRectMake(0, (self.businessView.frame.size.height-self.businessStarView.frame.size.height)/2, self.businessView.frame.size.width-50, 0);
    
    
    self.businessStarView.spacing = 0;
    self.businessStarView.checkedImage = [UIImage imageNamed:@"star_orange"];
    self.businessStarView.uncheckedImage = [UIImage imageNamed:@"star_gray"];
    self.businessStarView.type = RatingTypeHalf;
    self.businessStarView.touchEnabled = NO;
    self.businessStarView.slideEnabled = NO;
    self.businessStarView.maximumScore = 5.0f;
    self.businessStarView.minimumScore = 0.0f;
    
    
    self.businessLabel.frame = CGRectMake(CGRectGetMaxX(_businessStarView.frame), (self.businessView.frame.size.height-20)/2, 50, 20);
    
    [self.businessView addSubview:self.businessLabel];
    [self.businessView addSubview:self.businessStarView];
    
    _teamStarView.userInteractionEnabled = NO;
    _businessStarView.userInteractionEnabled = NO;
    
#pragma mark - 数据赋值
    self.userName.text = model.scoreName;
    
    if ([MyPublicClass stringIsNull:model.teamScore]) {
        self.teamLabel.text = @"0分";
        self.teamStarView.currentScore = 0.0;
    }else{
         self.teamLabel.text = [NSString stringWithFormat:@"%@分",model.teamScore];
          self.teamStarView.currentScore = model.teamScore.floatValue;
    }
    
    if ([MyPublicClass stringIsNull:model.businessScore]) {
        
        self.businessLabel.text =  @"0分";
        self.businessStarView.currentScore = 0.0;
    }else{
        self.businessLabel.text = [NSString stringWithFormat:@"%@分",model.businessScore];
        self.businessStarView.currentScore = model.businessScore.floatValue;
    }
   
   
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
