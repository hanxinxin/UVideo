//
//  emailCZViewController.m
//  video
//
//  Created by nian on 2021/5/14.
//

#import "emailCZViewController.h"

//MARK:输入框和键盘之间的间距
static CGFloat INTERVAL_KEYBOARD = 500;
@interface emailCZViewController ()<UITextFieldDelegate>
{
    NSDictionary *keyboardInfo;
    NSString * phrase_id;
}
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
    
    if(self.Type==1)
    {
        self.title=@"邮箱重置";
    }else if(self.Type==2)
    {
        self.title=@"邮箱设置";
    }
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    
    phrase_id=@"";
//    加载UI
    [self InitUI];
    [self addNoticeForKeyboard];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addtopview];
    });
    
}

-(void)InitUI{
    self.topImageBg = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-125)/2, 40, 125, 50)];
    [self.topImageBg setImage:[UIImage imageNamed:@"loginBg"]];
    [self.view addSubview:self.topImageBg];
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(30, self.topImageBg.bottom+60, self.view.width-60, 226)];
    self.centerView.layer.cornerRadius=6;
    self.centerView.backgroundColor=[UIColor whiteColor];
    self.centerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    self.centerView.layer.shadowOffset = CGSizeMake(0,0);
    self.centerView.layer.shadowRadius = 6;
    self.centerView.layer.shadowOpacity = 0.9;
    [self setyinying];
    [self.view addSubview:self.centerView];
    self.emailTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, 50, self.centerView.width-16, 42)];
    self.emailTextfield.placeholder=@"请输入邮箱";
    self.emailTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.emailTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.emailTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.emailTextfield.delegate=self;
    self.emailTextfield.layer.borderWidth = 1;
    self.emailTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.emailTextfield];
    self.passwordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, 50+34+16, self.centerView.width-16, 42)];
    self.passwordTextfield.placeholder=@"请输入密码";
    self.passwordTextfield.secureTextEntry = YES;
    self.passwordTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.passwordTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.passwordTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.passwordTextfield.delegate=self;
    self.passwordTextfield.layer.borderWidth = 1;
    self.passwordTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.passwordTextfield];
    self.CodeView=[[UIView alloc] initWithFrame:CGRectMake(8, 50+34+16+34+16, self.centerView.width-16, 42)];
    self.CodeView.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.CodeView.layer.borderWidth = 1;
    self.CodeView.layer.cornerRadius = 6;
    [self.centerView addSubview:self.CodeView];;
    self.CodeTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.CodeView.width-116, 42)];
    self.CodeTextfield.placeholder=@"请输入验证码";
    self.CodeTextfield.keyboardType=UIKeyboardTypeNumberPad;
    self.CodeTextfield.borderStyle=UITextBorderStyleNone;
    self.CodeTextfield.delegate=self;
    [self.CodeView addSubview:self.CodeTextfield];
    
    self.getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.CodeTextfield.right-8, 6, 100, 30)];
    self.getCodeBtn.layer.cornerRadius = 4;
    self.getCodeBtn.backgroundColor=[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0];
    [self.getCodeBtn setTitle:@"验证码" forState:(UIControlStateNormal)];
    [self.getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.getCodeBtn addTarget:self action:@selector(getCodeBtn_touch:) forControlEvents:(UIControlEventTouchUpInside)];
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
//-(void)ZC_touch:(id)sender
//{
//    
//}

