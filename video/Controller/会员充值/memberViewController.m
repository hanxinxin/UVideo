//
//  memberViewController.m
//  video
//
//  Created by macbook on 2021/5/9.
//

#import "memberViewController.h"
#import "CZCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
#import "vipHeaderView.h"

#define CZCollectionViewCellID @"CZCollectionViewCell"
@interface memberViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,WSLWaterFlowLayoutDelegate>
@property (nonatomic, copy) NSMutableArray *moneyArray;
@property (nonatomic, assign) NSInteger moneyselect;
@property (nonatomic, strong) NSMutableArray *PayArray;
@property (nonatomic, strong) NSMutableArray *imagearray;
@property (nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic,strong)UITableView*downtableview;
@end

@implementation memberViewController
- (NSMutableArray *)moneyArray
{
    if (_moneyArray == nil) {
        _moneyArray = [NSMutableArray array];
    }
    return _moneyArray;
}
- (NSMutableArray *)PayArray
{
    if (_PayArray == nil) {
        _PayArray = [NSMutableArray array];
    }
    return _PayArray;
}
- (NSMutableArray *)imagearray
{
    if (_imagearray == nil) {
        _imagearray = [NSMutableArray array];
    }
    return _imagearray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTopView];
    [self setupCollectionView];
    [self Addtableview];
}

-(void)addTopView
{
    vipHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:@"vipHeaderView" owner:self options:nil]objectAtIndex:0];
    view.frame=CGRectMake(20, 8, SCREEN_WIDTH-40, 120);
    view.txImage.layer.cornerRadius=20;
    [self.view addSubview:view];
}


- (void)setupCollectionView
{
    
    _moneyselect=0;
    WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    // 创建瀑布流view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 130, SCREEN_WIDTH-40, 185) collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.tag=2001;
    // 是否滚动//
    collectionView.scrollEnabled = NO;
    [self.view addSubview:collectionView];
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(@0);
//        make.width.mas_equalTo(self.bottomView.width);
//        make.height.equalTo(@370);
//    }];
    self.collectionView = collectionView;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:CZCollectionViewCellID];
//    [self.collectionView registerClass:[SHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
            
            [self getDataList_header];
        });
    }];
    // 第一次进入则自动加载
    [self.collectionView.mj_header beginRefreshing];
    
    
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
////            [self getDataList_footer1];
//
//        });
//    }];
}

-(void)getDataList_header
{
    [self.collectionView.mj_header endRefreshing];
    [self.moneyArray addObject:@"1"];
    [self.moneyArray addObject:@"2"];
    [self.moneyArray addObject:@"3"];
    [self.moneyArray addObject:@"4"];
    [self.collectionView reloadData];
    
}


#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.moneyArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    CZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CZCollectionViewCellID forIndexPath:indexPath];
    
    // 给cell传递模型
    if(_moneyselect==indexPath.item)
    {
        cell=[self setcellSelect:cell];
    }else{
        cell=[self setcellNoSelect:cell];
    }
    // 返回cell
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择第%ld素材",indexPath.item);
    _moneyselect = indexPath.item;
    [self.collectionView reloadData];
    
}
-(CZCollectionViewCell*)setcellSelect:(CZCollectionViewCell*)cell
{
    cell.backgroundColor=RGBA(236, 142, 20, 1);
//    [cell.layer addSublayer:[self setCA]];
    cell.topLabel.textColor=RGB(255, 255, 255);
    cell.centerLabel.textColor=RGB(135, 72, 0);
    cell.downLabel.textColor=RGB(255, 255, 255);
    cell.vipbg.hidden=NO;
    cell.layer.borderWidth = 0.5;
    cell.layer.shadowColor = RGBA(255, 255, 255, 0.7).CGColor;
    cell.layer.shadowOffset = CGSizeMake(2,3);
    cell.layer.shadowRadius = 6;
    cell.layer.shadowOpacity = 1;
    cell.layer.cornerRadius = 8;
    
    return cell;
}

-(CAGradientLayer*)setCA
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(16,191,165,66);
    gl.startPoint = CGPointMake(0.20536468923091888, 0.06643304228782654);
    gl.endPoint = CGPointMake(0.8882775902748108, 0.9592784643173218);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:185/255.0 blue:106/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
//    [view.layer addSublayer:gl];
    return gl;
}

-(CZCollectionViewCell*)setcellNoSelect:(CZCollectionViewCell*)cell
{
    cell.backgroundColor=[UIColor whiteColor];
    cell.topLabel.textColor=[UIColor blackColor];
    cell.centerLabel.textColor=[UIColor blackColor];
    cell.downLabel.textColor=RGB(51, 51, 51);
    cell.vipbg.hidden=YES;
    cell.layer.borderWidth = 0.5;
    cell.layer.shadowColor = RGBA(203, 203, 203, 0.7).CGColor;
    cell.layer.shadowOffset = CGSizeMake(2,3);
    cell.layer.shadowRadius = 6;
    cell.layer.shadowOpacity = 1;
    cell.layer.cornerRadius = 8;
    return cell;
}



#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        return CGSizeMake((self.collectionView.width-30)/2, 76);
}
///** 头视图Size */
//-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
//    return CGSizeMake(self.collectionView.width, 40);
//}


/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 2;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 10;
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




-(void)Addtableview
{
    _PayArray=[NSMutableArray arrayWithCapacity:0];
    [_PayArray addObject:[NSArray arrayWithObjects:@"选择支付方式",@"",@"",@"",@"卡密支付", nil]];
    _imagearray=[NSMutableArray arrayWithCapacity:0];
    [_imagearray addObject:[NSArray arrayWithObjects:@"",@"paypal",@"zhifubao",@"wximage",@"yhkimage",nil]];
    self.downtableview=[[UITableView alloc] init];
    self.downtableview.frame=CGRectMake(20, 220+kNavBarAndStatusBarHeight, SCREEN_WIDTH-40, SCREENH_HEIGHT-200-kNavBarAndStatusBarHeight);
    self.downtableview.backgroundColor=[UIColor clearColor];
    self.downtableview.delegate=self;
    self.downtableview.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.downtableview];
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _PayArray.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray * arr = _PayArray[0];
    return arr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
    if(indexPath.section==0)
    {
        NSArray  * titleT=_PayArray[0];
        cell.textLabel.text = [titleT objectAtIndex:indexPath.section];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
    }else{
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [cell.contentView addSubview:lbl];
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray  * titleT=_PayArray[0];
        cell.textLabel.text = [titleT objectAtIndex:indexPath.section];
        NSArray  * titleI=_imagearray[0];
        cell.imageView.image=[UIImage imageNamed:[titleI objectAtIndex:indexPath.section]];
        NSLog(@"section==== %ld",(long)indexPath.section);
        
        cell.backgroundColor = [UIColor whiteColor];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
     
        cell.textLabel.textColor = [UIColor darkGrayColor];
        //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth = 1;
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        cell.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
        cell.layer.shadowOffset = CGSizeMake(2,3);
        cell.layer.shadowRadius = 6;
        cell.layer.shadowOpacity = 1;
        cell.layer.cornerRadius = 8;
    }
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 10.f;
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
    NSLog(@"index == %ld",indexPath.section);
}

@end
