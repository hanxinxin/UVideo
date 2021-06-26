//
//  menberViewController.m
//  video
//
//  Created by macbook on 2021/5/9.
//

#import "menberViewController.h"
#import "CZCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
#import "vipHeaderView.h"
#import "HXtitleLabelView.h"
#import "KFView.h"
#import "KMPlayView.h"
#import "chongzhiView.h"
#import "PlayWTView.h"
#import "Paymentmethodlist.h"
#import "customerInfoMode.h"
#import "vipcardcategorylistModel.h"

#import "menberJSCollectionViewCell.h"

#define CZCollectionViewCellID @"CZCollectionViewCell"
#define MBCollectionViewCellID @"menberJSCollectionViewCell"
@interface menberViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,WSLWaterFlowLayoutDelegate,UITextFieldDelegate>
{
    NSDictionary *keyboardInfo;
}
@property (nonatomic, copy) NSMutableArray *moneyArray;
@property (nonatomic, assign) NSInteger moneyselect;
@property (nonatomic, strong) NSMutableArray *PayArray;
@property (nonatomic, strong) NSMutableArray *imagearray;
@property (nonatomic, strong) vipHeaderView *Topview;
@property(nonatomic,strong)UIScrollView*ScrollView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UICollectionView *menbercollectionView;
@property (nonatomic, weak) HXtitleLabelView *menberLabel;
@property (nonatomic, weak) UIButton *ConfirmPlayBtn;
@property (nonatomic, copy) NSMutableArray *menberJSArray;
@property(nonatomic,strong)UITableView*downtableview;
@property (nonatomic, assign) NSInteger tableviewselect;

///客服view
@property (strong, nonatomic) KFView*kfView;
@property (nonatomic, strong) NSMutableArray *kefuArray;

@property (strong, nonatomic) KMPlayView*kmPlayView;
@property (strong, nonatomic) chongzhiView*czView;
@property (strong, nonatomic) PlayWTView*playwtView;


@end

@implementation menberViewController

@synthesize ScrollView;

- (NSMutableArray *)moneyArray
{
    if (_moneyArray == nil) {
        _moneyArray = [NSMutableArray array];
    }
    return _moneyArray;
}
- (NSMutableArray *)menberJSArray
{
    if (_menberJSArray == nil) {
        _menberJSArray = [NSMutableArray array];
    }
    return _menberJSArray;
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
- (NSMutableArray *)kefuArray
{
    if (_kefuArray == nil) {
        _kefuArray = [NSMutableArray array];
    }
    return _kefuArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addScrollView];
    [self addTopView];
    [self setupCollectionView];
    [self Addtableview];
//    [self setupCollectionViewMenber];
    
    [self addkfViewM];
    [self addKMViewM];
    [self addCZViewM];
    [self addplaywtViewM];
    
    
    [self addNoticeForKeyboard];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self postPlayList];
    [self getcustomerServicelistData];
    [self Getvip_card_category_list];
}
-(void)postPlayList
{
    
    [UHud showHUDLoading];
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,payment_methodurl] Dictionary:nil success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
        
                if([code intValue]==0)
                {
                    NSDictionary *dictdata =[dict objectForKey:@"data"];
                    NSArray * payment_method_list=[dictdata objectForKey:@"payment_method_list"];
                    if(![payment_method_list isKindOfClass:[NSNull class]]){
                    if(payment_method_list.count>0)
                    {
                        [self.PayArray removeAllObjects];
                        for (int i=0; i<payment_method_list.count; i++) {
//                            [DYModelMaker DY_makeModelWithDictionary:payment_method_list[i] modelKeyword:@"payment" modelName:@"paymentmethodlist"];
//                            
                            Paymentmethodlist *model = [Paymentmethodlist yy_modelWithDictionary:payment_method_list[i]];
                            [self.PayArray addObject:model];
                            
                        }
                        self.downtableview.frame=CGRectMake(20, self.collectionView.bottom+10, SCREEN_WIDTH-40, (self.PayArray.count+2)*50+(self.PayArray.count+2)*10);
                        [self.downtableview reloadData];
                        [self setupCollectionViewMenber];
                    }
                    
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


-(void)Getvip_card_category_list
{
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,vipCardcategoryurl] Dictionary:nil success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
        
                if([code intValue]==0)
                {
                    NSDictionary *dictdata =[dict objectForKey:@"data"];
                    NSArray * vip_card_category_list=[dictdata objectForKey:@"vip_card_category_list"];
                    if(![vip_card_category_list isKindOfClass:[NSNull class]]){
                    if(vip_card_category_list.count>0)
                    {
                        [self.moneyArray removeAllObjects];
                        for (int i=0; i<vip_card_category_list.count; i++) {
//                            [DYModelMaker DY_makeModelWithDictionary:vip_card_category_list[i] modelKeyword:@"vipcardcategorylist" modelName:@"Model"];
//
                            vipcardcategorylistModel *model = [vipcardcategorylistModel yy_modelWithDictionary:vip_card_category_list[i]];
                            [self.moneyArray addObject:model];
                            
                        }
                        
                        self.collectionView.frame=CGRectMake(20, self.Topview.bottom+8, SCREEN_WIDTH-40, ceilf((self.moneyArray.count/2.0))*95);
                        [self.collectionView reloadData];
                    }
                    
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


-(void)postpurchaseVipCardurl
{
    if(_tableviewselect!=0)
    {
        if(_tableviewselect!=(self.PayArray.count+1))
        {
            [UHud showHUDLoading];
            vipcardcategorylistModel *modelA = self.moneyArray[_moneyselect];
            Paymentmethodlist *modelB = self.PayArray[_tableviewselect-1];
            NSDictionary *dict=@{@"vip_card_category_id":[NSString stringWithFormat:@"%.f",modelA.id],
                         @"payment_method_id":[NSString stringWithFormat:@"%.f",modelB.id],
            };
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,purchaseVipCardurl] Dictionary:dict success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
        
                if([code intValue]==0)
                {
                    NSDictionary *dictdata =[dict objectForKey:@"data"];
                    NSString *redirect_url =[dictdata objectForKey:@"redirect_url"];
                    if(redirect_url.length>0)
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirect_url]];
                        [self updateAlt];
                    }
//                    NSArray * vip_card_category_list=[dictdata objectForKey:@"vip_card_category_list"];
//                    if(![vip_card_category_list isKindOfClass:[NSNull class]]){
//
//                    }
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                }
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
            }];
            
        }else{
            [UHud showTXTWithStatus:@"选择的支付方式不对" delay:2.f];
        }
    }else{
        [UHud showTXTWithStatus:@"选择的支付方式不对" delay:2.f];
    }
}


