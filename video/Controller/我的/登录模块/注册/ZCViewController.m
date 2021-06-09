//
//  ZCViewController.m
//  video
//
//  Created by nian on 2021/5/13.
//

#import "ZCViewController.h"

//MARK:输入框和键盘之间的间距
static CGFloat INTERVAL_KEYBOARD = 500;
@interface ZCViewController ()<UITextFieldDelegate>
{
    NSDictionary *keyboardInfo;
}
@property(nonatomic,strong)UIView*topView;
@property(nonatomic,strong)UIButton *menuBtn1;
@property(nonatomic,strong)UIButton *menuBtn2;

@property(nonatomic,assign)NSInteger menuIndex; ///1是用户名注册 2是 邮箱注册
@end

@implementation ZCViewController
@synthesize topView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    https://www.jianshu.com/p/0754833349a1   //添加三面阴影的方法
    
    
    self.title=@"注册";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    //// 初始化数据
    self.menuIndex = 2; //初始值 为2 [self touchOne:nil];会修改为1
    
//    加载UI
    [self InitUI];
    [self addNoticeForKeyboard];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));

    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self addtopview];
    });
  
    [self touchOne:nil];
    
    
    [self gettuxingYZM];
    
    
    

    
//    /// 加密流程
//    NSString *certsPath2 = [[NSBundle mainBundle] pathForResource:@"server-public" ofType:@"pem"];
//    NSError *error2;
//    NSString *contentInUTF82 = [NSString stringWithContentsOfFile:certsPath2
//                    encoding:NSUTF8StringEncoding
//                     error:&error2];
//    NSString * aeskey = [AES createUuid];
//    NSLog(@"随机key aeskey = %@",aeskey);
//    NSString * string =  [AES AES256_Encrypt:aeskey encryptString:@"AESKEY" giv:@"abcdefghijklmnop"];
//    NSString *RSAjiami = [RSA encryptString:aeskey publicKey:contentInUTF82];
//    NSLog(@"AES string = %@",string);
//    NSLog(@"RSAjiami = %@",RSAjiami);
    
    
////    解密流程
//    NSString *certsPath = [[NSBundle mainBundle] pathForResource:@"client-private" ofType:@"pem"];
//    NSError *error;
//    NSString *contentInUTF8 = [NSString stringWithContentsOfFile:certsPath
//                    encoding:NSUTF8StringEncoding
//                     error:&error];
//    NSLog(@"contentInUTF8 === %@",contentInUTF8);
//
//    NSString *RSAjiemi = [RSA decryptString:RSAjiami privateKey:contentInUTF8];
//    NSLog(@"RSA 加密后的数据 %@ 解密后的数据 %@",RSAjiami,RSAjiemi);
//
////
//    NSString * string1 =  [AES AES256_Decrypt:aeskey encryptString:string giv:@"abcdefghijklmnop"];
//    NSLog(@"AES jiemi string = %@",string1);
    
}


-(void)gettuxingYZM{
//    [[HttpManagement shareManager] GetNetWork:[NSString stringWithFormat:@"%@%@",FWQURL,tuxingYZMurl] success:^(id _Nullable responseObject) {
//
//        NSLog(@"responseObject == %@",responseObject);
//        NSString * str = (NSString*)responseObject;
//        NSString * string1 =  [AES AES256_Decrypt:aeskey encryptString:string giv:@"abcdefghijklmnop"];
//
//
//    } failure:^(NSError * _Nullable error) {
//        NSLog(@"shareManager error == %@",error);
//        [UHud showHUDToView:self.view text:@"网络错误"];
//    }];
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,tuxingYZMurl] Dictionary:nil success:^(id  _Nullable responseObject) {
        NSLog(@"post responseObject == %@",responseObject);
        NSData * data = (NSData*)responseObject;
        NSString * str = [[jiemishujuClass shareManager] jiemiData:data];
        NSLog(@"json == %@",str);
    } failure:^(NSError * _Nullable error) {
        
        NSLog(@"shareManager error == %@",error);
        [UHud showHUDToView:self.view text:@"网络错误"];
    }];
    
}





