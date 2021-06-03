//
//  FAQViewController.m
//  video
//
//  Created by nian on 2021/5/15.
//

#import "FAQViewController.h"
#import "lxkfViewController.h"

#import "SCJTableViewCell.h"
#import "SliderTableViewCell.h"
#import "FAQTableViewCell.h"
#import "KFView.h"


#define cellID @"cellID"
#define cellID2 @"SliderTableViewCell"
#define cellID3 @"FAQTableViewCell"
@interface FAQViewController ()<UITableViewDelegate,UITableViewDataSource,YTSliderViewDelegate>
@property(nonatomic,strong)UIView*topView;
@property(nonatomic,strong)UITableView*downtableview1;
@property (nonatomic ,strong)NSMutableArray*Listarray1;
@property(nonatomic,strong)UITableView*downtableview2;
@property (nonatomic ,strong)NSMutableArray*Listarray2;
@property(nonatomic,strong)UITableView*downtableview3;
@property (nonatomic ,strong)NSMutableArray*Listarray3;
@property(nonatomic,strong)UIButton *menuBtn1;
@property(nonatomic,strong)UIButton *menuBtn2;
@property(nonatomic,strong)UIButton *menuBtn3;

@property(nonatomic,strong)CAGradientLayer *gl1n;
@property(nonatomic,strong)CAGradientLayer *gl1y;
@property(nonatomic,strong)CAGradientLayer *gl2n;
@property(nonatomic,strong)CAGradientLayer *gl2y;
@property(nonatomic,strong)CAGradientLayer *gl3n;
@property(nonatomic,strong)CAGradientLayer *gl3y;

///无内容显示view
@property (strong, nonatomic) UIView *nilView;
@property (strong, nonatomic) UIImageView * nilImageView;
@property (strong, nonatomic) UILabel * nilLabel;


///客服view
@property (strong, nonatomic) KFView*kfView;
@end