-(void)getCodeBtn_touch:(id)sender
{
    if(self.emailTextfield.text.length>0)
    {
        [UHud showHUDLoading];
        self->phrase_id=@"";
        NSDictionary * dict = @{@"email":self.emailTextfield.text};
        [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,emailYZMurl] Dictionary:dict success:^(id  _Nullable responseObject) {
    //        NSLog(@"post responseObject == %@",responseObject);
            [UHud hideLoadHud];
            NSDictionary *dict=(NSDictionary *)responseObject;
            NSNumber * code = [dict objectForKey:@"error"];
            if([code intValue]==0)
            {
                NSDictionary *dictdata =[dict objectForKey:@"data"];
                self->phrase_id=[dictdata objectForKey:@"phrase_id"];
                [self verifyEvent];
                [UHud showSuccessWithStatus:@"获取成功" delay:2.f];
                
            }else if([code intValue]==20){
                NSString * message = [dict objectForKey:@"message"];
    //            [UHud showHUDToView:self.view text:message];
    //            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
                [UHud showTXTWithStatus:message delay:2.f];
            }
    
        } failure:^(NSError * _Nullable error) {
            [UHud hideLoadHud];
            NSLog(@"shareManager error == %@",error);
            [UHud showTXTWithStatus:@"网络错误" delay:2.f];
        }];
    }else{
        [UHud showTXTWithStatus:@"请输入正确的邮箱" delay:2.f];
    }
}


-(void)XG_touch:(id)sender
{
    __block emailCZViewController *weakSelf = self;
    [UHud showHUDLoading];
    NSDictionary * dict =[[NSDictionary alloc] init];
    
        dict =@{@"email":self.emailTextfield.text,@"new_password":self.passwordTextfield.text,@"captcha":self.CodeTextfield.text,@"phrase_id":phrase_id};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,resetemaliPW] Dictionary:dict success:^(id  _Nullable responseObject) {
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
            
            NSDictionary *tokendata =[dictdata objectForKey:@"token"];
            NSString * token = [tokendata objectForKey:@"token"];
            NSNumber *expired_time=[tokendata objectForKey:@"expired_time"];
            [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"UserZH"];
            [[NSUserDefaults standardUserDefaults] setValue:nickname forKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:avatar forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setValue:vip_expired_time forKey:@"vip_expired_time"];
            
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"UserToken"];
            [[NSUserDefaults standardUserDefaults] setObject:expired_time forKey:@"expired_time"];
            
            [UHud showHudWithStatus:@"重置成功" delay:2.f];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));

            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf popViewcontroller];
            });
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showHudWithStatus:message delay:2.f];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
}
-(void)popViewcontroller
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)verifyEvent
{
    //启动倒计时
    [self performSelector:@selector(reflashGetKeyBt:)withObject:[NSNumber numberWithInt:60] afterDelay:0];
}
//倒数

- (void)reflashGetKeyBt:(NSNumber *)second
{
    if ([second integerValue] == 0)
    {
        _getCodeBtn.selected=YES;
        _getCodeBtn.userInteractionEnabled=YES;
        [_getCodeBtn setTitle:@"重新获取"forState:(UIControlStateNormal)];
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _getCodeBtn.selected=NO;
        _getCodeBtn.userInteractionEnabled=NO;
        int i = [second intValue];
        [_getCodeBtn setTitle:[NSString stringWithFormat:@"重新获得(%i)",i]forState:(UIControlStateNormal)];
        [self performSelector:@selector(reflashGetKeyBt:)withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
        
    }
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
    [button2 setTitle:@"" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    button2.selected=NO;
//    [button2.layer insertSublayer:[self NormalLayer:CGRectMake(0, 0, button2.width, button2.height)]atIndex:0];
    [button2 addTarget:self action:@selector(touchTwo:) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:button2];
    self.menuBtn2=button2;
    self.menuBtn2.hidden=YES;///// 不需要这个按钮  屏蔽
    [self touchTwo:nil];
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
    
    self.centerView.frame = CGRectMake(30, self.topImageBg.bottom+60, self.view.width-60, 210-40);
    self.centerView.layer.cornerRadius=6;
    [self setyinying];

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
    self.centerView.frame = CGRectMake(30, self.topImageBg.bottom+60, self.view.width-60, 210);
//    self.centerView.backgroundColor=[UIColor grayColor];
    self.centerView.layer.cornerRadius=6;
    [self setyinying];
    
    
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
    NSLog(@"%f      =    %f ",(self.XGBtn.bottom+kbHeight+40),SCREENH_HEIGHT);
    CGFloat offset = (self.XGBtn.bottom+kbHeight+40) - (SCREENH_HEIGHT);
    
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
