//
//  MyViewController.m
//  video
//
//  Created by nian on 2021/3/10.
//

#import "MyViewController.h"
#import "topHeaderView.h"


#import "HQImageEditViewController.h"
#import "TZImagePickerController.h"
#import "safeViewController.h"
#import "chongzhiListViewController.h"
#import "zhanghuInfoViewController.h"
#import "jiluViewController.h"
#import "ZjiluViewController.h"
#import "FAQViewController.h"
#import "NewFAQViewController.h"
#import "promptbottomView.h"
#import "FankuiViewController.h"
#import "UIButton+WebCache.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,ZGQActionSheetViewDelegate,HQImageEditViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UIView*ZtopView;
@property(nonatomic,strong)topHeaderView *Headerview;

@property(nonatomic,strong)UITableView*downtableview;
@property(nonatomic,strong)NSMutableArray*arrtitle;
@property(nonatomic,strong)NSMutableArray*imagearray;

@property(nonatomic,strong)promptbottomView*promptView;

@end

@implementation MyViewController
@synthesize ZtopView,arrtitle,imagearray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navBarColor=[UIColor whiteColor];
//    self.hiddenLeftBtn=YES;
    self.title=@"我的";
    [self InitUIView];
    [self Addtableview];
    [self setyinying];
    [self addpromptViewM];
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [UHud hideLoadHudForView:nil];
//    });
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getInfoData];
    [self updateHeaderViwe];
}

-(void)getInfoData
{
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,GetUserInfoURL] Dictionary:nil success:^(id  _Nullable responseObject) {
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
            
           
            [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"UserZH"];
            [[NSUserDefaults standardUserDefaults] setValue:nickname forKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:avatar forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setValue:vip_expired_time forKey:@"vip_expired_time"];
            
            [self updateHeaderViwe];
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showHudWithStatus:message delay:2.f];
            NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
            [TimeOfBootCount setValue:@"" forKey:@"UserToken"];
            [TimeOfBootCount setValue:@"" forKey:@"Userrole"];
            [TimeOfBootCount setValue:@"" forKey:@"UserZH"];
            [TimeOfBootCount setValue:@"" forKey:@"UserPW"];
            [TimeOfBootCount setValue:@"" forKey:@"nickname"];
            [TimeOfBootCount setValue:@"" forKey:@"username"];
            [TimeOfBootCount setValue:@"" forKey:@"avatar"];
            [TimeOfBootCount setValue:@(0) forKey:@"expired_time"];
            [TimeOfBootCount setValue:@(0) forKey:@"vip_expired_time"];
            [self updateHeaderViwe];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [self updateHeaderViwe];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
}




-(void)updateHeaderViwe
{
    if(self.Headerview)
    {
        if(![self StringIsNullOrEmpty:avatar_loca])
        {
//            [self.Headerview.txImage setImage:[self base64Image:avatar_loca] forState:(UIControlStateNormal)];
//            @"https://img2.baidu.com/it/u=4087057811,445331467&fm=26&fmt=auto&gp=0.jpg"  测试连接
            [self.Headerview.txImage xr_setButtonImageWithUrl:avatar_loca];
        }
        if(![self StringIsNullOrEmpty:nickname_loca])
        {
            [self.Headerview.nameLabel setText:nickname_loca];
        }else{
            if(![self StringIsNullOrEmpty:username_loca])
            {
                [self.Headerview.nameLabel setText:username_loca];
            }else{
                [self.Headerview.nameLabel setText:@"未登录"];
            }
        }
        if([vip_expired_time_loca intValue]==0)
        {
            [self.Headerview.vipTime setText:@"马上充值会员，立刻享受VIP观影特权"];
            [self.Headerview.vipImage setImage:[UIImage imageNamed:@"nohuiyuan"] forState:(UIControlStateNormal)];
        }else{
            [self.Headerview.vipTime setText:[NSString stringWithFormat:@"会员到期时间 %@",[self getTimeFromTimestamp:vip_expired_time_loca]]];
            [self.Headerview.vipImage setImage:[UIImage imageNamed:@"vipimage"] forState:(UIControlStateNormal)];
        }
    }
    
    
    self.Headerview.nameLabel.frame=CGRectMake(self.Headerview.txImage.left+self.Headerview.txImage.width+8, 20, [self getWidthWithText:self.Headerview.nameLabel.text height:self.Headerview.nameLabel.height font:18.f], 30);
    self.Headerview.vipImage.frame=CGRectMake(self.Headerview.nameLabel.left+self.Headerview.nameLabel.width+2, 20, 62, 34);
    self.Headerview.vipTime.frame=CGRectMake(self.Headerview.txImage.left+self.Headerview.txImage.width+8, self.Headerview.nameLabel.bottom+8, [self getWidthWithText:self.Headerview.vipTime.text height:self.Headerview.vipTime.height font:15.f], 30);
}