-(void)updateAlt
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功后可能会有延迟，大约3分钟内到账，请下拉刷新页面查询会员信息" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
        }];
     
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
}



-(void)addScrollView
{
    ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-(kNavAndTabHeight))];
//    ScrollView.backgroundColor=[UIColor blueColor];
    ScrollView.contentSize = CGSizeMake( SCREEN_WIDTH, SCREENH_HEIGHT);
    [self.view addSubview:ScrollView];
    // 为ScrollView添加下拉加载
    self.ScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            [self getInfoData];
    }];
    [self.ScrollView.mj_header beginRefreshing];
}

-(void)getInfoData
{
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,GetUserInfoURL] Dictionary:nil success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata=[dict objectForKey:@"data"];
            NSDictionary *userdata =[dictdata objectForKey:@"user"];
            NSString * email = [userdata objectForKey:@"email"];
            NSNumber * vip_expired_time = [userdata objectForKey:@"vip_expired_time"];
            NSString * nickname = [userdata objectForKey:@"nickname"];
            NSString * username = [userdata objectForKey:@"username"];
            NSString * avatar = [userdata objectForKey:@"avatar"];
            
            [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"UserZH"];
            [[NSUserDefaults standardUserDefaults] setValue:nickname forKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:avatar forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setValue:vip_expired_time forKey:@"vip_expired_time"];
            
