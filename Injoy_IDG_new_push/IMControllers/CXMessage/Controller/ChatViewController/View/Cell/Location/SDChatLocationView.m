//
//  SDChatLocationView.m
//  im
//
//  Created by lancely on 16/1/13.
//  Copyright © 2016年 chaselen. All rights reserved.
//

#import "SDChatLocationView.h"
#import "Masonry.h"

@interface SDChatLocationView()

@property (nonatomic,strong) UIImageView *locationPrevImageView;
@property (nonatomic,strong) UILabel *locationTitleLabel;

@end

@implementation SDChatLocationView

-(instancetype)init{
    if (self = [super init]) {
        _locationPrevImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_location_preview"]];
        
        _locationTitleLabel = [[UILabel alloc] init];
        _locationTitleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _locationTitleLabel.font = [UIFont systemFontOfSize:12];
        _locationTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_locationPrevImageView];
        [self addSubview:_locationTitleLabel];
        
        [_locationPrevImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(200).priorityHigh();
            make.width.equalTo(self).priorityLow();
            make.edges.equalTo(self);
        }];
        
        [_locationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

-(void)setLocation:(NSString *)location{
    _location = location;
    _locationTitleLabel.text = [NSString stringWithFormat:@" %@",location];
}

@end