-(void)addpromptViewM{
    promptbottomView *view = [[[NSBundle mainBundle]loadNibNamed:@"promptbottomView" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.8];
    view.hidden=YES;
    view.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 0);
//    view.bottomview.layer.cornerRadius=10;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
    [view.bottomview setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor] type:corners];
    view.okBtn.layer.cornerRadius=6;
    view.cancelBtn.layer.cornerRadius=6;
    [self.view addSubview:view];
    self.promptView=view;
    __weak MyViewController * weakSelf = self;
    self.promptView.touchIndex = ^(NSInteger Index) {
        
        NSLog(@"prompt idnex ==== %ld",Index);
        if(Index==0)
        {
            
        }else{
            [weakSelf signoutURL_touch];
        }
        [weakSelf Hidprompt];
    };
}
-(void)signoutURL_touch
{
    [UHud showHUDLoading];
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,signoutURL] Dictionary:nil success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    
//                    [UHud showSuccessWithStatus:@"获取成功" delay:2.f];
//                }else if([code intValue]==20){
                    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
                    [TimeOfBootCount setValue:@"" forKey:@"UserToken"];
                    [TimeOfBootCount setValue:@"" forKey:@"Userrole"];
                    [TimeOfBootCount setValue:@"" forKey:@"UserZH"];
                    [TimeOfBootCount setValue:@"" forKey:@"UserPW"];
                    [TimeOfBootCount setValue:@"" forKey:@"nickname"];
                    [TimeOfBootCount setValue:@"" forKey:@"username"];
                    [TimeOfBootCount setValue:@"" forKey:@"avatar"];
                    [TimeOfBootCount setValue:@(0) forKey:@"expired_time"];
                    [TimeOfBootCount setValue:@(0) forKey:@"vip_expired_time"];
                    [UHud showSuccessWithStatus:@"退出成功" delay:2.f];
                    [self updateHeaderViwe];
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
                    [TimeOfBootCount setValue:@"" forKey:@"UserToken"];
                    [TimeOfBootCount setValue:@"" forKey:@"Userrole"];
                    [TimeOfBootCount setValue:@"" forKey:@"UserZH"];
                    [TimeOfBootCount setValue:@"" forKey:@"UserPW"];
                    [TimeOfBootCount setValue:@"" forKey:@"nickname"];
                    [TimeOfBootCount setValue:@"" forKey:@"username"];
                    [TimeOfBootCount setValue:@"" forKey:@"avatar"];
                    [TimeOfBootCount setValue:@(0) forKey:@"expired_time"];
                    [TimeOfBootCount setValue:@(0) forKey:@"vip_expired_time"];
                    [UHud showSuccessWithStatus:@"退出成功" delay:2.f];
                    [self updateHeaderViwe];
                }
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
                [TimeOfBootCount setValue:@"" forKey:@"UserToken"];
                [TimeOfBootCount setValue:@"" forKey:@"Userrole"];
                [TimeOfBootCount setValue:@"" forKey:@"UserZH"];
                [TimeOfBootCount setValue:@"" forKey:@"UserPW"];
                [TimeOfBootCount setValue:@"" forKey:@"nickname"];
                [TimeOfBootCount setValue:@"" forKey:@"username"];
                [TimeOfBootCount setValue:@"" forKey:@"avatar"];
                [TimeOfBootCount setValue:@(0) forKey:@"expired_time"];
                [TimeOfBootCount setValue:@(0) forKey:@"vip_expired_time"];
                [UHud showSuccessWithStatus:@"退出成功" delay:2.f];
                [self updateHeaderViwe];
                NSLog(@"shareManager error == %@",error);