//            [UHud showHudWithStatus:@"登录成功" delay:2.f];
            [self.ScrollView.mj_header endRefreshing];
            [self updateHeaderViwe];
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showHudWithStatus:message delay:2.f];
            [self.ScrollView.mj_header endRefreshing];
            [self updateHeaderViwe];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [self.ScrollView.mj_header endRefreshing];
        [self updateHeaderViwe];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
}
-(void)updateHeaderViwe
{
    if(self.Topview)
    {
        if(![self StringIsNullOrEmpty:avatar_loca])
        {
            [self.Topview.txImage setImage:[self base64Image:avatar_loca] forState:(UIControlStateNormal)];
        }
        if(![self StringIsNullOrEmpty:nickname_loca])
        {
            [self.Topview.nameBtn setTitle:nickname_loca forState:(UIControlStateNormal)];
        }else{
            if(![self StringIsNullOrEmpty:username_loca] )
            {
                [self.Topview.nameBtn setTitle:username_loca  forState:(UIControlStateNormal)];
            }else{
                [self.Topview.nameBtn setTitle:@"未登录" forState:(UIControlStateNormal)];
            }
        }
        if([vip_expired_time_loca intValue]==0)
        {
            [self.Topview.dateBtn setTitle:@"马上充值会员，立刻享受VIP观影特权" forState:(UIControlStateNormal)];
            [self.Topview.bgImage setImage:[UIImage imageNamed:@"novipbg"]];
        }else{
            [self.Topview.dateBtn setTitle:[NSString stringWithFormat:@"会员到期时间: %@",[self getTimeFromTimestamp:vip_expired_time_loca]] forState:(UIControlStateNormal)];
        }
    }
}

-(void)addTopView
{
    vipHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:@"vipHeaderView" owner:self options:nil]objectAtIndex:0];
    view.frame=CGRectMake(20, 8, SCREEN_WIDTH-40, 120);
    view.txImage.layer.masksToBounds = YES;
    view.txImage.layer.cornerRadius=20;
    [ScrollView addSubview:view];
    self.Topview = view;
}


- (void)setupCollectionView
{
    
    _moneyselect=0;
    WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.tag=2001;
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    // 创建瀑布流view
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 130, SCREEN_WIDTH-40, 185) collectionViewLayout:layout];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, self.Topview.bottom+8, SCREEN_WIDTH-40, 185) collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.tag=2001;
    // 是否滚动//
    collectionView.scrollEnabled = NO;
    [ScrollView addSubview:collectionView];

    self.collectionView = collectionView;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CZCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:CZCollectionViewCellID];
//    [self.collectionView registerClass:[SHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
    // 为瀑布流控件添加下拉加载和上拉加载
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//            [self getDataList_header];
//    }];
//    // 第一次进入则自动加载
//    [self.collectionView.mj_header beginRefreshing];
    
    
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
    [self.collectionView reloadData];
    
}
-(void)Addtableview
{
    _tableviewselect=1; ///默认为1 0是title
//    _PayArray=[NSMutableArray arrayWithCapacity:0];
//    NSArray* titlearr=[NSArray arrayWithObjects:@"选择支付方式",@"",@"",@"",@"卡密支付",@"联系客服充值", nil];
//    [_PayArray addObject:titlearr];
//    _imagearray=[NSMutableArray arrayWithCapacity:0];
//    NSArray * iamgearr = [NSArray arrayWithObjects:@"",@"paypal",@"zhifubao",@"wximage",@"yhkimage",@"",nil];
//    [_imagearray addObject:iamgearr];
    self.downtableview=[[UITableView alloc] init];
    self.downtableview.frame=CGRectMake(20, self.collectionView.bottom+10, SCREEN_WIDTH-40, (self.PayArray.count+2)*50+(self.PayArray.count+1)*10);
    self.downtableview.backgroundColor=[UIColor clearColor];
    self.downtableview.delegate=self;
    self.downtableview.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;

    [ScrollView addSubview:self.downtableview];
    
}

/// 会员介绍 CollectionView
- (void)setupCollectionViewMenber
{

    [self.menberLabel removeFromSuperview];
    [self.menbercollectionView removeFromSuperview];
    [self.ConfirmPlayBtn removeFromSuperview];
    HXtitleLabelView *view = [[[NSBundle mainBundle]loadNibNamed:@"HXtitleLabelView" owner:self options:nil]objectAtIndex:0];
    view.frame=CGRectMake(20, self.downtableview.bottom+8, SCREEN_WIDTH-40, 40);
    [ScrollView addSubview:view];
    self.menberLabel = view;
    
    WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.tag=3001;
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
    // 创建瀑布流view
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 130, SCREEN_WIDTH-40, 185) collectionViewLayout:layout];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, self.menberLabel.bottom, SCREEN_WIDTH-40, 210) collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.tag=3001;
    // 是否滚动//
    collectionView.scrollEnabled = NO;
