//
//  ClarityView.m
//  video
//
//  Created by macbook on 2021/5/17.
//

#import "ClarityView.h"
#import "WSLWaterFlowLayout.h"
#import "clarityCollectionViewCell.h"

#define CellID @"clarityCollectionViewCell"

@interface ClarityView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,WSLWaterFlowLayoutDelegate>
@property (nonatomic, strong)NSMutableArray * titlearray;
@end
@implementation ClarityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.titlearray addObject:@"标清·360P"];
        [self.titlearray addObject:@"高清·480P"];
        [self.titlearray addObject:@"超清·720P"];
        [self.titlearray addObject:@"蓝光·1080P"];
        self.selectIndex=0;
        // 初始化CollectionView
        [self setupCollectionView1];
        
       
        
    }
    return self;
}
- (NSMutableArray *)titlearray
{
    if (_titlearray == nil) {
        _titlearray = [NSMutableArray array];
    }
    return _titlearray;
}
- (NSArray *)titleNumberarray
{
    if (_titleNumberarray == nil) {
        _titleNumberarray = [NSArray array];
    }
    return _titleNumberarray;
}

- (void)setupCollectionView1
{
    
   
    // 创建瀑布流layout
//    JRWaterFallLayout *layout = [[JRWaterFallLayout alloc] init];
//    // 设置代理
//    layout.delegate = self;
    WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.flowLayoutStyle = WSLWaterFlowHorizontalGrid;
//     = UICollectionViewScrollDirectionHorizontal;
    //水平滑动
            
    // 创建瀑布流view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.tag=2001;
    // 是否滚动//
    collectionView.scrollEnabled = YES;
    /// 设置此属性为yes 不满一屏幕 也能滚动
//    collectionView.alwaysBounceHorizontal = YES;
//    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.and.height.equalTo(self);
//        make.top.equalTo(@0);
//        make.width.mas_equalTo(self.width);
//        make.bottom.equalTo(self);
    }];
    self.collectionView1 = collectionView;
    
    // 注册cell
    [self.collectionView1 registerNib:[UINib nibWithNibName:NSStringFromClass([clarityCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:CellID];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
        
        [self updateCollection];
    });
//    // 为瀑布流控件添加下拉加载和上拉加载
//    self.collectionView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
//
//            [self updateCollection];
//        });
//    }];
//    // 第一次进入则自动加载
//    [self.collectionView1.mj_header beginRefreshing];
//
//
//    self.collectionView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
////            [self getDataList_footer1];
//
//        });
//    }];
}
-(void)updateCollection
{
    
    [self.collectionView1.mj_header endRefreshing];
    [self.collectionView1 reloadData];
}

