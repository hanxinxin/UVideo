//
//  LLSearchSuggestionVC.m
//  LLSearchView
//
//  Created by mac on 2021/6/1.
//  Copyright © 2021年 mac. All rights reserved.
//

#import "LLSearchSuggestionVC.h"
#import "MHYouKuController.h"
#import "WSLWaterFlowLayout.h"
#import "vlistCollectionViewCell.h"
#import "FankuiViewController.h"

#define VCellReuseID @"vlistCollectionViewCell"

@interface LLSearchSuggestionVC ()<WSLWaterFlowLayoutDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

//@property (nonatomic, strong) UITableView *contentView;
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)NSIndexPath * indexPath;
@property (nonatomic, copy)   NSString *searchTest;
@property(assign,nonatomic)NSInteger SXpage;

///无内容显示view
@property (strong, nonatomic) UIView *nilView;
@property (strong, nonatomic) UIImageView * nilImageView;
@property (strong, nonatomic) UILabel * nilLabel;
@property(nonatomic,strong)UIButton * XGBtn;
@end

@implementation LLSearchSuggestionVC

//- (UITableView *)contentView
//{
//    if (!_contentView) {
//        self.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) style:UITableViewStylePlain];
//        _contentView.delegate = self;
//        _contentView.dataSource = self;
//        _contentView.backgroundColor = [UIColor whiteColor];
//        _contentView.tableFooterView = [UIView new];
//    }
//    return _contentView;
//}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
//        _collectionView = [[UIcollectionView alloc]initWithFrame:CGRectMake(0, _subView.bottom, self.view.bounds.size.width, self.view.bounds.size.height-(_subView.height)) style:UIcollectionViewStylePlain];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
        
        WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
        layout.delegate = self;
        layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
        
        // 创建瀑布流view
        UICollectionView *collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20,self.view.height-kNavBarAndStatusBarHeight) collectionViewLayout:layout];
        // 设置数据源
        collectionView1.dataSource = self;
        collectionView1.delegate=self;
        collectionView1.backgroundColor = [UIColor whiteColor];
        // 是否滚动//
        collectionView1.scrollEnabled = YES;
//        [collectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(@0);
//            make.width.mas_equalTo(self.subView.width);
//            make.height.equalTo(@370);
//        }];
        self.collectionView = collectionView1;
        
        // 注册cell
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([vlistCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:VCellReuseID];
        
        
        
    }
    return _collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArr=[NSMutableArray arrayWithCapacity:0];
    self.keyword=@"";
    self.SXpage=1;
    [self initnilView];
    
//    [self.view addSubview:self.contentView];
    [self.view addSubview:self.collectionView];
    
    // 为瀑布流控件添加下拉加载和上拉加载
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getSXCollecheader];
    }];
    // 第一次进入则自动加载
//    [self.collectionView.mj_header beginRefreshing];
    
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getSXCollecfoot];
    }];
    
    
}