//    cell.backgroundColor=[UIColor clearColor];
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = collectionView.frame;
//    gl.startPoint = CGPointMake(0.5, 1);
//    gl.endPoint = CGPointMake(0.5, 0);
//    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0].CGColor];
//    gl.locations = @[@(0),@(1.0f)];
//
//    [collectionView.layer insertSublayer:gl atIndex:0];
//    gl.zPosition = 0;
    
    
    
    [ScrollView addSubview:collectionView];

    self.menbercollectionView = collectionView;
    
    // 注册cell
    [self.menbercollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([menberJSCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:MBCollectionViewCellID];
//    [self.collectionView registerClass:[SHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SHeaderView1"];
    [self getmenberList];
//    // 为瀑布流控件添加下拉加载和上拉加载
//    self.menbercollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//
//            [self getmenberList];
//    }];
//    // 第一次进入则自动加载
//    [self.menbercollectionView.mj_header beginRefreshing];
    
    
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 模拟网络请求延迟
////            [self getDataList_footer1];
//
//        });
//    }];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame=CGRectMake(20, self.menbercollectionView.bottom+25, SCREEN_WIDTH-40, 44);
    [btn setTitle:@"确认支付" forState:(UIControlStateNormal)];
    [btn setTintColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(play_Touch:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.layer.cornerRadius=8;
    btn.backgroundColor=[UIColor colorWithRed:106/255.0 green:203/255.0 blue:233/255.0 alpha:1.0];
//    CAGradientLayer *glbtn = [CAGradientLayer layer];
//    glbtn.frame = btn.frame;
//    glbtn.startPoint = CGPointMake(0.5, 1);
//    glbtn.endPoint = CGPointMake(0.5, 0);
//    glbtn.colors = @[(__bridge id)[UIColor colorWithRed:106/255.0 green:203/255.0 blue:233/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0].CGColor];
//    glbtn.locations = @[@(0),@(1.0f)];
//    glbtn.zPosition = -10;
//    [btn.layer insertSublayer:glbtn atIndex:0];
    [ScrollView addSubview:btn];
    self.ConfirmPlayBtn =btn;
    
//    ScrollView.contentSize = CGSizeMake( self.view.bounds.size.width, self.ConfirmPlayBtn.height+self.Topview.height+self.collectionView.height+self.menbercollectionView.height+self.downtableview.height+40+40);
//    NSLog(@"size bottom == %f",self.ConfirmPlayBtn.height+self.Topview.height+self.collectionView.height+self.menbercollectionView.height+self.downtableview.height+40+40);
    ScrollView.contentSize = CGSizeMake( self.view.bounds.size.width, self.ConfirmPlayBtn.bottom+30);
    NSLog(@"size bottom == %f",self.ConfirmPlayBtn.bottom+30);
}

-(void)getmenberList
{
    [self.menbercollectionView.mj_header endRefreshing];
    [self.menberJSArray removeAllObjects];
    [self.menberJSArray addObject:@{@"img":@"qingxiHD",@"title":@"清/蓝光清晰度"}];
    [self.menberJSArray addObject:@{@"img":@"beishuplay",@"title":@"倍数播放"}];
    [self.menberJSArray addObject:@{@"img":@"duxiangpy",@"title":@"VIP会员独享片源"}];
    [self.menberJSArray addObject:@{@"img":@"tiaoguopw",@"title":@"跳过片头/片尾"}];
    [self.menberJSArray addObject:@{@"img":@"guolvgg",@"title":@"过滤广告"}];
    [self.menberJSArray addObject:@{@"img":@"menberbiaoshi",@"title":@"VIP会员标识"}];
    [self.menbercollectionView reloadData];
    
}

-(void)play_Touch:(id)sender
{
    NSLog(@"点击了 play");
    [self postpurchaseVipCardurl];
}



#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    if(collectionView.tag==2001)
    {
    return 1;
    }else if(collectionView.tag==3001)
    {
        return 1;
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag==2001)
    {
        return self.moneyArray.count;
    }else if(collectionView.tag==3001)
    {
        return self.menberJSArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==2001)
    {
      
    // 创建cell
    CZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CZCollectionViewCellID forIndexPath:indexPath];
    
        vipcardcategorylistModel *model = self.moneyArray[indexPath.item];
        cell.topLabel.text=[NSString stringWithFormat:@"%@",model.name];
        cell.centerLabel.text=[NSString stringWithFormat:@"%@ %@",model.price,model.currency];
        cell.downLabel.text=[NSString stringWithFormat:@"%.f 天",model.period];
    // 给cell传递模型
    if(_moneyselect==indexPath.item)
    {
        cell=[self setcellSelect:cell];
    }else{
        cell=[self setcellNoSelect:cell];
    }
    // 返回cell
    return cell;
       
    }else if(collectionView.tag==3001)
    {
        
        menberJSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MBCollectionViewCellID forIndexPath:indexPath];
        NSDictionary * dict = self.menberJSArray[indexPath.item];
        [cell.topbg setImage:[UIImage imageNamed:[dict objectForKey:@"img"]]];
        cell.backgroundColor=[UIColor clearColor];
        cell.downtitle.text=[dict objectForKey:@"title"];
        [cell.downtitle setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]];
        return cell;
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==2001)
    {
        NSLog(@"选择第%ld素材",indexPath.item);
        _moneyselect = indexPath.item;
        [self.collectionView reloadData];
    }else if(collectionView.tag==3001)
    {
        
    }
   
    
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
    if(waterFlowLayout.tag==2001)
    {
        return CGSizeMake((self.collectionView.width-30)/2, 76);
    }else if(waterFlowLayout.tag==3001)
    {
        return CGSizeMake((self.menbercollectionView.width-15)/3, 82);
    }
    return CGSizeMake(0, 0);
}
///** 头视图Size */
//-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
//    return CGSizeMake(self.collectionView.width, 40);
//}


