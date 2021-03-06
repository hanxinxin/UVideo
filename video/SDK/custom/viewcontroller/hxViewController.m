//
//  hxViewController.m
//  video
//
//  Created by nian on 2021/5/8.
//

#import "hxViewController.h"
#import "LLSearchViewController.h"

@interface hxViewController ()

@end

@implementation hxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSearch];
}

-(void)addSearch
{
//    [self.navigationController.navigationBar addSubview:[self convertToView]];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.navigationController.navigationBar.bounds;
//    gradient.startPoint = CGPointMake(0.5, 0);
//    gradient.endPoint = CGPointMake(0.5, 1);
//    gradient.colors = @[(__bridge id)[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
//    gradient.locations = @[@(0),@(1.0f)];
//    [self.navigationController.navigationBar.layer addSublayer:gradient];
    //去除导航栏下方的横线
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                      forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navBarColor=[UIColor colorWithRed:211/255.0 green:236/255.0 blue:249/255.0 alpha:0.9];
    self.titleView = [[HomeTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - (80*2), 30)];
        self.titleView.backgroundColor=[UIColor whiteColor];
    
    self.titleView.layer.cornerRadius=15;

//    HQCustomButton * btn = [[HQCustomButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, btn.imageView.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.width-50, 0, 30)];
    [btn setTitle:@"请输入关键字" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1] forState:(UIControlStateNormal)];
    btn.layer.cornerRadius=15;
    [btn setTarget:self action:@selector(btnTouch:) forControlEvents:(UIControlEventTouchDown)];
    [_titleView addSubview:btn];
//    [_titleView.layer addSublayer:gl];
    self.navigationItem.titleView = _titleView;


        [self addLeft_RightButton];
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

-(void)addLeft_RightButton
{
    //下载按钮
    UIButton *Back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 25)];
    [Back setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [Back addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:Back];
    self.navigationItem.leftBarButtonItem = leftButton;
    
   
    //下载按钮
    UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [historyBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(DownLoadBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)DownLoadBtnEvent
{
    NSLog(@"hx 11111");
}
-(void)MessageBtnEvent
{
    NSLog(@"hx 22222");
}



-(void)historyBtnEvent
{
    NSLog(@"hx 33333");
}
-(void)TitleTouch:(UITapGestureRecognizer *)gesture
{
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    [self.navigationController pushViewController:seachVC animated:NO];
}
-(void)btnTouch:(id)sender
{
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    [self.navigationController pushViewController:seachVC animated:NO];
}

@end
