//
//  BaseWindow.m
//  GeneRov
//
//  Created by Daqi on 2018/5/9.
//  Copyright © 2018年 Daqi. All rights reserved.
//

#import "BaseWindow.h"
#import "BaseNavigationController.h"
#import "BaseColor.h"

#import "CNPPopupController.h"
#import "StartViewController.h"
#import "LaunchViewController.h"

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "menberViewController.h"
#import "OfflineViewController.h"
#import "MyViewController.h"
#import "jiluViewController.h"



@interface BaseWindow()<UITabBarControllerDelegate>
@property(nonatomic,strong)CNPPopupController *popupController;
@end
@implementation BaseWindow{
    NSInteger _lastSelectedIndex;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self startRootView];
//        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"time"]) {
////        if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]){
//            // 静态引导页
//            self.rootViewController = [[HXBaseNavgationController alloc] initWithRootViewController:[[StartViewController alloc] init]];
//        }else
//        {
//            LaunchViewController *login = [[LaunchViewController alloc]init];
//            self.rootViewController = login;
//
//            /* FullScreenAdType 全屏广告
//             * LogoAdType 带logo的广告类似网易广告，值得注意的是启动图片必须带logo图
//             * localAdImgName  本地图片名字
//             */
////            [self startRootView];
//
//        }
    }
    return self;
}

-(void)startRootView
{
//    self.rootViewController  = nil;
 
    self.rootViewController = self.tabBarController;
    self.tabBarController.selectedIndex = 0;
}


-(void)GotoLoginViewController{
    
    self.tabBarController.selectedIndex = 3;
}
-(void)startLogin
{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
    self.rootViewController = self.tabBarController;
}

-(void)setBarTitle
{
//    [_tabBarController setViewControllers:self.tabBarItemsAttributesForController];
    [self customizeTabBarAppearance:_tabBarController];
}
- (CYLTabBarController *)tabBarController
{
    if (_tabBarController == nil)
    {
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers tabBarItemsAttributes:self.tabBarItemsAttributesForController];
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
        _tabBarController.delegate = self;

    }
    return _tabBarController;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

        _lastSelectedIndex = tabBarController.selectedIndex;

}
// 子控制器
- (NSArray *)viewControllers
{
    
    HomeViewController * tabBarVC1 = [[HomeViewController alloc] init];
    BaseNavigationController *firstNavigationController = [[BaseNavigationController alloc]
                                                           initWithRootViewController:tabBarVC1];
//    [tabBarVC1 setTabBarItemWithTitle:@"首页" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"homeimageselect"] selectImage:[UIImage imageNamed:@"homeimage"] imageSize:CGSizeMake(30, 30)];

    jiluViewController * tabBarVC2 = [[jiluViewController alloc] init];
//    [tabBarVC2 setTabBarItemWithTitle:@"记录" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"jilu"] selectImage:[UIImage imageNamed:@"jiluselect"] imageSize:CGSizeMake(30, 30)];
    BaseNavigationController *secondNavigationController = [[BaseNavigationController alloc]
                                                           initWithRootViewController:tabBarVC2];
    menberViewController * tabBarVC3 = [[menberViewController alloc] init];
//    [tabBarVC3 setTabBarItemWithTitle:@"充值" titleUnSelectStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0], UITextAttributeTextColor,nil] titleSelectStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0], UITextAttributeTextColor,nil] unselectImage:[UIImage imageNamed:@"menber"] selectImage:[UIImage imageNamed:@"menber"] imageSize:CGSizeMake(45, 45)];
    BaseNavigationController *thirdNavigationController = [[BaseNavigationController alloc]
                                                           initWithRootViewController:tabBarVC3];
    OfflineViewController * tabBarVC4 = [[OfflineViewController alloc] init];
//    [tabBarVC4 setTabBarItemWithTitle:@"离线" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"lixianimage"] selectImage:[UIImage imageNamed:@"lixianimageselect"] imageSize:CGSizeMake(30, 30)];
    BaseNavigationController *fourNavigationController = [[BaseNavigationController alloc]
                                                           initWithRootViewController:tabBarVC4];
    MyViewController * tabBarVC5 = [[MyViewController alloc] init];
//    [tabBarVC5 setTabBarItemWithTitle:@"我的" titleUnSelectStyle:nil titleSelectStyle:nil unselectImage:[UIImage imageNamed:@"meimage"] selectImage:[UIImage imageNamed:@"meimageselect"] imageSize:CGSizeMake(30, 30)];
    BaseNavigationController *fivesNavigationController = [[BaseNavigationController alloc]
                                                           initWithRootViewController:tabBarVC5];

    NSArray *viewControllers = @[
                    firstNavigationController,secondNavigationController,thirdNavigationController,fourNavigationController,fivesNavigationController];
//    NSArray *viewControllers = @[[tabBarVC1 addNav],[tabBarVC2 addNav],[tabBarVC3 addNav],[tabBarVC4 addNav],[tabBarVC5 addNav]];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController
{
    NSDictionary *firstTabBarItemsAttributes = nil;
    NSDictionary *secondTabBarItemsAttributes = nil;
    NSDictionary *threeTabBarItemsAttributes = nil;
    NSDictionary *fourTabBarItemsAttributes = nil;
    NSDictionary *fivesTabBarItemsAttributes = nil;
    
        firstTabBarItemsAttributes  = @{
                                        CYLTabBarItemTitle : @"首页",
                                        CYLTabBarItemImage : @"homeimageselect",
                                        CYLTabBarItemSelectedImage : @"homeimage",
                                        };
        
        secondTabBarItemsAttributes = @{
                                        CYLTabBarItemTitle : @"记录",
                                        CYLTabBarItemImage : @"jilu",
                                        CYLTabBarItemSelectedImage : @"jiluselect",
                                        };
        threeTabBarItemsAttributes = @{
                                       CYLTabBarItemTitle :@"充值",
                                       CYLTabBarItemImage : @"menber",
                                       CYLTabBarItemSelectedImage : @"menber",
                                       };
        fourTabBarItemsAttributes = @{
                                      CYLTabBarItemTitle : @"离线",
                                      CYLTabBarItemImage : @"lixianimage",
                                      CYLTabBarItemSelectedImage : @"lixianimageselect",
                                      };
    
        
    fivesTabBarItemsAttributes = @{
                                  CYLTabBarItemTitle : @"我的",
                                  CYLTabBarItemImage : @"meimage",
                                  CYLTabBarItemSelectedImage : @"meimageselect",
                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       threeTabBarItemsAttributes,
                                       fourTabBarItemsAttributes,
                                       fivesTabBarItemsAttributes];
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    // Customize UITabBar height
    
    // 适配iOS 13 tabbar 标题字体不显示以及返回变蓝色的为问题
    if (@available(iOS 13.0, *)) {
                          
        //
        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor grayColor]];

    }
    // 自定义 TabBar 高度
    if (IS_IPAD)
    {
        tabBarController.tabBarHeight = 80.f;
    }
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    normalAttrs[NSFontAttributeName] = Font(15);

   
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = RGB(234, 83, 36);
    selectedAttrs[NSFontAttributeName] = Font(15);
    
    
    

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
//    [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:UTitleColor];
//    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
     [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    

}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate
{
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    UITabBarController *tabBarController = [self cyl_tabBarController] ?: [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor clearColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
