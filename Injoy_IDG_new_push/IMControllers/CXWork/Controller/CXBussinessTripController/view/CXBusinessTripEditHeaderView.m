//
//  CXBusinessTripEditHeaderView.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/17.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXBusinessTripEditHeaderView.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXBusinessTripCityModel.h"


#define margin 5.0f
#define arrowImagWidth  20.f
#define deleteBtnWidth 50.f
#define NSLogs(...) printf("时间是：%f 内容是：%s",[[NSDate date]timeIntervalSince1970],[NSString stringWithFormat:__VA_ARGS__].UTF8String)
@interface CXBusinessTripEditHeaderView()
@property(nonatomic, strong)CXEditLabel *tripTypeLabel;
@property(nonatomic, strong)CXEditLabel *startCityLbabel;
@property(nonatomic, strong)CXEditLabel *endCityLabel;
@property(nonatomic, copy)void (^dataHasFill)();
@property(nonatomic, strong)UIButton *addBtn;
@property(nonatomic, assign)VCType type;
@property(nonatomic, strong)NSArray *endCitis;



@end
static NSInteger endCount;
static NSInteger tagCount;
@implementation CXBusinessTripEditHeaderView{
    NSMutableArray *cityNameArray;
    NSMutableArray *cityIdArray;
    NSMutableArray *idxArray;
}
- (id)initWithFrame:(CGRect)frame dataModel:(CXBusinessTripEditDataManager *)dataManager andType:(VCType)type{
    if(self = [super initWithFrame:CGRectMake(0, 0, Screen_Width, 0)]){
        self.dataManager = dataManager;
        self.type = type;
        endCount =  tagCount = 1;
        idxArray = @[@"0"].mutableCopy;
        [self addSubview:self.tripTypeLabel];
        UIView *line0 = [self createLineView];
        UIImageView *typeImg = [self arrowImage];
        typeImg.frame = CGRectMake(self.tripTypeLabel.right, self.tripTypeLabel.top, arrowImagWidth-margin, kCellHeight);
        [self addSubview:typeImg];
        line0.frame = CGRectMake(0, self.tripTypeLabel.bottom, Screen_Width, 1.0f);
        [self addSubview:line0];
        [self addSubview:self.startCityLbabel];
        UIView *line1 = [self createLineView];
        line1.frame = CGRectMake(0, self.startCityLbabel.bottom, Screen_Width, 1.0f);
        [self addSubview:line1];
        [self addSubview:self.endCityLabel];
        self.endCityLabel.tag = 1000;
        UIView *line2 = [self createLineView];
        line2.frame = CGRectMake(0, self.endCityLabel.bottom, Screen_Width, 1.0f);
        line2.tag = 2000;
        [self addSubview:line2];
        if(self.type == isCreate){
            [self addSubview:self.addBtn];
            self.height = self.addBtn.bottom;
        }else{
            typeImg.hidden = YES;
            self.endCityLabel.allowEditing = NO;
            self.endCityLabel.numberOfLines = 0;
            self.endCityLabel.placeholder  = @"";
            self.endCityLabel.content = self.dataManager.targetCitiesRealName?:@"";
            self.endCityLabel.showDropdown = NO;
            self.startCityLbabel.placeholder = @"";
            self.startCityLbabel.content = self.dataManager.startCityRealName?:@"";
            self.startCityLbabel.allowEditing = NO;
            self.startCityLbabel.showDropdown = NO;
            self.tripTypeLabel.placeholder = @"";
            self.tripTypeLabel.content = self.dataManager.tripType;
            self.tripTypeLabel.allowEditing = NO;
            line2.top = self.endCityLabel.bottom;
            self.height = line2.bottom;
            
        }
    }
    return self;
}
#pragma mark - 响应方法

