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

   
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.f], NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
           
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBar=[self tabBarController];
    self.tabBar.delegate=self;
    self.nav = [self roottabbar];
    [self.window setRootViewController:self.nav];
    [self.window makeKeyAndVisible];
    
//    [self.window setRootViewController:[self tabBarController]];
//    [self.window makeKeyAndVisible];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //   使用NSUserDefaults来判断程序是否第一次启动
    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
    if (![TimeOfBootCount valueForKey:@"time"]) {
        [TimeOfBootCount setValue:@"sd" forKey:@"time"];
        
        [TimeOfBootCount setValue:@"" forKey:@"UserToken"];
        [TimeOfBootCount setValue:@"" forKey:@"Userrole"];
        [TimeOfBootCount setValue:@"" forKey:@"UserZH"];
        [TimeOfBootCount setValue:@"" forKey:@"UserPW"];
        [TimeOfBootCount setValue:@"0" forKey:@"SetDevNumber"];
        
        NSLog(@"第一次启动");
    }else{
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserToken"]isEqualToString:@""]) {
            
        }
        NSLog(@"不是第一次启动");
    }
    
    
    
    return YES;
}

-(UITabBarController *)tabBarController
{
    UITabBarController * tabBarC = [[UITabBarController alloc] init];
    
    HomeViewController * tabBarVC1 = [[HomeViewController alloc] init];
    [tabBarVC1 setTabBarItemWithTitle:@"首页" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"homeimageselect"] selectImage:[UIImage imageNamed:@"homeimage"] imageSize:CGSizeMake(30, 30)];

    jiluViewController * tabBarVC2 = [[jiluViewController alloc] init];
    [tabBarVC2 setTabBarItemWithTitle:@"记录" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"jilu"] selectImage:[UIImage imageNamed:@"jiluselect"] imageSize:CGSizeMake(30, 30)];
    menberViewController * tabBarVC3 = [[menberViewController alloc] init];
    [tabBarVC3 setTabBarItemWithTitle:@"充值" titleUnSelectStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] titleSelectStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] unselectImage:[UIImage imageNamed:@"menber"] selectImage:[UIImage imageNamed:@"menber"] imageSize:CGSizeMake(55, 55)];
    
    OfflineViewController * tabBarVC4 = [[OfflineViewController alloc] init];
    [tabBarVC4 setTabBarItemWithTitle:@"离线" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"lixianimage"] selectImage:[UIImage imageNamed:@"lixianimageselect"] imageSize:CGSizeMake(30, 30)];
    
    MyViewController * tabBarVC5 = [[MyViewController alloc] init];
    [tabBarVC5 setTabBarItemWithTitle:@"我的" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"meimage"] selectImage:[UIImage imageNamed:@"meimageselect"] imageSize:CGSizeMake(30, 30)];
    
    tabBarC.viewControllers = @[[tabBarVC1 addNav],[tabBarVC2 addNav],[tabBarVC3 addNav],[tabBarVC4 addNav],[tabBarVC5 addNav]];
    
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
    
   
//    return tabBarC;
    HXBaseNavgationController * rootNav = [[HXBaseNavgationController alloc ] initWithRootViewController:self.tabBar];
    [rootNav setNavigationBarHidden:YES];
    [rootNav.navigationController.navigationBar setHidden:YES];
    return rootNav;
}

#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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


@end
