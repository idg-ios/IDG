//
//  SDChattingSystemNotifyCell.m
//  SDIMApp
//
//  Created by lancely on 3/25/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "SDChattingSystemNotifyCell.h"
#import "UIView+Category.h"

@interface SDChattingSystemNotifyCell()

@property (nonatomic,strong) UIView *notifyView;
@property (nonatomic,strong) UILabel *notifyLabel;

@end

@implementation SDChattingSystemNotifyCell

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)]) {
        [self initCell];
    }
    return self;
}

-(void)initCell{
    [super initCell];
 
    self.notifyView = [[UIView alloc] init];
    [self.contentView addSubview:self.notifyView];
    
    self.notifyLabel = [[UILabel alloc] init];
    self.notifyLabel.textColor = [UIColor whiteColor];
    self.notifyView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    self.notifyView.layer.cornerRadius = 3;
    self.notifyView.layer.masksToBounds = YES;
    self.notifyLabel.font = [UIFont systemFontOfSize:14];
    self.notifyLabel.numberOfLines = 0;
    self.notifyLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.notifyView addSubview:self.notifyLabel];
    [super cellDidLoad];
}

-(void)setMessage:(CXIMMessage *)message{
    [super setMessage:message];
    
    // 文字
    CXIMSystemNotifyMessageBody *body = (CXIMSystemNotifyMessageBody *)message.body;
    self.notifyLabel.text = body.notifyContent;
    self.notifyLabel.size = [self.notifyLabel sizeThatFits:CGSizeMake(Screen_Width * .75, FLT_MAX)];
    self.notifyLabel.origin = CGPointMake(3, 3);
    
    // 背景
    self.notifyView.size = CGSizeMake(CGRectGetWidth(self.notifyLabel.frame) + self.notifyLabel.origin.x * 2, CGRectGetHeight(self.notifyLabel.frame) + self.notifyLabel.origin.y * 2);

    if (self.isNeedDisplayTime) {
        self.notifyView.y = CGRectGetMaxY(self.timeLabel.frame) + 10;
    }
    else{
        self.notifyView.y = 10;
    }
    self.notifyView.centerX = Screen_Width / 2.0;
    
    self.cellHeight = CGRectGetMaxY(self.notifyView.frame);
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [super subClassLayoutSubviews];
}

@end
