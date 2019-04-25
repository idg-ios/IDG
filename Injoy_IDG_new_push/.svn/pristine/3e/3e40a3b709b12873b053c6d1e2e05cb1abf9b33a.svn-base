//
//  CXSearchTableView.m
//  InjoyIDG
//
//  Created by ^ on 2018/6/4.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXSearchTableView.h"
#import "CXIDGProjectManagementListModel.h"
#import <objc/runtime.h>
#import "HttpTool.h"
#import "MJRefresh.h"
@interface CXSearchTableView()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) NSInteger pageNumber;

@end
#define seachBarHeight 50.f
#define rowheight 55.f
@implementation CXSearchTableView{
    NSMutableArray *_dataArray;
    NSInteger pageCount;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh)]){
        self.backgroundColor = [UIColor clearColor];
        self.pageNumber = pageCount =1;
        [self addSubview:self.listTableView];
        [self addSubview:self.searchBar];
        [self addSubview:self.maskView];
        
    }
    return self;
}
- (void)layoutSubviews{
    CGFloat height;
    if(self.dataArray.count * rowheight > (Screen_Height - navHigh - searchBar_Height)){
        height = Screen_Height - navHigh - searchBar_Height;
    }else{
        height = self.dataArray.count*rowheight;
    }
    _listTableView.frame = CGRectMake(0, searchBar_Height, Screen_Width, height);
    _maskView.frame = CGRectMake(0, CGRectGetMaxY(_listTableView.frame), Screen_Width, Screen_Height - navHigh - searchBar_Height - height);
    self.searchBar.frame = CGRectMake(0, 0, Screen_Width, searchBar_Height);
}
- (void)show{

    UIViewController *window = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([window isKindOfClass:[UITabBarController class]]) {
            window = ((UITabBarController*)window).selectedViewController;
       
        }
        if ([window isKindOfClass:[UINavigationController class]]) {
            window = ((UINavigationController*)window).visibleViewController;
        }
        if (window.presentedViewController) {
            window = window.presentedViewController;
        }else{
            break;
        }
    }
    window.definesPresentationContext = NO;
    self.searchBar.showsCancelButton = YES;
    [window.view addSubview:self];
    [self.searchBar becomeFirstResponder];
    UIButton *btn = [self getSearchBarBtn];
    [btn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}
- (NSAttributedString *)getAttributeString:(NSString *)str{
    if(nil == str || !trim(str).length){
        return nil;
    }
    NSMutableAttributedString *attriteString = [[NSMutableAttributedString alloc]initWithString:str];
    if([str rangeOfString:self.text options:NSCaseInsensitiveSearch].location != NSNotFound){
        NSRange range = [str rangeOfString:self.text options:NSCaseInsensitiveSearch];
        [attriteString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location, range.length)];
    }
    return attriteString;
}
- (UIButton *)getSearchBarBtn{
    UIButton *btn = [[UIButton alloc]init];
    for(id view in self.searchBar.subviews.lastObject.subviews){
        if([view isKindOfClass:[UIButton class]]){
            btn = view;
        }
    }
    return btn;
}

- (void)maskViewTap{
    [self.searchBar resignFirstResponder];
}
- (void)searchBtnTap:(UIButton *)btn{
//    NSString *text = objc_getAssociatedObject(btn, projName);
    [self hide];
    if(self.searchInputEnd){
        self.searchInputEnd(self.text);
    }
}

- (void)hide{
    if(self.searchInputCancel){
        self.searchInputCancel();
    }
    [self.searchBar resignFirstResponder];
    [self removeFromSuperview];
    
}

