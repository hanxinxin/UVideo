//
//  SceneDelegate.m
//  video
//
//  Created by nian on 2021/3/9.
//

#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "memberViewController.h"
#import "OfflineViewController.h"
#import "MyViewController.h"
#import "jiluViewController.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate{
    BaseWindow *_baseWindow;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    if (@available(iOS 13.0, *)) {
        
        
//        UIWindowScene *windowScene = (UIWindowScene *)scene;
//        self.window = [[BaseWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//         self.window.backgroundColor = [UIColor whiteColor];
//        self.window.windowScene=windowScene;
//         [self.window makeKeyAndVisible];
        
        
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        self.window.windowScene=windowScene;
        self.nav = [self tabBarController];
        [self.window setRootViewController:self.nav];
//        [self.window setRootViewController:[self tabBarController]];

        [self.window makeKeyAndVisible];
    } else {
        // Fallback on earlier versions
//        UIWindowScene *windowScene = (UIWindowScene *)scene;
//        self.window = [[BaseWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//         self.window.backgroundColor = [UIColor whiteColor];
////        self.window.windowScene=windowScene;
//         [self.window makeKeyAndVisible];
    }
              
    
    
    
}
- (HXBaseNavgationController *)tabBarController {
    if (@available(iOS 13.0, *)) {
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
    
        HXBaseNavgationController * rootNav = [[HXBaseNavgationController alloc ] initWithRootViewController:tabBarC];
        [rootNav setNavigationBarHidden:YES];
        [rootNav.navigationController.navigationBar setHidden:YES];
        return rootNav;
    }else{
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
        HXBaseNavgationController * rootNav = [[HXBaseNavgationController alloc ] initWithRootViewController:tabBarC];
        [rootNav setNavigationBarHidden:YES];
        [rootNav.navigationController.navigationBar setHidden:YES];
        return rootNav;
    }
    
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
