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

#import "bannerMode.h"


// collectionViewCell的重用标识符
static NSString * const shopCellReuseID = @"shop";
@interface VDViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate, JRWaterFallLayoutDelegate,WSLWaterFlowLayoutDelegate,MSCycleScrollViewDelegate>
/** 滑动底部 ScrollView */
@property (nonatomic, weak) UIScrollView *ZScrollView;

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

@end

@implementation VDViewController
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
    [self getbannerData];
//    [self getmenuData];
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





-(void)addScrollviewLB
{
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
    self.cycleScrollView =cycleScrollView7;
    
    cycleScrollView7.imageUrls = self.bannerimagesURL;
    
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
        
            [self getDataList_header1];
    }];
    // 第一次进入则自动加载
    [self.collectionView1.mj_header beginRefreshing];
    
    
    self.collectionView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
        make.height.equalTo(@370);
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
    
    
    self.collectionView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self getDataList_footer2];
            
    }];
    
    //更新 scrollview 滑动
    self.ZScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, self.collectionView2.bottom+kNavAndTabHeight+140) ;
}


-(void)getDataList_header1
{
    // 清空数据
    
    NSDictionary*dict =nil;
    if(_SelectIndex==0)
    {
        dict = @{@"parent_category_id":[NSString stringWithFormat:@"%@",@(100)]};
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
                        [self.shopsDS removeAllObjects];
                        NSMutableArray* arr=[NSMutableArray arrayWithCapacity:0];
                        NSArray * video_list = [dataArr objectForKey:@"video_list"];
                        for (int i=0; i<video_list.count; i++) {
                            
                            VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_list[i]];
                            [arr addObject:model];
                            
                        }
                        [self.shopsDS addObjectsFromArray:arr];
                        // 刷新数据
                        [self.collectionView1 reloadData];
                    
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                }
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
            }];
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
                    for (int i=0; i<video_list.count; i++) {
                        
                        VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_list[i]];
                        [arr addObject:model];
                        
                    }
                    [self.shopsDY addObjectsFromArray:arr];
                    // 刷新数据
                    [self.collectionView2 reloadData];
                    
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                }
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
            }];
    
    
    
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
    JRShop *shop1=self.shopsDS[indexPath.row];
    shop1.price=[NSString stringWithFormat:@"使用素材%ld",indexPath.row];
    cell.shop = shop1;
    // 返回cell
    return cell;
       
    }else if(collectionView.tag==2002)
    {
        // 创建cell
        JRShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellReuseID forIndexPath:indexPath];
        
        // 给cell传递模型
        JRShop *shop1=self.shopsDY[indexPath.row];
        shop1.price=[NSString stringWithFormat:@"使用素材%ld",indexPath.row];
        cell.shop = shop1;
        // 返回cell
        return cell;
           
    }
    return nil;
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
