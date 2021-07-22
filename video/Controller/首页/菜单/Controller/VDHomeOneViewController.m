//
//  VDHomeOneViewController.m
//  video
//
//  Created by macbook on 2021/7/22.
//

#import "VDHomeOneViewController.h"
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
#import "YYWebImage.h"
#import "bannerMode.h"

#import "TestWebViewController.h"
#import "GuanggaoMode.h"


#define homeOneTableViewCellID @"homeOneTableViewCellID"

// collectionViewCell的重用标识符
static NSString * const shopCellReuseID = @"shop";
@interface VDHomeOneViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, JRWaterFallLayoutDelegate,WSLWaterFlowLayoutDelegate,MSCycleScrollViewDelegate>
{
    CGFloat scrollerToRect;
}
/** 滑动底部 ScrollView */
@property (nonatomic, weak) UIScrollView *ZScrollView;
/** Top包含瀑布流view */
@property (nonatomic, weak) UIView *TopView;
/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView1;
/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView2;


@property (nonatomic, strong) NSMutableArray *bannerimagesmode;///轮播图mode数组
@property (nonatomic, strong) NSMutableArray *bannerimagesURL;//轮播图url


/** 包含瀑布流view */
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong)MSCycleScrollView *cycleScrollView;


@property (nonatomic, strong) YYAnimatedImageView* guanggaoImageView;
@property (nonatomic, strong)GuanggaoMode*GuanggaoModeA;

/** 瀑布流view */
@property (nonatomic, strong) UITableView *DowntableView;
@property (nonatomic, strong) NSMutableArray *VideoDictList;//菜单分类 数组


@end

@implementation VDHomeOneViewController
- (NSMutableArray *)shopsDS
{
    if (_shopsDS == nil) {
        _shopsDS = [NSMutableArray array];
    }
    return _shopsDS;
}
- (NSMutableArray *)shopsDY
{
    if (_shopsDY == nil) {
        _shopsDY = [NSMutableArray array];
    }
    return _shopsDY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bannerimagesURL=[NSMutableArray arrayWithCapacity:0];
    self.bannerimagesmode=[NSMutableArray arrayWithCapacity:0];
    
    self.VideoDictList=[NSMutableArray arrayWithCapacity:0];
    UIScrollView * scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight)];
    scrollview.backgroundColor = [UIColor whiteColor];
    scrollview.scrollsToTop = NO;

    scrollview.delegate =self;
    // 设置内容大小
//    scrollview.contentSize =CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT*2);
    // 是否反弹//
    scrollview.bounces = YES;
    // 是否分页//
    scrollview.pagingEnabled = NO;
    // 是否滚动//
    scrollview.scrollEnabled = YES;
    scrollview.contentSize =CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT+30+60-kNavAndTabHeight) ;
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
    
//    // 为ScrollView添加下拉加载
    self.ZScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataList_header1];
        [self getDataList_header2];
    }];
    [self.ZScrollView.mj_header beginRefreshing];
    UIView * topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ZScrollView.width, 175+70)];
    topV.backgroundColor=[UIColor whiteColor];
    [self.ZScrollView addSubview:topV];
    self.TopView =topV;
    ///包含瀑布流view
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 175+70, self.ZScrollView.width, 60+490+490)];
    view.backgroundColor=[UIColor whiteColor];
    
    [self.ZScrollView addSubview:view];
    
    
    self.bottomView=view;
    
    // 设置当前页码为0
    self.currentPage = 0;
    //加载轮播图
    [self addScrollviewLB];
    // 初始化瀑布流view
    [self setupDowntableView];
//    [self setupCollectionView1];
//    [self setupCollectionView2];
    [self getbannerData];