//                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
            }];
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
    NSLog(@"avatar_loca==== %@,nickname_loca= %@,username_loca= %@",avatar_loca,nickname_loca,username_loca);
    [self updateHeaderViwe];
    view.nameLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [view.nameLabel addGestureRecognizer:labelTapGestureRecognizer];
    view.txImage.layer.cornerRadius = 30;
    view.txImage.layer.masksToBounds = YES;
    view.jifenBtn.hidden=YES;
    [self.ZtopView addSubview:view];
    self.Headerview = view;
//    [self.Headerview.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo([self getWidthWithText:self.Headerview.nameLabel.text height:self.Headerview.nameLabel.height font:15.f]);
//    }];
    __weak __typeof(self)weakSelf = self;
    self.Headerview.topHeaderBlock = ^(NSInteger touchIndex) {
        NSLog(@"Touchindex= %ld",touchIndex);
        if(touchIndex==1001)
        {
            if([usertoken isEqualToString:@""])
            {
                LoginViewController * avc = [[LoginViewController alloc] init];
                [weakSelf pushRootNav:avc animated:YES];
            }else{
                [weakSelf ShowProfilePhoto];
            }
        }else if(touchIndex==1002)
        {
//            if([usertoken isEqualToString:@""])
//            {
//                LoginViewController * avc = [[LoginViewController alloc] init];
//                [weakSelf pushRootNav:avc animated:YES];
//            }else{
//                zhanghuInfoViewController * avc = [[zhanghuInfoViewController alloc] init];
//                [weakSelf pushRootNav:avc animated:YES];
//            }
        }else if(touchIndex==1003)
        {
            if([usertoken isEqualToString:@""])
            {
                LoginViewController * avc = [[LoginViewController alloc] init];
                [weakSelf pushRootNav:avc animated:YES];
            }else{
                zhanghuInfoViewController * avc = [[zhanghuInfoViewController alloc] init];
                [weakSelf pushRootNav:avc animated:YES];
            }
        }
    };
    self.Headerview.cellindexBlock = ^(NSInteger CellIndex) {
        NSLog(@"CellIndex= %ld",CellIndex);
        if(CellIndex==1000)
        {
// 收藏夹
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
                NSArray * arraynav = nav.viewControllers;
                UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
                tabViewController.selectedIndex = 1;
            NSNotification *notification = [NSNotification notificationWithName:@"listUpdate" object:nil userInfo:@{@"update":@(1)}];
            [[NSNotificationCenter defaultCenter]postNotification:notification];
        }else if(CellIndex==1001)
        {
            // 求片
            FankuiViewController * avc = [[FankuiViewController alloc] init];
            avc.typeInt=1001;
            [weakSelf pushRootNav:avc animated:YES];
        }else if(CellIndex==1002)
        {
            [UHud showTXTWithStatus:@"敬请期待" delay:2.f];
            // 任务
        }else if(CellIndex==1003)
        {
            // 充值
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
                NSArray * arraynav = nav.viewControllers;
                UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
                tabViewController.selectedIndex = 2;

        }
    };
}
-(void)labelTouchUpInside:(UITapGestureRecognizer*)tap
{
    
    NSLog(@"label被点击了" );
    if([usertoken isEqualToString:@""])
    {
        LoginViewController * avc = [[LoginViewController alloc] init];
        [self pushRootNav:avc animated:YES];
    }
}
-(void)ShowProfilePhoto
{
    
    //    optionArray = [NSArray array];
    NSArray *optionArray = @[@"拍照",@"相册选择照片"];
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray];
    sheetView.tag=101;
    sheetView.delegate = self;
    [sheetView show];
}
- (void)ZGQActionSheetView:(ZGQActionSheetView *)sheetView didSelectRowAtIndex:(NSInteger)index text:(NSString *)text {
    NSLog(@"%zd,%@",index,text);
    if(sheetView.tag==101)
    {
        if (index==0) {
            [self openCamera];
        }else if (index==1)
        {
            [self openAlbum];
        }
    }
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
    self.downtableview.frame=CGRectMake(20, 200, SCREEN_WIDTH-40, SCREENH_HEIGHT-210-kNavAndTabHeight);
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
    NSArray * arr = arrtitle[0];
 
    if(indexPath.section==0){

//        ZjiluViewController * avc = [[ZjiluViewController alloc] init];
//        [self pushRootNav:avc animated:YES];

            // Fallback on earlier versions
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            UITabBarController *tabViewController = (UITabBarController *) delegate.window.rootViewController;
//            [tabViewController setSelectedIndex:1];
            HXBaseNavgationController* nav =(HXBaseNavgationController*)delegate.window.rootViewController;
            NSArray * arraynav = nav.viewControllers;
            UITabBarController* tabViewController=(UITabBarController *)arraynav[0];
            tabViewController.selectedIndex = 1;
        NSNotification *notification = [NSNotification notificationWithName:@"listUpdate" object:nil userInfo:@{@"update":@(2)}];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
        
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
//        FAQViewController * avc = [[FAQViewController alloc] init];
        NewFAQViewController* avc = [[NewFAQViewController alloc] init];
        [self pushRootNav:avc animated:YES];
    }else if(indexPath.section==4)
    {
        safeViewController * avc = [[safeViewController alloc] init];
        [self pushRootNav:avc animated:YES];
    }else if(indexPath.section==5){
        [UHud showTXTWithStatus:@"敬请期待" delay:2.f];
    }else if(indexPath.section==(arr.count-1))
    {
        if([usertoken isEqualToString:@""])
        {
            [UHud showTXTWithStatus:@"您还没有登录" delay:2.f];
        }else{
            [self showprompt];;
        }
        
    }
}

