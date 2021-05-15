//
//  LaunchViewController.m
//  iSmartCam
//
//  Created by yst on 2017/8/21.
//  Copyright © 2017年 crazyit.org. All rights reserved.
//

#import "LaunchViewController.h"
#import "AppDelegate.h"
#import "HttpManagement.h"
#import "UIImageView+WebCache.h"

#import "NSObject+LBLaunchImage.h"


@interface LaunchViewController ()<UIApplicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation LaunchViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        AppDelegate *delegage = [UIApplication sharedApplication].delegate;
        LaunchModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:klaunch_path];
        //
        if (kStringIsEmpty(model.uDownLoadUrl)) { // 不存在
            
            __weak typeof(self) weakSelf = self;            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));

            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf startRootView];
            });
//            [self request];
            return ;
        }
//        __weak typeof(self) weakSelf = self;
        [NSObject makeLBLaunchImageAdView:^(LBLaunchImageAdView *imgAdView) {
            //设置广告的类型
            imgAdView.getLBlaunchImageAdViewType(FullScreenAdType);
            //设置本地启动图片
            //        imgAdView.localAdImgName = @"qidong.gif";
//            imgAdView.imgUrl = @"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif";
            imgAdView.imgUrl = model.uDownLoadUrl;
            //自定义跳过按钮
            imgAdView.skipBtn.backgroundColor = [UIColor blackColor];
            //各种点击事件的回调
            
            imgAdView.clickBlock = ^(clickType type){
                switch (type) {
                    case clickAdType:{
                        NSLog(@"点击广告回调");
//                        [self startRootView];
                    }
                        break;
                    case skipAdType:
                        NSLog(@"点击跳过回调");
                        [self startRootView];
//                        [self request];
                        break;
                    case overtimeAdType:
                        NSLog(@"倒计时完成后的回调");
                        [self startRootView];
//                        [self request];
                        break;
                    default:
                        break;
                }
            };
            
        }];

    });
}
-(void)startRootView
{
//            AppDelegate *delegage = [UIApplication sharedApplication].delegate;
//    
//            [delegage.window startRootView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    LaunchModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:klaunch_path];
  
//    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:model.uDownLoadUrl] placeholderImage:[UIImage imageNamed:@"1334.750-1"] options:SDWebImageLowPriority];

}
-(void)request
{
    [[HttpManagement shareManager] getStartScreenRequest:^(LaunchModel *model, NSError *error) {
        if (!error) {
            if (model.uCode == 1) {
//                [_bgImageView sd_setImageWithURL:[NSURL URLWithString:model.uDownLoadUrl] placeholderImage:[UIImage imageNamed:@"1334.750-1"]];
            }
        }
    }];
}
-(void)startLogin
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