//    [self getmenuData];
    [self getGuanggao_data];
}
-(void)getGuanggao_data
{
    NSDictionary *dict =@{
        @"symbol":@"mobile-home-banner-below",
        @"result":@"1",
    };
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,guanggaoGDurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary * datadict = [dict objectForKey:@"data"];
            NSDictionary * dataAD = [datadict objectForKey:@"ad"];
//            [DYModelMaker DY_makeModelWithDictionary:dataAD modelKeyword:@"Guanggao" modelName:@"Mode"];
            self.GuanggaoModeA=[GuanggaoMode yy_modelWithDictionary:dataAD];
//            NSString * urlstr = [dataAD objectForKey:@"source"];
            if(self.GuanggaoModeA)
            {
            self.guanggaoImageView.yy_imageURL=[NSURL URLWithString:self.GuanggaoModeA.source];
            }
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showTXTWithStatus:message delay:2.f];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
    
    
}
-(void)getbannerData
{
    NSDictionary * dict = @{@"platform":@"2"}; ///|platform|是|number||平台[1=pc 2=移动]|
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,getbannerurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        [self.bannerimagesURL removeAllObjects];
        [self.bannerimagesmode removeAllObjects];
        if([code intValue]==0)
        {
            NSDictionary * datadict = [dict objectForKey:@"data"];
            NSArray * banner_list=[datadict objectForKey:@"banner_list"];
            for (int i=0; i<banner_list.count; i++) {
                bannerMode *model = [bannerMode provinceWithDictionary:banner_list[i]];
                [self.bannerimagesmode addObject:model];
                [self.bannerimagesURL addObject:model.source];
            }
            self.cycleScrollView.imageUrls = self.bannerimagesURL;
        }else if([code intValue]==20){
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            [UHud showTXTWithStatus:message delay:2.f];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}
-(void)getmenuData
{
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_categoryurl] Dictionary:nil success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        
        if([code intValue]==0)
        {
            [self.VideoDictList removeAllObjects];
            NSDictionary * datadict = [dict objectForKey:@"data"];
            NSArray * category_list=[datadict objectForKey:@"category_list"];
//            if(category_list.count>0)
//            {
//                NSDictionary * zdy = @{@"icon":@"",
//                                       @"id":@(0),
//                                       @"name":@"全部",
//                                       @"pid":@(0),
//                                       @"show":@(1),};
//                [self.VideoDictList addObject:zdy];
//            }
            for (int i=0; i<category_list.count; i++) {
//                videoFenleiMode *model = [videoFenleiMode provinceWithDictionary:category_list[i]];
//                [self.VideofenleiList addObject:model];
                NSDictionary * dictM = category_list[i];
                NSNumber*show=[dictM objectForKey:@"show"];
                if([show intValue]==1)
                {
                    ///以前默认展示8个 全部展示
//                    if(i<=8)
//                    {
                        [self.VideoDictList addObject:dictM];
//                    }
                }
            }
            
            if(self.VideoDictList.count>0)
            {
                [self.DowntableView reloadData];
            }
            // 第一次进入则自动加载
            [self.DowntableView.mj_header endRefreshing];
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showTXTWithStatus:message delay:2.f];
            // 第一次进入则自动加载
            [self.DowntableView.mj_header endRefreshing];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        // 第一次进入则自动加载
        [self.DowntableView.mj_header endRefreshing];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"加载失败" delay:2.f];
    }];
}




-(void)addScrollviewLB
{
    // 网络加载 --- 创建带标题的图片轮播器
    MSCycleScrollView *cycleScrollView7 = [MSCycleScrollView cycleViewWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 160) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView7.pageDotColor = [UIColor whiteColor];
    cycleScrollView7.currentPageDotColor = [UIColor purpleColor];
    cycleScrollView7.dotBorderWidth = 1;
    cycleScrollView7.dotBorderColor = [UIColor whiteColor];
    cycleScrollView7.currentDotBorderColor =RGB(0, 174, 232);
    cycleScrollView7.currentDotBorderWidth = 5;
    cycleScrollView7.dotsIsSquare = NO;
    cycleScrollView7.spacingBetweenDots=4;
    cycleScrollView7.pageControlRightOffset=-(cycleScrollView7.width-250);
    cycleScrollView7.pageControlDotSize = CGSizeMake(8, 8);
    cycleScrollView7.backgroundColor=[UIColor clearColor];
    [self.TopView addSubview:cycleScrollView7];
    self.cycleScrollView =cycleScrollView7;
    
    cycleScrollView7.imageUrls = self.bannerimagesURL;
    
    /*
     block监听点击方式
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
     NSLog(@">>>>>  %ld", (long)index);
     };
     */
    YYAnimatedImageView * imageview = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(15, 175, self.bottomView.width-30, 60)];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius=8;
    if(self.GuanggaoModeA==nil)
    {
    [imageview setImage:[UIImage imageNamed:@"kthuiyuan"]];
    }
    
    imageview.userInteractionEnabled = YES;//打开用户交互
    //创建手势识别器对象
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];

    //设置手势识别器对象的具体属性
    // 连续敲击2次
    tap.numberOfTapsRequired = 1;
    // 需要2根手指一起敲击
    tap.numberOfTouchesRequired = 1;

    //添加手势识别器到对应的view上
    [imageview addGestureRecognizer:tap];

    //监听手势的触发
    [tap addTarget:self action:@selector(postWebView:)];
    self.guanggaoImageView=imageview;
    [self.TopView addSubview:imageview];
    
}

