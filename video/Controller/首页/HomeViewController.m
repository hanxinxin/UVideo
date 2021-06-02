//
//  HomeViewController.m
//  video
//
//  Created by nian on 2021/3/10.
//

#import "HomeViewController.h"
#import "ColumnEditViewController.h"
#import "LLSearchResultViewController.h"
#import "LLSearchViewController.h"
#import "VDViewController.h"
#import "HomeTitleView.h"
#import "ZBCycleVerticalView.h"
#import "YZYHorizListView.h"
#import "SearchViewController.h"
#import "MessageViewController.h"

#import "BadgeButton.h"

static NSString *const kCellIdentifier = @"HorizCellIdentifier";
@interface HomeViewController ()<UIScrollViewDelegate,UISearchBarDelegate,ColumnEditViewControllerDelegate,YZYHorizListViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *modelDictionary;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arrayForShow;



@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) HomeTitleView *titleView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) ZBCycleVerticalView * ZBView;

//@property (nonatomic, strong)YZYHorizListView *horizListView;
//@property (nonatomic, strong)NSArray *broadcastArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    self.showMore = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNav];
//    [self PMDLabel];
    [self addPageView];
    
    NSLog(@"kIs_iPhoneX  = %d",kIs_iPhoneX );
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (!_searchBar.isFirstResponder) {
//        [self.searchBar becomeFirstResponder];
//    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 回收键盘
    [self.searchBar resignFirstResponder];
   
}

- (void)initNav {
    self.navigationItem.title= @"首页";
//    self.navBarColor=[UIColor clearColor];
    
    self.hiddenNavBar = NO;
    
    
//    [self addSearch];
    [self addLeft_RightButton];
//
}
//-(void)addSearch
//{
//    self.titleView = [[HomeTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - (80*2), 30)];
////    self.titleView.backgroundColor=[UIColor clearColor];
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = CGRectMake(0, 0, ScreenWidth - (80*2), 30);
//    gl.startPoint = CGPointMake(0.5, 0);
//    gl.endPoint = CGPointMake(0.5, 1);
//    gl.colors = @[(__bridge id)[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
//    gl.locations = @[@(0),@(1.0f)];
//    [self.titleView.layer addSublayer:gl];
//    self.titleView.layer.cornerRadius=15;
//
////    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TitleTouch:)];
////    //设置需要连续点击几次才响应，默认点击1次
////    [tapGesture setNumberOfTapsRequired:1];
////
////    [self.titleView addGestureRecognizer:tapGesture];
////    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
////    _searchBar.userInteractionEnabled=NO;
////    _searchBar.text = _searchStr;
////    _searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
////    _searchBar.delegate = self;
////    _searchBar.tintColor = [UIColor blackColor];
////    _searchBar.layer.cornerRadius=15;
//////    UIView *searchTextField = searchTextField = [self.searchBar valueForKey:@"_searchTextField"];
//////    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
////    NSString *version = [UIDevice currentDevice].systemVersion;
////    if (version.doubleValue >= 13.0) {
////            UIView *searchTextField = searchTextField = [self.searchBar valueForKey:@"_searchTextField"];
////                searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
////        //这里设置相关属性
////    } else {
////        // 这里是对 13.0 以下的iOS系统进行处理
////        UIView *searchTextField = searchTextField = [self.searchBar valueForKey:@"_searchField"];
////        searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
////
////    }
////
////    [self.searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
////    [_titleView addSubview:_searchBar];
//
//    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width, 0, btn.imageView.size.width)];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
//    [btn setTitle:@"请输入关键字" forState:(UIControlStateNormal)];
//    [btn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
//    btn.layer.cornerRadius=15;
//    [btn setTarget:self action:@selector(btnTouch:) forControlEvents:(UIControlEventTouchDown)];
//    [_titleView addSubview:btn];
//    self.navigationItem.titleView = _titleView;
////    self.titleV=_titleView;
//
//
//
//}

//-(void)PMDLabel
//{
//    _broadcastArray = @[@"☂️12312313131",
//                        @"大家上午好哈啊哈哈😝"
//                        ];
//
//    _horizListView = [[YZYHorizListView alloc] initWithFrame: CGRectMake(40, self.navigationItem.titleView.height, [UIScreen mainScreen].bounds.size.width - 80, 40)];
//    _horizListView.listViewDelegate = self;
//    [_horizListView.collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier: kCellIdentifier];
//    [self.titleView addSubview: _horizListView];
//    _horizListView.backgroundColor = [UIColor blueColor];
//    
//    _horizListView.autoScroll = YES;
//    [_horizListView.collectionView reloadData];
//}


