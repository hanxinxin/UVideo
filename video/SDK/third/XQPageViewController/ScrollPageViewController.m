//
//  ScrollPageViewController.m
//  XQPageControllerDemo
//
//  Created by Ticsmatic on 2017/7/20.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//

#import "ScrollPageViewController.h"
#import <objc/runtime.h>
#import <YYCategories.h>
#import "ColumnEditViewController.h"
#import "menuBJViewController.h"

static NSString *const kCellIdentifier = @"HorizCellIdentifier";

@interface UIViewController (pageIndex)
@end

@implementation UIViewController (pageIndex)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(scrollpage_viewDidAppear:) with:@selector(viewDidAppear:)];
    });
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, @selector(index), @(index), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)scrollpage_viewDidAppear:(BOOL)animated {
    [self scrollpage_viewDidAppear:animated];
    [self changePage];
}

- (id)pageDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPageDelegate:(id)pageDelegate {
    objc_setAssociatedObject(self, @selector(pageDelegate), pageDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)changePage {
    if ([self.pageDelegate respondsToSelector:@selector(pageViewController:didShowViewController:atIndex:)]) {
        [self.pageDelegate pageViewController:self.pageDelegate didShowViewController:self atIndex:self.index];
    }
}



@end

#define titles [self.dataSource arrayForControllerTitles]

@interface ScrollPageViewController ()<YZYHorizListViewDelegate>

@property (nonatomic, strong, readwrite) UIPageViewController *pageViewController;
@property (nonatomic, assign) BOOL inTransition;
@property (nonatomic, assign) BOOL inDragging;
@property (nonatomic, assign) NSInteger nextIndex;

@end

@implementation ScrollPageViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    if(kiOS7Later) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _showMore = NO;
    _showOnNavigationBar = NO;
    _slideBarCustom = NO;
    _horizListViewHidden=NO;

    self.dataSource = self;
    [self addObserver:self forKeyPath:@"currentIndex" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

#pragma mark - Public

- (void)reloadData {
    self.slideBar.currentSelected = self.currentIndex;
    self.slideBar.itemsTitle = titles;

    if ([titles count]) [self setToIndex:self.currentIndex];
}

/// 切换到某个index
- (void)setToIndex:(NSInteger)index {
    self.nextIndex = NSNotFound;
    if ([titles count]) {
        // 判断index，防止传入异常数据导致角标越界
        if (index >= [titles count]) index = [titles count] - 1;
        if (index < 0) index = 0;
        
        __weak typeof(self) weakSelf = self;
        UIViewController *list = [self controllerWithIndex:index];
        [self.pageViewController setViewControllers:@[list] direction:(index > self.currentIndex ?UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse) animated:YES completion:^(BOOL finished){
            weakSelf.currentIndex = index;
        }];
    }
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearch];
    [self initUI];
    [self reloadData];
    
}

- (void)initUI {
    self.view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    // exclusiveTouch
    self.slideBar.exclusiveTouch = YES;
    self.pageViewController.view.exclusiveTouch = YES;
    // slideBar
    if (!_slideBarCustom) {
        if (self.showOnNavigationBar && self.navigationController.navigationBar) {
            self.navigationItem.titleView = self.slideBar;
        } else {
            
            [self.view addSubview:self.slideBar];
        }
    }
    [self setupSlideBar];
    // pageViewController
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
    // layout Frame
    [self layoutViews];
   
}
- (void)setupSlideBar {
    
    FDSlideBar *slide = self.slideBar;
    slide.backgroundColor = [UIColor whiteColor];
    slide.itemColor = [UIColor blackColor];
    slide.itemSelectedColor = [UIColor blackColor];
    slide.sliderColor = RGB(20,155,236);
    slide.showMenuButton = _showMore;
    slide.menuButtonSelectedTitleColor = [UIColor colorWithWhite:.5 alpha:1];
    slide.menuButtonImage = [UIImage imageNamed:@"rightmenu.png"];
    slide.menuButtonSelectedImage = [UIImage imageNamed:@"closeSY.png"];
    slide.menuButtonTitleColor = [UIColor colorWithWhite:0.5 alpha:1];
    // callBack
    __weak typeof(self) weakSel = self;
    [slide slideBarItemSelectedCallback:^(NSUInteger idx) {
        if (idx != weakSel.currentIndex) {
            [weakSel setToIndex:idx];
        }
    }];
    
    [slide slideShowMenuCallBack:^(BOOL show) {
//        ColumnEditViewController *columnEdit = [[ColumnEditViewController alloc] initWithColumnArray:[[weakSel.dataSource arrayForEditTitles] mutableCopy] allCloumn:[weakSel.dataSource arrayForEditAllTitles]];
//        columnEdit.hidesBottomBarWhenPushed = true;
//        columnEdit.delegate = weakSel.dataSource;
//
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
//        item.title = @"完成";
//        weakSel.navigationController.navigationBar.topItem.backBarButtonItem = item;
//        [weakSel.navigationController pushViewController:columnEdit animated:YES];
        
//        menuBJViewController * avc = [[menuBJViewController alloc] init];
//        [weakSel.navigationController pushViewController:avc animated:YES];
    }];
}

- (void)layoutViews {
    [self layoutSlideBar];
    [self layoutPageViewController];
}

- (void)layoutSlideBar {
    if (_slideBarCustom) return;
    // 手势滑动导航栏滚动的时候 self.navigationController.navigationBar 为 nil
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        if (self.slideBar.origin.x != 0) {
            self.slideBar.width = self.view.frame.size.width - self.slideBar.origin.x;
        }
    }
}

