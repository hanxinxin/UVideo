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
@end

@implementation jiluViewController
@synthesize topView,Listarray1,Listarray2;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.page1=1;
    self.page2=1;
    Listarray1=[NSMutableArray arrayWithCapacity:0];
    Listarray2=[NSMutableArray arrayWithCapacity:0];
    [self addtopview];
    [self initnilView];
    [self Addtableview1];
    [self Addtableview2];
    [self touchOne:nil];
    [self addnilView];
    [self removeNilView];
}
///// 加载无内容显示的view
-(void)initnilView
{
    self.nilView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height-40)];
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




-(void)addtopview
{
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(15,2,((SCREEN_WIDTH-40)/2)-1,38);
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
    button2.frame = CGRectMake(button1.right+1,2,((SCREEN_WIDTH-40)/2)-1,38);
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
    self.downtableview1.hidden=NO;
    self.downtableview2.hidden=YES;
    self.menuBtn1.selected=YES;
    self.menuBtn2.selected=NO;
    if(Listarray1.count!=0)
    {
        [self removeNilView];
    }else{
        [self addnilView];
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
    self.downtableview1.hidden=YES;
    self.downtableview2.hidden=NO;
    self.menuBtn1.selected=NO;
    self.menuBtn2.selected=YES;
    if(Listarray2.count!=0)
    {
        [self removeNilView];
    }else{
        [self addnilView];
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
    self.downtableview1.frame=CGRectMake(20, 50, SCREEN_WIDTH-40, SCREENH_HEIGHT-50-kNavAndTabHeight);
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
    
    
    self.downtableview1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getfootData1];
    }];

}
-(void)Addtableview2
{
    
    NSLog(@"SCREENH_HEIGHT == %f   h ==== %f",SCREENH_HEIGHT,SCREENH_HEIGHT-50-kNavAndTabHeight);
    self.downtableview2=[[UITableView alloc] init];
    self.downtableview2.frame=CGRectMake(20, 50, SCREEN_WIDTH-40, SCREENH_HEIGHT-50-kNavAndTabHeight);
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
    
    
    self.downtableview2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getfootData2];
    }];
}

-(void)getheaderData1
{
    
    
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page1],@"pagesize":@"20"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,videoFavoriteurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview1.mj_header endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            NSNumber*video_history_total=[dictdata objectForKey:@"video_history_total"];
            NSArray*video_history_list=[dictdata objectForKey:@"video_history_list"];
            if([video_history_total intValue]>0)
            {
                self.page2+=1;
                
            }else{
                [self addnilView];
            }
            
        }else if([code intValue]==20){
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            [UHud showTXTWithStatus:message delay:2.f];
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
            NSNumber*video_history_total=[dictdata objectForKey:@"video_history_total"];
            NSArray*video_history_list=[dictdata objectForKey:@"video_history_list"];
            if(video_history_total>0)
            {
                self.page1+=1;
                
            }else{
                [self addnilView];
            }
            
            
        }else if([code intValue]==20){
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            [UHud showTXTWithStatus:message delay:2.f];
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
    
    
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page2],@"pagesize":@"20"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,videoHistoryurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview2.mj_header endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            NSNumber*video_history_total=[dictdata objectForKey:@"video_history_total"];
            NSArray*video_history_list=[dictdata objectForKey:@"video_history_list"];
            if(video_history_total>0)
            {
                self.page1+=1;
                [self.Listarray2 removeAllObjects];
                for (int i =0; i<video_history_list.count; i++) {
                    NSDictionary * video_history =video_history_list[i];
                    VideoHistoryMode* model= [VideoHistoryMode yy_modelWithDictionary:video_history];
//                    [DYModelMaker DY_makeModelWithDictionary:video_history modelKeyword:@"Video" modelName:@"historyMode"];
                    [self.Listarray2 addObject:model];
                }
            }else{
                [self addnilView];
            }
            [self.downtableview2 reloadData];
        }else if([code intValue]==20){
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            [UHud showTXTWithStatus:message delay:2.f];
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
            NSNumber*video_history_total=[dictdata objectForKey:@"video_history_total"];
            NSArray*video_history_list=[dictdata objectForKey:@"video_history_list"];
            if(video_history_total>0)
            {
                self.page2+=1;
                
            }else{
                [self addnilView];
            }
        }else if([code intValue]==20){
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            [UHud showTXTWithStatus:message delay:2.f];
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
        SCJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[SCJTableViewCell alloc] init];
        }
        
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shuomingBtn.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没用
        [cell addBiaoqianLabel:@[@"打斗",@"科技",@"爱情"]];
        return cell;
    }else if(tableView.tag==10002)
    {
        SliderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (cell == nil) {
            cell = [[SliderTableViewCell alloc] init];
            
        }
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth = 1;
//        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        cell.Slider.currentPercent=(0.5*indexPath.section*0.1);
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
        cell.leftLabel.text=mode.video_title;
        
        
        
        return cell;
    }
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==10001)
    {
        return 144;
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
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==10001)
    {
        NSLog(@"10001index == %ld",indexPath.section);
    }else if(tableView.tag==10002)
    {
        NSLog(@"10002index == %ld",indexPath.section);
    }
    
}

@end
