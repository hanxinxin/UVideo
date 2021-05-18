//
//  MHYouKuAnthologyHeaderView.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuAnthologyHeaderView.h"
#import "MHTitleLeftButton.h"
#import "MHYouKuAnthologyItem.h"


#import "ZqwHorizontalTableView.h"
#import "ZqwTableViewCell.h"
#import "VtitleCollectionViewCell.h"

static NSString * const reuseIdentifier = @"AnthologyCell";

static NSString * const CollcetionCellID = @"VtitleCollectionViewCell";

@interface JLAnthologyCell : UICollectionViewCell

/** 选集 */
@property (nonatomic , strong) MHYouKuAnthology *anthology;

@end


@interface JLAnthologyCell ()

/** 数字 */
@property (nonatomic , weak) UILabel *numLabel;


@end

@implementation JLAnthologyCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.numLabel.textColor = selected?MHGlobalOrangeTextColor:MHGlobalBlackTextColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
    }
    return self;
}
#pragma mark - 公共方法
- (void)setAnthology:(MHYouKuAnthology *)anthology
{
    _anthology = anthology;
    
    self.numLabel.text = [NSString stringWithFormat:@"%zd",anthology.albums_sort];
    
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = MHColor(233, 238, 243);
    self.backgroundView = backgroundView;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = MHColor(239, 240, 242);
    self.selectedBackgroundView = selectedBackgroundView;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 选集
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = MHGlobalBlackTextColor;
    numLabel.font = MHFont(MHPxConvertPt(15.0f), NO);
    self.numLabel = numLabel;
    [self.contentView addSubview:numLabel];
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
    
    
}


@end


@interface MHYouKuAnthologyHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,ZqwTableViewDataSource,ZqwTableViewDelegate,UIScrollViewDelegate>

/** titleView */
@property (nonatomic , weak) UIView *titleView;
/** 标识View */
@property (nonatomic , weak) UIView *flagView;
/** 选集 */
@property (nonatomic , weak) UILabel *anthologyLabel;
/** 更多 */
@property (nonatomic , weak) MHTitleLeftButton *moreBtn;

/** collectionView **/
@property (nonatomic , weak) UICollectionView *collectionView;

/** 记录上一次选中 */
@property(nonatomic , weak) NSIndexPath *lastSelectedIndexPath;

/** 第一次加载 */
@property (nonatomic , assign , getter = isFirstLoad) BOOL firstLoad;

/** 分割线 */
@property (nonatomic , weak) MHDivider *bottomSeparate ;






/** 选集 */
@property (nonatomic , weak) UICollectionView *XJcollectionView;
/** tableView */
//@property (nonatomic , strong) ZqwHorizontalTableView *tableView;
@property (nonatomic , strong) NSMutableArray *topArray;
@property (nonatomic , assign) NSInteger xuanjiSelect;

@end



@implementation MHYouKuAnthologyHeaderView

+ (instancetype)anthologyHeaderView
{
    return [[self alloc] init];
}

- (NSMutableArray *)topArray
{
    if (_topArray == nil) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}
+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AnthologyHeader";
    MHYouKuAnthologyHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 公共方法
