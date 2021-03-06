//
//  MHYouKuMediaDetail.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  视频详情

#import <UIKit/UIKit.h>
#import "VideoVideoInfoMode.h"

@class MHYouKuMedia;

@interface MHYouKuMediaDetail : UIView
+ (instancetype)detail;

/** 详情 */
//@property (nonatomic , strong) MHYouKuMedia *media;

@property (nonatomic , strong)VideoVideoInfoMode * model;

/** 推掉 **/
@property (nonatomic,copy) void(^closeCallBack)(MHYouKuMediaDetail *detail);
@end
