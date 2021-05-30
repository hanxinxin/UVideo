//
//  VDViewController.m
//  video
//
//  Created by nian on 2021/3/11.
//

#import "VDViewController.h"
#import "JRShop.h"
#import "JRShopCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "JRWaterFallLayout.h"
#import "SHeaderView.h"
#import "WSLWaterFlowLayout.h"
#import "MSCycleScrollView.h"
#import "MHViewController.h"
#import "MHYouKuController.h"


// collectionViewCell的重用标识符
static NSString * const shopCellReuseID = @"shop";
@interface VDViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate, JRWaterFallLayoutDelegate,WSLWaterFlowLayoutDelegate,MSCycleScrollViewDelegate>
/** 滑动底部 ScrollView */
@property (nonatomic, weak) UIScrollView *ZScrollView;

/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView1;
/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView2;
/** shops */
@property (nonatomic, strong) NSMutableArray *shops;

/** 包含瀑布流view */
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation VDViewController
- (NSMutableArray *)shops
{
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView * scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    scrollview.backgroundColor = [UIColor whiteColor];
    scrollview.scrollsToTop = NO;

    scrollview.delegate =self;
    // 设置内容大小
//    scrollview.contentSize =CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT*2);
    // 是否反弹//
    scrollview.bounces = NO;
    // 是否分页//
    scrollview.pagingEnabled = NO;
    // 是否滚动//
    scrollview.scrollEnabled = YES;
    scrollview.contentSize =CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT+30+60) ;
    scrollview.tag=1000;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollview];
    self.ZScrollView=scrollview;
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(@0);
        
    }];
    ///包含瀑布流view
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(15, 160+70, self.ZScrollView.width-30, self.ZScrollView.height-160-70)];
    view.backgroundColor=[UIColor whiteColor];
    
    [self.ZScrollView addSubview:view];
    
    
    self.bottomView=view;
    
    // 设置当前页码为0
    self.currentPage = 0;
    //加载轮播图
    [self addScrollviewLB];
    // 初始化瀑布流view
    [self setupCollectionView1];
    [self setupCollectionView2];
}
-(void)addScrollviewLB
{
//    // 情景一：采用本地图片实现
//    NSArray *imageNames = @[@"timg5.jpeg",
//                            @"timg6.jpeg",
//                            @"timg7.jpeg",
//                            @"timg8.jpeg",
//                            @"timg9.jpeg",// 本地图片请填写全名
//                            ];
//    // 本地加载 --- 创建不带标题的图片轮播器
//    MSCycleScrollView *cycleScrollView = [MSCycleScrollView cycleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160) InfiniteLoop:YES locationImageNames:imageNames];
//    cycleScrollView.delegate = self;
//    cycleScrollView.pageDotColor = [UIColor blueColor];
//    cycleScrollView.currentPageDotColor = [UIColor yellowColor];
//    cycleScrollView.dotsIsSquare = YES;
//    cycleScrollView.currentWidthMultiple = 3;
////    cycleScrollView5.pageControlDotSize = CGSizeMake(6, 5);
//    [self.ZScrollView addSubview:cycleScrollView];
//    //指定Index
//    [cycleScrollView makeScrollViewScrollToIndex:2];
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://weiliicimg9.pstatp.com/weili/l/378983035183038486.webp",
                                  @"https://icweiliimg1.pstatp.com/weili/l/446936813792919821.webp",
                                  @"https://icweiliimg1.pstatp.com/weili/l/446936813792919821.webp",
                                  @"https://weiliicimg9.pstatp.com/weili/l/454268675154510337.webp",
                                  ];
    // 网络加载 --- 创建带标题的图片轮播器
    MSCycleScrollView *cycleScrollView7 = [MSCycleScrollView cycleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView7.pageDotColor = [UIColor whiteColor];
    cycleScrollView7.currentPageDotColor = [UIColor purpleColor];
    cycleScrollView7.dotBorderWidth = 1;
    cycleScrollView7.dotBorderColor = [UIColor whiteColor];
    cycleScrollView7.currentDotBorderColor =RGB(0, 174, 232);
    cycleScrollView7.currentDotBorderWidth = 5;
    cycleScrollView7.dotsIsSquare = YES;
    cycleScrollView7.pageControlDotSize = CGSizeMake(20, 4);
    [self.ZScrollView addSubview:cycleScrollView7];
    
    cycleScrollView7.imageUrls = imagesURLStrings;
    
    /*
     block监听点击方式
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
     NSLog(@">>>>>  %ld", (long)index);
     };
     */
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 165, self.bottomView.width, 60)];
    [imageview setImage:[UIImage imageNamed:@"kthuiyuan"]];