- (void)setAnthologyItem:(MHYouKuAnthologyItem *)anthologyItem
{
    _anthologyItem = anthologyItem;
    
    self.anthologyLabel.text = anthologyItem.title;
    
    [self.collectionView reloadData];
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _firstLoad = YES;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 主题View
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    self.titleView = titleView;
    [self.contentView addSubview:titleView];
    
    // 标注
    UIView *flagView = [[UIView alloc] init];
    flagView.backgroundColor = MHGlobalOrangeTextColor;
    self.flagView = flagView;
    [titleView addSubview:flagView];
    self.flagView = flagView;
    
    // 选集
    UILabel *anthologyLabel = [[UILabel alloc] init];
    anthologyLabel.textAlignment = NSTextAlignmentLeft;
    anthologyLabel.textColor = MHGlobalBlackTextColor;
    anthologyLabel.font = MHFont(MHPxConvertPt(15.0f), NO);
    self.anthologyLabel = anthologyLabel;
    [titleView addSubview:anthologyLabel];
    
    // 更多
    MHTitleLeftButton *moreBtn = [[MHTitleLeftButton alloc] init];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:MHGlobalShadowBlackTextColor forState:UIControlStateNormal];
    [moreBtn setTitleColor:MHGlobalGrayTextColor forState:UIControlStateHighlighted];
    [moreBtn setImage:[UIImage imageNamed:@"playerRecommend_rightArrow"] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = MHMediumFont(MHPxConvertPt(12.0f));
    [moreBtn addTarget:self action:@selector(_moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    
    _topArray=[NSMutableArray array];
    [_topArray addObject:@"1-20"];
    [_topArray addObject:@"21-40"];
    [_topArray addObject:@"41-60"];
    self.xuanjiSelect = 0;
//    _tableView = [[ZqwHorizontalTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
////    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.dataSource = self;
//    _tableView.actionDelegate = self;
//    _tableView.delegate = self;
//    _tableView.pagingEnabled = YES;
//    _tableView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
//    _tableView.layer.cornerRadius = 3;
//    [self.contentView addSubview:self.tableView];
//    [self.tableView reloadData];

    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout2 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout2];
    collectionView2.dataSource = self;
    collectionView2.delegate = self;
    collectionView2.tag=2000;
    collectionView2.showsHorizontalScrollIndicator = NO;
    collectionView2.showsVerticalScrollIndicator = NO;
//    collectionView2.backgroundColor = [UIColor whiteColor];
    collectionView2.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    collectionView2.layer.cornerRadius = 3;
    self.XJcollectionView = collectionView2;
    [self.contentView addSubview:collectionView2];
    
    //1.注册一定要注册，不注册会崩溃
    [collectionView2 registerNib:[UINib nibWithNibName:NSStringFromClass([VtitleCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:CollcetionCellID];
    [self.XJcollectionView reloadData];
    
    
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.tag=1000;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.contentView addSubview:collectionView];
    
    //1.注册一定要注册，不注册会崩溃
    [collectionView registerClass:[JLAnthologyCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 分割线
    MHDivider *bottomSeparate = [MHDivider divider];
    bottomSeparate.backgroundColor = MHColorFromHexString(@"#eeeeee");
    self.bottomSeparate = bottomSeparate;
    [self addSubview:bottomSeparate];
}



#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 布局titleView
//    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.top.and.right.equalTo(self.contentView);
//        make.height.mas_equalTo(MHRecommendTitleViewHeight);
//    }];
    
    
//    // 布局flagView
//    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleView).with.offset(MHGlobalViewLeftInset);
//        make.width.mas_equalTo(2);
//        make.height.mas_equalTo(16.0f);
//        make.centerY.equalTo(self.titleView);
//    }];
    
//    // 布局选集
//    [self.anthologyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.flagView.mas_right).with.offset(6);
//        make.top.and.bottom.equalTo(self.titleView);
//        make.right.equalTo(self.moreBtn.mas_left);
//    }];
//
//    // 布局更多
//    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.titleView.mas_right);
//        make.height.equalTo(self.anthologyLabel.mas_height);
//        make.width.mas_equalTo(50.0f);
//        make.centerY.equalTo(self.titleView.mas_centerY);
//
//    }];
    
    // 布局toptableView
    [self.XJcollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(35);
    }];
    // 布局collectionView
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self.contentView);
        make.top.equalTo(self.XJcollectionView.mas_bottom).offset(5);
        make.height.mas_equalTo(MHRecommendAnthologyHeaderViewHeight-45);
        make.bottom.equalTo(self.bottomSeparate.mas_top).with.offset(-5.0f);
    }];
    
    // 布局分割线
    [self.bottomSeparate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(5);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0.0f);
        
    }];
}