///// 加载无内容显示的view
-(void)initnilView
{
    self.nilView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-kNavBarAndStatusBarHeight)];
    self.nilView.backgroundColor=[UIColor whiteColor];
    [self.nilView setUserInteractionEnabled:YES];
    self.nilImageView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (self.view.height-40-200-kNavBarAndStatusBarHeight)/2, 250, 150)];
    [self.nilImageView setImage:[UIImage imageNamed:@"nilImage"]];
    [self.nilView addSubview:self.nilImageView];
    self.nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.nilImageView.left, self.nilImageView.bottom, self.nilImageView.width, 30)];
    [self.nilLabel setText:@"没有您搜索的内容"];
    self.nilLabel.textAlignment=NSTextAlignmentCenter;
    [self.nilLabel setTextColor:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0]];
    
    
    self.XGBtn= [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.XGBtn.frame = CGRectMake(20, self.nilView.height-86, self.nilView.width-40,46);
    self.XGBtn.alpha = 1;
    self.XGBtn.layer.cornerRadius = 10;
    self.XGBtn.backgroundColor=RGBA(20, 155, 236, 1);
    [self.XGBtn setTitle:@"我要求片" forState:(UIControlStateNormal)];
    [self.XGBtn.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [self.XGBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
    [self.XGBtn setUserInteractionEnabled:YES];
    [self.XGBtn addTarget:self action:@selector(XG_touch:) forControlEvents:(UIControlEventTouchDown)];
    [self.nilView addSubview:self.XGBtn];
    
    [self.nilView setHidden:YES];
    [self.nilView addSubview:self.nilLabel];
}
//显示
-(void)addnilView
{
    self.nilView.hidden=NO;
    [self.view addSubview:self.nilView];
}

//删除
-(void)removeNilView
{
    self.nilView.hidden=YES;
//    [self.nilView removeFromSuperview];
}
-(void)XG_touch:(id)sender
{
    // 求片
    FankuiViewController * avc = [[FankuiViewController alloc] init];
    avc.typeInt=1002;
    [self pushRootNav:avc animated:YES];
}

-(void)getSXCollecheader
{
//    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%@",@(self.SXpage)],
//                            @"pagesize":[NSString stringWithFormat:@"%@",@(15)],};
    
    self.SXpage=1;
    NSMutableDictionary*dict =[NSMutableDictionary dictionary];
    [dict setObject:self.keyword forKey:@"keyword"];
    [dict setObject:[NSString stringWithFormat:@"%@",@(self.SXpage)] forKey:@"page"];
    [dict setObject:[NSString stringWithFormat:@"%@",@(15)] forKey:@"pagesize"];
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_listurl] Dictionary:dict success:^(id  _Nullable responseObject) {
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            
                NSDictionary  * dataArr = [dict objectForKey:@"data"];
                // 清空数据
                [self.dataArr removeAllObjects];
                NSMutableArray* arr=[NSMutableArray arrayWithCapacity:0];
                NSArray * video_list = [dataArr objectForKey:@"video_list"];
            if(![video_list isKindOfClass:[NSNull class]]){
         
            if(video_list.count>0)
            {
                [self removeNilView];
                for (int i=0; i<video_list.count; i++) {
                    
                    VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_list[i]];
                    [arr addObject:model];
                    
                }
                [self.dataArr addObjectsFromArray:arr];
            }else{
                [self addnilView];
            }
            }
            [self.collectionView.mj_header endRefreshing];
                // 刷新数据
                [self.collectionView reloadData];
            
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showTXTWithStatus:message delay:2.f];
            [self.collectionView.mj_header endRefreshing];
            // 刷新数据
            [self.collectionView reloadData];
        }
        
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                [self.collectionView.mj_header endRefreshing];
                // 刷新数据
                [self.collectionView reloadData];
            }];
}

