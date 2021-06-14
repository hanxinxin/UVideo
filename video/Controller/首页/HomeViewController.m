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
#import "WSLWaterFlowLayout.h"
#import "MHYouKuController.h"

#import "videoFenleiMode.h"

#import "vlistCollectionViewCell.h"
#import "BadgeButton.h"
#import "PanView.h"
#define VCellReuseID @"VCellReuseID"
//头部高度
#define headerHeight 225
static NSString *const kCellIdentifier = @"HorizCellIdentifier";



@interface HomeViewController ()<UIScrollViewDelegate,UISearchBarDelegate,ColumnEditViewControllerDelegate,YZYHorizListViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
{
    CGFloat scrollerToRect;
    BOOL menuBool;
}
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

@property (nonatomic, strong) NSMutableArray *VideofenleiList;//菜单分类 数组


@property(strong,nonatomic)UIView * tittleView;
@property(strong,nonatomic)PanView * subView;
@property(strong,nonatomic)NSMutableDictionary  * dataDic;
@property(strong,nonatomic)UICollectionView *collectionView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    self.showMore = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.VideofenleiList=[NSMutableArray arrayWithCapacity:0];
    [self initNav];
//    [self PMDLabel];
    [self addPageView];
    [self.view addSubview:self.subView];
    [self.view addSubview:self.collectionView];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    // 第一次进入则自动加载
    [self.collectionView.mj_header beginRefreshing];
    
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            // 停止刷新
            [self.collectionView.mj_footer endRefreshing];
        });
    }];
    
    
    [self hiddenViewMenu];
    //点击标签后根据标签选择刷新数据
    self.subView.block = ^(NSString *labelText) {
        NSLog(@"====%@",labelText);
    };
//    NSLog(@"kIs_iPhoneX  = %d",kIs_iPhoneX );
    menuBool=NO;
    [self.slideBar slideShowMenuCallBack:^(BOOL show) {
        if(self->menuBool==NO)
        {
            [self addcollectionViewMM];
            self->menuBool=!self->menuBool;
        }else{
            [self hiddenViewMenu];
            self->menuBool=!self->menuBool;
        }
    }];
    
}

-(void)getmenuData
{
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_categoryurl] Dictionary:nil success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        [self.VideofenleiList removeAllObjects];
        
        if([code intValue]==0)
        {
            NSDictionary * datadict = [dict objectForKey:@"data"];
            NSArray * category_list=[datadict objectForKey:@"category_list"];
            for (int i=0; i<category_list.count; i++) {
                videoFenleiMode *model = [videoFenleiMode provinceWithDictionary:category_list[i]];
                [self.VideofenleiList addObject:model];
            }
            
        }else if([code intValue]==20){
            NSString * message = [dict objectForKey:@"message"];
            [UHud showTXTWithStatus:message delay:2.f];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
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
//                self->_arrayForShow = [NSMutableArray arrayWithArray:self->_dataArray];
                
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



#pragma mark --------------   collectionView   --------------

-(void)addcollectionViewMM
{
    
        self.subView.hidden=NO;
        self.collectionView.hidden=NO;
    
//    [self.view addSubview:self.tittleView];
    
}

-(void)hiddenViewMenu
{
    self.subView.hidden=YES;
    self.collectionView.hidden=YES;
}
//点击悬浮框
-(void)tabpAction{
    //滚动到顶部
//    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [UIView animateWithDuration:.5 animations:^{
        self.tittleView.alpha = 0;
        self.subView.frame = CGRectMake(0, 0, self.view.frame.size.width, headerHeight);
    }];
}





-(UICollectionView *)collectionView{
    if (!_collectionView) {
//        _collectionView = [[UIcollectionView alloc]initWithFrame:CGRectMake(0, _subView.bottom, self.view.bounds.size.width, self.view.bounds.size.height-(_subView.height)) style:UIcollectionViewStylePlain];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
        
        WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
        layout.delegate = self;
        layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
        
        // 创建瀑布流view
        UICollectionView *collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.subView.bottom-5, self.view.width-40, self.view.height - self.subView.bottom) collectionViewLayout:layout];
        // 设置数据源
        collectionView1.dataSource = self;
        collectionView1.delegate=self;
        collectionView1.backgroundColor = [UIColor whiteColor];
        // 是否滚动//
        collectionView1.scrollEnabled = YES;
