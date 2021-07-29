//
//  AppDelegate.m
//  video
//
//  Created by nian on 2021/3/9.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "OfflineViewController.h"
#import "MyViewController.h"
#import "menberViewController.h"
#import "jiluViewController.h"
#import "BaseWindow.h"
#import "LBLaunchImageAdView.h"
#import "NSObject+LBLaunchImage.h"
#import "CMHHTTPService.h"
#import "IQKeyboardManager.h"
#if defined(DEBUG)||defined(_DEBUG)
#import "JPFPSStatus.h"
#endif









@interface AppDelegate ()<UITabBarControllerDelegate,KJPlayerRotateAppDelegate>
/// 用户数据 只读
@property (nonatomic, readwrite, strong) MHAccount *account;

@property(nonatomic,assign) UIInterfaceOrientationMask rotateOrientation;
@end

@implementation AppDelegate

- (void)reachabilityChanged:(NSNotification *)notification
{

}

/* 传递当前旋转方向 */
- (void)kj_transmitCurrentRotateOrientation:(UIInterfaceOrientationMask)rotateOrientation{
    self.rotateOrientation = rotateOrientation;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.rotateOrientation) {
        return self.rotateOrientation;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self getGuanggao_data];
    if (@available(iOS 11.0, *)) {

            UITableView.appearance.estimatedRowHeight = 0;

            UITableView.appearance.estimatedSectionFooterHeight = 0;

            UITableView.appearance.estimatedSectionHeaderHeight = 0;

            UITableView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        }
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.f], NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //   使用NSUserDefaults来判断程序是否第一次启动
    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
    if (![TimeOfBootCount valueForKey:@"time"]) {
        [TimeOfBootCount setValue:@"sd" forKey:@"time"];
        
        [TimeOfBootCount setValue:@"" forKey:@"UserToken"];
        [TimeOfBootCount setValue:@"" forKey:@"Userrole"];
        [TimeOfBootCount setValue:@"" forKey:@"UserZH"];
        [TimeOfBootCount setValue:@"" forKey:@"UserPW"];
        [TimeOfBootCount setValue:@"" forKey:@"nickname"];
        [TimeOfBootCount setValue:@"" forKey:@"username"];
        [TimeOfBootCount setValue:@"" forKey:@"avatar"];
        [TimeOfBootCount setValue:@(0) forKey:@"expired_time"];
        [TimeOfBootCount setValue:@(0) forKey:@"vip_expired_time"];
        NSLog(@"第一次启动");
    }else{
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserToken"]isEqualToString:@""]) {
            
        }
        NSLog(@"不是第一次启动");
        
        if(!([expired_time_loca intValue]==0))
        {
            NSLog(@"[[self getCurrentTimestamp] intValue]= %d   [expired_time_loca intValue]=%d",[[self getCurrentTimestamp] intValue],[expired_time_loca intValue]);
            if([[self getCurrentTimestamp] intValue]>[expired_time_loca intValue])
            {
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
            }
        }
    }
//    P2P视频加速
    SWCP2pConfig *config = [SWCP2pConfig defaultConfiguration];
        [[SWCP2pEngine sharedInstance] startWithToken:YOUR_TOKEN andP2pConfig:config];
//    [[SWCP2pEngine sharedInstance] startWithToken:YOUR_TOKEN andP2pConfig:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMsg:) name:kP2pEngineDidReceiveStatistics object:nil];
     
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBar=[self tabBarController];
    self.tabBar.delegate=self;
    self.nav = [self roottabbar];
    
//    mobile-startup  //启动图广告
    
    /* FullScreenAdType 全屏广告
     * LogoAdType 带logo的广告类似网易广告，值得注意的是启动图片必须带logo图
     * localAdImgName  本地图片名字
     */
    NSData*SaveData=[[NSUserDefaults standardUserDefaults] objectForKey:@"GuanggaoModeA"];
    
    __weak typeof(self) weakSelf = self;
    [NSObject makeLBLaunchImageAdView:^(LBLaunchImageAdView *imgAdView) {
        imgAdView.frame=self.window.bounds;
        //设置广告的类型
        imgAdView.getLBlaunchImageAdViewType(FullScreenAdType);
        
        imgAdView.adTime=3;
        if(SaveData){
        NSDictionary * dict=[self dictionaryForJsonData:SaveData];
            GuanggaoMode  *modeSave=[GuanggaoMode yy_modelWithDictionary:dict];
            imgAdView.imgUrl=modeSave.source;
        }else{
            //设置本地启动图片
            imgAdView.localAdImgName = @"lcaunBg";
        }
//        imgAdView.imgUrl = @"https://hbimg.huabanimg.com/5e7d8c4bdf276d2f96b90f4f6e4f1b0fa681dacc2c584e-OgArEz_fw658";
        //自定义跳过按钮
        imgAdView.skipBtn.backgroundColor = [UIColor clearColor];
        //各种点击事件的回调
        imgAdView.clickBlock = ^(clickType type){
            switch (type) {
                case clickAdType:{
                    NSLog(@"点击广告回调 ");
//                    if(imgAdView.adTime==0)
//                    {
                        [self setWindowUpdate];
//                    }
                }
                    break;
                case skipAdType:{
                    NSLog(@"点击跳过回调");
                    [weakSelf setWindowUpdate];
                }
                    break;
                case overtimeAdType:{
                    NSLog(@"倒计时完成后的回调");
                    [weakSelf setWindowUpdate];
                }
                    break;
                default:
                    break;
            }
        };
       
    }];
    
    
    
    
    
    
    
