//
//  jiluViewController.m
//  video
//
//  Created by macbook on 2021/5/9.
//

#import "jiluViewController.h"

#import "SCJTableViewCell.h"
#import "SliderTableViewCell.h"
#import "VideoHistoryMode.h"
#import "VideoFavoriteMode.h"
#import "MHYouKuController.h"
#import "jlBottomView.h"


#define cellID @"cellID"
#define cellID2 @"SliderTableViewCell"
@interface jiluViewController ()<UITableViewDelegate,UITableViewDataSource,YTSliderViewDelegate>
@property(nonatomic,strong)UIView*topView;
@property(nonatomic,strong)UITableView*downtableview1;
@property (nonatomic ,strong)NSMutableArray*Listarray1;
@property (nonatomic,assign)NSInteger page1;

@property(nonatomic,strong)UITableView*downtableview2;
@property (nonatomic ,strong)NSMutableArray*Listarray2;
@property (nonatomic,assign)NSInteger page2;
@property(nonatomic,strong)UIButton *menuBtn1;
@property(nonatomic,strong)UIButton *menuBtn2;

@property(nonatomic,strong)CAGradientLayer *gl1n;
@property(nonatomic,strong)CAGradientLayer *gl1y;
@property(nonatomic,strong)CAGradientLayer *gl2n;
@property(nonatomic,strong)CAGradientLayer *gl2y;
///无内容显示view
@property (strong, nonatomic) UIView *nilView;
@property (strong, nonatomic) UIImageView * nilImageView;
@property (strong, nonatomic) UILabel * nilLabel;

///无内容显示view
@property (strong, nonatomic) UIView *nilView2;
@property (strong, nonatomic) UIImageView * nilImageView2;
@property (strong, nonatomic) UILabel * nilLabel2;


////   多选删除
@property (nonatomic ,strong) NSMutableArray *deleteArray;//删除的数据
@property (nonatomic ,strong) UIButton *btn;//编辑按钮
@property (nonatomic ,assign) BOOL isInsertEdit;//tableview编辑方式的判断
@property (nonatomic ,strong) jlBottomView *bottom_view;//底部视图


@end

@implementation jiluViewController
@synthesize topView,Listarray1,Listarray2;



- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        self.deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (jlBottomView *)bottom_view{
    if (!_bottom_view) {

        self.bottom_view = [[jlBottomView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.width, 40)];
        _bottom_view.backgroundColor = RGB(135,206,250);
        [_bottom_view.deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        [_bottom_view.allBtn addTarget:self action:@selector(tapAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottom_view;
}
/**
 删除数据方法
 */
- (void)deleteData{
//    if (self.deleteArray.count >0) {
//        [self.dataArray removeObjectsInArray:self.deleteArray];
//        [self.tableView reloadData];
//    }

    if(self.deleteArray.count>0)
    {
    if(self.menuBtn1.selected==YES)
    {
        [self PostVideo_emptyVideoFavorite:self.deleteArray];
    }else{
        [self PostVideo_emptyVideoHistory:self.deleteArray];
    }
    }else{
        [UHud showTXTWithStatus:@"没有选择要删除的记录" delay:2.f];
    }
}

- (UIButton *)btn{
    if (!_btn) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];

        _btn.frame = CGRectMake(0, 0, 40, 25);
        [_btn setTitle:@"完成" forState:UIControlStateSelected];
        [_btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        _btn.selected=NO;
        [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_btn setTitleColor:GNavBtnTitleColorNormal forState:UIControlStateNormal];
        [_btn setTitleColor:GNavBtnTitleColorSelect forState:UIControlStateHighlighted];
        _btn.titleLabel.font = GNavBtnTitleFont;

        [_btn sizeToFit];
        [_btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"记录";
    //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(noticeUpdate:) name:@"listUpdate" object:nil];
    
    
    self.page1=1;
    self.page2=1;
    Listarray1=[NSMutableArray arrayWithCapacity:0];
    Listarray2=[NSMutableArray arrayWithCapacity:0];
    
    ////设置  右侧按钮

    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    
    [self addtopview];
    [self initnilView1];
    [self initnilView2];
    [self Addtableview1];
    [self Addtableview2];
    [self touchOne:nil];
    [self addnilView1];
    [self addnilView2];
    [self removeNilView1];
    [self removeNilView2];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(self.downtableview1)
        {
            [self getheaderData1];
        }
        if(self.downtableview2)
        {
            [self getheaderData2];
        }
        });
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:@"listUpdate"];
   
}
-(void)noticeUpdate:(NSNotification *)not
{
    NSDictionary*userInfo=not.userInfo;
    NSNumber* index=[userInfo objectForKey:@"update"];
    if([index intValue]==1)
    {
        if(self.menuBtn1.selected==NO)
        {
            [self.menuBtn1.layer insertSublayer:_gl1y above:_gl1n];
            [self.menuBtn2.layer insertSublayer:_gl2n above:_gl2y];

            [self.menuBtn1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
            [self.menuBtn2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        }
        self.downtableview1.hidden=NO;
        self.downtableview2.hidden=YES;
        self.menuBtn1.selected=YES;
        self.menuBtn2.selected=NO;
    }else if([index intValue]==2)
    {
        if(self.menuBtn2.selected==NO)
        {
            [self.menuBtn1.layer insertSublayer:_gl1n above:_gl1y];
            [self.menuBtn2.layer insertSublayer:_gl2y above:_gl2n];

            [self.menuBtn1 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
            [self.menuBtn2 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        }
        self.downtableview1.hidden=YES;
        self.downtableview2.hidden=NO;
        self.menuBtn1.selected=NO;
        self.menuBtn2.selected=YES;
    }
}

///// 加载无内容显示的view
-(void)initnilView1
{
    self.nilView=[[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, self.downtableview1.height)];
    self.nilView.backgroundColor=[UIColor whiteColor];
    self.nilImageView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (self.view.height-40-200-kNavBarAndStatusBarHeight)/2, 250, 150)];
    [self.nilImageView setImage:[UIImage imageNamed:@"nilImage"]];
    [self.nilView addSubview:self.nilImageView];
    self.nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.nilImageView.left, self.nilImageView.bottom, self.nilImageView.width, 30)];
    [self.nilLabel setText:@"暂无记录"];
    self.nilLabel.textAlignment=NSTextAlignmentCenter;
    [self.nilLabel setTextColor:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0]];
    [self.nilView addSubview:self.nilLabel];
}

///// 加载无内容显示的view
-(void)initnilView2
{
    self.nilView2=[[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, self.downtableview2.height)];
    self.nilView2.backgroundColor=[UIColor whiteColor];
    self.nilImageView2=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (self.view.height-40-200-kNavBarAndStatusBarHeight)/2, 250, 150)];
    [self.nilImageView2 setImage:[UIImage imageNamed:@"nilImage"]];
    [self.nilView2 addSubview:self.nilImageView2];
    self.nilLabel2=[[UILabel alloc] initWithFrame:CGRectMake(self.nilImageView2.left, self.nilImageView2.bottom, self.nilImageView2.width, 30)];
    [self.nilLabel2 setText:@"暂无记录"];
    self.nilLabel2.textAlignment=NSTextAlignmentCenter;
    [self.nilLabel2 setTextColor:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0]];
    [self.nilView2 addSubview:self.nilLabel2];
}
//显示
-(void)addnilView1
{
    self.nilView.hidden=NO;
    [self.downtableview1 addSubview:self.nilView];
}
//显示
-(void)addnilView2
{
    self.nilView2.hidden=NO;
    [self.downtableview2 addSubview:self.nilView2];
}
//删除
-(void)removeNilView1
{
    self.nilView.hidden=YES;
//    [self.nilView removeFromSuperview];
}

//删除
-(void)removeNilView2
{
    self.nilView2.hidden=YES;
//    [self.nilView removeFromSuperview];
}