- (void)layoutPageViewController {
    
    if(_horizListViewHidden==YES)
    {
        [self PMDLabel];
        if(_slideBar){
        _slideBar.frame= CGRectMake(0, _messageView.bottom, self.view.frame.size.width, kDefaultHeightOFSlideBar);
        }
    }
    CGFloat originY = (self.showOnNavigationBar) ? 0 : CGRectGetMaxY(_slideBar.frame);
    if (_slideBarCustom) originY = 0;
//
//    originY += (_horizListViewHidden==YES) ? 40 : 0;
    self.pageViewController.view.frame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}


-(void)addSearch
{
//    [self.navigationController.navigationBar addSubview:[self convertToView]];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.navigationController.navigationBar.bounds;
//    gradient.startPoint = CGPointMake(0.5, 0);
//    gradient.endPoint = CGPointMake(0.5, 1);
//    gradient.colors = @[(__bridge id)[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
//    gradient.locations = @[@(0),@(1.0f)];
//    [self.navigationController.navigationBar.layer addSublayer:gradient];
    //去除导航栏下方的横线
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                      forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    self.titleView = [[HomeTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - (80*2), 30)];
        self.titleView.backgroundColor=[UIColor whiteColor];
    
    self.titleView.layer.cornerRadius=15;

//    HQCustomButton * btn = [[HQCustomButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleView.frame), 30)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, btn.imageView.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.width-50, 0, 30)];
    [btn setTitle:@"请输入关键字" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1] forState:(UIControlStateNormal)];
    btn.layer.cornerRadius=15;
    [btn setTarget:self action:@selector(btnTouch:) forControlEvents:(UIControlEventTouchDown)];
    [_titleView addSubview:btn];
//    [_titleView.layer addSublayer:gl];
    self.navigationItem.titleView = _titleView;


//        [self addLeft_RightButton];
}

-(UIView*)convertToView{
    //  创建 UIView用来承载渐变色放置在导航栏上时需要上移20否则状态栏会露出

    UIView *myTopView = [[UIView alloc]initWithFrame:self.navigationController.navigationBar.bounds];
        
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = myTopView.bounds;
//    gradient.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor whiteColor].CGColor];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.colors = @[(__bridge id)[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gradient.locations = @[@(0),@(1.0f)];
//    gradient.startPoint = CGPointMake(0, 1);
//    gradient.endPoint = CGPointMake(1, 0);
    //    gradient.locations = @[@(0.5f), @(1.0f)];
    [myTopView.layer addSublayer:gradient];
    return myTopView;
}

