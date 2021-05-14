//
//  emailCZViewController.m
//  video
//
//  Created by nian on 2021/5/14.
//

#import "emailCZViewController.h"

@interface emailCZViewController ()
@property(nonatomic,strong)UIView*topView;
@property(nonatomic,strong)UIButton *menuBtn1;
@property(nonatomic,strong)UIButton *menuBtn2;

@property(nonatomic,assign)NSInteger menuIndex; ///1是用户名注册 2是 邮箱注册
@end

@implementation emailCZViewController
@synthesize topView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"邮箱重置";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    
    
//    加载UI
    [self InitUI];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addtopview];
    });
    
}

-(void)InitUI{
    self.topImageBg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, self.view.width-60, 200)];
    [self.topImageBg setImage:[UIImage imageNamed:@"loginBg"]];
    [self.view addSubview:self.topImageBg];
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(30, 252, self.view.width-60, 226)];
    
    [self.view addSubview:self.centerView];
    self.emailTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, 50, self.centerView.width-16, 42)];
    self.emailTextfield.placeholder=@"请输入邮箱";
    self.emailTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.emailTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.emailTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.emailTextfield.layer.borderWidth = 1;
    self.emailTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.emailTextfield];
    self.passwordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, 50+34+16, self.centerView.width-16, 42)];
    self.passwordTextfield.placeholder=@"请输入密码";
    self.passwordTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.passwordTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.passwordTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.passwordTextfield.layer.borderWidth = 1;
    self.passwordTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.passwordTextfield];
    self.CodeView=[[UIView alloc] initWithFrame:CGRectMake(8, 50+34+16+34+16, self.centerView.width-16, 42)];
    self.CodeView.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.CodeView.layer.borderWidth = 1;
    self.CodeView.layer.cornerRadius = 6;
    [self.centerView addSubview:self.CodeView];;
    self.CodeTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.CodeView.width-78, 42)];
    self.CodeTextfield.placeholder=@"请输入验证码";
    self.CodeTextfield.keyboardType=UIKeyboardTypeNumberPad;
    self.CodeTextfield.borderStyle=UITextBorderStyleNone;
    [self.CodeView addSubview:self.CodeTextfield];
    
    self.getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.CodeTextfield.right, 6, 70, 30)];
    self.getCodeBtn.layer.cornerRadius = 4;
    self.getCodeBtn.backgroundColor=[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0];
    [self.getCodeBtn setTitle:@"验证码" forState:(UIControlStateNormal)];
    [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.CodeView addSubview:self.getCodeBtn];
    