-(void)addtopview
{
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 60)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(15,2,((SCREEN_WIDTH-40)/2)-1,45);
    button1.alpha = 1;
    button1.layer.cornerRadius = 10;
    [button1 setTitle:@"收藏夹" forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
//    [button1 setTitle:@"收藏夹" forState:(UIControlStateNormal)];
//    [button1 setTitle:@"收藏夹" forState:(UIControlStateSelected)];
//    [button1 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
//    [button1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    button1.selected=YES;
//    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
    
    [button1 addTarget:self action:@selector(touchOne:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button1];
    self.menuBtn1=button1;
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.frame = CGRectMake(button1.right+1,2,((SCREEN_WIDTH-40)/2)-1,45);
    button2.alpha = 1;
    button2.layer.cornerRadius = 10;
    [button2 setTitle:@"播放记录" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
//    [button2 setTitle:@"播放记录" forState:(UIControlStateNormal)];
//    [button2 setTitle:@"播放记录" forState:(UIControlStateSelected)];
//    [button2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
//    [button2 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateSelected)];
    button2.selected=NO;
//    [button2.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, button2.width, button2.height)]atIndex:0];
    [button2 addTarget:self action:@selector(touchTwo:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    [topView addSubview:button2];
    self.menuBtn2=button2;
    
    self.gl1n = [self NormalLayer:CGRectMake(0, 0, self.menuBtn1.width, self.menuBtn1.height)];
    self.gl1y = [self selectLayer:CGRectMake(0, 0, self.menuBtn1.width, self.menuBtn1.height)];
    self.gl2n = [self NormalLayer:CGRectMake(0, 0, self.menuBtn2.width, self.menuBtn2.height)];
    self.gl2y = [self selectLayer:CGRectMake(0, 0, self.menuBtn2.width, self.menuBtn2.height)];
    [self.menuBtn1.layer addSublayer:_gl1n];
    [self.menuBtn1.layer addSublayer:_gl1y];
    [self.menuBtn1.layer insertSublayer:_gl1y above:_gl1n];
    [self.menuBtn2.layer addSublayer:_gl2n];
    [self.menuBtn2.layer addSublayer:_gl2y];
    [self.menuBtn2.layer insertSublayer:_gl2n above:_gl2y];
}
-(void)touchOne:(id)sender
{
    
    if(self.menuBtn1.selected==NO)
    {
        [self.menuBtn1.layer insertSublayer:_gl1y above:_gl1n];
        [self.menuBtn2.layer insertSublayer:_gl2n above:_gl2y];

        [self.menuBtn1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    }
    self.btn.selected=NO;
    [self setBottomRemove];
//    _isInsertEdit = NO;
//    [_downtableview2 setEditing:NO animated:YES];
    
    self.downtableview1.hidden=NO;
    self.downtableview2.hidden=YES;
    self.menuBtn1.selected=YES;
    self.menuBtn2.selected=NO;
    if(Listarray1.count!=0)
    {
        [self removeNilView1];
    }else{
        [self addnilView1];
    }
}
-(void)touchTwo:(id)sender
{
    if(self.menuBtn2.selected==NO)
    {
        [self.menuBtn1.layer insertSublayer:_gl1n above:_gl1y];
        [self.menuBtn2.layer insertSublayer:_gl2y above:_gl2n];

        [self.menuBtn1 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    }
    self.btn.selected=NO;
    [self setBottomRemove];
//    _isInsertEdit = NO;
//    [_downtableview1 setEditing:NO animated:YES];
    self.downtableview1.hidden=YES;
    self.downtableview2.hidden=NO;
    self.menuBtn1.selected=NO;
    self.menuBtn2.selected=YES;
    if(Listarray2.count!=0)
    {
        [self removeNilView2];
    }else{
        [self addnilView2];
    }
}
-(CAGradientLayer*)selectLayer:(CGRect)frame
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = frame;
    gl.cornerRadius=10;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    return gl;
}
-(CAGradientLayer*)NormalLayer:(CGRect)frame
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = frame;
    gl.cornerRadius=10;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    return gl;
}
-(void)Addtableview1
{
    
//    [Listarray addObject:[NSArray arrayWithObjects:@"播放记录",@"充值记录",@"账户信息",@"帮助中心",@"安全设置",@"清理缓存",@"退出登录", nil]];
    
    self.downtableview1=[[UITableView alloc] init];
    self.downtableview1.frame=CGRectMake(20, self.topView.bottom, SCREEN_WIDTH-40, SCREENH_HEIGHT-self.topView.bottom-kNavAndTabHeight-10);
    self.downtableview1.backgroundColor=[UIColor whiteColor];
    self.downtableview1.delegate=self;
    self.downtableview1.dataSource=self;
    self.downtableview1.tag=10001;
    self.downtableview1.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.downtableview1.tableFooterView = [[UIView alloc]init];
 
//    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.downtableview1 registerNib:[UINib nibWithNibName:NSStringFromClass([SCJTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.downtableview1];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.downtableview1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getheaderData1];
    }];
    // 第一次进入则自动加载
    [self.downtableview1.mj_header beginRefreshing];
    
    
    self.downtableview1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getfootData1];
    }];

}
-(void)Addtableview2
{
    
    NSLog(@"SCREENH_HEIGHT == %f   h ==== %f",SCREENH_HEIGHT,SCREENH_HEIGHT-50-kNavAndTabHeight);
    self.downtableview2=[[UITableView alloc] init];
    self.downtableview2.frame=CGRectMake(20, self.topView.bottom, SCREEN_WIDTH-40, SCREENH_HEIGHT-self.topView.bottom-kNavAndTabHeight-10);
    self.downtableview2.backgroundColor=[UIColor whiteColor];
    self.downtableview2.delegate=self;
    self.downtableview2.dataSource=self;
    self.downtableview2.tag=10002;
    self.downtableview2.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.downtableview2.tableFooterView = [[UIView alloc]init];
//    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.downtableview2 registerNib:[UINib nibWithNibName:NSStringFromClass([SliderTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID2];
    [self.view addSubview:self.downtableview2];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.downtableview2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getheaderData2];
    }];
    // 第一次进入则自动加载
    [self.downtableview2.mj_header beginRefreshing];
    
    
    self.downtableview2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getfootData2];
    }];
}