- (void)searchHintList:(NSString *)text{
    NSString *url = [NSString stringWithFormat:@"%@project/queryHint/list/%zd.json",urlPrefix, self.pageNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:text forKey:@"s_projName"];
    [HttpTool postWithPath:url params:params success:^(id JSON){
        if([JSON[@"status"]integerValue] == 200){
            NSArray *tempArray = [NSArray array];
            tempArray = JSON[@"data"];
            if(self.pageNumber == 1){
                [self.dataArray removeAllObjects];
                [self.listTableView reloadData];
            }
           [self.dataArray addObjectsFromArray:tempArray];
            [self setNeedsLayout];
            [self layoutIfNeeded];
            [self.listTableView reloadData];
            pageCount = [JSON[@"pageCount"]integerValue];
          
        }else{
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.footer endRefreshing];
    } failure:^(NSError *error){
        CXAlert(@"获取查询列表失败");
        [self.listTableView.footer endRefreshing];
    }];
}
#pragma mark - UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"listCell";
    NSString *text = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(nil == cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.attributedText = [self getAttributeString:text];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
const char *projName = "projName";
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.dataArray[indexPath.row];
    self.text = str;
    [self searchBar:self.searchBar textDidChange:str];
    UIButton *btn = [self getSearchBarBtn];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
//    objc_setAssociatedObject(btn, projName, str, OBJC_ASSOCIATION_RETAIN);
    [btn removeTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(searchBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowheight;
}
#pragma mark - UISearchBar代理方法

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.text = searchText;
    if(!trim(searchBar.text).length){
        UIButton *btn = [self getSearchBarBtn];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn removeTarget:self action:@selector(searchBtnTap:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }else{
        UIButton *btn = [self getSearchBarBtn];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
//        objc_setAssociatedObject(btn, projName, searchText, OBJC_ASSOCIATION_RETAIN);
        [btn removeTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(searchBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark -UIScrollView代理回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
#pragma mark - 数据懒加载
- (UITableView *)listTableView{
    if(nil == _listTableView){
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.backgroundColor = [UIColor whiteColor];
        _listTableView.showsVerticalScrollIndicator = NO;
        CXWeakSelf(self)
        [_listTableView addLegendFooterWithRefreshingBlock:^{
            if(weakself.pageNumber < pageCount){
                weakself.pageNumber = weakself.pageNumber+1;
                if(weakself.delegate && [weakself.delegate respondsToSelector:@selector(CXSearchTableView:text:andPageNumber:block:)]){
                    [weakself.delegate CXSearchTableView:weakself text:weakself.text andPageNumber:weakself.pageNumber block:^(NSArray *array){
                        [weakself.dataArray addObjectsFromArray:array];
                        [weakself.listTableView reloadData];
                    }];

                }else
                    [weakself searchHintList:weakself.text];
            }else{
                [weakself.listTableView removeFooter];
                CXAlert(@"没有更多数据了");
            }
            [weakself.listTableView.footer endRefreshing];
        }];
    }
    return _listTableView;
}

- (void)setText:(NSString *)text{
    _text = text;
    self.searchBar.text = text;
    [self setNeedsLayout];
    self.pageNumber = 1;
    if(_delegate && [_delegate respondsToSelector:@selector(CXSearchTableView:text:andPageNumber:block:)]){
        [_delegate CXSearchTableView:self text:text andPageNumber:self.pageNumber block:^(NSArray *array){
            [self.dataArray removeAllObjects];
            [self.listTableView reloadData];
            [self.dataArray addObjectsFromArray:array];
            [self.listTableView reloadData];
        }];
    }else
        [self searchHintList:text];    //这个是项目管理里搜索的接口，如过不是项目管理则应该实现上面的代理


}
- (NSMutableArray *)dataArray{
    if(nil == _dataArray){
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
}
- (UISearchBar *)searchBar{
    if(nil == _searchBar){
        _searchBar = [[UISearchBar alloc]init];
//        _vc.hidesNavigationBarDuringPresentation = NO;
//        _vc.dimsBackgroundDuringPresentation = NO;
        _searchBar.delegate = self;
    }
    return _searchBar;
}
- (UIView *)maskView{
    if(nil == _maskView){
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = RGBACOLOR(0, 0, 0, .2);
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)]];
    }
    return _maskView;
}
- (void)dealloc{
    [self.searchBar resignFirstResponder];
    NSLog(@"%s",__func__);
}
@end
