//
//  BaseWindow.h
//  GeneRov
//
//  Created by Daqi on 2018/5/9.
//  Copyright © 2018年 Daqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLTabBarController.h"

@interface BaseWindow : UIWindow
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,strong) CYLTabBarController *tabBarController;
-(void)startLogin;
-(void)startRootView;
-(void)GotoLoginViewController;
-(void)setBarTitle;
@end
