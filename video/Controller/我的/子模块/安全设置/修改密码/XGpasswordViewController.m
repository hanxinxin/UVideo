//
//  XGpasswordViewController.m
//  video
//
//  Created by nian on 2021/5/14.
//

#import "XGpasswordViewController.h"

@interface XGpasswordViewController ()

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
}

-(void)InitUI
{
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.view.width-40, 226)];
    self.centerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.centerView];
    self.oldTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, 50, self.centerView.width-16, 42)];
    self.oldTextfield.placeholder=@"输入旧密码";
    self.oldTextfield.secureTextEntry = YES;
    self.oldTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.oldTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.oldTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.oldTextfield.layer.borderWidth = 1;
    self.oldTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.oldTextfield];
    self.onenewTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, self.oldTextfield.bottom+10, self.centerView.width-16, 42)];
    self.onenewTextfield.placeholder=@"输入新密码";
    self.onenewTextfield.secureTextEntry = YES;
    self.onenewTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.onenewTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.onenewTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.onenewTextfield.layer.borderWidth = 1;
    self.onenewTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.onenewTextfield];
    self.twonewTextfield = [[UITextField alloc] initWithFrame:CGRectMake(8, self.onenewTextfield.bottom+10, self.centerView.width-16, 42)];
    self.twonewTextfield.placeholder=@"重复新密码";
    self.twonewTextfield.secureTextEntry = YES;
    self.twonewTextfield.keyboardType=UIKeyboardTypeEmailAddress;
    self.twonewTextfield.borderStyle=UITextBorderStyleRoundedRect;
    self.twonewTextfield.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    self.twonewTextfield.layer.borderWidth = 1;
    self.twonewTextfield.layer.cornerRadius = 6;
    [self.centerView addSubview:self.twonewTextfield];
    
    
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
-(void)XG_touch:(id)sender
{
    
}
@end
