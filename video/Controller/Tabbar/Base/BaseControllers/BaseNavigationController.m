//
//  BaseNavigationController.m
//  iSmartHome
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 crazyit.org. All rights reserved.
//

#import "BaseNavigationController.h"
#import "AppDelegate.h"
@interface BaseNavigationController ()
@end

@implementation BaseNavigationController
-(void)viewDidLoad
{
    //设置导航栏的颜色
//    self.navigationBar.shadowImage = [[UIImage alloc] init];
//    [self.navigationBar setTranslucent:NO];
//    self.navigationBar.barTintColor = [UIColor whiteColor];
    
     /**设置文字属性**/
//    self.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor], UITextAttributeFont:[UIFont boldSystemFontOfSize:18]};
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
/**
 *  重写Pop方法(显示底部的tabbar)
 */

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{

//    NSLog(@"self.viewControllers.count ===  %lu",(unsigned long)self.viewControllers.count);
    //判断即将到栈底
    if (self.viewControllers.count == 0) {

        
        
    }
    //  pop出栈
     return [super popViewControllerAnimated:animated];
}

- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}
@end