-(void)addLeft_RightButton
{
    //下载按钮
//    UIButton *Back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 25)];
//    [Back setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
//    [Back setTitle:@"" forState:(UIControlStateNormal)];
//    [Back addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:Back];
//    self.navigationItem.leftBarButtonItem = leftButton;
//
//
//    //下载按钮
//    UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [historyBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
//    [historyBtn addTarget:self action:@selector(DownLoadBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    //两个按钮的父类view
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    //下载按钮
    UIButton *Back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    [Back setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [Back setTitle:@"" forState:(UIControlStateNormal)];
    [Back addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:Back];
    self.leftBtnV=leftButtonView;
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    //下载按钮
    BadgeButton *historyBtn = [[BadgeButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButtonView addSubview:historyBtn];
    historyBtn.badgeValue=1;
    historyBtn.isRedBall=YES;
    [historyBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(MessageBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtnV=rightButtonView;
    
    
}
-(void)DownLoadBtnEvent
{
    NSLog(@"11111");
}
-(void)MessageBtnEvent
{
    NSLog(@"22222");
}



-(void)historyBtnEvent
{
    NSLog(@"33333");
}
-(void)TitleTouch:(UITapGestureRecognizer *)gesture
{
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    [self.navigationController pushViewController:seachVC animated:NO];
}
-(void)btnTouch:(id)sender
{
    LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
    [self.navigationController pushViewController:seachVC animated:NO];
}


-(void)PMDLabel
{
    
    _broadcastArray = @[@"☂️12312313131",
                        @"大家上午好哈啊哈哈😝"
                        ];
    _messageView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40 , 40)];
    _messageView.backgroundColor=RGB(254, 184, 104);
    _messageView.layer.cornerRadius=8;
    _messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 40 , 40)];
    [_messageImageView setImage:[UIImage imageNamed:@"guanggao"]];
    _messageImageView.backgroundColor = [UIColor clearColor];
    _horizListView = [[YZYHorizListView alloc] initWithFrame: CGRectMake(50, 0, _messageView.width-50 , 40)];
    _horizListView.listViewDelegate = self;
    [_horizListView.collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier: kCellIdentifier];
    
    _horizListView.backgroundColor = [UIColor clearColor];
    
    _horizListView.autoScroll = YES;
    [_messageView addSubview:_messageImageView];
    [_messageView addSubview:_horizListView];
    [self.view addSubview: _messageView];
    [_horizListView.collectionView reloadData];
}

#pragma mark --- YZYHorizListViewDelegate
- (NSInteger)numberOfItemsInHorizListView:(YZYHorizListView *)listView {
    
    return _broadcastArray.count;
}

- (CGSize)horizListView:(YZYHorizListView *)listView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return _horizListView.frame.size;
    
}

- (UICollectionViewCell *)horizListView:(YZYHorizListView *)listView collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: kCellIdentifier forIndexPath: indexPath];
    
    NSInteger tag = 1008611;
    [[cell viewWithTag: tag] removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] initWithFrame: _horizListView.bounds];
    [cell addSubview: label];
    label.tag = tag;
    [label setText: _broadcastArray[indexPath.item]];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pageViewController viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pageViewController viewDidAppear:animated];
    // 在页面返回时开启定时器
    if(_horizListView != nil)
    {
        [_horizListView startScroll];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.pageViewController viewWillDisappear:animated];
    // 注意在页面消失的时候 手动调用停止计时器
    [_horizListView stopScroll];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.pageViewController viewDidDisappear:animated];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentIndex"];
}

