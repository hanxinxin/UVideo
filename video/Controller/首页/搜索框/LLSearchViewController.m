//
//  LLSearchViewController.m
//  LLSearchView
//
//  Created by mac on 2021/6/1.
//  Copyright © 2021年 mac. All rights reserved.
//

#import "LLSearchViewController.h"
#import "LLSearchResultViewController.h"
#import "LLSearchSuggestionVC.h"
#import "LLSearchView.h"


@interface LLSearchViewController ()<UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) LLSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) LLSearchSuggestionVC *searchSuggestVC;

@end

@implementation LLSearchViewController

- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        self.hotArray=[NSMutableArray arrayWithCapacity:0];
//        self.hotArray = [NSMutableArray arrayWithObjects:@"悦诗风吟", @"洗面奶", @"兰芝", @"面膜", @"篮球鞋", @"阿迪达斯", @"耐克", @"运动鞋", nil];
    }
    return _hotArray;
}

- (NSMutableArray *)historyArray
{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}


- (LLSearchView *)searchView
{
    if (!_searchView) {
        self.searchView = [[LLSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT -(kNavBarAndStatusBarHeight)) hotArray:self.hotArray historyArray:self.historyArray];
        __weak LLSearchViewController *weakSelf = self;
        _searchView.tapAction = ^(NSString *str) {
//            [weakSelf pushToSearchResultWithSearchStr:str];
            weakSelf.searchBar.text = str;
            weakSelf.searchSuggestVC.view.hidden = NO;
            [weakSelf.view bringSubviewToFront:weakSelf.searchSuggestVC.view];
            [weakSelf.searchSuggestVC searchTestChangeWithTest:str];
            [weakSelf setHistoryArrWithStr:str];
        };
    }
    return _searchView;
}


- (LLSearchSuggestionVC *)searchSuggestVC
{
    if (!_searchSuggestVC) {
        self.searchSuggestVC = [[LLSearchSuggestionVC alloc] init];
        _searchSuggestVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT - (kNavBarAndStatusBarHeight));
        _searchSuggestVC.view.hidden = YES;
        __weak LLSearchViewController *weakSelf = self;
        _searchSuggestVC.searchBlock = ^(NSString *searchTest) {
//            [weakSelf pushToSearchResultWithSearchStr:searchTest];
            
            [weakSelf.searchSuggestVC searchTestChangeWithTest:searchTest];
            [weakSelf setHistoryArrWithStr:searchTest];
        };
    }
    return _searchSuggestVC;
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 回收键盘
    [self.searchBar resignFirstResponder];
    _searchSuggestVC.view.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getvideo_rankurlData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarButtonItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.searchSuggestVC.view];
    [self addChildViewController:_searchSuggestVC];
    
}


- (void)setBarButtonItem
{
    [self.navigationItem setHidesBackButton:YES];
    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width, 30)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 15, 30)];
    searchBar.placeholder = @"搜索内容";
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 13.0) {
        //        UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchField"];
            UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchTextField"];
                searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
        //这里设置相关属性
    } else {
        // 这里是对 13.0 以下的iOS系统进行处理
        UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchField"];
//    UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchTextField"];
        searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
        
    }
    
    [searchBar setImage:[UIImage imageNamed:@"sort_magnifier"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //修改标题和标题颜色
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}


- (void)presentVCFirstBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/** 点击取消 */
- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)pushToSearchResultWithSearchStr:(NSString *)str
{
    self.searchBar.text = str;
    LLSearchResultViewController *searchResultVC = [[LLSearchResultViewController alloc] init];
    searchResultVC.searchStr = str;
    searchResultVC.hotArray = _hotArray;
    searchResultVC.historyArray = _historyArray;
    [self.navigationController pushViewController:searchResultVC animated:YES];
    [self setHistoryArrWithStr:str];
}

- (void)setHistoryArrWithStr:(NSString *)str
{
    for (int i = 0; i < _historyArray.count; i++) {
        if ([_historyArray[i] isEqualToString:str]) {
            [_historyArray removeObjectAtIndex:i];
            break;
        }
    }
    [_historyArray insertObject:str atIndex:0];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
}


#pragma mark - UISearchBarDelegate -


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [self pushToSearchResultWithSearchStr:searchBar.text];
    [searchBar resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    [self setHistoryArrWithStr:searchBar.text];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        _searchSuggestVC.view.hidden = YES;
        [self.view bringSubviewToFront:_searchView];
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHistorySearchPath];
        self.searchView.historyArray=_historyArray;
        [self.searchView updatesearchHistoryView];
    } else {
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        ///边输入边搜索 停止只有搜索按钮才开始搜索
//        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    }
}

-(void)getvideo_rankurlData
{
//    NSDictionary * dict = @{@"parent_category_id":@""};
//    [UHud showHUDLoading];
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_rankurl] Dictionary:nil success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        [self.hotArray removeAllObjects];
        if([code intValue]==0)
        {
            
            NSDictionary * datadict = [dict objectForKey:@"data"];
            NSArray * video_rank_list = [datadict objectForKey:@"video_rank_list"];
            for (int i=0; i<video_rank_list.count; i++) {
//                NSDictionary * video_rankdata=video_rank_list[i];
//                //直接放到网络请求结果调用，生成模型后删除就行，结果打印在控制台
//                [DYModelMaker DY_makeModelWithDictionary:video_rankdata modelKeyword:@"Video" modelName:@"RankMode"];
//                [VideoRankMode mj_replacedKeyFromPropertyName];
//                VideoRankMode *model=[[VideoRankMode alloc] init];
                // 将数据转模型
                VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_rank_list[i]];
//                VideoRankMode *model = [VideoRankMode provinceWithDictionary:video_rank_list[i]];
                [self.hotArray addObject:model];
                self->_searchView.hotArray=self.hotArray;
                [self.searchView.Downtableview reloadData];
            }
//            [self.hotArray addObject:@""];
        }else{
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            NSNumber * error = [dict objectForKey:@"error"];
            if([error intValue]!=21)
            {
                [UHud showTXTWithStatus:message delay:2.f];
            }else
            {
                if(![usertoken isEqualToString:@""])
                {
                    [UHud showTXTWithStatus:message delay:2.f];
                }
            }
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
    // 回收键盘
    [self.searchBar resignFirstResponder];
}
@end