-(void)addLeft_RightButton
{
    //两个按钮的父类view
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    //下载按钮
    UIButton *Back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    [Back setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [Back setTitle:@"" forState:(UIControlStateNormal)];
    [Back addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:Back];
    self.leftBtnV=leftButtonView;
    
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //下载按钮
    BadgeButton *historyBtn = [[BadgeButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButtonView addSubview:historyBtn];
    historyBtn.badgeValue=1;
    historyBtn.isRedBall=YES;
    [historyBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(MessageBtnEvent) forControlEvents:UIControlEventTouchUpInside];

//    #pragma mark >>>>>消息按钮
//    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 30, 30)];
//    [rightButtonView addSubview:mainAndSearchBtn];
//    [mainAndSearchBtn setImage:[UIImage imageNamed:@"cpselect"] forState:UIControlStateNormal];
//    [mainAndSearchBtn addTarget:self action:@selector(MessageBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}
-(void)DownLoadBtnEvent
{
    NSLog(@"11111");
}
-(void)MessageBtnEvent
{
    NSLog(@"22222");
    MessageViewController *seachVC = [[MessageViewController alloc] init];
    [self pushRootNav:seachVC animated:YES];
}



-(void)historyBtnEvent
{
    NSLog(@"33333");
}
-(void)TitleTouch:(UITapGestureRecognizer *)gesture
{
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    [self pushRootNav:seachVC animated:YES];
}
-(void)btnTouch:(id)sender
{
    SearchViewController *seachVC = [[SearchViewController alloc] init];
    [self pushRootNav:seachVC animated:YES];
}




- (void)addPageView {
    
    self.modelDictionary = [NSMutableDictionary dictionary];
    // loadData
    [self loadData];
}
/// network request, get cat list
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // network request data ....
        // get local cache
        id array = [[NSUserDefaults standardUserDefaults] objectForKey:@"catlist"];
        self->_arrayForShow = [NSMutableArray arrayWithArray:array];
        // normally, error value is from request
        NSError *error = nil;
        if (!error) {
            NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Untitled1" ofType:@"json"]];
            self->_dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            if (self->_arrayForShow.count == 0) {
                // you can add a custom item, here is all
                self->_arrayForShow = [NSMutableArray arrayWithArray:self->_dataArray];
//                [self->_arrayForShow insertObject:@{@"name" : @"全部", @"code" : @""} atIndex:0];
                // save to local
                [[NSUserDefaults standardUserDefaults] setObject:self->_arrayForShow forKey:@"catlist"];
            }
        }
        // reload
        [self reloadData];
    });
}

#pragma mark - ScrollPageViewControllerProtocol

- (NSArray *)arrayForControllerTitles {
    return [_arrayForShow valueForKeyPath:@"name"];
}

- (NSArray *)arrayForEditAllTitles {
    NSMutableArray *array = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:@{EditTitleKey:obj[@"name"], EditIDKey:obj[@"code"]}];
    }];
    return array;
}

- (NSArray *)arrayForEditTitles {
    NSMutableArray *array = [NSMutableArray array];
    [self.arrayForShow enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:@{EditTitleKey:obj[@"name"], EditIDKey:obj[@"code"]}];
    }];
    return array;
}

-(void)messageHidden
{
    self.horizListViewHidden=YES;
    [self layoutViews];
}
- (UIViewController *)viewcontrollerWithIndex:(NSInteger)index {
    if (index <0 || index > self.arrayForControllerTitles.count) return nil;
//    id model = _arrayForShow[index];
    if(index==0)
    {
        
        VDViewController *vc = [[VDViewController alloc] init];
        if(!vc)
        {
            vc = [VDViewController new];
        }
        
        return vc;
    }else{
        VDViewController *vc = [[VDViewController alloc] init];
        if(!vc)
        {
            vc = [VDViewController new];
        }
        return vc;
    }
    return nil;
}

#pragma mark - ColumnEditViewControllerDelegate

- (void)columnDidEdit:(NSArray *)array {
    if (!array.count) return;
    // this item is "all", sepcial one, we know
    NSDictionary *firstDict = array[0];
    if ([firstDict[EditIDKey] isEqualToString:@""]) {
        [self.arrayForShow removeAllObjects];
        [array enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSLog(@"%@", obj);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"name"] = obj[EditTitleKey];
            dict[@"code"] = obj[EditIDKey];
            [self.arrayForShow addObject:dict];
        }];
        // save to local
        [[NSUserDefaults standardUserDefaults] setObject:_arrayForShow forKey:@"catlist"];
    }
    // remove controler recorder, reload UI
    [self.modelDictionary removeAllObjects];
    [self reloadData];
}



@end