-(void)postWebView:(UITapGestureRecognizer*)tap
{
    if(self.GuanggaoModeA)
    {
//        TestWebViewController *webVC = [[TestWebViewController alloc] initWithURLString:self.GuanggaoModeA.url];
////        [self.navigationController pushViewController:webVC animated:YES];
//        [self pushRootNav:webVC animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.GuanggaoModeA.url]];

        
    }
}
-(void)setupDowntableView
{
    self.DowntableView=[[UITableView alloc] init];
    self.DowntableView.frame=CGRectMake(0, 0, SCREEN_WIDTH-40,500);
    self.DowntableView.backgroundColor=[UIColor whiteColor];
    self.DowntableView.delegate=self;
    self.DowntableView.dataSource=self;
    self.DowntableView.tag=10001;
    self.DowntableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.DowntableView.tableFooterView = [[UIView alloc]init];
    self.DowntableView.scrollEnabled=NO;
    [self.bottomView addSubview:self.DowntableView];
    [self.DowntableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.width.mas_equalTo(self.bottomView.width);
        make.height.equalTo(self.bottomView);
    }];
//    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.DowntableView registerNib:[UINib nibWithNibName:NSStringFromClass([homeOneTableViewCell class]) bundle:nil] forCellReuseIdentifier:homeOneTableViewCellID];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.DowntableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getheaderData1];
    }];
    // 第一次进入则自动加载
    [self.DowntableView.mj_header beginRefreshing];
    
    
//    self.DowntableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self getfootData1];
//    }];
}
-(void)getheaderData1
{
    
    [self getmenuData];
}
-(void)getfootData1
{
    
//    [self getmenuData];
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
        make.height.equalTo(@490);
    }];
    self.collectionView1 = collectionView;
    
    // 注册cell
    [self.collectionView1 registerNib:[UINib nibWithNibName:NSStringFromClass([JRShopCell class]) bundle:nil] forCellWithReuseIdentifier:shopCellReuseID];
    [self.collectionView1 registerClass:[SHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
//    [self.collectionView1 registerNib:[UINib nibWithNibName:NSStringFromClass([SHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.collectionView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
            [self getDataList_header1];
    }];
    // 第一次进入则自动加载
//    [self.collectionView1.mj_header beginRefreshing];
    
    
    self.collectionView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getDataList_footer1];
            
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
        make.height.equalTo(@490);
    }];
    self.collectionView2 = collectionView;
    
    // 注册cell
    [self.collectionView2 registerNib:[UINib nibWithNibName:NSStringFromClass([JRShopCell class]) bundle:nil] forCellWithReuseIdentifier:shopCellReuseID];
    [self.collectionView2 registerClass:[SHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView2"];
//    [self.collectionView2 registerNib:[UINib nibWithNibName:NSStringFromClass([SHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView2"];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.collectionView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
 
            [self getDataList_header2];
    }];
    // 第一次进入则自动加载
//    [self.collectionView2.mj_header beginRefreshing];
    
    
    self.collectionView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getDataList_footer2];
            
    }];
    
    //更新 scrollview 滑动
    self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, 175+70+self.bottomView.height+10);
//    self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, 160+70+960+50);
}