/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    if(waterFlowLayout.tag==2001)
    {
        return 2;
    }else if(waterFlowLayout.tag==3001)
    {
        return 3;
    }
    return 2;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    if(waterFlowLayout.tag==2001)
    {
        return 10;
    }else if(waterFlowLayout.tag==3001)
    {
        return 5;
    }
    return 10;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    if(waterFlowLayout.tag==2001)
    {
        return 10;
    }else if(waterFlowLayout.tag==3001)
    {
        return 5;
    }
    return 10;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    if (waterFlowLayout.flowLayoutStyle == (WSLWaterFlowLayoutStyle)3){
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }else if(waterFlowLayout.tag==2001)
    {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }else if(waterFlowLayout.tag==3001)
    {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}






#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.PayArray.count+2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
    NSLog(@"section==== %ld",(long)indexPath.section);
    if(indexPath.section==0)
    {
        cell.textLabel.text = @"选择支付方式";
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
    }else if(indexPath.section==(self.PayArray.count+1))
    {
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [cell.contentView addSubview:lbl];
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            cell.textLabel.text =@"联系客服";
            cell.imageView.image=[UIImage imageNamed:@"yhkimage"];
        
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
//        NSLog(@"section==== %ld",(long)indexPath.section);
        
        cell.backgroundColor = [UIColor whiteColor];

//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.textLabel.textColor = [UIColor darkGrayColor];
        //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.layer.borderWidth = 1;
//            cell.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
//        cell.layer.shadowOffset = CGSizeMake(2,3);
//        cell.layer.shadowRadius = 6;
//        cell.layer.shadowOpacity = 1;
        cell.layer.cornerRadius = 8;
        if(_tableviewselect==indexPath.section)
        {
            
            cell.layer.borderColor = RGBA(255, 136, 0, 1).CGColor;
        }else{
            cell.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;

        
        }
    }else{
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [cell.contentView addSubview:lbl];
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        Paymentmethodlist *model = self.PayArray[indexPath.section-1];
        cell.textLabel.text=@"";
//        cell.textLabel.text = model.name;
        if([model.symbol isEqualToString:@"paypal"])
        {
            cell.imageView.image=[UIImage imageNamed:@"paypal"];
        }else if([model.symbol isEqualToString:@"alipay"])
        {
            cell.imageView.image=[UIImage imageNamed:@"zhifubao"];
        }else if([model.symbol isEqualToString:@"vip-card"])
        {
            cell.textLabel.text =@"卡密支付";
            cell.imageView.image=[UIImage imageNamed:@"yhkimage"];
        }
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
        
        cell.backgroundColor = [UIColor whiteColor];

//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.textLabel.textColor = [UIColor darkGrayColor];
        //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.layer.borderWidth = 1;
//            cell.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
//        cell.layer.shadowOffset = CGSizeMake(2,3);
//        cell.layer.shadowRadius = 6;
//        cell.layer.shadowOpacity = 1;
        cell.layer.cornerRadius = 8;
        if(_tableviewselect==indexPath.section)
        {
            
            cell.layer.borderColor = RGBA(255, 136, 0, 1).CGColor;
        }else{
            cell.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;

        
        }
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

    if(indexPath.section!=0)
    {
        if(indexPath.section==(self.PayArray.count+1))
        {
            if(self.kefuArray.count>0)
            {
                customerInfoMode*model=self.kefuArray[0];
                [self.kfView.EWMImage sd_setImageWithURL:[NSURL URLWithString:model.wechat_qrcode]];
            }
            [self showkfView];
        }else{
        Paymentmethodlist *model = self.PayArray[indexPath.section-1];
//        cell.textLabel.text = model.name;
        if([model.symbol isEqualToString:@"paypal"])
        {
            
        }else if([model.symbol isEqualToString:@"alipay"])
        {
            
        }else if([model.symbol isEqualToString:@"vip-card"])
        {
            [self showkmPlay];
        }
        }
     
//            [self showczView:YES];
//            [self showczView:NO];
//            [self showplaywtView];
//            [self showkfView];
        _tableviewselect=indexPath.section;
        [self.downtableview reloadData];
    }
    
}




