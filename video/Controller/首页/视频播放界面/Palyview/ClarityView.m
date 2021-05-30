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
@property (nonatomic, weak) UICollectionView *collectionView1;
@property (nonatomic, strong)NSMutableArray * titlearray;
@property (nonatomic, assign)NSInteger selectIndex;
@end
@implementation ClarityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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

- (void)setupCollectionView1
{
    self.selectIndex=0;
   
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
    [self.titlearray addObject:@"标清·360"];
    [self.titlearray addObject:@"高清·480P"];
    [self.titlearray addObject:@"超清·720P"];
    [self.titlearray addObject:@"蓝光·1080P"];
    [self.collectionView1.mj_header endRefreshing];
    [self.collectionView1 reloadData];
}

#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.titlearray.count;
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
    [cell.downtitle setTitle:self.titlearray[indexPath.item] forState:(UIControlStateNormal)];
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
    
    // 返回cell
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择第%ld素材",indexPath.item);
    self.selectIndex=indexPath.item;
    [self.collectionView1 reloadData];
    !self.ClarityCallBack ? :self.ClarityCallBack(indexPath.item);
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
        return UIEdgeInsetsMake(20, 8, 20, 8);
    }
    return UIEdgeInsetsMake(6, 6, 6, 6);
}


@end