-(void)getDataList_header1
{
    // 清空数据
    
    NSDictionary*dict =nil;
    if(_SelectIndex==0)
    {
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%@",@(100)],
                 @"page":[NSString stringWithFormat:@"%@",@(1)],
                 @"pagesize":[NSString stringWithFormat:@"%@",@(6)]
        };
    }else{
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%f",_FenleiMode.id],
                 @"page":[NSString stringWithFormat:@"%@",@(1)],
                 @"pagesize":[NSString stringWithFormat:@"%@",@(10)],};
    }
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_listurl] Dictionary:dict success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    
                        NSDictionary  * dataArr = [dict objectForKey:@"data"];
                        // 清空数据
                        [self.shopsDS removeAllObjects];
                        NSMutableArray* arr=[NSMutableArray arrayWithCapacity:0];
                        NSArray * video_list = [dataArr objectForKey:@"video_list"];
                    if(![video_list isKindOfClass:[NSNull class]]){
                    if(video_list.count>0)
                    {
                        for (int i=0; i<video_list.count; i++) {
                            
                            VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_list[i]];
                            [arr addObject:model];
                            
                        }
                        [self.shopsDS addObjectsFromArray:arr];
                    }
                    }
                        // 刷新数据
                        [self.collectionView1 reloadData];
                    
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                }
        
        // 停止刷新
        [self.collectionView1.mj_header endRefreshing];
        [self.ZScrollView.mj_header endRefreshing];
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                // 停止刷新
                [self.collectionView1.mj_header endRefreshing];
                [self.ZScrollView.mj_header endRefreshing];
            }];
    
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
    
    
//    [self.shopsDY addObjectsFromArray:[self newShops]];
    NSDictionary*dict =nil;
    if(_SelectIndex==0)
    {
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%@",@(101)],
                 @"page":[NSString stringWithFormat:@"%@",@(1)],
                 @"pagesize":[NSString stringWithFormat:@"%@",@(6)]
        };
    }else{
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%f",_FenleiMode.id],
                 @"page":[NSString stringWithFormat:@"%@",@(1)],
                 @"pagesize":[NSString stringWithFormat:@"%@",@(10)],};
    }
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_listurl] Dictionary:dict success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    NSDictionary  * dataArr = [dict objectForKey:@"data"];
                    // 清空数据
                    [self.shopsDY removeAllObjects];
                    NSMutableArray* arr=[NSMutableArray arrayWithCapacity:0];
                    NSArray * video_list = [dataArr objectForKey:@"video_list"];
                    if(![video_list isKindOfClass:[NSNull class]]){
                    if(video_list.count>0)
                    {
                    for (int i=0; i<video_list.count; i++) {
                        
                        VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_list[i]];
                        [arr addObject:model];
                        
                    }
                    [self.shopsDY addObjectsFromArray:arr];
                    }
                    }
                    // 刷新数据
                    [self.collectionView2 reloadData];
                    
                   
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                }
        
        // 停止刷新
        [self.collectionView2.mj_header endRefreshing];
        [self.ZScrollView.mj_header endRefreshing];
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                
                // 停止刷新
                [self.collectionView2.mj_header endRefreshing];
                [self.ZScrollView.mj_header endRefreshing];
            }];
    
    
    
}
-(void)getDataList_footer2
{
    // 刷新数据
    [self.collectionView2 reloadData];
    
    // 停止刷新
    [self.collectionView2.mj_footer endRefreshing];
}



#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    if(collectionView.tag==2001)
    {
        return 1;
    }else if(collectionView.tag==2002)
    {
        return 1;
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag==2001)
    {
        return self.shopsDS.count;
    }else if(collectionView.tag==2002)
    {
        return self.shopsDY.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==2001)
    {
        
    // 创建cell
    JRShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellReuseID forIndexPath:indexPath];
    
    // 给cell传递模型
        VideoRankMode *shop1=self.shopsDS[indexPath.row];
//    shop1.price=[NSString stringWithFormat:@"使用素材%ld",indexPath.row];
    cell.shop = shop1;
    // 返回cell
    return cell;
       
    }else if(collectionView.tag==2002)
    {
        // 创建cell
        JRShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellReuseID forIndexPath:indexPath];
        
        // 给cell传递模型
        VideoRankMode *shop1=self.shopsDY[indexPath.row];
//        shop1.price=[NSString stringWithFormat:@"使用素材%ld",indexPath.row];
        cell.shop = shop1;
        // 返回cell
        return cell;
           
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择第%ld素材",indexPath.item);
    
    if(collectionView.tag==2001)
    {
        VideoRankMode*Vmodel=self.shopsDS[indexPath.row];
        [self getVideoInfo:[NSString stringWithFormat:@"%f",Vmodel.id]];
    }else if(collectionView.tag==2002)
    {
        VideoRankMode*Vmodel=self.shopsDY[indexPath.row];
        [self getVideoInfo:[NSString stringWithFormat:@"%f",Vmodel.id]];
    }
    
}
-(void)pushViewControllerVideo:(ZVideoMode*)mode{
    MHYouKuController *avc = [[MHYouKuController alloc] init];
    avc.Zvideomodel= mode;
    [self pushRootNav:avc animated:YES];
}