-(void)getheaderData1
{
    
    self.page1=1;
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page1],@"pagesize":@"20"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,videoFavoriteurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview1.mj_header endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            [self.Listarray1 removeAllObjects];
            NSDictionary *dictdata =[dict objectForKey:@"data"];
//            NSNumber*video_history_total=[dictdata objectForKey:@"video_history_total"];
            NSArray*video_favorite_list=[dictdata objectForKey:@"video_favorite_list"];
            if(![video_favorite_list isKindOfClass:[NSNull class]]){
            if(video_favorite_list.count>0)
            {
                [self removeNilView1];
                for (int i =0; i<video_favorite_list.count; i++) {
                    NSDictionary * video_Favorite =video_favorite_list[i];
//                    [DYModelMaker DY_makeModelWithDictionary:video_Favorite modelKeyword:@"Video" modelName:@"FavoriteMode"];
                    VideoFavoriteMode * model=[VideoFavoriteMode yy_modelWithDictionary:video_Favorite];
                    [self.Listarray1 addObject:model];
                }
            }else{
                [self addnilView1];
            }
            }
            [self.downtableview1 reloadData];
        }else{
            
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
        [self.downtableview1.mj_header endRefreshing];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}
-(void)getfootData1
{
    
    
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page1+1],@"pagesize":@"20"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,videoFavoriteurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview1.mj_footer endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
//            NSNumber*video_history_total=[dictdata objectForKey:@"video_history_total"];
            NSArray*video_favorite_list=[dictdata objectForKey:@"video_favorite_list"];
            if(![video_favorite_list isKindOfClass:[NSNull class]]){
            if(video_favorite_list.count>0)
            {
                self.page1+=1;
                [self removeNilView1];
                for (int i =0; i<video_favorite_list.count; i++) {
                    NSDictionary * video_Favorite =video_favorite_list[i];
                    
                    VideoFavoriteMode * model=[VideoFavoriteMode yy_modelWithDictionary:video_Favorite];
                    [self.Listarray1 addObject:model];
                }
                [self.downtableview1 reloadData];
            }else{
//                [self addnilView1];
            }
            }
            
            
        }else{
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
        [self.downtableview1.mj_footer endRefreshing];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}

-(void)getheaderData2
{
    
    self.page2=1;
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page2],@"pagesize":@"20"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,videoHistoryurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview2.mj_header endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            [self.Listarray2 removeAllObjects];
            NSDictionary *dictdata =[dict objectForKey:@"data"];
//            NSNumber*video_history_total=[dictdata objectForKey:@"video_history_total"];
            NSArray*video_history_list=[dictdata objectForKey:@"video_history_list"];
            if(![video_history_list isKindOfClass:[NSNull class]]){
            if(video_history_list.count>0)
            {
//                if(NULL_TO_NIL(video_history_list))
//                {
                [self removeNilView2];
                
                for (int i =0; i<video_history_list.count; i++) {
                    NSDictionary * video_history =video_history_list[i];
                    
//                    [DYModelMaker DY_makeModelWithDictionary:video_history modelKeyword:@"Video" modelName:@"historyMode"];
                    VideoHistoryMode* model= [VideoHistoryMode yy_modelWithDictionary:video_history];
                    [self.Listarray2 addObject:model];
                }
                }
            }else{
                [self addnilView2];
                
            }
            [self.downtableview2 reloadData];
        }else{
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
            [self.downtableview2 reloadData];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [self.downtableview2 reloadData];
        [self.downtableview2.mj_header endRefreshing];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}
