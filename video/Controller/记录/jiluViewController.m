//
//  jiluViewController.m
//  video
//
//  Created by macbook on 2021/5/9.
//

#import "jiluViewController.h"
#import "HYSlider.h"

#import "SCJTableViewCell.h"
#import "SliderTableViewCell.h"

#define cellID @"cellID"
#define cellID2 @"SliderTableViewCell"
@interface jiluViewController ()<UITableViewDelegate,UITableViewDataSource,HYSliderDelegate>
@property(nonatomic,strong)UIView*topView;
@property(nonatomic,strong)UITableView*downtableview1;
@property (nonatomic ,strong)NSMutableArray*Listarray1;
@property(nonatomic,strong)UITableView*downtableview2;
@property (nonatomic ,strong)NSMutableArray*Listarray2;
@property(nonatomic,strong)UIButton *menuBtn1;
@property(nonatomic,strong)UIButton *menuBtn2;

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

    
    
    [self addtopview];
    [self initnilView];
    [self Addtableview1];
    [self Addtableview2];
    [self touchOne:nil];
//    [self addnilView];
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
    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
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
    [button2.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, button2.width, button2.height)]atIndex:0];
    [button2 addTarget:self action:@selector(touchTwo:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button2];
    self.menuBtn2=button2;
}
-(void)touchOne:(id)sender
{
    
    if(self.menuBtn1.selected==NO)
    {
        [self.menuBtn1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, self.menuBtn1.width, self.menuBtn1.height)]atIndex:0];
        [self.menuBtn2.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, self.menuBtn2.width, self.menuBtn2.height)]atIndex:0];
        [self.menuBtn1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    }
    self.downtableview1.hidden=NO;
    self.downtableview2.hidden=YES;
    self.menuBtn1.selected=YES;
    self.menuBtn2.selected=NO;
}
-(void)touchTwo:(id)sender
{
    if(self.menuBtn2.selected==NO)
    {
        [self.menuBtn1.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, self.menuBtn1.width, self.menuBtn1.height)]atIndex:0];
        [self.menuBtn2.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, self.menuBtn2.width, self.menuBtn2.height)]atIndex:0];
        
        [self.menuBtn1 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    }
    self.downtableview1.hidden=YES;
    self.downtableview2.hidden=NO;
    self.menuBtn1.selected=NO;
    self.menuBtn2.selected=YES;
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
    self.downtableview1.frame=CGRectMake(20, 40, SCREEN_WIDTH-40, SCREENH_HEIGHT-40-kNavBarAndStatusBarHeight);
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
    self.downtableview2.frame=CGRectMake(20, 40, SCREEN_WIDTH-40, SCREENH_HEIGHT-40-kNavBarAndStatusBarHeight);
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
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        cell.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
        cell.layer.shadowOffset = CGSizeMake(2,3);
        cell.layer.shadowRadius = 6;
        cell.layer.shadowOpacity = 1;
        cell.layer.cornerRadius = 8;
        
        
        NSLog(@"in  === %ld",indexPath.section);
        
        
        return cell;
    }
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==10001)
    {
        return 90;
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
