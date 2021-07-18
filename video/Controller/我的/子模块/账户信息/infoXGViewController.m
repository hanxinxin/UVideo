//
//  infoXGViewController.m
//  video
//
//  Created by nian on 2021/6/22.
//

#import "infoXGViewController.h"
#import "PWView.h"
static CGFloat INTERVAL_KEYBOARD = 500;
@interface infoXGViewController ()<UITextFieldDelegate>
{
    NSDictionary *keyboardInfo;
}
@property(nonatomic,assign)PWView*pwView;
@end
@implementation infoXGViewController

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
    __weak infoXGViewController * weakSelf = self;
    self.pwView.touchIndex = ^(NSInteger Index) {
        
        NSLog(@"prompt idnex ==== %ld",Index);
        if(Index==0)
        {
        }else{
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
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.view.width-40, 80)];
    self.centerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.centerView];
    self.SRTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, 50, self.centerView.width-16, 42)];
    if(![self StringIsNullOrEmpty:nickname_loca])
    {
        self.SRTextfield.placeholder=nickname_loca;
    }else{
        self.SRTextfield.placeholder=@"请输入昵称";
    }
    self.SRTextfield.secureTextEntry = NO;
    self.SRTextfield.delegate = self;
    self.SRTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.SRTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.SRTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.SRTextfield.layer.borderWidth = 1;
    self.SRTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.SRTextfield];
    self.tispLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.SRTextfield.bottom+10, self.centerView.width-16, 30)];
    self.tispLabel.text=@"";
    self.tispLabel.textColor=RGBA(255, 0, 0, 1);
    self.tispLabel.textAlignment=NSTextAlignmentCenter;
    [self.tispLabel setFont:[UIFont systemFontOfSize:15.f]];
    self.tispLabel.hidden=YES;
    [self.centerView addSubview:self.tispLabel];
    
    
    self.XGBtn= [[UIButton alloc] init];
    self.XGBtn.frame = CGRectMake(self.centerView.left,self.centerView.bottom+40,self.centerView.width,46);
    self.XGBtn.alpha = 1;
    self.XGBtn.layer.cornerRadius = 10;
    self.XGBtn.backgroundColor=RGB(20, 155, 236);
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
    if ([self.SRTextfield isFirstResponder]) {
        return self.SRTextfield;
    }else
    {
        return self.SRTextfield;
    }
}
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.SRTextfield) {
        [self.SRTextfield becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    NSString *trimText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textField == self.SRTextfield) {
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



-(void)XG_touch:(id)sender
{
    [self PossXGdata];
}
-(void)PossXGdata
{
    __block infoXGViewController *weakSelf = self;
    if(self.SRTextfield.text.length>3)
    {
        [UHud showHUDLoading];
        NSDictionary * dict =[[NSDictionary alloc] init];
        
            dict =@{@"nickname":self.SRTextfield.text,};
        [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,changeNicknameurl] Dictionary:dict success:^(id  _Nullable responseObject) {
    //        NSLog(@"post responseObject == %@",responseObject);
            [UHud hideLoadHud];
            NSDictionary *dict=(NSDictionary *)responseObject;
            NSNumber * code = [dict objectForKey:@"error"];
            if([code intValue]==0)
            {
                NSDictionary *dictdata=[dict objectForKey:@"data"];
                NSDictionary *userdata =[dictdata objectForKey:@"user"];
                NSString * nickname = [userdata objectForKey:@"nickname"];
                
                [[NSUserDefaults standardUserDefaults] setValue:nickname forKey:@"nickname"];
                
                [UHud showHudWithStatus:@"修改成功" delay:2.f];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));

                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    //
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
}

-(void)popViewcontroller
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
