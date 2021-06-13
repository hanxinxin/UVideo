//
//  XGpasswordViewController.m
//  video
//
//  Created by nian on 2021/5/14.
//

#import "XGpasswordViewController.h"
#import "PWView.h"
static CGFloat INTERVAL_KEYBOARD = 500;
@interface XGpasswordViewController ()<UITextFieldDelegate>
{
    NSDictionary *keyboardInfo;
}
@property(nonatomic,assign)PWView*pwView;
@end

@implementation XGpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"修改密码";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    [self InitUI];
    [self addPWViewM];
    [self addNoticeForKeyboard];
}
-(void)addPWViewM{
    PWView *view = [[[NSBundle mainBundle]loadNibNamed:@"PWView" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.8];
    view.hidden=YES;
    view.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 0);
//    view.bottomView.layer.cornerRadius=10;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
    [view.bottomView setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor] type:corners];
    view.okBtn.layer.cornerRadius=6;
    [self.view addSubview:view];
    self.pwView=view;
    __weak XGpasswordViewController * weakSelf = self;
    self.pwView.touchIndex = ^(NSInteger Index) {
        
        NSLog(@"prompt idnex ==== %ld",Index);
        if(Index==0)
        {
            [weakSelf popViewcontroller];
        }else{
            [weakSelf popViewcontroller];
        }
        [weakSelf HidpwView];
    };
}

-(void)showpwView
{
    
    [UIView animateWithDuration:0.7 animations:^{
        self.pwView.bottomView.hidden=NO;
        self.pwView.hidden=NO;
        self.pwView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavBarAndStatusBarHeight);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)HidpwView
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pwView.bottomView.hidden=YES;
        self.pwView.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH,0 );
    } completion:^(BOOL finished) {
        self.pwView.hidden=YES;
    }];
}

-(void)InitUI
{
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.view.width-40, 256)];
    self.centerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.centerView];
    self.oldTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, 50, self.centerView.width-16, 42)];
    self.oldTextfield.placeholder=@"输入旧密码";
    self.oldTextfield.secureTextEntry = YES;
    self.oldTextfield.delegate = self;
    self.oldTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.oldTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.oldTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.oldTextfield.layer.borderWidth = 1;
    self.oldTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.oldTextfield];
    self.onenewTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, self.oldTextfield.bottom+10, self.centerView.width-16, 42)];
    self.onenewTextfield.placeholder=@"输入新密码";
    self.onenewTextfield.secureTextEntry = YES;
    self.onenewTextfield.delegate = self;
    self.onenewTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.onenewTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.onenewTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.onenewTextfield.layer.borderWidth = 1;
    self.onenewTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.onenewTextfield];
    self.twonewTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, self.onenewTextfield.bottom+10, self.centerView.width-16, 42)];
    self.twonewTextfield.placeholder=@"重复新密码";
    self.twonewTextfield.secureTextEntry = YES;
    self.twonewTextfield.delegate = self;
    self.twonewTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.twonewTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.twonewTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.twonewTextfield.layer.borderWidth = 1;
    self.twonewTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.twonewTextfield];
    self.tispLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.twonewTextfield.bottom+10, self.centerView.width-16, 30)];
    self.tispLabel.text=@"";
    self.tispLabel.textColor=RGBA(255, 0, 0, 1);
    self.tispLabel.textAlignment=NSTextAlignmentCenter;
    [self.tispLabel setFont:[UIFont systemFontOfSize:15.f]];
    [self.centerView addSubview:self.tispLabel];
    
    
    self.XGBtn= [[UIButton alloc] init];
    self.XGBtn.frame = CGRectMake(self.centerView.left,self.centerView.bottom+40,self.centerView.width,46);
    self.XGBtn.alpha = 1;
    self.XGBtn.layer.cornerRadius = 10;
    self.XGBtn.backgroundColor=RGB(168,222,242);
    [self.XGBtn setTitle:@"确认修改" forState:(UIControlStateNormal)];
    [self.XGBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
    [self.XGBtn addTarget:self action:@selector(XG_touch:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.XGBtn];
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
    if ([self.oldTextfield isFirstResponder]) {
        return self.oldTextfield;
    }else if ([self.onenewTextfield isFirstResponder]) {
        return self.onenewTextfield;
    }else if ([self.twonewTextfield isFirstResponder]) {
        return self.twonewTextfield;
    }else
    {
        return self.oldTextfield;
    }
}
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.onenewTextfield) {
        [self.onenewTextfield becomeFirstResponder];
    }else if (textField == self.twonewTextfield){
        [self.twonewTextfield becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    NSString *trimText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textField == self.oldTextfield) {
        if ([trimText length] > 60) {
            return NO;
        }
    }else if (textField == self.onenewTextfield) {
        if ([trimText length] > 60) {
            return NO;
        }
    }else if (textField == self.twonewTextfield){
        if ([trimText length] > 60) {
            return NO;
        }
        if([self.onenewTextfield.text isEqualToString:trimText])
        {
            self.tispLabel.text=@"";
        }else{
            self.tispLabel.text=@"两次输入的密码不一致，请重新输入";
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



-(void)XG_touch:(id)sender
{
    [self PostsetPW];
}

-(void)PostsetPW
{
    __block XGpasswordViewController *weakSelf = self;
    
    if([self.oldTextfield.text length]>0)
    {
        if([self.onenewTextfield.text length]>0)
        {
            if([self.twonewTextfield.text length]>0)
            {
                if([self.onenewTextfield.text isEqualToString:self.twonewTextfield.text])
                {
    [UHud showHUDLoading];
    NSDictionary * dict =[[NSDictionary alloc] init];
    
        dict =@{@"original_password":self.oldTextfield.text,@"new_password":self.twonewTextfield.text};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,xiugaiPwURL] Dictionary:dict success:^(id  _Nullable responseObject) {
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
//
                [weakSelf showpwView];
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
                }else{
                    [UHud showTXTWithStatus:@"新密码不一致" delay:2.f];
                }
            }else{
                [UHud showTXTWithStatus:@"新密码不能为空" delay:2.f];
            }
        }else{
            [UHud showTXTWithStatus:@"新密码不能为空" delay:2.f];
        }
    }else{
        [UHud showTXTWithStatus:@"旧密码不能为空" delay:2.f];
    }
}
-(void)popViewcontroller
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
