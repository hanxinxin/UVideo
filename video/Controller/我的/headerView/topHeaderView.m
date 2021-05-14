//
//  topHeaderView.m
//  video
//
//  Created by macbook on 2021/5/9.
//

#import "topHeaderView.h"
#import "headerCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"

// collectionViewCell的重用标识符
static NSString * const headerCellReuseID = @"header";
@interface topHeaderView () <UICollectionViewDataSource,UICollectionViewDelegate,WSLWaterFlowLayoutDelegate>
{
    
    UICollectionViewFlowLayout *_layout;
}
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) NSArray *imageArray;
@end

@implementation topHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder: aDecoder]) {
        [self createUI];
    }
    return self;
}
-(void)awakeFromNib {

    [super awakeFromNib];
}

- (void)createUI {
    
    
    self.txImage.layer.cornerRadius=30;
    self.titleArray = [NSArray arrayWithObjects:@"收藏夹",@"求片",@"任务",@"充值", nil];
    self.imageArray = [NSArray arrayWithObjects:@"shoucangjia",@"qiupian",@"renwu",@"chongzhiImage", nil];
    WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    // 创建瀑布流view
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80+8, self.width-40, 80) collectionViewLayout:layout];
    // 设置数据源
    self.collectionView.dataSource = self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    // 是否滚动//
    self.collectionView.scrollEnabled = NO;
    [self addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.txImage.mas_bottom).offset(8);
//        make.width.mas_equalTo(self.width-40);
//        make.height.equalTo(@370);
//    }];
    
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([headerCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:headerCellReuseID];
}


- (IBAction)tx_touch:(id)sender {
    if (self.topHeaderBlock) {
        self.topHeaderBlock(1001);
    }
}
- (IBAction)jifen_touch:(id)sender {
    //积分
    if (self.topHeaderBlock) {
        self.topHeaderBlock(1002);
    }
}
- (IBAction)vip_touch:(id)sender {
    //VIP
    if (self.topHeaderBlock) {
        self.topHeaderBlock(1003);
    }
}


#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    headerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCellReuseID forIndexPath:indexPath];
    
    // 给cell传递模型
    [cell.image setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    cell.title.text=self.titleArray[indexPath.row];
    
    // 返回cell
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择第%ld素材",indexPath.item);
    
    if (self.cellindexBlock) {
        self.cellindexBlock(1000+indexPath.item);
    }
    
}
#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        return CGSizeMake((self.collectionView.width-50)/self.titleArray.count, 74);
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
    return 10;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    if (waterFlowLayout.flowLayoutStyle == (WSLWaterFlowLayoutStyle)3){
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