//    self.backBtn = [[UIButton alloc] init];
//    self.backBtn.frame = CGRectMake(30,self.centerView.bottom+15,((self.view.width-68)/2)-1,46);
//    self.backBtn.alpha = 1;
//    self.backBtn.layer.cornerRadius = 10;
//    self.backBtn.backgroundColor=RGB(220,240,251);
//    [self.backBtn setTitle:@"返回登录" forState:(UIControlStateNormal)];
//    [self.backBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
//    [self.backBtn addTarget:self action:@selector(back_touch:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:self.backBtn];
//
//    self.ZCBtn= [[UIButton alloc] init];
//    self.ZCBtn.frame = CGRectMake((self.view.width-68)/2+30,self.centerView.bottom+15,((self.view.width-68)/2)-1,46);
//    self.ZCBtn.alpha = 1;
//    self.ZCBtn.layer.cornerRadius = 10;
//    self.ZCBtn.backgroundColor=RGB(168,222,242);
//    [self.ZCBtn setTitle:@"立即重置" forState:(UIControlStateNormal)];
//    [self.ZCBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
////    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
//    [self.ZCBtn addTarget:self action:@selector(ZC_touch:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:self.ZCBtn];
    
    self.XGBtn= [[UIButton alloc] init];
    self.XGBtn.frame = CGRectMake(self.centerView.left,self.centerView.bottom+20,self.centerView.width,46);
    self.XGBtn.alpha = 1;
    self.XGBtn.layer.cornerRadius = 10;
    self.XGBtn.backgroundColor=RGB(168,222,242);
    [self.XGBtn setTitle:@"确认修改" forState:(UIControlStateNormal)];
    [self.XGBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
    [self.XGBtn addTarget:self action:@selector(XG_touch:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.XGBtn];
    
    
}

-(void)back_touch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ZC_touch:(id)sender
{
    
}
-(void)XG_touch:(id)sender
{
    
}


-(void)addtopview
{
    self.menuIndex = 1;
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.centerView.width, 40)];
    topView.backgroundColor=[UIColor clearColor];
    [self.centerView addSubview:topView];
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(0,2,(topView.width),38);
    button1.alpha = 1;
    button1.layer.cornerRadius = 10;
    [button1 setTitle:@"邮箱重置" forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    button1.selected=YES;
//    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
    [button1 addTarget:self action:@selector(touchOne:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button1];
    self.menuBtn1=button1;
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.frame = CGRectMake(button1.right+1,2,((topView.width-2)/2)-1,38);
    button2.alpha = 1;
    button2.layer.cornerRadius = 10;
    [button2 setTitle:@"邮箱注册" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    button2.selected=NO;
//    [button2.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, button2.width, button2.height)]atIndex:0];
    [button2 addTarget:self action:@selector(touchTwo:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button2];
    self.menuBtn2=button2;
    self.menuBtn2.hidden=YES;///// 不需要这个按钮  屏蔽
    [self touchOne:nil];
}
-(void)touchOne:(id)sender
{
    
    if(self.menuBtn1.selected==NO)
    {
//        [self.menuBtn1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, self.menuBtn1.width, self.menuBtn1.height)]atIndex:0];
//        [self.menuBtn2.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, self.menuBtn2.width, self.menuBtn2.height)]atIndex:0];
        [self.menuBtn1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    }
    self.CodeView.hidden=YES;
//    self.centerView.backgroundColor=[UIColor orangeColor];
    
    self.centerView.frame = CGRectMake(30, 252, self.view.width-60, 210-40);
    //首先保证你的imageVIew是正方形的，要不然效果不是圆的
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.cornerRadius=6;
    [self setBorderWithView:self.centerView top:NO left:YES bottom:YES right:YES borderColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] borderWidth:0.5];
    self.centerView.layer.shadowOpacity = 0.5;// 阴影透明度

    self.centerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;// 阴影的颜色
    self.centerView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    self.centerView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围

//    [self setBorderWithView:self.menuBtn1 top:NO left:NO bottom:YES right:NO borderColor:RGB(20, 155, 236) borderWidth:0.5];
//    [self setBorderWithView:self.menuBtn2 top:NO left:NO bottom:YES right:NO borderColor:RGB(255, 255, 255) borderWidth:0.5];
    self.emailTextfield.placeholder=@"请输入邮箱";
    self.menuIndex = 1;
    self.menuBtn1.selected=YES;
    self.menuBtn2.selected=NO;
}
-(void)touchTwo:(id)sender
{
    if(self.menuBtn2.selected==NO)
    {
        
        [self.menuBtn1 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    }
    self.CodeView.hidden=NO;
    self.centerView.frame = CGRectMake(30, 252, self.view.width-60, 210);
//    self.centerView.backgroundColor=[UIColor grayColor];
    //首先保证你的imageVIew是正方形的，要不然效果不是圆的
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.cornerRadius=6;
    [self setBorderWithView:self.centerView top:NO left:YES bottom:YES right:YES borderColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] borderWidth:1];
    self.centerView.layer.shadowOpacity = 0.5;// 阴影透明度
    self.centerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;// 阴影的颜色
    self.centerView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    self.centerView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    
    
    [self setBorderWithView:self.menuBtn2 top:NO left:NO bottom:YES right:NO borderColor:RGB(20, 155, 236) borderWidth:0.5];
    [self setBorderWithView:self.menuBtn1 top:NO left:NO bottom:YES right:NO borderColor:RGB(255, 255, 255) borderWidth:0.5];
    self.emailTextfield.placeholder=@"请输入邮箱";
    self.menuIndex = 2;
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


- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}
@end