#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.titleNumberarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    clarityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    if(self.selectIndex==indexPath.item)
    {
        if(indexPath.item==0 || indexPath.item==1)
        {
            
            [cell.downtitle setBackgroundColor:RGB(20, 155, 236)];
            [cell.downtitle setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
            cell.downtitle.layer.borderColor = RGB(20, 155, 236).CGColor;
            cell.downtitle.layer.borderWidth = 1;
            cell.downtitle.layer.cornerRadius = 4;
        }else{
            [cell.downtitle setBackgroundColor:RGB(255, 136, 0)];
            [cell.downtitle setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
            cell.downtitle.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
            cell.downtitle.layer.borderWidth = 1;
            cell.downtitle.layer.cornerRadius = 4;
        }
    }else{
        if(indexPath.item==0 || indexPath.item==1)
        {
            cell.downtitle.backgroundColor = RGB(255, 255, 255);
            [cell.downtitle setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            cell.downtitle.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
            cell.downtitle.layer.borderWidth = 1;
            cell.downtitle.layer.cornerRadius = 4;
        }else{
            cell.downtitle.backgroundColor = RGB(255, 255, 255);
            [cell.downtitle setTitleColor:RGB(255, 136, 0) forState:UIControlStateNormal];
            cell.downtitle.layer.borderColor = RGBA(255, 136, 0, 1).CGColor;
            cell.downtitle.layer.borderWidth = 1;
            cell.downtitle.layer.cornerRadius = 4;
            
        
        }
    }
    NSNumber * Sindex=self.titleNumberarray[indexPath.item];
    [cell.downtitle setTitle:self.titlearray[[Sindex intValue]-1] forState:(UIControlStateNormal)];
    if(self.titleNumberarray.count==1)
    {
        if(indexPath.item==0)
        {
            cell.toptitle.text=@"游客";
            cell.toptitle.textColor=RGB(102, 102, 102);
        }else{
            cell.toptitle.text=@"注册会员";
            cell.toptitle.textColor=RGB(255, 136, 0);
        }
        
    }else if(self.titleNumberarray.count==2)
    {
        if(indexPath.item==0)
        {
            cell.toptitle.text=@"游客";
            cell.toptitle.textColor=RGB(102, 102, 102);
        }else{
            cell.toptitle.text=@"注册会员";
            cell.toptitle.textColor=RGB(255, 136, 0);
        }
        
    }else if(self.titleNumberarray.count==3){
        if(indexPath.item==0)
        {
            cell.toptitle.text=@"游客";
            cell.toptitle.textColor=RGB(102, 102, 102);
        }else if(indexPath.item==1)
        {
            cell.toptitle.text=@"注册会员";
            cell.toptitle.textColor=RGB(102, 102, 102);
        }else{
            cell.toptitle.text=@"VIP会员";
            cell.toptitle.textColor=RGB(255, 136, 0);
        }
    }else if(self.titleNumberarray.count==4){
        if(indexPath.item==0)
        {
            cell.toptitle.text=@"游客";
            cell.toptitle.textColor=RGB(102, 102, 102);
        }else if(indexPath.item==1)
        {
            cell.toptitle.text=@"注册会员";
            cell.toptitle.textColor=RGB(102, 102, 102);
        }else{
            cell.toptitle.text=@"VIP会员";
            cell.toptitle.textColor=RGB(255, 136, 0);
        }
    }
    
    
    // 返回cell
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择第%ld素材",indexPath.item);
    
    [self.collectionView1 reloadData];
    NSNumber * qxd=self.titleNumberarray[indexPath.item];
    if([qxd intValue]==3 || [qxd intValue]==4)
    {
        //////会员才能看蓝光
        if([vip_expired_time_loca intValue]!=0)
        {
            NSString * vipStr=[vip_expired_time_loca stringValue];
            NSString * dqStr=[self gs_getCurrentTimeBySecond11];
            NSDate * timeStampToDate1 = [NSDate dateWithTimeIntervalSince1970:[dqStr doubleValue]];
            NSDate * timeStampToDate2 = [NSDate dateWithTimeIntervalSince1970:[vipStr doubleValue]];
            NSLog(@"[self compareOneDay:timeStampToDate1 withAnotherDay:timeStampToDate2]=====   %d",[self compareOneDay11:timeStampToDate1 withAnotherDay:timeStampToDate2]);
            if([self compareOneDay11:timeStampToDate1 withAnotherDay:timeStampToDate2]!=1)/////   时间对比  返回1 - 过期, 0 - 相等, -1 - 没过期
            {
                
                self.selectIndex=indexPath.item;
            }else{
                
//                [self.collectionView1 reloadData];
            }
        }else{
//            [self.collectionView1 reloadData];
        }
    }else if([qxd intValue]==2 )
    {
        if([usertoken isEqualToString:@""])
        {
            [self.collectionView1 reloadData];
        }else{
            self.selectIndex=indexPath.item;
        }
    }else{
        self.selectIndex=indexPath.item;
    }
    !self.ClarityCallBack ? :self.ClarityCallBack(indexPath);
}

#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        return CGSizeMake(100, 85);
}
/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}


/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
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
        return UIEdgeInsetsMake(20, 0, 20, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
/////   10位时间戳
- (NSString *)gs_getCurrentTimeBySecond11 {

    double currentTime =  [[NSDate date] timeIntervalSince1970];

    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];

    return strTime;

}
///   时间对比  返回1 - 过期, 0 - 相等, -1 - 没过期
- (int)compareOneDay11:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}
@end