#pragma mark  ---------------------    view 弹窗    -----------------

-(void)addkfViewM{
    KFView *view = [[[NSBundle mainBundle]loadNibNamed:@"KFView" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.8];
    view.hidden=YES;
    view.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 0);
//    view.bottomView.layer.cornerRadius=10;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
    [view.bottomView setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor] type:corners];
    [self.view addSubview:view];
    self.kfView=view;
    __weak menberViewController * weakSelf = self;
    self.kfView.touchIndex = ^(NSInteger Index) {
        
        NSLog(@"prompt idnex ==== %ld",Index);
        if(Index==0)
        {
            
        }else{
            
        }
        [weakSelf HidkfView];
    };
}
-(void)showkfView
{
    
    
    [UIView animateWithDuration:0.7 animations:^{
        self.kfView.bottomView.hidden=NO;
        self.kfView.hidden=NO;
        self.kfView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)HidkfView
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.kfView.bottomView.hidden=YES;
        self.kfView.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH,0 );
    } completion:^(BOOL finished) {
        self.kfView.hidden=YES;
    }];
}
-(void)addKMViewM{
    KMPlayView *view = [[[NSBundle mainBundle]loadNibNamed:@"KMPlayView" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.8];
    view.hidden=YES;
    view.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 0);
//    view.bottomView.layer.cornerRadius=10;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
    [view.bottomView setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor] type:corners];
    view.PWText.delegate=self;
    view.PWText.returnKeyType =UIReturnKeyDone;
    [self.view addSubview:view];
    self.kmPlayView=view;
    __weak menberViewController * weakSelf = self;
    self.kmPlayView.touchIndex = ^(NSInteger Index, NSString * _Nonnull pwStr) {
        
        NSLog(@"prompt idnex ==== %ld    pwStr=== %@",Index,pwStr);
        if(Index==0)
        {
            
        }else{
            [weakSelf postkmPlay:pwStr];
        }
        [weakSelf HidkmPlay];
        
        
    };
}
#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    NSString *trimText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textField == self.kmPlayView.PWText) {
        if ([trimText length] > 60) {
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /* 辞去第一响应者 */
        [textField resignFirstResponder];
    return YES;
}
-(void)postkmPlay:(NSString*)cipher
{
    [UHud showHUDLoading];
    NSDictionary* dict=@{@"cipher":cipher};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,PostCardactivateurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            NSDictionary *userdata =[dictdata objectForKey:@"user"];
            NSNumber * vip_expired_time = [userdata objectForKey:@"vip_expired_time"];
            [[NSUserDefaults standardUserDefaults] setValue:vip_expired_time forKey:@"vip_expired_time"];
            [self updateHeaderViwe];
            [UHud showTXTWithStatus:@"充值成功" delay:2.f];
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
-(void)showkmPlay
{
    
    [UIView animateWithDuration:0.7 animations:^{
        self.kmPlayView.bottomView.hidden=NO;
        self.kmPlayView.hidden=NO;
        self.kmPlayView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)HidkmPlay
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.kmPlayView.bottomView.hidden=YES;
        self.kmPlayView.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH,0 );
    } completion:^(BOOL finished) {
        self.kmPlayView.hidden=YES;
    }];
}
-(void)addCZViewM{
    chongzhiView *view = [[[NSBundle mainBundle]loadNibNamed:@"chongzhiView" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.8];
    view.hidden=YES;
    view.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 0);
    [view.titleBtn setBackgroundColor:[UIColor clearColor]];
    [view.titleBtn setTitle:@"充值失败，请返回重试" forState:(UIControlStateNormal)];
    [view.okBtn setTitle:@"返回重试" forState:(UIControlStateNormal)];
    [view.titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [view.centerBtn setImage:[UIImage imageNamed:@"playSB"] forState:UIControlStateNormal];
    [view.titleBtn setTitle:@"充值成功" forState:(UIControlStateSelected)];
    [view.okBtn setTitle:@"确认" forState:(UIControlStateSelected)];
    [view.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [view.centerBtn setImage:[UIImage imageNamed:@"playOK"] forState:UIControlStateSelected];
//    view.bottomView.layer.cornerRadius=10;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
    [view.bottomView setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor] type:corners];
    [self.view addSubview:view];
    self.czView=view;
    __weak menberViewController * weakSelf = self;
    self.czView.touchIndex = ^(NSInteger Index) {
        
        NSLog(@"prompt idnex ==== %ld",Index);
        if(Index==0)
        {
            
        }else{
            
        }
        [weakSelf HidczView];
    };
}
/// 充值提示
/// @param selectbool 成功 YES 失败NO
-(void)showczView:(BOOL)selectbool
{
    self.czView.titleBtn.selected=selectbool;
    self.czView.centerBtn.selected=selectbool;
    self.czView.okBtn.selected=selectbool;
    [UIView animateWithDuration:0.7 animations:^{
        self.czView.bottomView.hidden=NO;
        self.czView.hidden=NO;
        self.czView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)HidczView
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.czView.bottomView.hidden=YES;
        self.czView.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH,0 );
    } completion:^(BOOL finished) {
        self.czView.hidden=YES;
    }];
}
-(void)addplaywtViewM{
    PlayWTView *view = [[[NSBundle mainBundle]loadNibNamed:@"PlayWTView" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.8];
    view.hidden=YES;
    view.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 0);
//    view.bottomView.layer.cornerRadius=10;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
    [view.bottomView setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor] type:corners];
    [self.view addSubview:view];
    self.playwtView=view;
    __weak menberViewController * weakSelf = self;
    self.playwtView.touchIndex = ^(NSInteger Index) {
        
        NSLog(@"prompt idnex ==== %ld",Index);
        if(Index==0)
        {
            
        }else{
            
        }
        [weakSelf HidplaywtView];
    };
}