@implementation FAQViewController
@synthesize topView,Listarray1,Listarray2,Listarray3;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"常见问题";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    
    //下载按钮
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 25)];
    [rightItem setTitle:@"联系客服" forState:(UIControlStateNormal)];
    [rightItem setTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0]];
    [rightItem setImage:[UIImage imageNamed:@"helpimage"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(right_touch:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtnV=rightItem;
    
    [self addtopview];
    [self initnilView];
    [self addPWViewM];
    [self Addtableview1];
    [self Addtableview2];
    [self Addtableview3];
    [self touchOne:nil];
//    [self addnilView];
}
-(void)right_touch:(id)sender
{
//    lxkfViewController * avc = [[UIStoryboard storyboardWithName: @"Main" bundle: nil] instantiateViewControllerWithIdentifier: @"lxkfViewController"];
//    [self pushRootNav:avc animated:YES];
    [self showkfView];
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

-(void)addPWViewM{
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
    __weak FAQViewController * weakSelf = self;
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
        self.kfView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavBarAndStatusBarHeight);
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


-(void)addtopview
{
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(20,2,((SCREEN_WIDTH-40-16)/3),38);
    button1.alpha = 1;
    button1.layer.cornerRadius = 10;
    [button1 setTitle:@"注册登录" forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    [button1 setTitle:@"注册登录" forState:(UIControlStateNormal)];
    [button1 setTitle:@"注册登录" forState:(UIControlStateSelected)];
    [button1 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateSelected)];
    button1.selected=YES;
    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
    [button1 addTarget:self action:@selector(touchOne:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button1];
    self.menuBtn1=button1;
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.frame = CGRectMake(button1.right+8,2,((SCREEN_WIDTH-40-16)/3),38);
    button2.alpha = 1;
    button2.layer.cornerRadius = 10;
    [button2 setTitle:@"充值到账" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [button2 setTitle:@"充值到账" forState:(UIControlStateNormal)];
    [button2 setTitle:@"充值到账" forState:(UIControlStateSelected)];
    [button2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateSelected)];
    button2.selected=NO;
    [button2.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, button2.width, button2.height)]atIndex:0];
    [button2 addTarget:self action:@selector(touchTwo:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button2];
    self.menuBtn2=button2;
    UIButton *button3 = [[UIButton alloc] init];
    button3.frame = CGRectMake(button2.right+8,2,((SCREEN_WIDTH-40-16)/3),38);
    button3.alpha = 1;
    button3.layer.cornerRadius = 10;
    [button3 setTitle:@"金币任务" forState:(UIControlStateNormal)];
    [button3 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [button3 setTitle:@"金币任务" forState:(UIControlStateNormal)];
    [button3 setTitle:@"金币任务" forState:(UIControlStateSelected)];
    [button3 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [button3 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateSelected)];
    button3.selected=NO;
    [button3.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, button3.width, button3.height)]atIndex:0];
    [button3 addTarget:self action:@selector(touchThree:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button3];
    self.menuBtn3=button3;
    
    
    self.gl1n = [self NormalLayer:CGRectMake(0, 0, self.menuBtn1.width, self.menuBtn1.height)];
    self.gl1y = [self selectLayer:CGRectMake(0, 0, self.menuBtn1.width, self.menuBtn1.height)];
    self.gl2n = [self NormalLayer:CGRectMake(0, 0, self.menuBtn2.width, self.menuBtn2.height)];
    self.gl2y = [self selectLayer:CGRectMake(0, 0, self.menuBtn2.width, self.menuBtn2.height)];
    self.gl3n = [self NormalLayer:CGRectMake(0, 0, self.menuBtn3.width, self.menuBtn3.height)];
    self.gl3y = [self selectLayer:CGRectMake(0, 0, self.menuBtn3.width, self.menuBtn3.height)];
    [self.menuBtn1.layer addSublayer:_gl1n];
    [self.menuBtn1.layer addSublayer:_gl1y];
    [self.menuBtn1.layer insertSublayer:_gl1y above:_gl1n];
    [self.menuBtn2.layer addSublayer:_gl2n];
    [self.menuBtn2.layer addSublayer:_gl2y];
    [self.menuBtn2.layer insertSublayer:_gl2n above:_gl2y];
    [self.menuBtn3.layer addSublayer:_gl3n];
    [self.menuBtn3.layer addSublayer:_gl3y];
    [self.menuBtn3.layer insertSublayer:_gl3n above:_gl3y];
}
-(void)touchOne:(id)sender
{
    
    if(self.menuBtn1.selected==NO)
    {
        [self.menuBtn1.layer insertSublayer:_gl1y above:_gl1n];
        [self.menuBtn2.layer insertSublayer:_gl2n above:_gl2y];
        [self.menuBtn3.layer insertSublayer:_gl3n above:_gl3y];
    }
    self.downtableview1.hidden=NO;
    self.downtableview2.hidden=YES;
    self.downtableview3.hidden=YES;
    self.menuBtn1.selected=YES;
    self.menuBtn2.selected=NO;
    self.menuBtn3.selected=NO;
}
-(void)touchTwo:(id)sender
{
    if(self.menuBtn2.selected==NO)
    {
        [self.menuBtn1.layer insertSublayer:_gl1n above:_gl1y];
        [self.menuBtn2.layer insertSublayer:_gl2y above:_gl2n];
        [self.menuBtn3.layer insertSublayer:_gl3n above:_gl3y];
    }
    self.downtableview1.hidden=YES;
    self.downtableview2.hidden=NO;
    self.downtableview3.hidden=YES;
    self.menuBtn1.selected=NO;
    self.menuBtn2.selected=YES;
    self.menuBtn3.selected=NO;
}

-(void)touchThree:(id)sender
{
    if(self.menuBtn3.selected==NO)
    {
        [self.menuBtn1.layer insertSublayer:_gl1n above:_gl1y];
        [self.menuBtn2.layer insertSublayer:_gl2n above:_gl2y];
        [self.menuBtn3.layer insertSublayer:_gl3y above:_gl3n];
    }
    self.downtableview1.hidden=YES;
    self.downtableview2.hidden=YES;
    self.downtableview3.hidden=NO;
    self.menuBtn1.selected=NO;
    self.menuBtn2.selected=NO;
    self.menuBtn3.selected=YES;
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
    Listarray1=[NSMutableArray arrayWithCapacity:0];
//    [Listarray addObject:[NSArray arrayWithObjects:@"播放记录",@"充值记录",@"账户信息",@"帮助中心",@"安全设置",@"清理缓存",@"退出登录", nil]];
    [Listarray1 addObject:@"播放记录"];
    [Listarray1 addObject:@"充值记录"];
    [Listarray1 addObject:@"账户信息"];
    [Listarray1 addObject:@"帮助中心"];
    [Listarray1 addObject:@"安全设置"];
    [Listarray1 addObject:@"清理缓存"];
    self.downtableview1=[[UITableView alloc] init];
    self.downtableview1.frame=CGRectMake(20, 50, SCREEN_WIDTH-40, SCREENH_HEIGHT-50-kNavBarAndStatusBarHeight);
    self.downtableview1.backgroundColor=[UIColor whiteColor];
    self.downtableview1.delegate=self;
    self.downtableview1.dataSource=self;
    self.downtableview1.tag=10001;
    self.downtableview1.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.downtableview1.tableFooterView = [[UIView alloc]init];
//    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.downtableview1 registerNib:[UINib nibWithNibName:NSStringFromClass([FAQTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID3];
    [self.view addSubview:self.downtableview1];
}
-(void)Addtableview2
{
    Listarray2=[NSMutableArray arrayWithCapacity:0];
//    [Listarray addObject:[NSArray arrayWithObjects:@"播放记录",@"充值记录",@"账户信息",@"帮助中心",@"安全设置",@"清理缓存",@"退出登录", nil]];
    [Listarray2 addObject:@"播放记录"];
    [Listarray2 addObject:@"充值记录"];
    [Listarray2 addObject:@"账户信息"];
    [Listarray2 addObject:@"帮助中心"];
    [Listarray2 addObject:@"安全设置"];
    [Listarray2 addObject:@"清理缓存"];
    self.downtableview2=[[UITableView alloc] init];
    self.downtableview2.frame=CGRectMake(20, 50, SCREEN_WIDTH-40, SCREENH_HEIGHT-50-kNavBarAndStatusBarHeight);
    self.downtableview2.backgroundColor=[UIColor whiteColor];
    self.downtableview2.delegate=self;
    self.downtableview2.dataSource=self;
    self.downtableview2.tag=10002;
    self.downtableview2.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.downtableview2.tableFooterView = [[UIView alloc]init];
//    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.downtableview2 registerNib:[UINib nibWithNibName:NSStringFromClass([FAQTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID3];
    [self.view addSubview:self.downtableview2];
}
-(void)Addtableview3
{
    Listarray3=[NSMutableArray arrayWithCapacity:0];
//    [Listarray addObject:[NSArray arrayWithObjects:@"播放记录",@"充值记录",@"账户信息",@"帮助中心",@"安全设置",@"清理缓存",@"退出登录", nil]];
    [Listarray3 addObject:@"播放记录"];
    [Listarray3 addObject:@"充值记录"];
    [Listarray3 addObject:@"账户信息"];
    [Listarray3 addObject:@"帮助中心"];
    [Listarray3 addObject:@"安全设置"];
    [Listarray3 addObject:@"清理缓存"];
    self.downtableview3=[[UITableView alloc] init];
    self.downtableview3.frame=CGRectMake(20, 50, SCREEN_WIDTH-40, SCREENH_HEIGHT-50-kNavBarAndStatusBarHeight);
    self.downtableview3.backgroundColor=[UIColor whiteColor];
    self.downtableview3.delegate=self;
    self.downtableview3.dataSource=self;
    self.downtableview3.tag=10003;
    self.downtableview3.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.downtableview3.tableFooterView = [[UIView alloc]init];
//    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.downtableview3 registerNib:[UINib nibWithNibName:NSStringFromClass([FAQTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID3];
    [self.view addSubview:self.downtableview3];
}
#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==10001)
    {
        return 1;
    }else if(tableView.tag==10002)
    {
        return 1;
    }else if(tableView.tag==10003)
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
    }else if(tableView.tag==10003)
    {
        return Listarray3.count;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView.tag==10001 || tableView.tag==10002 || tableView.tag==10003)
    {
        FAQTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if (cell == nil) {
            cell = [[FAQTableViewCell alloc] init];
        }
        
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth = 1;
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        cell.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
        cell.layer.shadowOffset = CGSizeMake(2,3);
        cell.layer.shadowRadius = 6;
        cell.layer.shadowOpacity = 1;
        cell.layer.cornerRadius = 8;
        return cell;
    }
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==10001)
    {
        return 155;
    }else if(tableView.tag==10002)
    {
        return 155;
    }else if(tableView.tag==10003)
    {
        return 155;
    }
    return 0;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView.tag==10001)
    {
        return 10.f;
    }else if(tableView.tag==10002)
    {
        return 10.f;
    }else if(tableView.tag==10003)
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
    }else if(tableView.tag==10003)
    {
        NSLog(@"10002index == %ld",indexPath.section);
    }
    
    
}

@end