#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
    
    
}




#pragma mark - 事假处理
/** 更所按钮事件 */
- (void)_moreBtnClicked:(MHTitleLeftButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(anthologyHeaderViewForMoreButtonAction:)]) {
        [self.delegate anthologyHeaderViewForMoreButtonAction:self];
    }
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag==1000)
    {
        return self.anthologyItem.anthologys.count;
    }else if(collectionView.tag==2000)
    {
        return self.topArray.count;
    }
    return 0;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==1000)
    {
        
    JLAnthologyCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.anthology = self.anthologyItem.anthologys[indexPath.item];
        if(cell.selected==YES)
        {
            cell.layer.borderWidth = 1;
            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            cell.layer.cornerRadius = 4;
            
        }else{
            cell.layer.borderWidth = 1;
            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            cell.layer.cornerRadius = 4;
        }
    return cell;
        
    }else if(collectionView.tag==2000)
    {
        VtitleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollcetionCellID forIndexPath:indexPath];
        cell.titleL.text = self.topArray[indexPath.item];
        if(self.xuanjiSelect==indexPath.item)
        {
            cell.titleL.textColor=RGBA(20, 155, 236, 1);
        }else{
            cell.titleL.textColor=RGBA(51, 51, 51, 1);
        }
        return cell;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==1000)
    {
       
    // 记录选中的Item
    self.anthologyItem.item = indexPath.item;
    
    // 取消上一次的选中
    if (self.lastSelectedIndexPath != indexPath)
    {
        // 选中不是同一个cell
        // 获取上一次的选中的cell
        JLAnthologyCell *lastCell = (JLAnthologyCell *)[collectionView cellForItemAtIndexPath:self.lastSelectedIndexPath];
        // 取消当前的cell
        lastCell.selected = NO;
        // 记录当前的选中
        self.lastSelectedIndexPath = indexPath;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(anthologyHeaderView:mediaBaseId:)]) {
            MHYouKuAnthology *anthology = self.anthologyItem.anthologys[indexPath.item];
            [self.delegate anthologyHeaderView:self mediaBaseId:anthology.mediabase_id];
            
        }
    }
        
    }else if(collectionView.tag==2000)
    {
        self.xuanjiSelect=indexPath.item;
        [self.XJcollectionView reloadData];
    }
}


- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==1000)
    {
    // 第一次加载滚动到指定位置
    if (self.isFirstLoad) {
        
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.anthologyItem.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        self.firstLoad = NO;
    }
    
    if (indexPath.item == self.anthologyItem.item) {
        
        cell.selected = YES;
        self.lastSelectedIndexPath = indexPath;
        
    }else{
        cell.selected = NO;
    }
    
    
    }else if(collectionView.tag==2000)
    {
        
    }
}





//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(collectionView.tag==1000)
    {
       
    UIEdgeInsets top = UIEdgeInsetsMake(0, 3, 0, 3);
    return top;
        
    }else if(collectionView.tag==2000)
    {
        UIEdgeInsets top = UIEdgeInsetsMake(0, 5, 0, 5);
        return top;
    }
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置水平之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if(collectionView.tag==1000)
    {
       
        return 10;
        
    }else if(collectionView.tag==2000)
    {
        return 5;
    }
    return 10;
}

//设置垂直之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if(collectionView.tag==1000)
    {
       
        return 10;
        
    }else if(collectionView.tag==2000)
    {
        return 10;
    }
    return 10;
    
}


//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==1000)
    {
//    CGFloat width = MHRecommendAnthologyViewHeight;
    CGFloat width = (self.width-32-40)/5;
    return CGSizeMake(width, 34);
       
        
    }else if(collectionView.tag==2000)
    {
        CGFloat width = 60;
        return CGSizeMake(width, 35);
    }
    return CGSizeMake(0, 0);
}

@end