#pragma mark - Setter
- (void)setShowOnNavigationBar:(BOOL)showOnNavigationBar {
    if (_showOnNavigationBar == showOnNavigationBar) return;
    _showOnNavigationBar = showOnNavigationBar;
    if (self.slideBar.superview) {
        [self.slideBar removeFromSuperview];
        [self layoutViews];
    }
}
- (void)setControllerGap:(NSInteger)controllerGap {
    _controllerGap = controllerGap;
    if (self.pageViewController.view.superview) {
        self.pageViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.slideBar.frame) + self.controllerGap, self.view.width, self.view.height - self.slideBar.frame.size.height - self.controllerGap);
    }
}

/// 在变化中不允许slidebar点击
- (void)setInTransition:(BOOL)inTransition {
    _inTransition = inTransition;
    self.slideBar.userInteractionEnabled = !inTransition;
}

- (NSInteger)nextIndex {
    if (_nextIndex == NSNotFound) {
        return self.currentIndex;
    }
    return _nextIndex;
}

#pragma mark - getter

- (FDSlideBar *)slideBar {
    if (_slideBar == nil) {
        _slideBar = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kDefaultHeightOFSlideBar)];
    }
    return _slideBar;
}

- (UIPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:(UIPageViewControllerTransitionStyleScroll) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:@{UIPageViewControllerOptionSpineLocationKey: @(0),UIPageViewControllerOptionInterPageSpacingKey: @(self.controllerPageGap)}];

        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;

        for (UIView *v in self.pageViewController.view.subviews) {
            if ([v isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *) v).delegate = (id)self;
            }
        }
    }
    return _pageViewController;
}

- (NSInteger)controllerPageGap {
    if (_controllerPageGap == NSNotFound) {
        return 2;
    }
    return _controllerPageGap;
}
#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.inTransition = YES;
    self.nextIndex = pendingViewControllers[0].index;
    if ([self.dataSource respondsToSelector:@selector(pageViewController:willTransitionToViewControllers:)] && ![self isEqual:self.dataSource]) {
        [self.dataSource pageViewController:pageViewController willTransitionToViewControllers:pendingViewControllers];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.inTransition = NO;
}

- (void)pageViewController:(id<ScrollPageViewControllerProtocol>)pageViewController didShowViewController:(UIViewController *)controller atIndex:(NSInteger)index {
    self.nextIndex = NSNotFound;
    self.currentIndex = index;
    if ([self.dataSource respondsToSelector:@selector(pageViewController:didShowViewController:atIndex:)] && ![self.dataSource isEqual:self]) {
        [self.dataSource pageViewController:pageViewController didShowViewController:controller atIndex:index];
    }
}
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(UIViewController *)vc {
    NSInteger index = self.nextIndex - 1;
    return [self controllerWithIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(UIViewController *)vc {
    NSInteger index = self.nextIndex + 1;
    return [self controllerWithIndex:index];
}

- (UIViewController *)controllerWithIndex:(NSInteger)index {
    if (index < [titles count] && index >= 0) {
        UIViewController *controller = [self.dataSource viewcontrollerWithIndex:index];
        controller.index = index;

        controller.pageDelegate = self;
        return controller;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.inDragging = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.inDragging = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.inDragging) {
        CGPoint offset = scrollView.contentOffset;
        CGFloat offsetX = ABS(offset.x - kScreenWidth);
        if (offsetX > kScreenWidth / 2) {
            self.currentIndex = self.nextIndex;
        }
        CGFloat progress = offsetX / kScreenWidth;
        if ([self.slideBar respondsToSelector:@selector(scrollToNextIndex:progress:)]) {
            [self.slideBar scrollToNextIndex:self.nextIndex progress:progress];
        }
    }
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        NSUInteger changenew = [change[@"new"] integerValue];
        NSUInteger changeold = [change[@"old"] integerValue];
        if (changeold != changenew) {
            [self.slideBar selectSlideBarItemAtIndex:changenew];
        }
    }
}

@end