- (bool)checkData{
    if(!trim(self.tripTypeLabel.content).length){
        CXAlert(@"请选择出差类型！");
        return false;
    }else if(!trim(self.startCityLbabel.content).length){
        if([self.tripTypeLabel.content isEqualToString:@"国内"]){
            CXAlert(@"请选择出发城市！");
        }else{
            CXAlert(@"请填写出发城市！");
        }
        return false;
    }
    self.dataManager.model.tripType = [self.tripTypeLabel.selectedPickerData valueForKey:CXEditLabelCustomPickerValueKey];
     NSMutableArray *tempArray = [NSMutableArray array];
    if([self.tripTypeLabel.content isEqualToString:@"国内"]){
        NSLogs(@" startData is %@, value is %@", self.startCityLbabel.selectedPickerData, [self.startCityLbabel.selectedPickerData valueForKey:CXEditLabelCustomPickerValueKey]);
        self.dataManager.startCityJsonString = [self.startCityLbabel.selectedPickerData valueForKey:CXEditLabelCustomPickerValueKey];
        for(CXEditLabel *label in self.subviews){
        if([label isKindOfClass:[CXEditLabel class]]){
            if([label.title isEqualToString:@"出差类型："] || [label.title isEqualToString:@"出发城市："]){
                continue;
            }else{
                if(trim(label.content).length)
                    [tempArray addObject:[label.selectedPickerData valueForKey:CXEditLabelCustomPickerValueKey]];
            }
        }
        }
        if(tempArray.count){
            NSData *cityData = [NSJSONSerialization dataWithJSONObject:tempArray options:NSJSONWritingPrettyPrinted error:nil];
            self.dataManager.targetCitiesJsonString = [[NSString alloc]initWithData:cityData encoding:NSUTF8StringEncoding];
        }
        }else{                                      //出差类型是国外时出发城市和目的城市都是自己定义
            self.dataManager.startCityJsonString = self.startCityLbabel.content;
            for(CXEditLabel *label in self.subviews){
                if([label isKindOfClass:[CXEditLabel class]]){
                    if([label.title isEqualToString:@"出差类型："] || [label.title isEqualToString:@"出发城市："]){
                        continue;
                    }else{
                        if(trim(label.content).length)
                            [tempArray addObject:label.content];
                    }
                }
            }
            if(tempArray.count){
                NSData *cityData = [NSJSONSerialization dataWithJSONObject:tempArray options:NSJSONWritingPrettyPrinted error:nil];
                self.dataManager.targetCitiesJsonString = [[NSString alloc]initWithData:cityData encoding:NSUTF8StringEncoding];
            }
          }
    if(!tempArray.count){
        if([self.tripTypeLabel.content isEqualToString:@"国内"]){
            CXAlert(@"请至少选择一个目的城市！");
        }else{
            CXAlert(@"请至少填写一个目的城市！");
        }
        return false;
    }

    return true;
}
- (void)addBtnTap{
    CXEditLabel *label = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, self.addBtn.top, Screen_Width - margin - deleteBtnWidth, kCellHeight)];
    label.title = [NSString stringWithFormat:@"目的城市%zd：",endCount];
    if([self.tripTypeLabel.content isEqualToString:@"国内"]){
        label.inputType = CXEditLabelInputTypeCity;
    }
    label.showDropdown = NO;
    label.tag = 1000+tagCount;
    label.pickerTextArray = cityNameArray;
    label.pickerValueArray = cityIdArray;
    [self addSubview:label];
    label.placeholder = [NSString stringWithFormat:@"请输入目的城市%zd",endCount];
    UIButton *btn = [self deleteBtn];
    btn.frame = CGRectMake(label.right, label.top, deleteBtnWidth, kCellHeight);
    [self addSubview:btn];
    btn.tag = 10000+tagCount;
    UIView *line = [self createLineView];
    line.frame = CGRectMake(0, label.bottom, Screen_Width, 1.0f);
    line.tag = 2000+tagCount;
    [self addSubview:line];
    self.addBtn.top = line.bottom;
    self.height = self.addBtn.bottom - self.tripTypeLabel.top;
    if(self.viewUpdate){
        self.viewUpdate();
    }
    [idxArray addObject:[NSString stringWithFormat:@"%zd", tagCount]];
    tagCount++;
    endCount++;
}
- (UIView *)createLineView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kColorWithRGB(242, 242, 242);
    return view;
}
- (UIImageView *)arrowImage {
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrow.contentMode = UIViewContentModeCenter;
    return arrow;
}
- (UIButton *)deleteBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.backgroundColor = kColorWithRGB(250, 61, 59);
    [btn addTarget:self action:@selector(deleteBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)dispatchCityNameAndId{
    if(!self.cityArray.count)
        return;
    [self.cityArray enumerateObjectsUsingBlock:^(CXBusinessTripCityModel *model, NSUInteger idx, BOOL *stop){
        [cityNameArray addObject:model.name?:@""];
        [cityIdArray addObject:[NSString stringWithFormat:@"%@",model.id]?:@""];
    }];
    self.startCityLbabel.pickerTextArray = cityNameArray.copy;
    self.endCityLabel.pickerTextArray = cityNameArray.copy;
    self.startCityLbabel.pickerValueArray = cityIdArray.copy;
    self.endCityLabel.pickerValueArray = cityIdArray.copy;
}
#pragma  mark - 删除按钮点击事件
- (void)deleteBtnTap:(UIButton *)sender{
    __block NSInteger index = sender.tag - 10000;
    [[self viewWithTag:index+1000]removeFromSuperview];
    [sender removeFromSuperview];
    [[self viewWithTag:index+2000]removeFromSuperview];
    
   __block bool found = false;
   __block NSUInteger dataPosition;
    [idxArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop){
        if([str isEqualToString:[NSString stringWithFormat:@"%zd", index]]){
            found = YES;
            dataPosition = idx;
            *stop = YES;
        }
    }];
    if(found){
        if(dataPosition == idxArray.count-1){
            dataPosition  = dataPosition - 1;
            UIView *view = [self viewWithTag:2000+[idxArray[dataPosition]integerValue]];
            self.addBtn.top = view.bottom;
            self.height = self.addBtn.bottom - self.tripTypeLabel.top;
            endCount--;
            if(self.viewUpdate){
                self.viewUpdate();
            }
        }else{
            [self updateDeleteBtn:dataPosition];
        }
    }
    endCount = idxArray.count-1;
    [idxArray removeObject:[NSString stringWithFormat:@"%zd",index]];

}
- (void)updateDeleteBtn:(NSUInteger)dataPosition{
    if(dataPosition>0&&dataPosition<idxArray.count-1){
        NSInteger bIdx = [idxArray[dataPosition+1]integerValue];
        NSInteger fIdx = [idxArray[dataPosition-1]integerValue];
        if(dataPosition< idxArray.count){
            CXEditLabel *label1 = (CXEditLabel *)[self viewWithTag:bIdx+1000];
            label1.title = [NSString stringWithFormat:@"目的城市%zd：", dataPosition];
            label1.placeholder = [NSString stringWithFormat:@"请输入目的城市%zd", dataPosition];;
            UIButton *deletBtn1 = (UIButton *)[self viewWithTag:bIdx+10000];
            UIView *line1 = (UIView *)[self viewWithTag:bIdx+2000];
            UIView *line0 = (UIView *)[self viewWithTag:fIdx+2000];
            label1.top = line0.bottom;
            deletBtn1.top = line0.bottom;
            line1.top = label1.bottom;
            
        }
    }
    dataPosition = dataPosition+1;
    while(dataPosition < idxArray.count-1){
        NSInteger bIdx = [idxArray[dataPosition+1]integerValue];
        NSInteger fIdx = [idxArray[dataPosition]integerValue];
        if(dataPosition< idxArray.count){
            CXEditLabel *label1 = (CXEditLabel *)[self viewWithTag:bIdx+1000];
            label1.title = [NSString stringWithFormat:@"目的城市%zd：", dataPosition];
            label1.placeholder = [NSString stringWithFormat:@"请输入目的城市%zd：", dataPosition];
            UIButton *deletBtn1 = (UIButton *)[self viewWithTag:bIdx+10000];
            UIView *line1 = (UIView *)[self viewWithTag:bIdx+2000];
            UIView *line0 = (UIView *)[self viewWithTag:fIdx+2000];
            label1.top = line0.bottom;
            deletBtn1.top = line0.bottom;
            line1.top = label1.bottom;
        }
        dataPosition++;
    }
    UIView *view = [self viewWithTag:2000 + [idxArray.lastObject integerValue]];
    self.addBtn.top = view.bottom;
    self.height = self.addBtn.bottom - self.tripTypeLabel.top;
    if(self.viewUpdate){
        self.viewUpdate();
    }
}
#pragma mark - 数据懒加载
- (CXEditLabel *)tripTypeLabel{
    if(nil == _tripTypeLabel){
        _tripTypeLabel = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, 0, Screen_Width - 2*margin - arrowImagWidth, kCellHeight)];
        _tripTypeLabel.title = @"出差类型：";
        _tripTypeLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _tripTypeLabel.placeholder = @"请选择出差类型";
        _tripTypeLabel.showDropdown = NO;
        _tripTypeLabel.pickerTextArray = @[@"国内", @"海外"].copy;
        _tripTypeLabel.pickerValueArray = @[@"MAINLAND", @"OVERSEA"].copy;
        CXWeakSelf(self);
        _tripTypeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel){
            
            for (UIView *view in weakself.subviews) {
                if([view isKindOfClass:[CXEditLabel class]]){
                    CXEditLabel *label  = (CXEditLabel *)view;
                    if(![label.title isEqualToString:@"出差类型："]){
                        label.content  =@"";
                        if([editLabel.content isEqualToString:@"海外"]){
                            label.inputType = CXEditLabelInputTypeText;
                        }else if ([editLabel.content isEqualToString:@"国内"]){
                            label.inputType = CXEditLabelInputTypeCity;
                        }
                    }
                }
            }
       };
    }
    return _tripTypeLabel;
}
- (CXEditLabel *)startCityLbabel{
    if(nil == _startCityLbabel){
        _startCityLbabel = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, self.tripTypeLabel.bottom+1, Screen_Width-2*margin, kCellHeight)];
        _startCityLbabel.title = @"出发城市：";
        _startCityLbabel.inputType = CXEditLabelInputTypeCity;
        _startCityLbabel.placeholder = @"请输入出发城市";
        _startCityLbabel.showDropdown = YES;
    }
    return _startCityLbabel;
}
- (CXEditLabel *)endCityLabel{
    if(nil == _endCityLabel){
        _endCityLabel = [[CXEditLabel alloc]initWithFrame:CGRectMake(margin, self.startCityLbabel.bottom+1, Screen_Width-2*margin, kCellHeight)];
        _endCityLabel.title = @"目的城市：";
        _endCityLabel.inputType = CXEditLabelInputTypeCity;
        _endCityLabel.placeholder = @"请输入目的城市";
        _endCityLabel.showDropdown = YES;
    }
    return _endCityLabel;
}
- (UIButton *)addBtn{
    if(nil == _addBtn){
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:Image(@"add_1") forState:UIControlStateNormal];
        [_addBtn setTitle:@"新增目的城市" forState:UIControlStateNormal];
        [_addBtn setTitleColor:kColorWithRGB(229, 70, 73) forState:UIControlStateNormal];
        _addBtn.frame = CGRectMake(0, self.endCityLabel.bottom, Screen_Width, kCellHeight);
        [_addBtn addTarget:self action:@selector(addBtnTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
- (void)setCityArray:(NSArray *)cityArray{
    _cityArray = cityArray;
    cityNameArray = @[].mutableCopy;
    cityIdArray = @[].mutableCopy;
    [self dispatchCityNameAndId];
}
- (CXBusinessTripEditDataManager *)dataManager{
    if(nil == _dataManager){
        _dataManager = [[CXBusinessTripEditDataManager alloc]init];
    }
    return _dataManager;
}
@end