//    [self.window setRootViewController:[self tabBarController]];
//    [self.window makeKeyAndVisible];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    
    
    
    return YES;
}

- (void)didReceiveMsg:(NSNotification *)note {
//    NSDictionary *dict = (NSDictionary *)note.object;
//    NSLog(@"didReceiveMsg====  %@", dict);
}
-(void)setWindowUpdate
{
    
    [self.window setRootViewController:self.nav];
    [self.window makeKeyAndVisible];
}


// 获取当前时间戳
- (NSString *)getCurrentTimestamp {
NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
return timeString;
}
-(UITabBarController *)tabBarController
{
    UITabBarController * tabBarC = [[UITabBarController alloc] init];
    
    HomeViewController * tabBarVC1 = [[HomeViewController alloc] init];
    [tabBarVC1 setTabBarItemWithTitle:@"首页" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"shouye_image"] selectImage:[UIImage imageNamed:@"shouye_select_image"] imageSize:CGSizeMake(30, 30)];

    jiluViewController * tabBarVC2 = [[jiluViewController alloc] init];
    [tabBarVC2 setTabBarItemWithTitle:@"记录" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"jilu_image"] selectImage:[UIImage imageNamed:@"jilu_select_image"] imageSize:CGSizeMake(30, 30)];
    menberViewController * tabBarVC3 = [[menberViewController alloc] init];
    [tabBarVC3 setTabBarItemWithTitle:@"充值" titleUnSelectStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] titleSelectStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] unselectImage:[UIImage imageNamed:@"menber"] selectImage:[UIImage imageNamed:@"menber"] imageSize:CGSizeMake(40, 40)];//调整图标大小  CGSizeMake(55, 55)  
    
//    OfflineViewController * tabBarVC4 = [[OfflineViewController alloc] init];
//    [tabBarVC4 setTabBarItemWithTitle:@"离线" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"lixian_image"] selectImage:[UIImage imageNamed:@"lixian_select_image"] imageSize:CGSizeMake(30, 30)];
    
    MyViewController * tabBarVC5 = [[MyViewController alloc] init];
    [tabBarVC5 setTabBarItemWithTitle:@"我的" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"my_image"] selectImage:[UIImage imageNamed:@"my_select_image"] imageSize:CGSizeMake(30, 30)];
    
//    tabBarC.viewControllers = @[[tabBarVC1 addNav],[tabBarVC2 addNav],[tabBarVC3 addNav],[tabBarVC4 addNav],[tabBarVC5 addNav]];
    tabBarC.viewControllers = @[[tabBarVC1 addNav],[tabBarVC2 addNav],[tabBarVC3 addNav],[tabBarVC5 addNav]];
    
    //去掉tabBar顶部黑色线条

    CGRect rect = CGRectMake(0, 0, ScreenWidth, SCREENH_HEIGHT);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);

    CGContextFillRect(context, rect);

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    [tabBarC.tabBar setBackgroundImage:img];

    [tabBarC.tabBar setShadowImage:img];
    
    return tabBarC;
}
- (HXBaseNavgationController *)roottabbar {
    
    self.tabBar.tabBar.translucent = NO;
//    return tabBarC;
    HXBaseNavgationController * rootNav = [[HXBaseNavgationController alloc ] initWithRootViewController:self.tabBar];
    [rootNav setNavigationBarHidden:YES];
    [rootNav.navigationController.navigationBar setHidden:YES];
    return rootNav;
}

//这个是UITabBarController的代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    static int i=0;
    // 判断哪个界面要需要再次点击刷新，这里以第一个VC为例
    if ([tabBarController.selectedViewController isEqual:[tabBarController.viewControllers firstObject]]) {
        // 判断再次选中的是否为当前的控制器
        if ([viewController isEqual:tabBarController.selectedViewController]) {
            // 执行操作
            NSLog(@"刷新界面 i = %d",i);
               [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"notificationVUP" object:nil userInfo:@{@"key":@"接收到了通知"}]];
            return NO;
        }
        
    }
    
    return YES;

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^
              {
                  dispatch_async(dispatch_get_main_queue(), ^
                                 {
                                     if (bgTask != UIBackgroundTaskInvalid)
                                     {
                                         bgTask = UIBackgroundTaskInvalid;
                                     }
                                 });
              }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if (bgTask != UIBackgroundTaskInvalid)
                                          {
                                              bgTask = UIBackgroundTaskInvalid;
                                          }
                                      });
                   });
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    

