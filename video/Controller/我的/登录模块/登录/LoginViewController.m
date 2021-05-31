//
//  LoginViewController.m
//  video
//
//  Created by nian on 2021/5/13.
//

#import "LoginViewController.h"
#import "ZCViewController.h"
//MARK:输入框和键盘之间的间距
static CGFloat INTERVAL_KEYBOARD = 500;
@interface LoginViewController ()<UITextFieldDelegate>
{
    NSDictionary *keyboardInfo;
}
@property(nonatomic,strong)UIView*topView;
@property(nonatomic,strong)UIButton *menuBtn1;
@property(nonatomic,strong)UIButton *menuBtn2;

@property(nonatomic,assign)NSInteger menuIndex; ///1是手机号登录 2是 邮箱登录
@end

@implementation LoginViewController
@synthesize topView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"登录";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    [self addNoticeForKeyboard];
    [self initUI];
    
}

-(void)initUI
{
    self.emailTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.emailTextfield.delegate=self;
    self.passwordTextfield.secureTextEntry = YES;
    self.passwordTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.passwordTextfield.delegate=self;
    self.ZC_btn.layer.cornerRadius = 10;
    self.DL_Btn.layer.cornerRadius = 10;
    self.centerView.layer.cornerRadius=6;
    self.centerView.backgroundColor=[UIColor whiteColor];
    self.centerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    self.centerView.layer.shadowOffset = CGSizeMake(0,0);
    self.centerView.layer.shadowRadius = 6;
    self.centerView.layer.shadowOpacity = 0.9;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addtopview];
        [self setyinying];
    });
}




- (IBAction)ZC_touch:(id)sender {
    ZCViewController * avc = [[ZCViewController alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)DL_touch:(id)sender {
}
- (IBAction)WJMM_touch:(id)sender {
}





-(void)addtopview
{
    self.menuIndex = 1;
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.centerView.width, 40)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.centerView addSubview:topView];
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(0,2,((topView.width-2)/2)-1,38);
    button1.alpha = 1;
    button1.layer.cornerRadius = 10;
    [button1 setTitle:@"手机号登录" forState:(UIControlStateNormal)];
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
    [button2 setTitle:@"邮箱登录" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    button2.selected=NO;
//    [button2.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, button2.width, button2.height)]atIndex:0];
    [button2 addTarget:self action:@selector(touchTwo:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button2];
    self.menuBtn2=button2;
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
    
    [self setyinying];
    
    [self setBorderWithView:self.menuBtn1 top:NO left:NO bottom:YES right:NO borderColor:RGB(20, 155, 236) borderWidth:0.5];
    [self setBorderWithView:self.menuBtn2 top:NO left:NO bottom:YES right:NO borderColor:RGB(255, 255, 255) borderWidth:0.5];
    self.emailTextfield.placeholder=@"请输入手机号";
    self.menuIndex = 1;
    self.menuBtn1.selected=YES;
    self.menuBtn2.selected=NO;
}
-(void)touchTwo:(id)sender
{
    if(self.menuBtn2.selected==NO)
    {
//        [self.menuBtn1.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, self.menuBtn1.width, self.menuBtn1.height)]atIndex:0];
//        [self.menuBtn2.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, self.menuBtn2.width, self.menuBtn2.height)]atIndex:0];
        
        [self.menuBtn1 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    }
    
    self.centerView.layer.cornerRadius=6;
    [self setyinying];

    
    [self setBorderWithView:self.menuBtn2 top:NO left:NO bottom:YES right:NO borderColor:RGB(20, 155, 236) borderWidth:0.5];
    [self setBorderWithView:self.menuBtn1 top:NO left:NO bottom:YES right:NO borderColor:RGB(255 ,255, 255) borderWidth:0.5];
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

- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.5;
    theView.layer.shadowRadius = 2;
    
    // 单边阴影 顶边
        float shadowPathWidth = theView.layer.shadowRadius;
        CGRect shadowRect = CGRectMake(0, theView.bounds.size.height, theView.bounds.size.width, shadowPathWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        theView.layer.shadowPath = path.CGPath;
}


- (void)setyinying
{
    self.centerView.layer.masksToBounds = NO;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat shadowWidth = 6;
       [path moveToPoint:CGPointMake(0, shadowWidth)];
       [path addLineToPoint:CGPointMake(0, self.centerView.bounds.size.height)];
       [path addLineToPoint:CGPointMake(self.centerView.width, self.centerView.height)];
       [path addLineToPoint:CGPointMake(self.centerView.width, shadowWidth)];
       
       [path closePath];
       
    self.centerView.layer.shadowPath = path.CGPath;
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
    NSLog(@"%f      =    %f ",(self.DL_Btn.bottom+kbHeight+40),SCREENH_HEIGHT);
    CGFloat offset = (self.DL_Btn.bottom+kbHeight+40) - (SCREENH_HEIGHT);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
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
        self.view.frame = [UIScreen mainScreen].bounds;
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
- (UITextField *)isFirstTextFieldResponder{
    if ([self.emailTextfield isFirstResponder]) {
        return self.emailTextfield;
    }else if ([self.passwordTextfield isFirstResponder]) {
        return self.passwordTextfield;
    }else
    {
        return self.emailTextfield;
    }
}
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.emailTextfield) {
        [self.emailTextfield becomeFirstResponder];
    }else if (textField == self.passwordTextfield){
        [self.passwordTextfield becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    NSString *trimText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textField == self.emailTextfield) {
        if ([trimText length] > 60) {
            return NO;
        }
    }else if (textField == self.passwordTextfield){
        if ([trimText length] > 60) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (!keyboardInfo) {
        return YES;
    }
    CGFloat kbHeight = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat offset = (textField.frame.origin.y + textField.frame.size.height + INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    if (offset > 0) {
        if (offset > kbHeight) {
            offset = kbHeight-50;
        }
        [self animationWithkeybooard:^{
            self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }else{
        [self animationWithkeybooard:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