-(void)getfootData2
{
    
    
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page2+1],@"pagesize":@"20"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,videoHistoryurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview2.mj_footer endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
//            NSNumber*video_history_total=[dictdata objectForKey:@"video_history_total"];
            NSArray*video_history_list=[dictdata objectForKey:@"video_history_list"];
            if(![video_history_list isKindOfClass:[NSNull class]]){
            if(video_history_list.count>0)
            {
                [self removeNilView2];
                self.page2+=1;
                for (int i =0; i<video_history_list.count; i++) {
                    NSDictionary * video_history =video_history_list[i];
                    VideoHistoryMode* model= [VideoHistoryMode yy_modelWithDictionary:video_history];
//                    [DYModelMaker DY_makeModelWithDictionary:video_history modelKeyword:@"Video" modelName:@"historyMode"];
                    [self.Listarray2 addObject:model];
                }
            }else{
//                [self addnilView2];
            }
            }
        }else{
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
        [self.downtableview2.mj_footer endRefreshing];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}



#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==10001)
    {
        return 1;
    }else if(tableView.tag==10002)
    {
        return 1;
    }
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag==10001)
    {
        return Listarray1.count;
    }else if(tableView.tag==10002)
    {
        return Listarray2.count;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView.tag==10001)
    {
        NSString *identifier=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        [self.downtableview1 registerNib:[UINib nibWithNibName:NSStringFromClass([SCJTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifier];
        SCJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        SCJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SCJTableViewCell alloc] init];
        }
        VideoFavoriteMode * modell=Listarray1[indexPath.section];
        //cell选中效果
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shuomingMiaoshu.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没用
//        [cell addBiaoqianLabel:@[@"打斗",@"科技",@"爱情"]];

        [cell.leftImage sd_setImageWithURL:[NSURL URLWithString:modell.video_pic]];
        cell.movietitle.text=modell.video_title;
        cell.liulanTime.text=[self getTimeFromTimestamp:@(modell.create_time)];
        cell.shuomingMiaoshu.text=modell.video_description;
        [cell addBiaoqianLabel:@[modell.video_region,modell.video_language]];
        cell.movieTime.hidden=YES;
        
        //处理选中背景色问题
        UIView *backGroundView = [[UIView alloc]init];
        backGroundView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backGroundView;
        return cell;
    }else if(tableView.tag==10002)
    {
        NSString *identifier=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        [self.downtableview2 registerNib:[UINib nibWithNibName:NSStringFromClass([SliderTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifier];
        SliderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        SliderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        
        if (cell == nil) {
            cell = [[SliderTableViewCell alloc] init];
            
        }
        //cell选中效果
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth = 1;
//        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//        cell.Slider.currentPercent=(0.5*indexPath.section*0.1);
        cell.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
        cell.layer.shadowOffset = CGSizeMake(2,3);
        cell.layer.shadowRadius = 6;
        cell.layer.shadowOpacity = 1;
        cell.layer.cornerRadius = 8;
        
        VideoHistoryMode * mode =Listarray2[indexPath.section];
        NSLog(@"in  === %ld",indexPath.section);
        
//        "video_history_total": 5,                  // 视频观看记录总数
//        "video_history_list": [                    // 观看历史列表
//          {
//            "video_id": 7,                        // 视频id
//            "video_title": "ss",                  // 视频标题(名称)
//            "video_description": "ss",            // 视频描述(简介)
//            "video_pic": "http://xxx/sss.jpg",    // 封面图地址
//            "video_score": 8.1,                   // 视频评分
//            "video_hits": 0,                      // 视频点击数量(播放数量)
//            "video_favorite": 0,                  // 视频总收藏数量
//            "video_appreciate": 0,                // 视频总点赞数量
//            "video_depreciate": 0,                // 视频总点踩数量
//            "video_remark": "ss",                 // 视频备注说明
//            "create_time": 1234567890,            // 观看时间
//          }
//        ]
//        video_fragment_symbol
        if([mode.last_fragment_symbol intValue]>1)
        {
            cell.leftLabel.text=[NSString stringWithFormat:@"%@ 第%@集",mode.video_title,mode.video_fragment_symbol];
        }else{
            cell.leftLabel.text=mode.video_title;
        }
        cell.rightLabel.text=[self getTimeFromTimestamp:@(mode.create_time)];
        NSLog(@"mode.elapsed== %f    mode.video_duration = %f ",mode.elapsed,mode.video_duration);
        
        if(mode.video_duration!=0)
        {
            NSLog(@"播放进度== %.f ",mode.elapsed/mode.video_duration*100);
//            NSDecimalNumber *chufa = [elapsedNum decimalNumberByDividingBy:video_durationNum];
//            NSDecimalNumber *chufa=[self chuFNumber:[NSString stringWithFormat:@"%.f",mode.elapsed] num2:[NSString stringWithFormat:@"%.f",mode.video_duration]];
            
//            [self ChengFNumber:[NSString stringWithFormat:@"%@",chufa] num2:@"100"]
        cell.bfbLabel.text=[NSString stringWithFormat:@"%.f%%",mode.elapsed/mode.video_duration*100];
        cell.Slider.currentPercent=mode.elapsed/mode.video_duration;  /// value 百分比
        }else
        {
            cell.bfbLabel.text=@"0%";
            cell.Slider.currentPercent=0;  /// value 百分比
        }
        //处理选中背景色问题
        UIView *backGroundView = [[UIView alloc]init];
        backGroundView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backGroundView;
        return cell;
    }
    return nil;
}
//除法
-(NSDecimalNumber*)chuFNumber:(NSString*)num1 num2:(NSString*)num2
{
    //方式1：不进行四舍五入
    NSDecimalNumber*number1 = [NSDecimalNumber decimalNumberWithString:num1];
    NSDecimalNumber*number2 = [NSDecimalNumber decimalNumberWithString:num2];
    NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:1 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *num = [number1 decimalNumberByDividingBy:number2 withBehavior:handler];
    return num;
}
//乘法
-(NSDecimalNumber*)ChengFNumber:(NSString*)num1 num2:(NSString*)num2
{
    //方式1：不进行四舍五入
    NSDecimalNumber*number1 = [NSDecimalNumber decimalNumberWithString:num1];
    NSDecimalNumber*number2 = [NSDecimalNumber decimalNumberWithString:num2];

    NSDecimalNumber *num = [number1 decimalNumberBySubtracting:number2];
    return num;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==10001)
    {
        return 156;
    }else if(tableView.tag==10002)
    {
        return 60;
    }
    return 0;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView.tag==10001)
    {
        return 0;
    }else if(tableView.tag==10002)
    {
        return 10.f;
    }
    return 0.f;
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

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //根据不同状态返回不同编辑模式
    if (_isInsertEdit) {
        
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
        
    }else{
        
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    //左滑删除数据方法
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(tableView.tag==10001)
        {
//            [self.Listarray1 removeObjectAtIndex: indexPath.row];
//            [self.downtableview1 deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            VideoFavoriteMode * modell=Listarray1[indexPath.section];
            NSArray * arrayF=@[modell];
            [self PostVideo_emptyVideoFavorite:arrayF];
        }else if(tableView.tag==10002)
        {
//            [self.Listarray2 removeObjectAtIndex: indexPath.row];
//            [self.downtableview2 deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            VideoHistoryMode * modell=Listarray2[indexPath.section];
            NSArray * arrayH=@[modell];
            [self PostVideo_emptyVideoHistory:arrayH];
        }
        
        
    }
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //正常状态下，点击cell进入跳转下一页
    //在编辑模式下点击cell 是选中数据
    if (self.btn.selected) {
         NSLog(@"选中");
        if(tableView.tag==10001)
        {
            VideoFavoriteMode * modell=[self.Listarray1 objectAtIndex:indexPath.section];
            if(![self.deleteArray containsObject:modell])
            {
                [self.deleteArray addObject:modell];
            }
            

        }else if(tableView.tag==10002)
        {
            VideoHistoryMode * modell=[self.Listarray2 objectAtIndex:indexPath.section];
            if(![self.deleteArray containsObject:modell])
            {
                [self.deleteArray addObject:modell];
            }
        }
    }else{
        if(tableView.tag==10001)
        {
            NSLog(@"10001index == %ld",indexPath.section);
            VideoFavoriteMode * modell=Listarray1[indexPath.section];
            [self getVideoInfo:[NSString stringWithFormat:@"%f",modell.video_id] D_elapsed:0 video_fragment_id:0];
            
        }else if(tableView.tag==10002)
        {
            NSLog(@"10002index == %ld",indexPath.section);
            
            VideoHistoryMode* model= self.Listarray2[indexPath.section];
            [self getVideoInfo:[NSString stringWithFormat:@"%f",model.video_id] D_elapsed:model.elapsed video_fragment_id:model.video_fragment_id];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (self.btn.selected) {
        NSLog(@"撤销");
        if(tableView.tag==10001)
        {
            VideoFavoriteMode * modell=[self.Listarray1 objectAtIndex:indexPath.section];
            if([self.deleteArray containsObject:modell])
            {
                [self.deleteArray removeObject:modell];
            }
            

        }else if(tableView.tag==10002)
        {
            VideoHistoryMode * modell=[self.Listarray2 objectAtIndex:indexPath.section];
            if([self.deleteArray containsObject:modell])
            {
                [self.deleteArray removeObject:modell];
            }
        }
        
        
        
    }else{
        NSLog(@"取消跳转");
    }

    
}


-(void)pushViewControllerVideo:(ZVideoMode*)mode  D_elapsed:(double)elapsed video_fragment_id:(double)video_fragment_id{
    MHYouKuController *avc = [[MHYouKuController alloc] init];
    avc.Zvideomodel= mode;
    avc.OldJiLutime=elapsed;
    avc.JiLutime=0;
    avc.video_fragment_id=video_fragment_id;
    avc.mediabase_id=[NSString stringWithFormat:@"%.f",video_fragment_id];
    [self pushRootNav:avc animated:YES];
}

-(void)getVideoInfo:(NSString*)videoId D_elapsed:(double)elapsed video_fragment_id:(double)video_fragment_id
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
                    [self pushViewControllerVideo:model D_elapsed:elapsed video_fragment_id:video_fragment_id];
                    
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











- (void)tapBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
    //点击编辑的时候清空删除数组
        [self.deleteArray removeAllObjects];

        _isInsertEdit = YES;//这个时候是全选模式
        if(self.menuBtn1.selected)
        {
            [_downtableview1 setEditing:YES animated:YES];

            self.downtableview1.frame=CGRectMake(self.downtableview1.left, self.downtableview1.top, self.downtableview1.width, self.downtableview1.height-45);
        }else{
            [_downtableview2 setEditing:YES animated:YES];
            self.downtableview2.frame=CGRectMake(self.downtableview2.left, self.downtableview2.top, self.downtableview2.width, self.downtableview2.height-45);
        }
        
        //如果在全选状态下，点击完成，再次进来的时候需要改变按钮的文字和点击状态
        if (_bottom_view.allBtn.selected) {
            _bottom_view.allBtn.selected = !_bottom_view.allBtn.selected;
            [_bottom_view.allBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        
            //添加底部视图
        CGRect frame = self.bottom_view.frame;
            frame.origin.y -= 50;
            [UIView animateWithDuration:0.5 animations:^{
                self.bottom_view.frame = frame;
                [self.view addSubview:self.bottom_view];
            }];
        
        
        
    }else{

        _isInsertEdit = NO;
        if(self.menuBtn1.selected)
        {
            [_downtableview1 setEditing:NO animated:YES];

            self.downtableview1.frame=CGRectMake(self.downtableview1.left, self.downtableview1.top, self.downtableview1.width, self.downtableview1.height+45);
        }else{
            [_downtableview2 setEditing:NO animated:YES];
            self.downtableview2.frame=CGRectMake(self.downtableview2.left, self.downtableview2.top, self.downtableview2.width, self.downtableview2.height+45);
        }
        
        
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint point = self.bottom_view.center;
            point.y      += 50;
            self.bottom_view.center   = point;
            
        } completion:^(BOOL finished) {
            [self.bottom_view removeFromSuperview];
        }];
        
    }
}

