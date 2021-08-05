//
//  VDxfViewController.m
//  video
//
//  Created by macbook on 2021/6/15.
//

#import "VDxfViewController.h"
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

#import "bannerMode.h"
#import "ZVideoMode.h"
#import "TestWebViewController.h"
#import "GuanggaoMode.h"

// collectionViewCell的重用标识符
static NSString * const shopCellReuseID = @"shop";
@interface VDxfViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate, JRWaterFallLayoutDelegate,WSLWaterFlowLayoutDelegate,MSCycleScrollViewDelegate>
{
    CGFloat scrollerToRect;
}
/** 滑动底部 ScrollView */
@property (nonatomic, weak) UIScrollView *ZScrollView;

/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView1;
/** 瀑布流view */
@property (nonatomic, weak) UICollectionView *collectionView2;


@property (nonatomic, strong) NSMutableArray *bannerimagesmode;///轮播图mode数组
@property (nonatomic, strong) NSMutableArray *bannerimagesURL;//轮播图url


@property(nonatomic,assign)NSInteger page;
/** 包含瀑布流view */
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong)MSCycleScrollView *cycleScrollView;

@property (nonatomic, strong)GuanggaoMode*GuanggaoModeA;
@property (nonatomic, strong)YYAnimatedImageView * imageviewGG;

@end

@implementation VDxfViewController
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
    self.page=1;
    UIScrollView * scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight-40)];
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
//    scrollview.contentSize =CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight-40) ;
    scrollview.tag=1000;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollview];
    self.ZScrollView=scrollview;
//    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.bottom.equalTo(@0);
//
//    }];
    
    
    
    
    ///包含瀑布流view
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 175+70, self.ZScrollView.width, self.ZScrollView.height-175-70)];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ZScrollView.width, self.ZScrollView.height)];
    view.backgroundColor=[UIColor whiteColor];
    
    [self.ZScrollView addSubview:view];
    
    
    self.bottomView=view;
    
    // 设置当前页码为0
    self.currentPage = 0;
    //加载轮播图
//    [self addScrollviewLB];
    // 初始化瀑布流view
    [self setupCollectionView1];
//    [self setupCollectionView2];
//    [self getbannerData];
//    [self getmenuData];
//    [self getGuanggao_data];
    
    [self creatTapImageView];
}
-(void)getGuanggao_data
{
    NSDictionary *dict =@{@"symbol":@"mobile-home-banner-below",
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
            self.imageviewGG.yy_imageURL=[NSURL URLWithString:self.GuanggaoModeA.source];
            }
        }else{
            NSString * message = [dict objectForKey:@"message"];
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





-(void)addScrollviewLB
{
    // 网络加载 --- 创建带标题的图片轮播器
    MSCycleScrollView *cycleScrollView7 = [MSCycleScrollView cycleViewWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 160) delegate:self placeholderImage:[UIImage imageNamed:@"BannerGBimage"]];
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
    [self.ZScrollView addSubview:cycleScrollView7];
    self.cycleScrollView =cycleScrollView7;
    
    cycleScrollView7.imageUrls = self.bannerimagesURL;
    
    /*
     block监听点击方式
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
     NSLog(@">>>>>  %ld", (long)index);
     };
     */
//    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 165, self.bottomView.width, 60)];
//    [imageview setImage:[UIImage imageNamed:@"kthuiyuan"]];
//    [self.ZScrollView addSubview:imageview];
//    self.imageviewGG=imageview;
    
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
    self.imageviewGG=imageview;
    [self.ZScrollView addSubview:imageview];
//    imageview.backgroundColor=[UIColor redColor];
    
    
}

