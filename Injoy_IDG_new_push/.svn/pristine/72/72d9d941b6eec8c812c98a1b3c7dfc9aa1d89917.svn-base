//
//  SDChatFileView.m
//  SDIMApp
//
//  Created by lancely on 2/26/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "SDChatFileView.h"
#import "Masonry.h"

@interface SDChatFileView()

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *fileNameLabel;
@property (nonatomic,strong) UILabel *fileSizeLabel;

@end

@implementation SDChatFileView

-(instancetype)init{
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"chat-file-icon"];
    [self addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 49)).priorityHigh();
        make.leading.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    _fileNameLabel = [[UILabel alloc] init];
    _fileNameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_fileNameLabel];
    [_fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView);
        make.leading.equalTo(_iconImageView.mas_trailing).offset(8);
        make.trailing.lessThanOrEqualTo(self).offset(-5);
    }];
    
    _fileSizeLabel = [[UILabel alloc] init];
    _fileSizeLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_fileSizeLabel];
    [_fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_iconImageView);
        make.leading.equalTo(_fileNameLabel);
    }];
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(200);
//    }];
}

-(void)setFile:(CXIMFileMessageBody *)file{
    _file = file;
    self.fileNameLabel.text = file.name;
    self.fileSizeLabel.text = [NSString stringWithFormat:@"%dk",file.size.integerValue / 1024];
}

@end
