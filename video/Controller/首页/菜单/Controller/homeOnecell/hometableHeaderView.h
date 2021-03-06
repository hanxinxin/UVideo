//
//  hometableHeaderView.h
//  video
//
//  Created by macbook on 2021/7/23.
//

#import <UIKit/UIKit.h>
#import "MSCycleScrollView.h"
#import "MHViewController.h"
#import "MHYouKuController.h"
#import "YYWebImage.h"
#import "bannerMode.h"
#import "YYAnimatedImageView.h"
#import "TestWebViewController.h"
#import "GuanggaoMode.h"
NS_ASSUME_NONNULL_BEGIN


typedef void(^hometableHeaderViewBannerBlock)(MSCycleScrollView * cycleScrollView,bannerMode *banner,NSInteger index);

@interface hometableHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong)MSCycleScrollView *cycleScrollView;


@property (nonatomic, strong) YYAnimatedImageView* guanggaoImageView;
@property (nonatomic, strong)GuanggaoMode*GuanggaoModeA;

@property (nonatomic, strong) NSMutableArray *bannerimagesmode;///轮播图mode数组
@property (nonatomic, strong) NSMutableArray *bannerimagesURL;//轮播图url


@property (nonatomic,copy) hometableHeaderViewBannerBlock BannerTouch;
@end

NS_ASSUME_NONNULL_END