-(void)postWebView:(UITapGestureRecognizer*)tap
{
    if(self.GuanggaoModeA)
    {
//        TestWebViewController *webVC = [[TestWebViewController alloc] initWithURLString:self.GuanggaoModeA.url];
//        [self pushRootNav:webVC animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.GuanggaoModeA.url]];
    }
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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.ZScrollView.bounds collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.tag=2001;
    // 是否滚动//
//    collectionView.scrollEnabled = NO;
    [self.bottomView addSubview:collectionView];
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(@0);
//        make.width.mas_equalTo(self.bottomView.width);
//        make.height.mas_equalTo(self.ZScrollView.height-self.imageviewGG.bottom);
//    }];
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
    [self.collectionView1.mj_header beginRefreshing];
    
    
    self.collectionView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getDataList_footer1];
            
    }];
    //更新 scrollview 滑动
//    self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, self.collectionView1.bottom+240) ;
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
        make.height.equalTo(@420);
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
    [self.collectionView2.mj_header beginRefreshing];
    
    
    self.collectionView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getDataList_footer2];
            
    }];
    
    //更新 scrollview 滑动
//    self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, self.collectionView2.bottom+kNavAndTabHeight+30) ;
    //更新 scrollview 滑动
//    self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, 175+70+self.bottomView.height+10);
}


-(void)getDataList_header1
{
    // 清空数据
    self.page=1;
    NSDictionary*dict =nil;
    if(_SelectIndex==0)
    {
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%@",@(100)],
                 @"page":[NSString stringWithFormat:@"%@",@(self.page)],
                 @"pagesize":[NSString stringWithFormat:@"%@",@(15)],
        };
    }else{
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%f",_FenleiMode.id],
                 @"page":[NSString stringWithFormat:@"%@",@(self.page)],
                 @"pagesize":[NSString stringWithFormat:@"%@",@(15)],};
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
        
        // 停止刷新
        [self.collectionView1.mj_header endRefreshing];
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                // 停止刷新
                [self.collectionView1.mj_header endRefreshing];
            }];
    
}
-(void)getDataList_footer1
{
    // 刷新数据
    
    NSDictionary*dict =nil;
    if(_SelectIndex==0)
    {
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%@",@(100)],
                 @"page":[NSString stringWithFormat:@"%@",@(self.page+1)],
                 @"pagesize":[NSString stringWithFormat:@"%@",@(15)],
        };
    }else{
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%f",_FenleiMode.id],
                 @"page":[NSString stringWithFormat:@"%@",@(self.page+1)],
                 @"pagesize":[NSString stringWithFormat:@"%@",@(15)],};
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
                        NSMutableArray* arr=[NSMutableArray arrayWithCapacity:0];
//                    [arr addObject:self.shopsDS];
                        NSArray * video_list = [dataArr objectForKey:@"video_list"];
                    if(![video_list isKindOfClass:[NSNull class]]){
                    if(video_list.count>0)
                    {
                        self.page+=1;
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
        
        // 停止刷新
        [self.collectionView1.mj_header endRefreshing];
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                // 停止刷新
                [self.collectionView1.mj_header endRefreshing];
            }];
    // 停止刷新
    [self.collectionView1.mj_footer endRefreshing];
}


-(void)getDataList_header2
{
    
    self.page=1;
//    [self.shopsDY addObjectsFromArray:[self newShops]];
    NSDictionary*dict =nil;
    if(_SelectIndex==0)
    {
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%@",@(101)]};
    }else{
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%f",_FenleiMode.id]};
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
                    for (int i=0; i<video_list.count; i++) {
                        
                        VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_list[i]];
                        [arr addObject:model];
                        
                    }
                    }
                    [self.shopsDY addObjectsFromArray:arr];
                    // 刷新数据
                    [self.collectionView2 reloadData];
                    
                   
                }else{
                    NSString * message = [dict objectForKey:@"message"];
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
        
        // 停止刷新
        [self.collectionView2.mj_header endRefreshing];
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                
                // 停止刷新
                [self.collectionView2.mj_header endRefreshing];
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
            [view.leftLabel setText:_FenleiMode.name];
//            view.rightBtn.hidden=YES;
//            if(indexPath.section==0)
//            {
//                [view.leftLabel setText:@"电视剧"];
//            }else if(indexPath.section==1)
//            {
//                [view.leftLabel setText:@"电影"];
//            }
            view.rightBtn.hidden=YES;
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






////控制头部显示
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView.tag==1000)
//    {
        
