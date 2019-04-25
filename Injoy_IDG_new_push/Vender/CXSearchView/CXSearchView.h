//
//  CXSearchView.h
//  CusSearchBarDemo
//
//  Created by HelloIOS on 2018/6/21.
//  Copyright © 2018年 HelloIOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXSearchBar.h"

typedef NS_ENUM(NSInteger,CXSearchType) {
    //只要searchBar
    CXSearch,
    //融资信息
    CXSearchTMT,
    //项目管理
    CXSearchPM,
    //研究报告
    CXSearchReport,
    //约见项目
    CXSearchMeet,
    //最具影响力公司
    CXSearchMIC,
    //NewsLetter
    CXSearchNewsLetter
};
 
typedef void(^SearchPMBlock)(NSArray *stages,NSArray *industries,NSString *searchText);
typedef void(^SearchReportBlock)(NSString *bgmc,NSString *zy,NSString *searchText);
typedef void(^SearchMeetBlock)(NSString *fzr,NSString *industries,NSString *searchText);
typedef void(^SearchMICBlock)(NSString *s_projManager, NSString *s_indusType, NSString *searchText);
typedef void(^SearchTMTBlock)(NSString *searchText);
typedef void(^SearchBlock)(NSString *searchText);
typedef void (^SearchNewsLetter)(NSString *searchText,NSString *s_projManager);


@interface CXSearchView : UIView <UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

/****************************   block ***************************/
/** 项目管理block回调 */
@property (nonatomic, strong) SearchPMBlock searchPMBlock;
/** 研究报告block回调 */
@property (nonatomic, strong) SearchReportBlock researchReportBlock;
/** 约见项目Block回调 */
@property (nonatomic, strong) SearchMeetBlock meetBlock;
/** 最具影响力公司Block回调 */
@property (nonatomic, strong) SearchMICBlock searchMICBlock;
/** TMT潜力项目Block回调 */
@property (nonatomic, strong) SearchTMTBlock searchTMTBlock;

/**
 NewsLetter
 */
@property (nonatomic, strong) SearchNewsLetter searchNewsLetter;
@property (nonatomic, copy) SearchBlock searchBlock;


/** 搜索输入框 */
@property (nonatomic, strong) CXSearchBar *searchBar;
/** 搜索类型 */
@property (nonatomic, assign) CXSearchType cxSearchType;


/****************************   项目管理  ***************************/
/** 数据源：项目阶段/项目经理
 {
 "machId": 1,
 "machName": "接触项目"
 } */
@property (nonatomic, copy) NSArray<NSDictionary *> *stageList;//项目管理类型中项目阶段的数据，以及最具影响力公司中的项目经理数据
/** 数据源：一级行业
 {
 "baseId": "101",
 "baseName": "TMT"
 } */
@property (nonatomic, copy) NSArray<NSDictionary *> *industryList;//项目管理类型中一级行业的数据，以及约见项目中行业的数据

/** 选项卡列表 */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 项目管理搜索列表 */
@property (nonatomic, strong) UITableView *searchTable;
/** 项目管理搜索数据 */
@property (nonatomic, strong) NSMutableArray *searchArray;
/** 搜索页数 */
@property (nonatomic, assign) NSInteger pageNumber;
/** 选择的项目阶段 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *selectedStageList;
/** 选择的一级行业 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *selectedIndustryList;

/** 是否展开项目阶段 */
@property (nonatomic, assign, getter=isExpandStage) BOOL expandStage;
/** 是否展开一级行业 */
@property (nonatomic, assign, getter=isExpandIndustry) BOOL expandIndustry;




/****************************   研究报告  ***************************/
/** 报告名称 */
@property (nonatomic, strong) UILabel * bgmcTitleLable;
/** 报告名称TextField */
@property (nonatomic, strong) UITextField * bgmcTextField;
/** 摘要 */
@property (nonatomic, strong) UILabel * zyTitleLable;
/** 摘要TextField */
@property (nonatomic, strong) UITextField * zyTextField;


/****************************   最具影响力公司  ***************************/
/** 最具影响力公司选择的内容数据 */
@property (nonatomic, copy) NSDictionary *s_projManager;//项目经理
@property (nonatomic, copy) NSString *s_indusType;//行业
/** 最具影响力公司行业的数据，JSON数据返回的是NSString类型 */
@property (nonatomic, copy) NSArray <NSString *> *industryMICList;

/****************************   约见项目  ***************************/
/** 负责人*/
@property (nonatomic, strong) UILabel * fzrTitleLable;
/** 负责人TextField */
@property (nonatomic, strong) UITextField * fzrTextField;
/** 选择的行业 */
@property (nonatomic, strong) NSString *selectIndustry;
/** 约见项目中行业的数据，返回数组是NSString类型 */
@property (nonatomic, strong) NSArray *meetingArray;
/** 上一次选中的indexPath，用于刷新上一次选中的cell */
@property (nonatomic, strong) NSIndexPath *selectIndex;

/****************************   底部重置和搜索按钮，每个搜索页都有  ***************************/
/** 底部视图 */
@property (nonatomic, strong) UIView *footerView;
/** 重置按钮 */
@property (nonatomic, strong) UIButton *resetButton;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton *searchButton;



-(instancetype)init;

//加载搜索页
- (void)showInView:(UIView *)view;
//隐藏
-(void)hide;

@end