-(void)getSXCollecfoot
{
//    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%@",@(self.SXpage)],
//                            @"pagesize":[NSString stringWithFormat:@"%@",@(15)],};
    NSMutableDictionary*dict =[NSMutableDictionary dictionary];
//
    
    [dict setObject:self.keyword forKey:@"keyword"];
    [dict setObject:[NSString stringWithFormat:@"%@",@(self.SXpage+1)] forKey:@"page"];
    [dict setObject:[NSString stringWithFormat:@"%@",@(15)] forKey:@"pagesize"];
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_listurl] Dictionary:dict success:^(id  _Nullable responseObject) {
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            
                NSDictionary  * datadict = [dict objectForKey:@"data"];
                NSMutableArray* arr=[NSMutableArray arrayWithCapacity:0];
                NSArray * video_list = [datadict objectForKey:@"video_list"];
            if(![video_list isKindOfClass:[NSNull class]]){
            if(video_list.count>0)
            {
                self.SXpage+=1;
                for (int i=0; i<video_list.count; i++) {
                    
                    VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_list[i]];
                    [arr addObject:model];
                    
                }
                [self.dataArr addObjectsFromArray:arr];
            }
            }
            [self.collectionView.mj_footer endRefreshing];
                // 刷新数据
                [self.collectionView reloadData];
            
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showTXTWithStatus:message delay:2.f];
            [self.collectionView.mj_footer endRefreshing];
            // 刷新数据
            [self.collectionView reloadData];
        }
        
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                [self.collectionView.mj_footer endRefreshing];
                // 刷新数据
                [self.collectionView reloadData];
            }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchTestChangeWithTest:(NSString *)test
{
    _searchTest = test;
    self.keyword=test;
    self.SXpage=1;
//    [_contentView reloadData];
    [self SearchGetData:test];
    [self.collectionView reloadData];
}
-(void)SearchGetData:(NSString*)string
{
    
//    |sort_field|否|string||排序依据字段(create_time|update_time|hits|score)|
//    |sort_type|否|string||排序类型(desc=降序|asc=升序)|
    // 清空数据
    [self.dataArr removeAllObjects];
    [self.collectionView reloadData];
//    NSDictionary*dict =nil;
//
//        dict = @{@"keyword":string,
////                 @"sort_field":@"score",
////                 @"sort_type":@"asc"
//
//        };
    self.SXpage=1;
    NSMutableDictionary*dict =[NSMutableDictionary dictionary];
    [dict setObject:string forKey:@"keyword"];
    [dict setObject:[NSString stringWithFormat:@"%@",@(self.SXpage)] forKey:@"page"];
    [dict setObject:[NSString stringWithFormat:@"%@",@(15)] forKey:@"pagesize"];
    [[HttpManagement shareManager] StartcancelAllOperations];
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_listurl] Dictionary:dict success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
            [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    
                        NSDictionary  * dataArray = [dict objectForKey:@"data"];
                        // 清空数据
                        [self.dataArr removeAllObjects];
                        NSMutableArray* arr=[NSMutableArray arrayWithCapacity:0];
                        NSArray * video_list = [dataArray objectForKey:@"video_list"];
                    if(![video_list isKindOfClass:[NSNull class]]){
                    if(video_list.count>0)
                    {
                        [self removeNilView];
                        for (int i=0; i<video_list.count; i++) {
                            
                            VideoRankMode *model = [VideoRankMode yy_modelWithDictionary:video_list[i]];
                            [arr addObject:model];
                            
                        }
                        [self.dataArr addObjectsFromArray:arr];
                        
                        
                        }else
                        {
                            [self addnilView];
                        }
                    }else
                    {
                        [self addnilView];
                    }
                        // 刷新数据
                        [self.collectionView reloadData];
                    
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                    // 刷新数据
                    [self.collectionView reloadData];
                }
        
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
                // 刷新数据
                [self.collectionView reloadData];
            }];
}
#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    vlistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VCellReuseID forIndexPath:indexPath];
    
    VideoRankMode*model=self.dataArr[indexPath.item];
    
    cell.model=model;
    // 返回cell
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择第%ld素材",indexPath.item);
    
//    MHYouKuController *avc = [[MHYouKuController alloc] init];
//    [self pushRootNav:avc animated:YES];
    VideoRankMode*Vmodel=self.dataArr[indexPath.row];
    [self getVideoInfo:[NSString stringWithFormat:@"%f",Vmodel.id]];
   
    
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
-(void)pushViewControllerVideo:(ZVideoMode*)mode{
    MHYouKuController *avc = [[MHYouKuController alloc] init];
    avc.Zvideomodel= mode;
    [self pushRootNav:avc animated:YES];
}
#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat wid=(self.collectionView.width-50)/3;
    CGFloat hei=wid/3*4 + 50;
        return CGSizeMake(wid, hei);
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
    

    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - UITableViewDataSource -

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return (_searchTest.length > 0) ? (10 / _searchTest.length) : 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellId = @"CellIdentifier";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%@编号%ld", _searchTest, indexPath.row];
//    return cell;
//}
//
//
//#pragma mark - UITableViewDelegate -
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.searchBlock) {
//        self.searchBlock([NSString stringWithFormat:@"%@编号%ld", _searchTest, indexPath.row]);
//    }
//}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
    // 回收键盘
//    [self.searchBar resignFirstResponder];
}
@end