-(void)InitUI{
    self.topImageBg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, self.view.width-60, 200)];
    [self.topImageBg setImage:[UIImage imageNamed:@"loginBg"]];
    [self.view addSubview:self.topImageBg];
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(30, 252, self.view.width-60, 210-40)];
    self.centerView.layer.cornerRadius=6;
    self.centerView.backgroundColor=[UIColor whiteColor];
    self.centerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    self.centerView.layer.shadowOffset = CGSizeMake(0,0);
    self.centerView.layer.shadowRadius = 6;
    self.centerView.layer.shadowOpacity = 0.9;
    
    
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
    self.CodeTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.CodeView.width-92, 42)];
    self.CodeTextfield.placeholder=@"请输入验证码";
    self.CodeTextfield.keyboardType=UIKeyboardTypeNumberPad;
    self.CodeTextfield.borderStyle=UITextBorderStyleNone;
    self.CodeTextfield.delegate=self;
    [self.CodeView addSubview:self.CodeTextfield];
    
    self.getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.CodeTextfield.right-8, 6, 70, 30)];
    self.getCodeBtn.layer.cornerRadius = 4;
    self.getCodeBtn.backgroundColor=[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0];
    [self.getCodeBtn setTitle:@"验证码" forState:(UIControlStateNormal)];
    [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.CodeView addSubview:self.getCodeBtn];
    
    self.backBtn = [[UIButton alloc] init];
    self.backBtn.frame = CGRectMake(30,self.centerView.bottom+15,((self.view.width-68)/2)-5,46);
    self.backBtn.alpha = 1;
    self.backBtn.layer.cornerRadius = 10;
    self.backBtn.backgroundColor=RGB(220,240,251);
    [self.backBtn setTitle:@"返回登录" forState:(UIControlStateNormal)];
    [self.backBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [self.backBtn addTarget:self action:@selector(back_touch:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.backBtn];
    
    self.ZCBtn= [[UIButton alloc] init];
    self.ZCBtn.frame = CGRectMake(self.backBtn.right+10,self.centerView.bottom+15,((self.view.width-68)/2)-5,46);
    self.ZCBtn.alpha = 1;
    self.ZCBtn.layer.cornerRadius = 10;
    self.ZCBtn.backgroundColor=RGB(168,222,242);
    [self.ZCBtn setTitle:@"立即注册" forState:(UIControlStateNormal)];
    [self.ZCBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
    [self.ZCBtn addTarget:self action:@selector(ZC_touch:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.ZCBtn];
    
    
    
    
}

-(void)back_touch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ZC_touch:(id)sender
{
    
}

-(void)addtopview
{
    
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.centerView.width, 40)];
    
    topView.backgroundColor=[UIColor clearColor];
    [self.centerView addSubview:topView];
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(0,2,((topView.width-2)/2)-1,38);
    button1.alpha = 1;
    button1.layer.cornerRadius = 10;
    [button1 setTitle:@"用户名注册" forState:(UIControlStateNormal)];
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
    
}
-(void)touchOne:(id)sender
{
  
    
    if(self.menuIndex==2)
    {
//        [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//        for (CALayer *layer in self.view.layer.sublayers) {
//            [layer removeFromSuperlayer];
//        }
//        [self InitUI];
//        [self addtopview];

        [self.menuBtn1 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.CodeView.hidden=YES;
    //    self.centerView.backgroundColor=[UIColor orangeColor];
        self.centerView.frame = CGRectMake(30, 252, self.view.width-60, 210-40);
        [self setyinying];

        self.backBtn.frame = CGRectMake(30,self.centerView.bottom+15,((self.view.width-68)/2)-5,46);
        self.ZCBtn.frame = CGRectMake(self.backBtn.right+10,self.centerView.bottom+15,((self.view.width-68)/2)-5,46);
    }

    [self setBorderWithView:self.menuBtn1 top:NO left:NO bottom:YES right:NO borderColor:RGB(20, 155, 236) borderWidth:0.5];
    [self setBorderWithView:self.menuBtn2 top:NO left:NO bottom:YES right:NO borderColor:RGB(255, 255, 255) borderWidth:0.5];
    self.emailTextfield.placeholder=@"请输入用户名";
    self.menuIndex=1;
    self.menuBtn1.selected=YES;
    self.menuBtn2.selected=NO;
}
-(void)touchTwo:(id)sender
{
   
    
    if(self.menuIndex==1)
    {

        [self.menuBtn1 setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [self.menuBtn2 setTitleColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        self.CodeView.hidden=NO;
        self.centerView.frame = CGRectMake(30, 252, self.view.width-60, 210);
        [self setyinying];

        self.backBtn.frame = CGRectMake(30,self.centerView.bottom+15,((self.view.width-68)/2)-5,46);
        self.ZCBtn.frame = CGRectMake(self.backBtn.right+10,self.centerView.bottom+15,((self.view.width-68)/2)-5,46);
    }
    
    
    [self setBorderWithView:self.menuBtn2 top:NO left:NO bottom:YES right:NO borderColor:RGB(20, 155, 236) borderWidth:0.5];
    [self setBorderWithView:self.menuBtn1 top:NO left:NO bottom:YES right:NO borderColor:RGB(255, 255, 255) borderWidth:0.5];
    self.emailTextfield.placeholder=@"请输入邮箱";
    self.menuBtn1.selected=NO;
    self.menuBtn2.selected=YES;
    self.menuIndex=2;
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
    NSLog(@"%f      =    %f ",(self.ZCBtn.bottom+kbHeight+40),SCREENH_HEIGHT);
    CGFloat offset = (self.ZCBtn.bottom+kbHeight+40) - (SCREENH_HEIGHT);
    
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