//    [self customizeTabBarAppearance:self.tabBar];
//    NSInteger selectInt = tabBarController.selectedIndex;
//    if (@available(iOS 13.0, *)) {
//        
//        if(selectInt==2)
//        {
//            // titColor就是选中的颜色
//            tabBarController.tabBar.tintColor = [UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0];
//        }else{
//            // titColor就是选中的颜色
//            tabBarController.tabBar.tintColor = RGBA(20, 155, 236, 1);
//        }
//        //如果需要设置默认颜色可以使用setUnselectedItemTintColor来设置未选中颜色
//             [tabBarController.tabBar setUnselectedItemTintColor:RGBA(153, 153, 153, 1)];
//        } else {
//            
//        }
    
}
/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(UITabBarController *)tabBarController {
#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    // Customize UITabBar height
    
    // 适配iOS 13 tabbar 标题字体不显示以及返回变蓝色的为问题
    if (@available(iOS 13.0, *)) {
                          
        //
        [[UITabBar appearance] setUnselectedItemTintColor:RGB(155, 155, 155)];

    }
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = RGB(155, 155, 155);
   
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20.f];;

   
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = RGB(234, 83, 36);
    
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20.f];
    
    
    

    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
     [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    

}








#pragma mark- 获取appdelegate
+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (MHAccount *)account{
    if (_account == nil) {
        // 内部初始化了数据
        _account = [[MHAccount alloc] init];
    }
    return _account;
}


#pragma mark - 在初始化UI之前配置
- (void)_configureApplication:(UIApplication *)application initialParamsBeforeInitUI:(NSDictionary *)launchOptions{
    /// 显示状态栏
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    /// 配置键盘
    [self _configureKeyboardManager];
    
    // 配置YYWebImage
    [self _configureYYWebImage];
    
    /// 配置网络请求
    [CMHHTTPService sharedInstance];
}

/// 配置键盘管理器
- (void)_configureKeyboardManager {
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
}

/// 配置YYWebImage
- (void)_configureYYWebImage {
    /// CoderMikeHe Fixed Bug : 解决 SDWebImage & YYWebImage 加载不出http://img3.imgtn.bdimg.com/it/u=965183317,1784857244&fm=27&gp=0.jpg的BUG
    NSMutableDictionary *header = [YYWebImageManager sharedManager].headers.mutableCopy;
    header[@"User-Agent"] = @"iPhone";
    [YYWebImageManager sharedManager].headers = header;
}



-(void)getGuanggao_data
{
//    PC-首页-轮播图底下     pc-home-banner-below
//    PC-播放页-侧边-上部    pc-play-side-top
//    PC-播放页-侧边-下部    pc-play-side-bottom
//    PC-播放页-播放器底下    pc-play-player-below
//    PC-播放页-播放器      pc-play-player
//    移动-首页-轮播图底下   mobile-home-banner-below
//    移动-播放页-播放器    mobile-play-player
//    PC-筛选页-右边       pc-filter-right
//    NSDictionary *dict =@{@"symbol":@"mobile-play-player",
//                          @"result":@"1",
//    };
    
        NSDictionary *dict =@{@"symbol":@"mobile-startup",
                              @"result":@"1",
        };
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,guanggaoGDurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary * datadict = [dict objectForKey:@"data"];
            NSDictionary * dataAD = [datadict objectForKey:@"ad"];
//            [DYModelMaker DY_makeModelWithDictionary:dataAD modelKeyword:@"Guanggao" modelName:@"Mode"];
            if(![dataAD isKindOfClass:[NSNull class]]){
            self.GuanggaoModeA=[GuanggaoMode yy_modelWithDictionary:dataAD];
//            NSString * urlstr = [dataAD objectForKey:@"source"];
            if(self.GuanggaoModeA)
            {
//                self.GGimageview.yy_imageURL=[NSURL URLWithString:self.GuanggaoModeA.source];
                NSData * SaveData=[self.GuanggaoModeA yy_modelToJSONData];
                [[NSUserDefaults standardUserDefaults] setObject:SaveData forKey:@"GuanggaoModeA"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
            }
            }
        }else{
            NSString * message = [dict objectForKey:@"message"];
            NSNumber * error = [dict objectForKey:@"error"];
            if([error intValue]!=21)
            {
                [UHud showTXTWithStatus:message delay:2.f];
            }else
            {
                if(![usertoken isEqualToString:@""])
                {
                    [UHud showTXTWithStatus:message delay:2.f];
                }
            }
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
    
    
}


/** 将二进制数据转换成字典*/

- (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData
{
    if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) {
        return nil;
    }
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if (![jsonObj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];
}

@end
