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
#import "memberViewController.h"
#import "jiluViewController.h"

#import "CMHHTTPService.h"
#import "IQKeyboardManager.h"
#if defined(DEBUG)||defined(_DEBUG)
#import "JPFPSStatus.h"
#endif

@interface AppDelegate ()
/// 用户数据 只读
@property (nonatomic, readwrite, strong) MHAccount *account;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 13.0, *)) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        HXBaseNavgationController * viewC = [self tabBarController];
        [self.window setRootViewController:[self tabBarController]];
        [self.window makeKeyAndVisible];
        } else {
        
//            HXBaseNavgationController * viewC = [self tabBarController];
            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self.window setRootViewController:[self tabBarController]];
            [self.window makeKeyAndVisible];
        }
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
- (UITabBarController *)tabBarController {
    
    UITabBarController * tabBarC = [[UITabBarController alloc] init];
    
    HomeViewController * tabBarVC1 = [[HomeViewController alloc] init];
    [tabBarVC1 setTabBarItemWithTitle:@"首页" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"homeimageselect"] selectImage:[UIImage imageNamed:@"homeimage"] imageSize:CGSizeMake(30, 30)];

    jiluViewController * tabBarVC2 = [[jiluViewController alloc] init];
    [tabBarVC2 setTabBarItemWithTitle:@"记录" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"jilu"] selectImage:[UIImage imageNamed:@"jiluselect"] imageSize:CGSizeMake(30, 30)];
    memberViewController * tabBarVC3 = [[memberViewController alloc] init];
    [tabBarVC3 setTabBarItemWithTitle:@"充值" titleUnSelectStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0], UITextAttributeTextColor,nil] titleSelectStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0], UITextAttributeTextColor,nil] unselectImage:[UIImage imageNamed:@"menber"] selectImage:[UIImage imageNamed:@"menber"] imageSize:CGSizeMake(45, 45)];
    
    OfflineViewController * tabBarVC4 = [[OfflineViewController alloc] init];
    [tabBarVC4 setTabBarItemWithTitle:@"离线" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"lixianimage"] selectImage:[UIImage imageNamed:@"lixianimageselect"] imageSize:CGSizeMake(30, 30)];
    
    MyViewController * tabBarVC5 = [[MyViewController alloc] init];
    [tabBarVC5 setTabBarItemWithTitle:@"我的" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"meimage"] selectImage:[UIImage imageNamed:@"meimageselect"] imageSize:CGSizeMake(30, 30)];
    
    tabBarC.viewControllers = @[[tabBarVC1 addNav],[tabBarVC2 addNav],[tabBarVC3 addNav],[tabBarVC4 addNav],[tabBarVC5 addNav]];
    
//    HXBaseNavgationController * rootNav = [[HXBaseNavgationController alloc ] initWithRootViewController:tabBarC];
//    [rootNav setNavigationBarHidden:YES];
    return tabBarC;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
