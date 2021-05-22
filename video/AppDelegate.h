//
//  AppDelegate.h
//  video
//
//  Created by nian on 2021/3/9.
//

#import <UIKit/UIKit.h>
#import "MHAccount.h"
#import "BaseWindow.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

//@property (strong, nonatomic) BaseWindow *window;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * nav;
@property (strong, nonatomic) UITabBarController *tabBar;
/**
 *  用户数据 只读
 */
@property (nonatomic, readonly , strong) MHAccount *account;

/**
 *  获取delegate
 *
 */
+ (AppDelegate *)sharedDelegate;

@end

