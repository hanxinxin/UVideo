//
//  ScrollPageViewController.h
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSlideBar.h"
#import "HXBaseViewController.h"
#import "YZYHorizListView.h"
#import "HomeTitleView.h"
#import "LLSearchViewController.h"
#import "HQCustomButton.h"
@protocol ScrollPageViewControllerProtocol <NSObject>
@optional
- (void)pageViewController:(id<ScrollPageViewControllerProtocol>)pageViewController didShowViewController:(UIViewController *)controller atIndex:(NSInteger)index;
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers;

- (NSArray *)arrayForEditTitles;
- (NSArray *)arrayForEditAllTitles;
/// 继承这个控制器，然后实现协议的这两个方法即可
- (UIViewController *)viewcontrollerWithIndex:(NSInteger)index;
- (NSArray *)arrayForControllerTitles;
@end

@interface ScrollPageViewController : HXBaseViewController <ScrollPageViewControllerProtocol, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSInteger currentIndex;
@property (strong, nonatomic) FDSlideBar *slideBar;
/// 显示更多按钮，默认NO
@property (nonatomic, assign) BOOL showMore;
/// 控制器view到slidebar的距离
@property (nonatomic, assign) NSInteger controllerGap;
/// 两个分页之间的距离
@property (nonatomic, assign) NSInteger controllerPageGap;
/// 数据源
@property (nonatomic, weak) id dataSource;
/// 在导航栏上显示，默认NO
@property (nonatomic, assign) BOOL showOnNavigationBar;
/// 自定义slideBar，默认NO
@property (nonatomic, assign) BOOL slideBarCustom;
/// 在setdata之后要刷新数据
- (void)reloadData;



////  自定义加入
///
@property (nonatomic, strong) HomeTitleView *titleView;
@property (nonatomic, strong)UIView * messageView;
@property (nonatomic, strong)UIImageView * messageImageView;
@property (nonatomic, strong)YZYHorizListView *horizListView;
@property (nonatomic, strong)NSArray *broadcastArray;
@property (nonatomic, assign) BOOL horizListViewHidden;//是否显示 消息跑马灯 默认不显示
///
///// 刷新界面布局
- (void)layoutViews;

@end