//        [collectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(@0);
//            make.width.mas_equalTo(self.subView.width);
//            make.height.equalTo(@370);
//        }];
        self.collectionView = collectionView1;
        
        // 注册cell
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([vlistCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:VCellReuseID];
        
        
        
    }
    return _collectionView;
}

//控制头部显示
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.subView.frame = CGRectMake(0,  -scrollerToRect, self.view.frame.size.width, self.subView.height);
    NSLog(@"%lf",offsetY);
    if (offsetY > 0 && offsetY < self.subView.height) {
        scrollerToRect = offsetY;
        self.subView.frame = CGRectMake(0,  -scrollerToRect, self.view.frame.size.width, self.subView.height);
        self.collectionView.frame = CGRectMake(0, self.subView.bottom-5, self.view.width, self.view.bounds.size.height - self.subView.height + offsetY+5);
//        self.collectionView.frame = CGRectMake(0, self.subView.bottom, self.view.bounds.size.width, self.view.bounds.size.height - self.subView.height + offsetY);
        if (offsetY>140) {
            if (self.subView.height - offsetY  <= 105) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.tittleView.alpha = 1.0 - (self.subView.height - offsetY)/105;
                }];
            }else{
                self.tittleView.alpha = 1;
            }
        }
    }else if(offsetY<=0) {
        self.subView.frame = CGRectMake(0, self.slideBar.bottom, self.view.frame.size.width, self.subView.height);
        self.collectionView.frame = CGRectMake(0, self.subView.bottom-5, self.view.width, self.view.height - self.subView.bottom+5);
        self.tittleView.alpha = 0;
    }else{
        self.tittleView.alpha = 1;
    }
}
-(UIView *)tittleView{
    if (!_tittleView) {
        _tittleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _tittleView.backgroundColor = [UIColor grayColor];
        _tittleView.alpha = 0;
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 10, 100, 30)];
        [button setTitle:@"综合排序" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(tabpAction) forControlEvents:UIControlEventTouchUpInside];
        [_tittleView addSubview:button];
    }
    return _tittleView;
}
-(PanView *)subView{
    if (!_subView) {
        _subView = [[PanView alloc]initWithFrame:CGRectMake(0, self.slideBar.height, self.view.frame.size.width, headerHeight) WithTextDic:self.dataDic];
    }
    return _subView;
}
-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        //制造假数据
        _dataDic = [NSMutableDictionary dictionary];
        [_dataDic setValue:@[@"综合排序",@"热播榜",@"好评榜",@"新上线"] forKey:@"1"];
        [_dataDic setValue:@[@"全部地区",@"华语",@"香港地区",@"美国",@"欧洲",@"韩国",@"日本",@"泰国"] forKey:@"2"];
        [_dataDic setValue:@[@"全部类型",@"喜剧",@"爱情",@"动作",@"抢占",@"犯罪",@"伦理",@"色情"] forKey:@"3"];
        [_dataDic setValue:@[@"全部规格",@"巨制",@"院线",@"独播",@"网络大电影",@"经典",@"杜比",@"电影节目"] forKey:@"4"];
        [_dataDic setValue:@[@"全部年份",@"2019",@"2018",@"2017",@"2016",@"2015",@"2000",@"1900"] forKey:@"5"];
        [_dataDic setValue:@[@"是否付费",@"免费",@"付费"] forKey:@"6"];
    }return _dataDic;
}





#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 14;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    vlistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VCellReuseID forIndexPath:indexPath];
    
    
    
    
    // 返回cell
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择第%ld素材",indexPath.item);
    
    MHYouKuController *avc = [[MHYouKuController alloc] init];
    [self pushRootNav:avc animated:YES];
    
}

#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        return CGSizeMake(106, 156);
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 3;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 15;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 10;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(15, 15, 15, 15);
}



@end
