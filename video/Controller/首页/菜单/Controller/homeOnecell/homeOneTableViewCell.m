//
//  homeOneTableViewCell.m
//  video
//
//  Created by macbook on 2021/7/22.
//

#import "homeOneTableViewCell.h"
#import "JRShop.h"
#import "JRShopCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "JRWaterFallLayout.h"
#import "SHeaderView.h"
#import "WSLWaterFlowLayout.h"
#import "YYWebImage.h"
#import "bannerMode.h"
#import "MHYouKuController.h"
#import "TestWebViewController.h"
#import "GuanggaoMode.h"

// collectionViewCell的重用标识符
static NSString * const shopCellReuseID = @"shop";
@interface homeOneTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate, JRWaterFallLayoutDelegate,WSLWaterFlowLayoutDelegate>
@end

@implementation homeOneTableViewCell
- (NSMutableArray *)shopsDS
{
    if (_shopsDS == nil) {
        _shopsDS = [NSMutableArray array];
    }
    return _shopsDS;
}
-(void)setModel:(videoFenleiMode *)model
{
    _model=model;
    
    [self getDataList_header1];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
    [self setupCollectionView1];
        });
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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.tag=2001;
    // 是否滚动//
    collectionView.scrollEnabled = NO;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    self.collectionView1 = collectionView;
    
    // 注册cell
    [self.collectionView1 registerNib:[UINib nibWithNibName:NSStringFromClass([JRShopCell class]) bundle:nil] forCellWithReuseIdentifier:shopCellReuseID];
    [self.collectionView1 registerClass:[SHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
//    [self.collectionView1 registerNib:[UINib nibWithNibName:NSStringFromClass([SHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
    // 为瀑布流控件添加下拉加载和上拉加载
//    self.collectionView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//            [self getDataList_header1];
//    }];
    // 第一次进入则自动加载
//    [self.collectionView1.mj_header beginRefreshing];
    
    
//    self.collectionView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            [self getDataList_footer1];
//
//    }];
    
}

-(void)getDataList_header1
{
    // 清空数据
//    [UHud showHUDLoading];
    NSDictionary*dict = @{@"parent_category_id":[NSString stringWithFormat:@"%.f",self.model.id],
                                @"page":[NSString stringWithFormat:@"%@",@(1)],
                                @"pagesize":[NSString stringWithFormat:@"%@",@(6)]
                       };
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
//        [self.collectionView1.mj_header endRefreshing];
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                // 停止刷新
//                [self.collectionView1.mj_header endRefreshing];
            }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shopsDS.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    // 创建cell
    JRShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellReuseID forIndexPath:indexPath];
    
    // 给cell传递模型
        VideoRankMode *shop1=self.shopsDS[indexPath.row];
//    shop1.price=[NSString stringWithFormat:@"使用素材%ld",indexPath.row];
    cell.shop = shop1;
    // 返回cell
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择第%ld素材",indexPath.item);

        VideoRankMode*Vmodel=self.shopsDS[indexPath.row];
//        [self getVideoInfo:[NSString stringWithFormat:@"%f",Vmodel.id]];
    if (self.touchIndex) {
        self.touchIndex(indexPath.row, Vmodel);
    }
    
}
-(void)pushViewControllerVideo:(ZVideoMode*)mode{
//    MHYouKuController *avc = [[MHYouKuController alloc] init];
//    avc.Zvideomodel= mode;
//    [self pushRootNav:avc animated:YES];
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
    CGFloat wid=(self.width-60)/3;
    CGFloat hei=wid/3*4 + 50;
        return CGSizeMake(wid, hei);
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(self.width, 40);
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
            [view.leftLabel setText:self.model.name];
//            view.tag=collectionView.tag;
            view.tag=indexPath.item;
//            if(indexPath.section==0)
//            {
//                [view.leftLabel setText:@"电视剧"];
//            }else if(indexPath.section==1)
//            {
//                [view.leftLabel setText:@"电影"];
//            }
            view.touchIndex = ^(NSInteger tag) {
//              if(tag==2001)
//              {
                  [self pushMovie:self.tag];
//              }
            };
            return view;
//        }
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




@end
