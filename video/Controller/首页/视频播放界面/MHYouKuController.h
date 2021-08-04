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
@property(nonatomic,assign)NSInteger QXDSelectIndex; //// 清晰度选择
@property(nonatomic,assign)NSInteger xuanjiSelectIndex; ///  集数选择
@property (nonatomic, assign) double video_fragment_id;  ///浏览记录 视频片段ID 为空直接播放默认  不为空 播放这个片段
@property (nonatomic, copy) NSString *video_fragment_symbol;  //浏览的集数
/** 视频id */
@property (nonatomic , copy) NSString *mediabase_id;
@end