-(void)showprompt
{
    
    [UIView animateWithDuration:0.7 animations:^{
        self.promptView.bottomview.hidden=NO;
        self.promptView.hidden=NO;
        self.promptView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavAndTabHeight);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)Hidprompt
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.promptView.bottomview.hidden=YES;
        self.promptView.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH,0 );
    } completion:^(BOOL finished) {
        self.promptView.hidden=YES;
    }];
}

    
    
    
    
    
    
-(void)postUploadHeadImage:(UIImage *)image
{
    
    [UHud showHUDLoading];
//    avatar
    NSArray * arr = [NSArray arrayWithObjects:image, nil];
//    NSDictionary * dict;
//    for (int i = 0; i < arr.count; i++) {
//        UIImage *image = arr[i];
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//        dict=@{@"avatar":imageData};
//    }
//
    [[HttpManagement shareManager] uploadImagesWihtImgArr:arr url:[NSString stringWithFormat:@"%@%@",FWQURL,YHupdateavatar] Tokenbool:NO parameters:nil block:^(id objc, BOOL success) {
        [UHud hideLoadHud];
        if(success==YES)
        {
                NSDictionary *dict=(NSDictionary *)objc;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    NSDictionary *dictdata =[dict objectForKey:@"data"];
                    NSDictionary *userData =[dictdata objectForKey:@"user"];
                    NSString * avatar =[userData objectForKey:@"avatar"];
                    [[NSUserDefaults standardUserDefaults] setValue:avatar forKey:@"avatar"];
                    [SVProgressHUD dismiss];
                    [self updateHeaderViwe];
//                    [UHud showSuccessWithStatus:@"获取成功" delay:2.f];
//                }else if([code intValue]==20){
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [SVProgressHUD dismiss];
                    [UHud showTXTWithStatus:message delay:2.f];
                }
        }else{
            NSError * error = (NSError *)objc;
            NSLog(@"shareManager error == %@",error);
            [SVProgressHUD dismiss];
            [UHud showTXTWithStatus:@"网络错误" delay:2.f];
            
        }
    }blockprogress:^(id progress) {
//        NSLog(@"progress == %@",progress);
        NSProgress * pro = (NSProgress *)progress;
        CGFloat jd=pro.fractionCompleted;
//        [SVProgressHUD showProgress:jd];
//        if(jd>=1)
//        {
//            [SVProgressHUD dismiss];
//        }
    }];
}
    
