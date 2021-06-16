//
//  MHYouKuController.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  功能说明：本控制器 利用UITableView的段头+cell+段尾的方法 实现视频的评论和回复功能
//  文档说明：

#import "MHViewController.h"
#import "VideoRankMode.h"
#import "ZVideoMode.h"
#import "videofragmentMode.h"
#import "VideoRelatedlistMode.h"
#import "VideoVideoInfoMode.h"
#import "VideoVideosource.h"
//@interface MHYouKuController : hxpushViewController
@interface MHYouKuController : HXBaseViewController

@property(nonatomic,strong)VideoRankMode* Vmodel;
@property(nonatomic,strong)ZVideoMode*Zvideomodel;

@end