-(void)getVideoInfo:(NSString*)videoId
{
    [UHud showHUDLoading];
    NSDictionary* dict = @{
        @"id":videoId,};
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_infourl] Dictionary:dict success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    NSDictionary  * dataArr = [dict objectForKey:@"data"];
                    
                    // 将数据转模型
                    ZVideoMode *model = [ZVideoMode yy_modelWithDictionary:dataArr];
                    NSLog(@"model  == %@",model);
                    [self pushViewControllerVideo:model];
                    
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                }
//        [self pushViewControllerVideo];
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
            
            }];
}



#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wid=(self.bottomView.width-60)/3;
    CGFloat hei=wid/3*4 + 50;
        return CGSizeMake(wid, hei);
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(self.bottomView.width, 40);
}


/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 3;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 13;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 10;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    if (waterFlowLayout.flowLayoutStyle == (WSLWaterFlowLayoutStyle)3){
        return UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(collectionView.tag==2001)
    {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1" forIndexPath:indexPath];
        // if (self.dataArr.count == 0) return view; 这里之前没有注意，直接return view 的话 刷新会看到这个view，通过下面处理就行了。
//        if (self.shops.count == 0){
            view.backgroundColor = [UIColor clearColor];
            [view.leftLabel setText:@"电影"];
            view.tag=collectionView.tag;
//            if(indexPath.section==0)
//            {
//                [view.leftLabel setText:@"电视剧"];
//            }else if(indexPath.section==1)
//            {
//                [view.leftLabel setText:@"电影"];
//            }
            view.touchIndex = ^(NSInteger tag) {
              if(tag==2001)
              {
                  [self pushMovie:1];
              }
            };
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
                [view.leftLabel setText:@"电视剧"];
            view.tag=collectionView.tag;
            view.touchIndex = ^(NSInteger tag) {
              if(tag==2002)
              {
                  [self pushMovie:2];
              }
            };
                return view;
//            }
        }
    }
    return nil;
}

/// 发送跳转 界面
/// @param index 1是 电影 2是电视剧
-(void)pushMovie:(NSInteger)index
{
    NSNotification *notification = [NSNotification notificationWithName:@"pushMovie" object:nil userInfo:@{@"index":@(index)}];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(MSCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
//    [self.navigationController pushViewController:[ViewController new] animated:YES];
}






//控制头部显示
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.TopView.frame = CGRectMake(0,  -scrollerToRect, self.view.frame.size.width, self.TopView.height);
    
    NSLog(@"offsetY == %lf",offsetY);
    if (offsetY > 0 && offsetY < self.TopView.height) {
        scrollerToRect = offsetY;
//        self.TopView.frame = CGRectMake(0,  -scrollerToRect, self.view.frame.size.width, self.TopView.height);
        self.bottomView.frame = CGRectMake(0, self.TopView.bottom, self.view.width, self.view.bounds.size.height - self.TopView.height + offsetY+5);
        if (offsetY>self.TopView.height) {
            self.bottomView.frame = CGRectMake(0, self.TopView.bottom, self.view.width, self.view.bounds.size.height - self.TopView.height + offsetY+5);
        }
        
        self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight) ;
//        self.collectionView.frame = CGRectMake(0, self.subView.bottom, self.view.bounds.size.width, self.view.bounds.size.height - self.subView.height + offsetY);
        self.DowntableView.scrollEnabled=YES;
        self.ZScrollView.scrollEnabled=NO;
    }else if(offsetY<=0) {
        self.TopView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.TopView.height);
        self.bottomView.frame = CGRectMake(0, self.TopView.bottom+8, self.view.width, self.ZScrollView.height - self.TopView.bottom+5);
        self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT+90-kNavAndTabHeight) ;
        self.DowntableView.scrollEnabled=NO;
        self.ZScrollView.scrollEnabled=YES;
    }else{
    }
}



#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.VideoDictList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    homeOneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:homeOneTableViewCellID];
    if (cell == nil) {
        cell = [[homeOneTableViewCell alloc] init];
    }
    NSDictionary * dict=self.VideoDictList[indexPath.section];
    videoFenleiMode * model=[videoFenleiMode yy_modelWithDictionary:dict];
    cell.model=model;
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 490;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
        return CGFLOAT_MIN;//最小数，相当于0
    }
    return 0;//机器不可识别，然后自动返回默认高度
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //自定义间隔view，可以不写默认用系统的
    UIView * view_c= [[UIView alloc] init];
    view_c.frame=CGRectMake(0, 0, 0, 0);
//    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    view_c.backgroundColor=[UIColor clearColor];
    return view_c;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"10001index == %ld",indexPath.section);
    
    
}





@end
