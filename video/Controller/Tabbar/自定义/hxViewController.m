//
//  hxViewController.m
//  video
//
//  Created by macbook on 2021/5/9.
//

#import "hxViewController.h"
#import "LLSearchViewController.h"
#import "MessageViewController.h"

@interface hxViewController ()

@end

@implementation hxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.title=@"";
    [self addSearch];
    self.view.backgroundColor=[UIColor whiteColor];
}

-(void)addSearch
{
//    //去除导航栏下方的横线
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
//                                                      forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navBarColor=RGBA(180, 223, 246, 1);
    [self setNavBarTranslucent:NO];
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:RGBA(20, 155, 236, 1)] forBarMetrics: UIBarMetricsDefault];
    
    
    //渐变gl  [self convertToImage:view]
//    [self.navigationController.navigationBar.layer insertSublayer:gl atIndex:0];
//    self.titleView = [[HomeTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - (80+40), 30)];
//        self.titleView.backgroundColor=[UIColor whiteColor];
//    self.titleView.layer.cornerRadius=15;
//
////    HQCustomButton * btn = [[HQCustomButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
//    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//使图片和文字水平居中显示
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, btn.imageView.size.width)];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.width-50, 0, 30)];
//    [btn setTitle:@"请输入关键字" forState:(UIControlStateNormal)];
//    [btn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
//    [btn setTitleColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1] forState:(UIControlStateNormal)];
//    btn.layer.cornerRadius=15;
//    [btn setTarget:self action:@selector(btnTouch:) forControlEvents:(UIControlEventTouchDown)];
//    [_titleView addSubview:btn];
////    [_titleView.layer addSublayer:gl];
//    self.navigationItem.titleView = _titleView;

        [self addLeft_RightButton];
}
- (UIImage *)imageWithColor:(UIColor *)color {

    //创建1像素区域并开始绘图
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);

    //创建画板并填充颜色和区域
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    //从画板上获取图片并关闭图片绘图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
-(UIImage*)convertToImage:(UIView*)viewS{
    CGSize s = viewS.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [viewS.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)addLeft_RightButton
{
    //下载按钮
    UIButton *Back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    [Back setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [Back addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:Back];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //    #pragma mark >>>>>消息按钮
    BadgeButton *historyBtn = [[BadgeButton alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
    [rightButtonView addSubview:historyBtn];
    historyBtn.badgeValue=1;
    historyBtn.isRedBall=YES;
    [historyBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(DownLoadBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//    historyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
//    historyBtn.translatesAutoresizingMaskIntoConstraints=NO;
//    //把右侧的两个按钮添加到rightBarButtonItem
//    UIBarButtonItem *downBtn = [[UIBarButtonItem alloc] initWithCustomView:mainAndSearchBtn];
    UIBarButtonItem *messagebtn = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    
    self.navigationItem.rightBarButtonItem = messagebtn;
}
-(void)DownLoadBtnEvent
{
    NSLog(@"11111");
    
    MessageViewController *seachVC = [[MessageViewController alloc] init];
//    seachVC.hidesBottomBarWhenPushed=NO;
//    [self.navigationController pushViewController:seachVC animated:NO];
    [self pushRootNav:seachVC animated:YES];
}
-(void)MessageBtnEvent
{
    NSLog(@"22222");
}

-(void)historyBtnEvent
{
    NSLog(@"33333");
}
-(void)btnTouch:(id)sender
{
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    seachVC.hidesBottomBarWhenPushed=NO;
    [self.navigationController pushViewController:seachVC animated:NO];
}
-(UIView*)convertToView{
    //  创建 UIView用来承载渐变色放置在导航栏上时需要上移20否则状态栏会露出

    UIView *myTopView = [[UIView alloc]initWithFrame:self.navigationController.navigationBar.bounds];
        
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = myTopView.bounds;
//    gradient.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor whiteColor].CGColor];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.colors = @[(__bridge id)[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gradient.locations = @[@(0),@(1.0f)];
//    gradient.startPoint = CGPointMake(0, 1);
//    gradient.endPoint = CGPointMake(1, 0);
    //    gradient.locations = @[@(0.5f), @(1.0f)];
    [myTopView.layer addSublayer:gradient];
    return myTopView;
}

@end
