//
//  CXHouseProjectListTableViewCell.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectListTableViewCell.h"


@interface CXHouseProjectListTableViewCell()

@property (nonatomic, strong)UIView *groupNameBackView;
@property (nonatomic, strong)UILabel *groupTitleNameLabel;
@property (nonatomic, strong)UILabel *projectNameLabel;
@property (nonatomic, strong)UILabel *groupNameLabel;
@property (nonatomic, strong)UILabel *remarkLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@end
#define  imageViewSize (46*uinitpx)
#define CellHeight (84*uinitpx) //cell高度
@implementation CXHouseProjectListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = kColorWithRGB(245, 246, 248);
        [self.contentView addSubview:self.groupNameLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.projectNameLabel];
        [self.contentView addSubview:self.groupNameBackView];
        [self.contentView addSubview:self.remarkLabel];
        [self.contentView addSubview:self.groupTitleNameLabel];
        [self.groupNameBackView addShadow];
    }
    return self;
}

- (void)setGroupTitleNameLabelFrameWithInteger:(NSInteger)projGroup AndDataFrame:(CXHouseProjectModelFrame *)dataFrame
{
    NSString *groupDtr;
    UIColor *fontColor;
    switch (projGroup) {
        case -1:
        case 8:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 1:{
            if(dataFrame.TMTModel){
               groupDtr = @"融";
            }else{
                groupDtr = @"VC";
            }
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 2:{
            groupDtr = @"工业";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 3:{
            if(dataFrame.metModel){
                groupDtr = @"潜";
            }else{
                groupDtr = @"PE";
            }
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 4:{
            groupDtr = @"地产";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 5:{
            groupDtr = @"保险";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 6:{
            groupDtr = @"娱乐";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
        case 7:{
            groupDtr = @"体育";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 9:{
            groupDtr = @"并购";
            fontColor = kColorWithRGB(174,17,41);
        }
            break;
        case 10:{
            groupDtr = @"医疗";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 87619:{
            groupDtr = @"能源";
            fontColor = kColorWithRGB(70,158,133);
        }
            break;
        case 144144:{
            groupDtr = @"金融";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        case 5354:{
            groupDtr = @"PE";
            fontColor = kColorWithRGB(210,135,62);
        }
            break;
        default:{
            groupDtr = @"其他";
            fontColor = kColorWithRGB(99,141,208);
        }
            break;
    }
    self.groupTitleNameLabel.text = groupDtr;
    self.groupTitleNameLabel.textColor = fontColor;
    self.groupTitleNameLabel.font = [UIFont systemFontOfSize:imageViewSize *scale];
    [self.groupTitleNameLabel sizeToFit];
    self.groupTitleNameLabel.center = self.groupNameBackView.center;
}

- (void)setDataFrame:(CXHouseProjectModelFrame *)dataFrame{
    _dataFrame = dataFrame;
    if(dataFrame.model){
        self.projectNameLabel.text = dataFrame.model.projName;
        self.nameLabel.text = dataFrame.model.projManagerNames;
        self.groupNameLabel.text = dataFrame.model.indusGroupName;
        self.remarkLabel.text = dataFrame.model.zhDesc;
        self.projectNameLabel.frame = dataFrame.projectNameLabelFrame;
        self.nameLabel.frame = dataFrame.nameLabelFrame;
        self.groupNameLabel.frame = dataFrame.groupNameLabelFrame;
        self.remarkLabel.frame = dataFrame.remarkLabelFrame;
        [self setGroupTitleNameLabelFrameWithInteger:4 AndDataFrame:dataFrame];
    }else if (dataFrame.managerModel){
        self.projectNameLabel.text = dataFrame.managerModel.projName;
        self.nameLabel.text = dataFrame.managerModel.projManagerName;
        self.groupNameLabel.text = dataFrame.managerModel.induName;
        self.remarkLabel.text = dataFrame.managerModel.business;
        self.projectNameLabel.frame = dataFrame.projectNameLabelFrame;
        self.nameLabel.frame = dataFrame.nameLabelFrame;
        self.groupNameLabel.frame = dataFrame.groupNameLabelFrame;
        self.remarkLabel.frame = dataFrame.remarkLabelFrame;
        [self setGroupTitleNameLabelFrameWithInteger:[dataFrame.managerModel.projGroup integerValue] AndDataFrame:dataFrame];
    }else if (dataFrame.metModel){
        self.projectNameLabel.text = dataFrame.metModel.projName;
        self.nameLabel.text = dataFrame.metModel.userName;
        self.groupNameLabel.text = dataFrame.metModel.comIndus;
        self.remarkLabel.text = dataFrame.metModel.bizDesc;
        self.projectNameLabel.frame = dataFrame.projectNameLabelFrame;
        self.nameLabel.frame = dataFrame.nameLabelFrame;
        self.groupNameLabel.frame = dataFrame.groupNameLabelFrame;
        self.remarkLabel.frame = dataFrame.remarkLabelFrame;
        [self setGroupTitleNameLabelFrameWithInteger:3 AndDataFrame:dataFrame];
        
    }else if (dataFrame.ZJYXLGSModel){
        self.projectNameLabel.text = dataFrame.ZJYXLGSModel.projName;
        self.nameLabel.text = dataFrame.ZJYXLGSModel.projManagerName;
        self.groupNameLabel.text = dataFrame.ZJYXLGSModel.indusType;
        self.remarkLabel.text = dataFrame.ZJYXLGSModel.createDate;
        self.projectNameLabel.frame = dataFrame.projectNameLabelFrame;
        self.nameLabel.frame = dataFrame.nameLabelFrame;
        self.groupNameLabel.frame = dataFrame.groupNameLabelFrame;
        self.remarkLabel.frame = dataFrame.remarkLabelFrame;
        [self setGroupTitleNameLabelFrameWithInteger:3 AndDataFrame:dataFrame];
    }else if (dataFrame.TMTModel){
        self.projectNameLabel.text = dataFrame.TMTModel.projName;
        self.nameLabel.text = dataFrame.TMTModel.followUpPersonName;
        self.groupNameLabel.text = dataFrame.TMTModel.indu;
        self.remarkLabel.text = dataFrame.TMTModel.zhDesc;
        self.projectNameLabel.frame = dataFrame.projectNameLabelFrame;
        self.nameLabel.frame = dataFrame.nameLabelFrame;
        self.groupNameLabel.frame = dataFrame.groupNameLabelFrame;
        self.remarkLabel.frame = dataFrame.remarkLabelFrame;
        [self setGroupTitleNameLabelFrameWithInteger:1 AndDataFrame:dataFrame];
        
    }else if (dataFrame.researchModel){
        self.projectNameLabel.text = dataFrame.researchModel.docName;
        self.nameLabel.text = dataFrame.researchModel.authorName;
        self.groupNameLabel.text = dataFrame.researchModel.induName;
        self.remarkLabel.text = dataFrame.researchModel.summary;
        self.projectNameLabel.frame = dataFrame.projectNameLabelFrame;
        self.nameLabel.frame = dataFrame.nameLabelFrame;
        self.groupNameLabel.frame = dataFrame.groupNameLabelFrame;
        self.remarkLabel.frame = dataFrame.remarkLabelFrame;
        [self setGroupTitleNameLabelFrameWithInteger:[dataFrame.researchModel.indusGroup integerValue] AndDataFrame:dataFrame];
        
    }
    _dataFrame = dataFrame;
}

- (UILabel *)nameLabel{
    if(nil == _nameLabel){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:12.f];
        _nameLabel.textColor = kColorWithRGB(174, 17, 41);
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
}
- (UILabel *)groupTitleNameLabel{
    if(nil == _groupTitleNameLabel){
        _groupTitleNameLabel = [[UILabel alloc]init];
        _groupTitleNameLabel.font = [UIFont systemFontOfSize:12.f];
        _groupTitleNameLabel.textColor = kColorWithRGB(174, 17, 41);
        _groupTitleNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _groupTitleNameLabel;
}
- (UILabel *)projectNameLabel{
    if(nil == _projectNameLabel){
        _projectNameLabel = [[UILabel alloc]init];
        _projectNameLabel.font = [UIFont systemFontOfSize:18.f];
        _projectNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _projectNameLabel;
}
- (UILabel *)groupNameLabel{
    if(nil == _groupNameLabel){
        _groupNameLabel = [[UILabel alloc]init];
        _groupNameLabel.font = [UIFont systemFontOfSize:14.f];
        _groupNameLabel.textColor = kColorWithRGB(132, 142, 153);
    }
    return _groupNameLabel;
}
- (UILabel *)remarkLabel{
    if(nil == _remarkLabel){
        _remarkLabel = [[UILabel alloc]init];
        _remarkLabel.font = [UIFont systemFontOfSize:14.f];
        _remarkLabel.textColor = kColorWithRGB(132, 142, 153);
    }
    return _remarkLabel;
}

- (UIView *)groupNameBackView{
    if(!_groupNameBackView){
        _groupNameBackView = [[UIView alloc] init];
        _groupNameBackView.backgroundColor = kColorWithRGB(255, 255, 255);
        _groupNameBackView.layer.shadowColor = [UIColor yellowColor].CGColor;//阴影颜色
        _groupNameBackView.layer.shadowOffset = CGSizeMake(10, 10);//width表示阴影与x的便宜量,height表示阴影与y值的偏移量
        _groupNameBackView.layer.shadowOpacity = 0.4;//阴影透明度,默认为0则看不到阴影
        _groupNameBackView.layer.shadowRadius = 5;
        _groupNameBackView.layer.cornerRadius = imageViewSize/2.0;
        _groupNameBackView.clipsToBounds = YES;
        _groupNameBackView.frame = CGRectMake(viewmargin, (CellHeight - imageViewSize)/2.0f, imageViewSize, imageViewSize);
    }
    return _groupNameBackView;
}
@end
