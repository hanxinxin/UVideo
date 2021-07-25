//
//  MHYouKuController.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/14.



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
/////  播放时间记录
@property(nonatomic,assign)NSTimeInterval JiLutime;
@property(nonatomic,assign)NSTimeInterval OldJiLutime;
@end