-(void)showplaywtView
{
    
    [UIView animateWithDuration:0.7 animations:^{
        self.playwtView.bottomView.hidden=NO;
        self.playwtView.hidden=NO;
        self.playwtView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)HidplaywtView
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.playwtView.bottomView.hidden=YES;
        self.playwtView.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH,0 );
    } completion:^(BOOL finished) {
        self.playwtView.hidden=YES;
    }];
}


#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //    获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    NSLog(@"%f      =    %f ",(self.kmPlayView.okPlayBtn.bottom+kbHeight+40),SCREENH_HEIGHT);
    CGFloat offset = (self.kmPlayView.okPlayBtn.bottom+kbHeight+40) - (SCREENH_HEIGHT);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.kmPlayView.frame = CGRectMake(0.0f, -offset, self.kmPlayView.frame.size.width, self.kmPlayView.frame.size.height);
//            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.height,self.view.frame.size.width);
        }];
    }
}






///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
//        self.view.frame = [UIScreen mainScreen].bounds;
        self.kmPlayView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight);
    }];
}



- (void)animationWithkeybooard:(void (^)(void))animations{
    NSTimeInterval duration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    animations();
    [UIView commitAnimations];
}

-(void)getcustomerServicelistData
{
    
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,postcustomerServicelisturl] Dictionary:nil success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            
            NSArray* customer_service_list=[dictdata objectForKey:@"customer_service_list"];
            if(![customer_service_list isKindOfClass:[NSNull class]]){
            if(customer_service_list.count>=0)
            {
                [self.kefuArray removeAllObjects];
                for (int i=0; i<customer_service_list.count; i++) {
//                    [DYModelMaker DY_makeModelWithDictionary:customer_service_list[i] modelKeyword:@"customer" modelName:@"InfoMode"];
                    customerInfoMode*model=[customerInfoMode yy_modelWithDictionary:customer_service_list[i]];
                    if([model.symbol isEqualToString:@"purchase_vip_card"])
                    [self.kefuArray addObject:model];
                }
                
            
            }
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
@end