-(void)setBottomRemove
{
    
    if(self.menuBtn1.selected)
    {
        [_downtableview1 setEditing:NO animated:YES];
    }else{
        [_downtableview2 setEditing:NO animated:YES];
    }
    
    if(_isInsertEdit==YES)
    {
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = self.bottom_view.center;
        point.y      += 50;
        self.bottom_view.center   = point;
        
    } completion:^(BOOL finished) {
        [self.bottom_view removeFromSuperview];
    }];
    }
    
    _isInsertEdit = NO;
}
- (void)tapAllBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;

    if (btn.selected) {
        
        if(self.menuBtn1.selected)
        {
            for (int i = 0; i< self.Listarray1.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
                //全选实现方法
                [_downtableview1 selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
        }else{
            for (int i = 0; i< self.Listarray2.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
                //全选实现方法
                [_downtableview2 selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
            
        }
        
        
        //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
        if (self.deleteArray.count >0) {
            [self.deleteArray removeAllObjects];
        }
        if(self.menuBtn1.selected)
        {
            [self.deleteArray addObjectsFromArray:self.Listarray1];
        }else{
            [self.deleteArray addObjectsFromArray:self.Listarray2];
        }
        
        [btn setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        if(self.menuBtn1.selected)
        {
            //取消选中
            for (int i = 0; i< self.Listarray1.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
                [_downtableview1 deselectRowAtIndexPath:indexPath animated:NO];
                
            }
        }else{
            //取消选中
            for (int i = 0; i< self.Listarray2.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
                [_downtableview2 deselectRowAtIndexPath:indexPath animated:NO];
                
            }
        }
        
        
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        [self.deleteArray removeAllObjects];
    }
  
  
//    NSLog(@"+++++%ld",self.deleteArray.count);
//    NSLog(@"===%@",self.deleteArray);
    
}




//清空收藏
-(void)PostVideo_emptyVideoFavorite:(NSArray*)RMarray
{
    [UHud showHUDLoading];
    NSString * Vpjstr=@"";
    NSMutableDictionary*dict=[[NSMutableDictionary alloc] init];
    if(RMarray.count==1)
    {
        VideoFavoriteMode * modell=RMarray[0];
        Vpjstr=[NSString stringWithFormat:@"%.f",modell.id];
    }else{
        for (int i=0; i<RMarray.count; i++) {
            VideoFavoriteMode * modell=RMarray[i];
            if(i==0)
            {
                Vpjstr = [NSString stringWithFormat:@"%.f",modell.id];
            }else{
                Vpjstr = [NSString stringWithFormat:@"%@,%.f", Vpjstr,modell.id];
            }
        }
    }
    [dict setValue:Vpjstr forKey:@"ids"];
//    if(RMarray.count==self.Listarray1.count)
//    {
//        [dict setValue:@"0" forKey:@"selected"];
//    }else{
        
        [dict setValue:@"1" forKey:@"selected"];
        
//    }
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,Post_emptyVideoFavorite] Dictionary:dict success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    // 刷新数据
                    [self.downtableview1.mj_header beginRefreshing];
                    
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

//清空浏览记录
-(void)PostVideo_emptyVideoHistory:(NSArray*)RMarray
{
    [UHud showHUDLoading];
    NSString * Vpjstr=@"";
    NSMutableDictionary*dict=[[NSMutableDictionary alloc] init];
    if(RMarray.count==1)
    {
        VideoHistoryMode * modell=RMarray[0];
        Vpjstr=[NSString stringWithFormat:@"%.f",modell.id];
    }else{
        for (int i=0; i<RMarray.count; i++) {
            VideoHistoryMode * modell=RMarray[i];
            if(i==0)
            {
                Vpjstr = [NSString stringWithFormat:@"%.f",modell.id];
            }else{
                Vpjstr = [NSString stringWithFormat:@"%@,%.f", Vpjstr,modell.id];
            }
        }
    }
    [dict setValue:Vpjstr forKey:@"ids"];
//    if(RMarray.count==self.Listarray2.count)
//    {
//        [dict setValue:@"0" forKey:@"selected"];
//    }else{
       
        [dict setValue:@"1" forKey:@"selected"];
        
//    }
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,Post_emptyVideoHistory] Dictionary:dict success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    // 刷新数据
                    [self.downtableview2.mj_header beginRefreshing];
                    
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


@end