- (void)openCamera
{
    //判断是否已授权
    //    AVAuthorizationStatus autjStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"在设置-隐私中允许 U视频 访问摄像头" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                //响应事件
                NSLog(@"action = %@", action);
                [self dismissViewControllerAnimated:YES completion:nil];
                //                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else
        {
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = self;
            [self.navigationController presentViewController:ipc animated:YES completion:nil];
//            [self pushRootNav:ipc animated:YES];
        }
    }
}

-(void)openSDKHQImageEdit:(UIImage*)imageBD
{
     HQImageEditViewController *vc = [[HQImageEditViewController alloc] init];
        vc.originImage = imageBD;
        vc.delegate = self;
        vc.maskViewAnimation = YES;
    //    vc.editViewSize = CGSizeMake(300, 200);
    //    [self presentViewController:vc animated:YES completion:nil];
//        [self.navigationController pushViewController:vc animated:YES];
    [self pushRootNav:vc animated:YES];
}
#pragma mark - HQImageEditViewControllerDelegate
- (void)editController:(HQImageEditViewController *)vc finishiEditShotImage:(UIImage *)image originSizeImage:(UIImage *)originSizeImage {
//    self.imageView.image = originSizeImage;
//    [vc dismissViewControllerAnimated:YES completion:nil];
    [self postUploadHeadImage:originSizeImage];
    [vc.navigationController popViewControllerAnimated:YES];
}

- (void)editControllerDidClickCancel:(HQImageEditViewController *)vc {
//    [vc dismissViewControllerAnimated:YES completion:nil];
    [vc.navigationController popViewControllerAnimated:YES];
}


- (void)openAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        //        [self presentViewController:imagePickerVc animated:YES completion:nil];
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        //            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        [self.navigationController presentViewController:ipc animated:YES completion:nil];
//        [self pushRootNav:ipc animated:YES];
    }else{
        //        [self showHint:@"请打开允许访问相册权限"];
        NSLog(@"请打开允许访问相册权限");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"在设置-隐私中允许 U视频 访问相册" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
            [self dismissViewControllerAnimated:YES completion:nil];
            //                [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
//相机选的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 关闭相册\相机
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    //     [self.navigationController popViewControllerAnimated:NO];
    // 往数据数组拼接图片
    //    [self.dataArr addObject:info[UIImagePickerControllerOriginalImage]];
    NSLog(@"MMMM= %@",info[UIImagePickerControllerOriginalImage]);
    [self openSDKHQImageEdit:[MyViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200]];
//    [self postUploadHeadImage:[InformationViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200]];
}
//取消按钮
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picke{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *dict = @{@"Dismiss":@"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNext" object:nil userInfo:dict];
}
// 相册选的图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
//    [self postUploadHeadImage:[InformationViewController compressImageQuality:(UIImage*)photos[0] toByte:51200]];
    [self openSDKHQImageEdit:[MyViewController compressImageQuality:(UIImage*)photos[0] toByte:51200]];
}



-(NSData *)compressWithMaxLength:(NSUInteger)maxLength image_P:(UIImage *)imageVV{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(imageVV, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(imageVV, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}


+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

-(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>2*1024*1024) {//2M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.05);
        }else if (data.length>1024*1024) {//1M-2M
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.4);
        }
    }
    return data;
}




//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}




@end
