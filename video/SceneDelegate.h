//
//  SceneDelegate.h
//  video
//
//  Created by nian on 2021/3/9.
//

#import <UIKit/UIKit.h>
#import "MHAccount.h"
#import "BaseWindow.h"
@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>
@property (strong, nonatomic) UINavigationController * nav;
@property (strong, nonatomic) UIWindow * window;
//@property (strong, nonatomic) BaseWindow *window;
@property (strong, nonatomic) UITabBarController *tabBar;
@end