//    CGFloat offsetY = scrollView.contentOffset.y;
//
//    NSLog(@"%lf",offsetY);
//    if (offsetY > 0 && offsetY < self.ZScrollView.height) {
//        scrollerToRect=offsetY;
//        if(offsetY>=20)
//        {
//            self.collectionView1.scrollEnabled = YES;
//            [UIView animateWithDuration:0.5 animations:^{
//                self.bottomView.frame=CGRectMake(0, kNavAndTabHeight+50, self.ZScrollView.width, self.ZScrollView.height) ;
//                self.collectionView1.frame=CGRectMake(0,30,self.bottomView.width, self.bottomView.height) ;
//                }];
//
//
////            [self.ZScrollView setContentOffset:CGPointMake(0, self.bottomView.bottom+50) animated:YES];
//        }else {
//            self.collectionView1.scrollEnabled = NO;
//            [UIView animateWithDuration:0.5 animations:^{
//            self.bottomView.frame=CGRectMake(0, 175+70, self.ZScrollView.width, self.ZScrollView.height-175-70) ;
//                self.collectionView1.frame=CGRectMake(0,0,self.bottomView.width, self.collectionView1.height+self->scrollerToRect) ;
//            }];
//
//        }
        
      
        
        
        
        
        
//    }
//    }
//}




- (void)creatTapImageView {
    

    self.tapView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 55, SCREENH_HEIGHT -kNavAndTabHeight -100, 35, 35)];

    [self.view addSubview:_tapView];

    [self.view bringSubviewToFront:_tapView];

    _tapView.backgroundColor = RGBA(51, 51, 51, 0.6);

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTopView:)];

    _tapView.hidden = YES;

    [_tapView addGestureRecognizer:tapGesture];

    _tapView.layer.masksToBounds = YES;

    _tapView.layer.cornerRadius = 4;

    _tapView.layer.borderWidth = 0;

    _tapView.layer.borderColor = RGB(215,215,215).CGColor;

    [self.view bringSubviewToFront:_tapView];
    
    [self.view insertSubview:self.tapView aboveSubview:self.ZScrollView];

//    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 50, 20)];
//
//    [self.tapView addSubview:_countLabel];
//
//    _countLabel.textAlignment = NSTextAlignmentCenter;
//
//    _countLabel.text = @"";
//
//    _countLabel.font = Font(14);
//
//    _countLabel.textColor = RGB(120, 120, 120);
//
//
//
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(7, 25, 36, 1)];
//
//    [_tapView addSubview:line];
//
//    line.backgroundColor = RGB(215,215,215);
//
//    line.backgroundColor = [UIColor blackColor];
//
//    self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 50, 20)];
//
//    [self.tapView addSubview:_numLabel];
//
//    _numLabel.textAlignment = NSTextAlignmentCenter;
//
//    _numLabel.text = @"";
//
//    _numLabel.font = Font(14);
//
//    _numLabel.textColor = RGB(120, 120, 120);

    

    self.tapImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.tapView.width-20)/2, (self.tapView.height-18)/2, 20, 18)];

    _tapImageView.image = [UIImage imageNamed:@"zhidingImage"];

    [_tapView addSubview:_tapImageView];

    

}

- (void)gotoTopView:(UITapGestureRecognizer *)gesture {
//    [self.ZScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.collectionView1 setContentOffset:CGPointMake(0, 0) animated:YES];


}
//开始拖动

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    

    self.tapImageView.hidden = YES;

    

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    

    self.tapImageView.hidden = NO;

    

}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    

    if (scrollView.contentOffset.y > 200) {
        self.tapView.hidden = NO;

    }else{
        self.tapView.hidden = YES;

    }

    

}




@end
