//
//  SearchViewController.m
//  video
//
//  Created by nian on 2021/3/10.
//

#import "SearchViewController.h"
#import "LLSearchViewController.h"
#import "LLSearchResultViewController.h"
#import "LLSearchSuggestionVC.h"
#import "LLSearchView.h"
@interface SearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) LLSearchView *searchView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) LLSearchSuggestionVC *searchSuggestVC;

@end

@implementation SearchViewController


- (NSMutableArray *)hotArray
{
    if (!_hotArray) {
        self.hotArray = [NSMutableArray arrayWithObjects:@"悦诗风吟", @"洗面奶", @"兰芝", @"面膜", @"篮球鞋", @"阿迪达斯", @"耐克", @"运动鞋", nil];
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
        __weak SearchViewController *weakSelf = self;
        _searchView.tapAction = ^(NSString *str) {
            [weakSelf pushToSearchResultWithSearchStr:str];
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
        __weak SearchViewController *weakSelf = self;
        _searchSuggestVC.searchBlock = ^(NSString *searchTest) {
            [weakSelf pushToSearchResultWithSearchStr:searchTest];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hiddenLeftBtn = YES;
    self.navBarColor=[UIColor whiteColor];
    
    [self setBarButtonItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.searchSuggestVC.view];
    [self addChildViewController:_searchSuggestVC];
}


- (void)setBarButtonItem
{
    [self.navigationItem setHidesBackButton:YES];
    //去除导航栏下方的横线
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                      forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navBarColor=[UIColor colorWithRed:211/255.0 green:236/255.0 blue:249/255.0 alpha:0.9];
    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, self.view.frame.size.width, 40)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(69, 0, CGRectGetWidth(titleView.frame) - 85, 30)];
    searchBar.placeholder = @"请输入关键字";
//    searchBar.backgroundImage = [UIImage imageNamed:@"guideImage_button_backgound"];
//    searchBar.backgroundColor=[UIColor whiteColor];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 13.0) {
        //        UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchField"];
        UITextField *searchTextField = searchTextField = [searchBar valueForKey:@"_searchTextField"];
                searchTextField.backgroundColor = [UIColor whiteColor];
        searchTextField.leftView=nil;
        //这里设置相关属性
    } else {
        // 这里是对 13.0 以下的iOS系统进行处理
        UITextField *searchTextField = searchTextField = [searchBar valueForKey:@"_searchField"];
//    UIView *searchTextField = searchTextField = [searchBar valueForKey:@"_searchTextField"];
        searchTextField.backgroundColor = [UIColor whiteColor];
        searchTextField.leftView=nil;
    }
    
//    [searchBar setImage:[UIImage imageNamed:@"sort_magnifier"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //修改标题和标题颜色
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    
    UIButton *Back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 25)];
    [Back setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [Back addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:Back];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self addLeft_RightButton];
}

-(void)addLeft_RightButton
{
    //下载按钮
    UIButton *Back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 25)];
    [Back setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [Back addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:Back];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}


-(void)historyBtnEvent
{
    NSLog(@"ssss 33333");
}

- (void)presentVCFirstBackClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/** 点击取消 */
- (void)cancelDidClick
{
//    [self.searchBar resignFirstResponder];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
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
    [self pushToSearchResultWithSearchStr:searchBar.text];
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
    } else {
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    }
}


@end
