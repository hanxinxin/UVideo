//
//  MyViewController.m
//  video
//
//  Created by nian on 2021/3/10.
//

#import "MyViewController.h"
#import "topHeaderView.h"

#import "safeViewController.h"
#import "chongzhiListViewController.h"
#import "zhanghuInfoViewController.h"
#import "jiluViewController.h"
#import "ZjiluViewController.h"
#import "FAQViewController.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView*ZtopView;
@property(nonatomic,strong)topHeaderView *Headerview;

@property(nonatomic,strong)UITableView*downtableview;
@property(nonatomic,strong)NSMutableArray*arrtitle;
@property(nonatomic,strong)NSMutableArray*imagearray;
@end

@implementation MyViewController
@synthesize ZtopView,arrtitle,imagearray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navBarColor=[UIColor whiteColor];
//    self.hiddenLeftBtn=YES;
    
    [self InitUIView];
    [self Addtableview];
    [self setyinying];
}

-(void)InitUIView
{
    ZtopView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185)];
    ZtopView.alpha = 1;

    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = ZtopView.frame;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:194/255.0 green:228/255.0 blue:249/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    [self.ZtopView.layer addSublayer:gl];
    [self.view addSubview:self.ZtopView];
    topHeaderView *view = [[[NSBundle mainBundle]loadNibNamed:@"topHeaderView" owner:self options:nil]objectAtIndex:0];
    view.alpha=0.7;
    view.frame=CGRectMake(20, 10, SCREEN_WIDTH-40, 180);
    view.layer.cornerRadius=6;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,3);
    view.layer.shadowRadius = 6;
    view.layer.shadowOpacity = 1;
    
    view.txImage.layer.cornerRadius = 30;
    view.txImage.layer.masksToBounds = YES;
    [self.ZtopView addSubview:view];
    self.Headerview = view;
    __weak __typeof(self)weakSelf = self;
    self.Headerview.topHeaderBlock = ^(NSInteger touchIndex) {
        NSLog(@"Touchindex= %ld",touchIndex);
        if(touchIndex==1001)
        {

            LoginViewController * avc = [[UIStoryboard storyboardWithName: @"Main" bundle: nil] instantiateViewControllerWithIdentifier: @"LoginViewController"];
            [weakSelf pushRootNav:avc animated:YES];
        }
    };
    self.Headerview.cellindexBlock = ^(NSInteger CellIndex) {
        NSLog(@"CellIndex= %ld",CellIndex);
        if(CellIndex==1000)
        {
            // 这是从一个模态出来的页面跳到tabbar的某一个页面
            if (@available(iOS 13.0, *)) {
                NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
                UIWindowScene *windowScene = (UIWindowScene *)array[0];
                SceneDelegate *delegate =(SceneDelegate *)windowScene.delegate;
                HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
                NSArray * arraynav = nav.viewControllers;
                UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
                tabViewController.selectedIndex = 1;
            } else {
                // Fallback on earlier versions
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
                NSArray * arraynav = nav.viewControllers;
                UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
                tabViewController.selectedIndex = 1;
            }
        }else if(CellIndex==1001)
        {
            
        }else if(CellIndex==1002)
        {
            
        }else if(CellIndex==1003)
        {

            // 这是从一个模态出来的页面跳到tabbar的某一个页面
            if (@available(iOS 13.0, *)) {
                NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
                UIWindowScene *windowScene = (UIWindowScene *)array[0];
                SceneDelegate *delegate =(SceneDelegate *)windowScene.delegate;
                HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
                NSArray * arraynav = nav.viewControllers;
                UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
                tabViewController.selectedIndex = 2;
            } else {
                // Fallback on earlier versions
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
                NSArray * arraynav = nav.viewControllers;
                UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
                tabViewController.selectedIndex = 2;
            }
 
        }
    };
}
- (void)setyinying
{
    self.ZtopView.layer.masksToBounds = NO;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat shadowWidth = 3;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
        path.lineJoinStyle = kCGLineJoinRound; //终点处理
       [path moveToPoint:CGPointMake(0, shadowWidth)];
       [path addLineToPoint:CGPointMake(0, self.ZtopView.bounds.size.height)];
       [path addLineToPoint:CGPointMake(self.ZtopView.bounds.size.width, self.ZtopView.bounds.size.height)];
       [path addLineToPoint:CGPointMake(self.ZtopView.bounds.size.width, 8)];
       [path addLineToPoint:CGPointMake(self.ZtopView.bounds.size.width , self.ZtopView.bounds.size.height )];
       [path closePath];
       
    self.ZtopView.layer.shadowPath = path.CGPath;
}
-(void)Addtableview
{
    arrtitle=[NSMutableArray arrayWithCapacity:0];
    [arrtitle addObject:[NSArray arrayWithObjects:@"播放记录",@"充值记录",@"账户信息",@"帮助中心",@"安全设置",@"清理缓存",@"退出登录", nil]];
    imagearray=[NSMutableArray arrayWithCapacity:0];
    [imagearray addObject:[NSArray arrayWithObjects:@"bofangjilu",@"chongzhijilu",@"zhanghu",@"bangzhu",@"setimage",@"qingli",@"signout", nil]];
    
    self.downtableview=[[UITableView alloc] init];
    self.downtableview.frame=CGRectMake(20, 200, SCREEN_WIDTH-40, SCREENH_HEIGHT-200-kNavBarAndStatusBarHeight);
    self.downtableview.backgroundColor=[UIColor clearColor];
    self.downtableview.delegate=self;
    self.downtableview.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.downtableview];
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrtitle.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray * arr = arrtitle[0];
    return arr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
//    NSLog(@"self.topView.bottom = %f , self.topView.height = %f",self.topView.bottom,self.topView.height);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray  * titleT=arrtitle[0];
    cell.textLabel.text = [titleT objectAtIndex:indexPath.section];
    NSArray  * titleI=imagearray[0];
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
    
    if(indexPath.section==0){

//        ZjiluViewController * avc = [[ZjiluViewController alloc] init];
//        [self pushRootNav:avc animated:YES];
        
        // 这是从一个模态出来的页面跳到tabbar的某一个页面
        if (@available(iOS 13.0, *)) {
            NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *windowScene = (UIWindowScene *)array[0];
            SceneDelegate *delegate =(SceneDelegate *)windowScene.delegate;
//            UITabBarController* tabViewController=(UITabBarController *) delegate.window.rootViewController;
//            tabViewController.selectedIndex = 1;
            HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
            NSArray * arraynav = nav.viewControllers;
            UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
            tabViewController.selectedIndex = 1;
            
        } else {
            // Fallback on earlier versions
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            UITabBarController *tabViewController = (UITabBarController *) delegate.window.rootViewController;
//            [tabViewController setSelectedIndex:1];
            HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
            NSArray * arraynav = nav.viewControllers;
            UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
            tabViewController.selectedIndex = 1;
        }
        
        
    }else if(indexPath.section==1)
    {
        chongzhiListViewController * avc = [[chongzhiListViewController alloc] init];
        [self pushRootNav:avc animated:YES];
    }else if(indexPath.section==2)
    {
        zhanghuInfoViewController * avc = [[zhanghuInfoViewController alloc] init];
        [self pushRootNav:avc animated:YES];
        
    }else if(indexPath.section==3)
    {
        FAQViewController * avc = [[FAQViewController alloc] init];
        [self pushRootNav:avc animated:YES];
    }else if(indexPath.section==4)
    {
        safeViewController * avc = [[safeViewController alloc] init];
        [self pushRootNav:avc animated:YES];
    }
}
@end