//    imageview.backgroundColor=[UIColor redColor];
    [self.ZScrollView addSubview:imageview];
    
}
- (void)setupCollectionView1
{
    
    
    // 创建瀑布流layout
//    JRWaterFallLayout *layout = [[JRWaterFallLayout alloc] init];
//    // 设置代理
//    layout.delegate = self;
    WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    // 创建瀑布流view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.tag=2001;
    // 是否滚动//
    collectionView.scrollEnabled = NO;
    [self.bottomView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.width.mas_equalTo(self.bottomView.width);
        make.height.equalTo(@370);
    }];
    self.collectionView1 = collectionView;
    
    // 注册cell
    [self.collectionView1 registerNib:[UINib nibWithNibName:NSStringFromClass([JRShopCell class]) bundle:nil] forCellWithReuseIdentifier:shopCellReuseID];
    [self.collectionView1 registerClass:[SHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
//    [self.collectionView1 registerNib:[UINib nibWithNibName:NSStringFromClass([SHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.collectionView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            
            [self getDataList_header1];
        });
    }];
    // 第一次进入则自动加载
    [self.collectionView1.mj_header beginRefreshing];
    
    
    self.collectionView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            [self getDataList_footer1];
            
        });
    }];
    
}

-(void)setupCollectionView2
{
    // 创建瀑布流layout
//    JRWaterFallLayout *layout = [[JRWaterFallLayout alloc] init];
//    // 设置代理
//    layout.delegate = self;
    WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    // 创建瀑布流view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.tag=2002;
    // 是否滚动//
    collectionView.scrollEnabled = NO;
    [self.bottomView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView1.mas_bottom).offset(8);
        make.width.mas_equalTo(self.bottomView.width);
        make.height.equalTo(@370);
    }];
    self.collectionView2 = collectionView;
    
    // 注册cell
    [self.collectionView2 registerNib:[UINib nibWithNibName:NSStringFromClass([JRShopCell class]) bundle:nil] forCellWithReuseIdentifier:shopCellReuseID];
    [self.collectionView2 registerClass:[SHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView2"];
//    [self.collectionView2 registerNib:[UINib nibWithNibName:NSStringFromClass([SHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView2"];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.collectionView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            
            [self getDataList_header2];
        });
    }];
    // 第一次进入则自动加载
    [self.collectionView2.mj_header beginRefreshing];
    
    
    self.collectionView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            [self getDataList_footer2];
            
        });
    }];
    
    //更新 scrollview 滑动
    self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, self.collectionView2.bottom+kNavAndTabHeight+140) ;
}


-(void)getDataList_header1
{
    // 清空数据
    [self.shops removeAllObjects];
    
    [self.shops addObjectsFromArray:[self newShops]];
    
    // 刷新数据
    [self.collectionView1 reloadData];
    
    // 停止刷新
    [self.collectionView1.mj_header endRefreshing];
}
-(void)getDataList_footer1
{
    // 刷新数据
    [self.collectionView1 reloadData];
    
    // 停止刷新
    [self.collectionView1.mj_footer endRefreshing];
}


-(void)getDataList_header2
{
    // 清空数据
    [self.shops removeAllObjects];
    
    [self.shops addObjectsFromArray:[self newShops]];
    
    // 刷新数据
    [self.collectionView2 reloadData];
    
    // 停止刷新
    [self.collectionView2.mj_header endRefreshing];
}
-(void)getDataList_footer2
{
    // 刷新数据
    [self.collectionView2 reloadData];
    
    // 停止刷新
    [self.collectionView2.mj_footer endRefreshing];
}

#pragma mark - 内部方法
- (NSArray *)newShops
{
    return [JRShop mj_objectArrayWithFilename:@"0.plist"];
}

- (NSArray *)moreShopsWithCurrentPage:(NSUInteger)currentPage
{
    // 页码的判断
    if (currentPage == 3) {
//        self.currentPage = 0;
        
            return nil;
        
    } else {
        self.currentPage++;
    }
    
    NSString *nextPage = [NSString stringWithFormat:@"%lu.plist", self.currentPage];
    
    return [JRShop mj_objectArrayWithFilename:nextPage];
}


#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    JRShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellReuseID forIndexPath:indexPath];
    
    // 给cell传递模型
    JRShop *shop1=self.shops[indexPath.row];
    shop1.price=[NSString stringWithFormat:@"使用素材%ld",indexPath.row];
    cell.shop = shop1;
    
    
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
    
        return CGSizeMake((self.bottomView.width-40)/2, 169);
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(self.bottomView.width, 40);
}


/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 2;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    if (waterFlowLayout.flowLayoutStyle == (WSLWaterFlowLayoutStyle)3){
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag==2001)
    {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1" forIndexPath:indexPath];
        // if (self.dataArr.count == 0) return view; 这里之前没有注意，直接return view 的话 刷新会看到这个view，通过下面处理就行了。
//        if (self.shops.count == 0){
            view.backgroundColor = [UIColor clearColor];
            [view.leftLabel setText:@"电视剧"];
//            if(indexPath.section==0)
//            {
//                [view.leftLabel setText:@"电视剧"];
//            }else if(indexPath.section==1)
//            {
//                [view.leftLabel setText:@"电影"];
//            }
            return view;
//        }
        }
  
    }else if(collectionView.tag==2002)
    {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            SHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView2" forIndexPath:indexPath];
            // if (self.dataArr.count == 0) return view; 这里之前没有注意，直接return view 的话 刷新会看到这个view，通过下面处理就行了。
//            if (self.shops.count == 0){
                view.backgroundColor = [UIColor clearColor];
                [view.leftLabel setText:@"电影"];
                return view;
//            }
        }
    }
    return nil;
}



#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(MSCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
//    [self.navigationController pushViewController:[ViewController new] animated:YES];
}



@end
