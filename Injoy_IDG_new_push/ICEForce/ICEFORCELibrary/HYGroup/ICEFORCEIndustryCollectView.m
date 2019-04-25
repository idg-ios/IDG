//
//  ICEFORCEIndustryCollectView.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/24.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEIndustryCollectView.h"

#import "HttpTool.h"

#import "ICEFORCEIndustryCollectionViewCell.h"
#import "ICEFORCEIndustryCollectionReusableView.h"
#import "ICEFORCEIndustryOtherCollectionReusableView.h"


@interface ICEFORCEIndustryCollectView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) NSMutableArray *oneArray;
@property (nonatomic ,strong) NSMutableArray *twoArray;

@property (nonatomic ,assign) NSInteger selectIndex;
@property (nonatomic ,strong) NSIndexPath *lastPath;
@property (nonatomic ,strong) NSIndexPath *currPath;


@property (nonatomic ,assign) BOOL isShow;

@end

@implementation ICEFORCEIndustryCollectView
-(NSMutableArray *)oneArray{
    if (!_oneArray) {
        _oneArray = [[NSMutableArray alloc]init];
    }
    return _oneArray;
}

-(NSMutableArray *)twoArray{
    if (!_twoArray) {
        _twoArray = [[NSMutableArray alloc]init];
    }
    return _twoArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubView];
    }
    return self;
}
-(void)loadSubView{
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    
    self.isShow = NO;
    [self loadService];
}

#pragma mark - 初始化界面
-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIView *baseView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.frame.size.width, 280))];
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:(CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height)) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ICEFORCEIndustryCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"industryCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ICEFORCEIndustryCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ICEFORCEIndustryCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ICEFORCEIndustryOtherCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"industryOtherHeadView"];
    
    self.collectionView.delegate = self;
    [baseView addSubview:self.collectionView];
}

//分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return [_oneArray count]+1;
    }else{
       
        if (self.isShow == NO) {
            return 0;
        }else{
            
            return [[self.twoArray objectAtIndex:_selectIndex] count];
        }
       
    }
   
}
//头部视图尺寸设置
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 40);
    }else{
        return CGSizeMake(ScreenWidth, 40);
        
    }
}
//头部视图装载
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
               ICEFORCEIndustryCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ICEFORCEIndustryCollectionReusableView" forIndexPath:indexPath];
            headView.titieLabel.text = @"行业小组";
            return headView;
        }
    }else{
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            ICEFORCEIndustryOtherCollectionReusableView  *otherHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"industryOtherHeadView" forIndexPath:indexPath];
            otherHeadView.titleLabel.text = @"细分行业";
            return otherHeadView;
        }
    }
    return nil;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat space = 10;
    return CGSizeMake((Screen_Width - space * 5) / 4.0, 35);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ICEFORCEIndustryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"industryCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.contentLabel.text = @"全部";
        }else{
            ICEFORCEIndustryModel *model  = [self.oneArray objectAtIndex:indexPath.row-1];
            cell.contentLabel.text = model.codeNameZhCn;
        }
    }else{
        ICEFORCEIndustryModel *model  = [[self.twoArray objectAtIndex:_selectIndex] objectAtIndex:indexPath.row];
        cell.contentLabel.text = model.codeNameZhCn;
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        self.lastPath = self.currPath;
        self.currPath = indexPath;
        
        ICEFORCEIndustryCollectionViewCell *lastCell  = (ICEFORCEIndustryCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.lastPath];
        lastCell.contentLabel.textColor = [UIColor blackColor];
        
        ICEFORCEIndustryCollectionViewCell *cell  = (ICEFORCEIndustryCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.currPath];
        cell.contentLabel.textColor = [UIColor redColor];
        
        if (indexPath.row > 0) {
            self.isShow = YES;
            _selectIndex = indexPath.row-1;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }else{
             self.isShow = NO;
            [self removeFromSuperview];
            ICEFORCEIndustryModel *model  = [[ICEFORCEIndustryModel alloc] init];
            if (self.IndustryBlock) {
                self.IndustryBlock(model);
            }
        }
        
    }else{
        ICEFORCEIndustryModel *model  = [[self.twoArray objectAtIndex:_selectIndex] objectAtIndex:indexPath.row];
        if (self.IndustryBlock) {
            self.IndustryBlock(model);
        }
        NSLog(@"%@",model.codeNameZhCn);
        [self removeFromSuperview];
    }
}
#pragma mark - 获取行业网络请求
-(void)loadService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"induType" forKey:@"type"];
    
    [HttpTool getWithPath:GET_SYSCODE_QueryByType params:dic success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray * dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            
            for (int i = 0; i < dataArray.count; i++) {
                NSMutableArray *two = [[NSMutableArray alloc]init];
                NSDictionary *dic = [dataArray objectAtIndex:i];
                ICEFORCEIndustryModel *model = [ICEFORCEIndustryModel modelWithDict:dic];
                model.isShow = NO;
                for (NSDictionary *twoDic in [dic objectForKey:@"children"]) {
                    ICEFORCEIndustryModel *twoModel = [ICEFORCEIndustryModel modelWithDict:twoDic];
                    twoModel.isShow = NO;
                    [two addObject:twoModel];
                }
                
                [self.oneArray addObject:model];
                [self.twoArray addObject:two];
            }
            self.collectionView.dataSource = self;
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
