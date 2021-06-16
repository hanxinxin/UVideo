//
//  MHYouKuController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuController.h"
#import "MHTopicFrame.h"
#import "MHTopicHeaderView.h"
#import "MHTopicFooterView.h"
#import "MHCommentCell.h"
#import "MHUserInfoController.h"
#import "MHYouKuBottomToolBar.h"
#import "MHYouKuTopicController.h"
#import "MHYouKuMedia.h"
#import "MHYouKuMediaSummary.h"
#import "MHYouKuMediaDetail.h"
#import "MHYouKuCommentItem.h"
#import "MHTopicManager.h"
#import "MHUserInfoController.h"
#import "MHYouKuAnthologyItem.h"
#import "MHYouKuAnthologyHeaderView.h"
#import "MHYouKuCommentHeaderView.h"
#import "MHYouKuCommentController.h"
#import "MHYouKuInputPanelView.h"
#import "MHYouKuTopicDetailController.h"

#import "ClarityView.h"
#import "menberViewTS.h"

@interface MHYouKuController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate , MHCommentCellDelegate ,MHTopicHeaderViewDelegate,MHYouKuBottomToolBarDelegate,MHYouKuTopicControllerDelegate,MHYouKuAnthologyHeaderViewDelegate,MHYouKuCommentHeaderViewDelegate , MHYouKuInputPanelViewDelegate,KJPlayerDelegate,KJPlayerBaseViewDelegate,KJPlayerBaseViewDelegate,YTSliderViewDelegate>

///// 播放器 Player


@property(nonatomic,strong)KJBasePlayerView *playerView;
@property(nonatomic,strong)KJAVPlayer *player;
@property(nonatomic,strong)NSArray *temps;



//@property(nonatomic,strong)KJIJKPlayer *player;
//@property(nonatomic,strong)KJBasePlayerView *basePlayerView;
//@property(nonatomic,strong)NSArray *temps;

@property (nonatomic ,strong) UIButton *btn;//缓存按钮

/** 顶部容器View   **/
@property (nonatomic , strong) UIView *topContainer;

/** 底部容器View  **/
@property (nonatomic , strong) UIView *bottomContainer;

/** 话题控制器的容器View */
@property (nonatomic , strong) UIView *topicContainer;

/** Footer */
@property (nonatomic , strong) UIButton *commentFooter;

/** 返回按钮 **/
@property (nonatomic , strong) MHBackButton *backBtn;

/** 广告View */
@property (nonatomic , weak)UIImageView * GGimageview;

/** tableView */
@property (nonatomic , weak) UITableView *tableView;

/** 视频toolBar **/
@property (nonatomic , weak) MHYouKuBottomToolBar *bottomToolBar;


/** 话题控制器 **/
@property (nonatomic , weak) MHYouKuTopicController *topic;

/** dataSource */
@property (nonatomic , strong) NSMutableArray *dataSource;

/**  */
@property (nonatomic , strong) MHYouKuMedia *media;


/** 视频id */
@property (nonatomic , copy) NSString *mediabase_id;

/** 简介 */
@property (nonatomic , weak) MHYouKuMediaSummary *summary ;
/** 详情 **/
@property (nonatomic , weak) MHYouKuMediaDetail *detail;

/** 选中的话题尺寸模型 */
@property (nonatomic , strong) MHTopicFrame *selectedTopicFrame;

/** 评论Item */
@property (nonatomic , strong) MHYouKuCommentItem *commentItem;
/** 选集Item */
@property (nonatomic , strong) MHYouKuAnthologyItem *anthologyItem;

/** 选集 */
@property (nonatomic , weak) MHYouKuAnthologyHeaderView *anthologyHeaderView;


/** 清晰度 */
@property (nonatomic , weak) ClarityView *Clarity ;



/** inputPanelView */
@property (nonatomic , weak) MHYouKuInputPanelView *inputPanelView;


@property(nonatomic,strong)menberViewTS*menberView;


//////////    video数据     /////////////////

@property(nonatomic,strong)NSArray*qualitieslist;
@property(nonatomic,strong)NSArray*subtitleslist;

@property(nonatomic,strong)NSArray*video_fragment_list;

@property(nonatomic,assign)NSInteger QXDSelectIndex; //// 清晰度选择
@property(nonatomic,assign)NSInteger xuanjiSelectIndex; ///  集数选择
@end

@implementation MHYouKuController

- (void)dealloc
{
    MHDealloc;
    // 移除通知
    [MHNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        NSLog(@"clicked navigationbar back button");
        self.playerView.isFullScreen=NO;
        //在页面消失的回调方法中移除通知。
           [[NSNotificationCenter defaultCenter]removeObserver:self name:@"fullItemClick"object:nil];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_player) {
        [self.player kj_stop];
        _player = nil;
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self SetData];
    // 初始化
    [self _setup];

    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
    
     // 监听通知中心
    [self _addNotificationCenter];
    
    // 初始化假数据
    [self _setupData];
    
    ///设置 playerView
    [self setPlayerView];
    
    ///加载提示框
    [self addmenberViewM];
    
   
}

-(void)SetData
{
    
    self.qualitieslist=[[NSArray alloc] init];
    self.subtitleslist=[[NSArray alloc] init];
    self.QXDSelectIndex=0;
    self.xuanjiSelectIndex=0;
    if(_Zvideomodel!=nil)
    {
    VideoVideoInfoMode*modelL=[VideoVideoInfoMode yy_modelWithDictionary:_Zvideomodel.video ];
    videofragmentMode*Fmo=[videofragmentMode yy_modelWithDictionary:_Zvideomodel.video_fragment_list[0] ];
    
        self.video_fragment_list=_Zvideomodel.video_fragment_list;
    
    [self getplayerMode:[NSString stringWithFormat:@"%f",modelL.id] video_fragment_id:[NSString stringWithFormat:@"%f",Fmo.id] quality:Fmo.qualities[self.QXDSelectIndex]];
    }
}
-(void)getplayerMode:(NSString*)video_id video_fragment_id:(NSString*)video_fragment_id quality:(NSString*)quality
{
    NSDictionary* dict = @{
        @"video_id":[NSString stringWithFormat:@"%@",video_id],
        @"video_fragment_id":[NSString stringWithFormat:@"%@",video_fragment_id],
        @"quality":[NSString stringWithFormat:@"%@",quality],};
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,video_sourceurl] Dictionary:dict success:^(id  _Nullable responseObject) {
        //        NSLog(@"post responseObject == %@",responseObject);
//        [UHud hideLoadHudForView:self.view];
        [UHud hideLoadHud];
                NSDictionary *dict=(NSDictionary *)responseObject;
                NSNumber * code = [dict objectForKey:@"error"];
                if([code intValue]==0)
                {
                    NSDictionary  * dataArr = [dict objectForKey:@"data"];
                    NSDictionary * video_soruce = [dataArr objectForKey:@"video_soruce"];
                    VideoVideosource*model=[VideoVideosource yy_modelWithDictionary:video_soruce];
//                    //直接放到网络请求结果调用，生成模型后删除就行，结果打印在控制台
//                    [DYModelMaker DY_makeModelWithDictionary:video_soruce modelKeyword:@"Video" modelName:@"videosource"];
                    self.player.videoURL = [NSURL URLWithString:model.url];
                    NSArray * qualities = [dataArr objectForKey:@"qualities"];
                    NSArray * subtitles = [dataArr objectForKey:@"subtitles"];
                    self.qualitieslist=qualities;
                    self.subtitleslist=subtitles;
                    self.Clarity.titleNumberarray=self.qualitieslist;
                    
                    [self.Clarity.collectionView1 reloadData];
                }else{
                    NSString * message = [dict objectForKey:@"message"];
                    [UHud showTXTWithStatus:message delay:2.f];
                }
        
            } failure:^(NSError * _Nullable error) {
                [UHud hideLoadHud];
                NSLog(@"shareManager error == %@",error);
                [UHud showTXTWithStatus:@"网络错误" delay:2.f];
            
            }];
}


-(void)setPlayerView
{
    
    KJBasePlayerView *backview = [[KJBasePlayerView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*(9.f/16.f))];
//    KJBasePlayerView *backview = [[KJBasePlayerView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, SCREENH_HEIGHT)];
    [self.view addSubview:backview];
//    [self.topContainer addSubview:backview];
    self.playerView = backview;
    backview.delegate = self;
    backview.isHiddenBackButton=YES;
    backview.gestureType = KJPlayerGestureTypeAll;
    backview.smallScreenHiddenBackButton = YES;
    backview.backButton.hidden=YES;
    backview.autoHideTime = 3;
    if(_Zvideomodel!=nil)
    {
        VideoVideoInfoMode*modelL=[VideoVideoInfoMode yy_modelWithDictionary:_Zvideomodel.video ];
        [backview.backButton setTitle:modelL.title forState:(UIControlStateNormal)];
    }
    PLAYER_WEAKSELF;
    backview.kVideoClickButtonBack = ^(KJBasePlayerView *view){
//        if (view.isFullScreen) {
           
        view.isFullScreen = NO;
        weakself.hiddenNavBar=NO;
        weakself.playerView.isHiddenBackButton=YES;
        weakself.playerView.smallScreenHiddenBackButton = YES;
        weakself.playerView.backButton.hidden=YES;
//        }else{
//            [weakself.player kj_stop];
//            [weakself.navigationController setNavigationBarHidden:NO animated:YES];
//            [weakself.navigationController popViewControllerAnimated:YES];
//        }
    };
    backview.kVideoChangeScreenState = ^(KJPlayerVideoScreenState state) {
      
        NSLog(@"pingmu == %ld",state);
    };
    
    backview.bottomView.kVideoOperationViewBtnTouch = ^(NSInteger selectIndex) {
//        NSLog(@"selectIndex====   %ld",(long)selectIndex);
        // 1是 弹幕  2是 静音
      if(selectIndex==1)
      {
//          if(self.player.playerView.danmubottomView.hidden==YES)
//          {
//              self.player.playerView.danmubottomView.hidden=NO;
//              self.player.playerView.bottomView.hidden=YES;
//          }else{
//              self.player.playerView.danmubottomView.hidden=YES;
//              self.player.playerView.bottomView.hidden=NO;
//          }
      }else if(selectIndex==2)
      {
          if(self.player.muted==YES)
          {
              self.player.muted=NO;
              self.player.playerView.bottomView.ShengyiButton.selected=NO;
          }else{
              self.player.muted=YES;
              self.player.playerView.bottomView.ShengyiButton.selected=YES;
          }
          
      }
    };
//
    KJAVPlayer *player = [[KJAVPlayer alloc]init];
    self.player = player;
    player.delegate = self;
    player.placeholder = [UIImage imageNamed:@"comment_loading_bgView"];
    player.playerView = backview;
//    player.videoURL = [NSURL URLWithString:@"https://mp4.vjshi.com/2018-03-30/1f36dd9819eeef0bc508414494d34ad9.mp4"];

    
//    self.temps = @[@"https://mp4.vjshi.com/2021-01-13/d37b7bea25b063b4f9d4bdd98bc611e3.mp4",
//                   @"https://mp4.vjshi.com/2018-03-30/1f36dd9819eeef0bc508414494d34ad9.mp4",
//                   @"https://mp4.vjshi.com/2021-01-13/ac721f0590f0b0509092afea52d55a90.mp4",@"http://ivi.bupt.edu.cn/hls/hunanhd.m3u8"];
    
    
//    self.player.videoURL = [NSURL URLWithString:self.temps[3]];
//    player.videoURL = [NSURL URLWithString:self.temps[0]];
    
    
    //注册、接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatefullItemClick:)name:@"fullItemClick"object:nil];
   
    
    
}

//接收通知后调用的方法

- (void)updatefullItemClick:(NSNotification *)noti{
    NSNumber * num= [noti.userInfo objectForKey:@"full"];
    if([num boolValue])
    {
        self.hiddenNavBar=YES;
        self.playerView.isHiddenBackButton=NO;
        self.playerView.smallScreenHiddenBackButton = NO;
        self.playerView.backButton.hidden=NO;
    }else{
        self.hiddenNavBar=NO;
        self.playerView.isHiddenBackButton=YES;
        self.playerView.smallScreenHiddenBackButton = YES;
        self.playerView.backButton.hidden=YES;
    }
    
}
- (void)tempsAction:(NSInteger)index{
//    if(index>=1)
//    {
//        [self showmenberViewTS];
//    }else
//    {
//    self.player.videoURL = [NSURL URLWithString:self.temps[index]];
        
        if(_Zvideomodel!=nil)
        {
        VideoVideoInfoMode*modelL=[VideoVideoInfoMode yy_modelWithDictionary:_Zvideomodel.video ];
        videofragmentMode*Fmo=[videofragmentMode yy_modelWithDictionary:_Zvideomodel.video_fragment_list[self.xuanjiSelectIndex] ];
        
        [self getplayerMode:[NSString stringWithFormat:@"%f",modelL.id] video_fragment_id:[NSString stringWithFormat:@"%f",Fmo.id] quality:Fmo.qualities[index]];
        }
//    }
}

#pragma mark - KJPlayerDelegate
/* 当前播放器状态 */
- (void)kj_player:(KJBasePlayer*)player state:(KJPlayerState)state{
    NSLog(@"播放状态 == %ld  ",(long)state);
    if (state == KJPlayerStateBuffering || state == KJPlayerStatePausing) {
        [player kj_startAnimation];
    }else if (state == KJPlayerStatePreparePlay || state == KJPlayerStatePlaying) {
        [player kj_stopAnimation];
        //设置 滑竿 最大值
//        player.playerView.bottomHYSlider=self.player.totalTime;
    }else if (state == KJPlayerStatePlayFinished) {
        [player kj_replay];
    }
}
/* 播放进度 */
- (void)kj_player:(KJBasePlayer*)player currentTime:(NSTimeInterval)time{
    NSLog(@"播放进度 == %f   self.player.totalTime= %d",fmod(time,60.0),(int)fmod(self.player.totalTime,60.0));
    NSString * qstring = [NSString stringWithFormat:@"%d:%d",(int)time/60,(int)fmodl(time,60.0)];
    NSString * hstring = [NSString stringWithFormat:@"%d:%d",(int)self.player.totalTime/60,(int)fmod(self.player.totalTime,60.0)];
    player.playerView.TimeTotal.text=[NSString stringWithFormat:@"%@/%@",qstring,hstring];
//    player.playerView.bottomHYSlider.currentSliderValue=time;
    player.playerView.bottomHYSlider.currentPercent=(time/self.player.totalTime);
    
}
/* 缓存进度 */
- (void)kj_player:(KJBasePlayer*)player loadProgress:(CGFloat)progress{
    
}
/* 播放错误 */
- (void)kj_player:(KJBasePlayer*)player playFailed:(NSError*)failed{
    
}

#pragma mark - KJPlayerBaseViewDelegate
/* 单双击手势反馈 */
- (void)kj_basePlayerView:(KJBasePlayerView*)view isSingleTap:(BOOL)tap{
    if (tap) {
        if (view.displayOperation) {
            [view kj_hiddenOperationView];
        }else{
            [view kj_displayOperationView];
        }
    }else{
        if ([self.player isPlaying]) {
            [self.player kj_pause];
//            [self.player kj_startAnimation];
            
        }else{
            [self.player kj_resume];
//            [self.player kj_stopAnimation];
        }
    }
}
/* 长按手势反馈 */
- (void)kj_basePlayerView:(KJBasePlayerView*)view longPress:(UILongPressGestureRecognizer*)longPress{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            self.player.speed = 2.;
            [self.player kj_displayHintText:@"长按快进播放中..." time:0 position:KJPlayerHintPositionTop];
        }
            break;
        case UIGestureRecognizerStateChanged: {
        }
            break;
        case UIGestureRecognizerStateEnded: {
            self.player.speed = 1.0;
            [self.player kj_hideHintText];
        }
        default:
            break;
    }
}
/* 进度手势反馈，是否替换自带UI，范围-1 ～ 1 */
- (NSArray*)kj_basePlayerView:(KJBasePlayerView*)view progress:(float)progress end:(BOOL)end{
    if (end) {
        NSTimeInterval time = self.player.currentTime + progress * self.player.totalTime;
        NSLog(@"---time:%.2f",time);
        self.player.kVideoAdvanceAndReverse(time, nil);
    }
    return @[@(self.player.currentTime),@(self.player.totalTime)];
}
/* 音量手势反馈，是否替换自带UI，范围0 ～ 1 */
- (BOOL)kj_basePlayerView:(KJBasePlayerView*)view volumeValue:(float)value{
    NSLog(@"---voiceValue:%.2f",value);
    return NO;
}
/* 亮度手势反馈，是否替换自带UI，范围0 ～ 1 */
- (BOOL)kj_basePlayerView:(KJBasePlayerView*)view brightnessValue:(float)value{
    NSLog(@"---lightValue:%.2f",value);
    return NO;
}

-(void)addmenberViewM{
    menberViewTS *view = [[[NSBundle mainBundle]loadNibNamed:@"menberViewTS" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.8];
    view.hidden=YES;
    view.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 0);
//    view.bottomview.layer.cornerRadius=10;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
    [view.bottomview setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor] type:corners];
    view.okBtn.layer.cornerRadius=6;
    view.cancelBtn.layer.cornerRadius=6;
    [self.view addSubview:view];
    self.menberView=view;
    __weak MHYouKuController * weakSelf = self;
    self.menberView.touchIndex = ^(NSInteger Index) {
        
        NSLog(@"menberView idnex ==== %ld",Index);
        if(Index==0)
        {
            
        }else{
            
        }
        [weakSelf HidmenberViewTS];
    };
}

-(void)showmenberViewTS
{
    
    [UIView animateWithDuration:0.7 animations:^{
        self.menberView.bottomview.hidden=NO;
        self.menberView.hidden=NO;
        self.menberView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavBarAndStatusBarHeight);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)HidmenberViewTS
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.menberView.bottomview.hidden=YES;
        self.menberView.frame=CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH,0 );
    } completion:^(BOOL finished) {
        self.menberView.hidden=YES;
    }];
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - Getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (UIView *)topContainer
{
    if (_topContainer == nil) {
        _topContainer = [[UIView alloc] init];
        _topContainer.backgroundColor = [UIColor whiteColor];
    }
    return _topContainer;
}

- (UIView *)bottomContainer
{
    if (_bottomContainer == nil) {
        _bottomContainer = [[UIView alloc] init];
        _bottomContainer.backgroundColor = [UIColor whiteColor];
    }
    return _bottomContainer;
}

// 返回按钮
- (MHBackButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[MHBackButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"player_back"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(_backBtnDidiClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeCenter;
    }
    return _backBtn;
}


- (UIView *)topicContainer
{
    if (_topicContainer == nil) {
        _topicContainer = [[UIView alloc] init];
        _topicContainer.backgroundColor = [UIColor whiteColor];
    }
    return _topicContainer;
}

- (MHYouKuMedia *)media
{
    if (_media == nil) {
        _media = [[MHYouKuMedia alloc] init];
        _media.thumb = [NSObject mh_randomNumber:0 to:1];
        _media.thumbNums = [NSObject mh_randomNumber:10 to:1000];
        _media.mediaUrl = @"xxxx";
        _media.commentNums = [NSObject mh_randomNumber:0 to:1000];
        _media.collect = [NSObject mh_randomNumber:0 to:1];
        _media.mediaScanTotal = [NSObject mh_randomNumber:0 to:100000];
        _media.creatTime = [NSDate mh_currentTimestamp];
    }
    return _media;
}

- (MHYouKuCommentItem *)commentItem
{
    if (_commentItem == nil) {
        _commentItem = [[MHYouKuCommentItem alloc] init];
        _commentItem.title = @"评论";
        _commentItem.commentCount = 0;
    }
    return _commentItem;
}

- (MHYouKuAnthologyItem *)anthologyItem
{
    if (_anthologyItem == nil) {
        _anthologyItem = [[MHYouKuAnthologyItem alloc] init];
        _anthologyItem.title = @"选集";
        _anthologyItem.mediabase_id = self.mediabase_id;
        _anthologyItem.displayType = MHYouKuAnthologyDisplayTypeTextPlain;
        // 98757
//        VideoVideoInfoMode*modelL=[VideoVideoInfoMode yy_modelWithDictionary:_Zvideomodel.video ];
//        _mediabase_id = [NSString stringWithFormat:@"%.f",modelL.id];
        
        for (NSInteger i = 0; i<self.video_fragment_list.count; i++) {
            videofragmentMode*Fmo=[videofragmentMode yy_modelWithDictionary:_Zvideomodel.video_fragment_list[i] ];
            MHYouKuAnthology *anthology = [[MHYouKuAnthology alloc] init];
            anthology.albums_sort = i+1;
            anthology.mediabase_id = [NSString stringWithFormat:@"%.f",Fmo.id];
            if([anthology.mediabase_id isEqualToString:_anthologyItem.mediabase_id])
            {
                _anthologyItem.item = i;
            }
            [_anthologyItem.anthologys addObject:anthology];
        }
    }
    return _anthologyItem;
}


/** 评论底部 */
- (UIButton *)commentFooter
{
    if (_commentFooter == nil) {
        _commentFooter = [[UIButton alloc] init];
        _commentFooter.backgroundColor = [UIColor whiteColor];
        [_commentFooter addTarget:self action:@selector(_commentFooterDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_commentFooter setTitle:@"查看全部0条回复 >" forState:UIControlStateNormal];
        _commentFooter.titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
        [_commentFooter setTitleColor:MHGlobalOrangeTextColor forState:UIControlStateNormal];
        [_commentFooter setTitleColor:MHGlobalShadowBlackTextColor forState:UIControlStateHighlighted];
        _commentFooter.mh_height = 44.0f;
    }
    return _commentFooter;
}


#pragma mark - 初始化
- (void)_setup
{
    // 当前控制器 禁止侧滑 返回
    self.fd_interactivePopDisabled = YES;
    // hiden掉系统的导航栏
    self.fd_prefersNavigationBarHidden = YES;
    // 设置视频id 编号89757
    VideoVideoInfoMode*modelL=[VideoVideoInfoMode yy_modelWithDictionary:_Zvideomodel.video ];
    _mediabase_id = [NSString stringWithFormat:@"%.f",modelL.id];;
   
}
- (UIButton *)btn{
    if (!_btn) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, 50, 44);
        [_btn setTitle:@"缓存" forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"huancun"] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitleColor:RGB(68,68,68) forState:(UIControlStateNormal)];
        [_btn addTarget:self action:@selector(huancunBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
-(void)huancunBtn:(UIButton*)sender
{
    
}
#pragma mark -  初始化数据

- (void)_setupData
{
    [self.dataSource insertObject:self.anthologyItem atIndex:0];
    
    [self.tableView reloadData];
}



#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    if(_Zvideomodel!=nil)
    {
    VideoVideoInfoMode*modelL=[VideoVideoInfoMode yy_modelWithDictionary:_Zvideomodel.video ];
        self.title = modelL.title;
    }
    
    
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
    
    self.navigationItem.rightBarButtonItem = rightitem;
    self.navigationController.navigationBar.tintColor = RGB(68,68,68);
//    self.hiddenNavBar=YES;
//    [self updateNavigationBarAppearance];
}

#pragma mark - 设置子控件
- (void)_setupSubViews
{
    // 创建黑色状态条
    [self _setupStatusBarView];
    
    // 创建顶部View
    [self _setupTopContainerView];
    
    // 创建底部View
    [self _setupBottomContainerView];
    
    // 刷新数据
    [self _refreshDataWithMedia:self.media];
}

// 创建statusBarView
- (void)_setupStatusBarView
{
//    UIView *statusBarView =  [[UIView alloc] init];
//    statusBarView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:statusBarView];
//    [statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.and.top.equalTo(self.view);
//        make.height.mas_equalTo(20.0f);
//    }];
//
//    // 创建视图view
//    [self _setupVideoBackgroundView];
//
//    // 创建返回按钮
//    [self _setupBackButton];
}

// 初始化播放器View
- (void)_setupTopContainerView
{
    
    
    [self.view addSubview:self.topContainer];
    [self.topContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(self.view.frame.size.width).multipliedBy(9.0f/16.0f);
        make.height.mas_equalTo(self.view.width*(9.f/16.f));
    }];
    
    
}



// 创建视频封面
- (void)_setupVideoBackgroundView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = MHImageNamed(@"comment_loading_bgView");
    [self.topContainer addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

// 创建返回按钮
- (void)_setupBackButton
{
    [self.topContainer addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContainer.mas_left).offset(20);
        make.top.equalTo(self.topContainer).with.offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
}


// 底部View
- (void)_setupBottomContainerView
{
    // 添加底部容器
    [self.view addSubview:self.bottomContainer];
    
    // 布局
    [self.bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainer.mas_bottom);
//        make.left.bottom.and.right.equalTo(self.view);
        make.left.mas_offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.view);
    }];
    
    // 创建底部工具条
    [self _setupBottomToolBar];
    
    // 创建tableView
    [self _setupTableView];
    
    // 创建容器
    [self _setupTopicContainer];
    
    // 创建详情
    [self _setupVideoDetail];
    
}

// 创建底部工具条
- (void)_setupBottomToolBar
{
    UIImageView * iamgeview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [iamgeview setImage:[UIImage imageNamed:@"Videoguanggao"]];
    self.GGimageview=iamgeview;
    [self.bottomContainer addSubview:iamgeview];
    // 布局工具条
    [iamgeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.bottomContainer);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(66.0f);
    }];
    // 底部工具条
    MHYouKuBottomToolBar *bottomToolBar = [[MHYouKuBottomToolBar alloc] init];
    bottomToolBar.backgroundColor = [UIColor whiteColor];
    bottomToolBar.delegate = self;
    self.bottomToolBar = bottomToolBar;
    [self.bottomContainer addSubview:bottomToolBar];
    
    // 布局工具条
    [bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.bottomContainer);
        make.top.equalTo(self.GGimageview.mas_bottom).offset(5);
        make.height.mas_equalTo(36.0f);
    }];
    
    
}


// 初始化话题容器
- (void)_setupTopicContainer
{
    // 容器
    [self.bottomContainer addSubview:self.topicContainer];
    
    // 话题控制器
    MHYouKuTopicController *topic = [[MHYouKuTopicController alloc] init];
    topic.mediabase_id = self.mediabase_id;
    topic.delegate = self;
    [self.topicContainer addSubview:topic.view];
    [self addChildViewController:topic];
    [topic didMoveToParentViewController:self];
    self.topic = topic;
    
    //
    [self.topicContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.bottomContainer);
        make.top.equalTo(self.bottomContainer.mas_bottom);
        make.height.mas_equalTo(self.bottomContainer.mas_height);
    }];
    
    // 布局
    [topic.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


// 创建tableView
- (void)_setupTableView
{
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView
    tableView.backgroundColor = [UIColor whiteColor];
    [self.bottomContainer addSubview:tableView];
    self.tableView = tableView;
    // 布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomToolBar.mas_bottom);
        make.left.bottom.and.right.equalTo(self.bottomContainer);
    }];
    
//    // 视频简介 tableViewHeader
//    MHYouKuMediaSummary *summary = [MHYouKuMediaSummary summary];
//    summary.backgroundColor = [UIColor whiteColor];
//    self.summary = summary;
//    summary.mh_height = 70.0f;
//    tableView.tableHeaderView = summary;
//
//    // 详情点击事件
//    __weak typeof(self) weakSelf = self;
//    [summary setDetailCallBack:^(MHYouKuMediaSummary *s) {
//        //
//        [weakSelf _showMediaDetail];
//    }];
    // 视频简介 tableViewHeader
    ClarityView *clarity = [[ClarityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    clarity.backgroundColor = [UIColor whiteColor];
    self.Clarity=clarity;
    tableView.tableHeaderView = clarity;
    
    // 详情点击事件
//    __weak typeof(self) weakSelf = self;
    [self.Clarity setClarityCallBack:^(NSInteger index) {
        
        NSLog(@"清晰度选择 = %ld",index);
        self.QXDSelectIndex=index;
        [self tempsAction:index];
    }];
    
    
}


/** 创建视频详情 */
- (void)_setupVideoDetail
{
    // 详情点击事件
    __weak typeof(self) weakSelf = self;
    // 视频详情
    MHYouKuMediaDetail *detail =  [[MHYouKuMediaDetail alloc] init];
    self.detail = detail;
    detail.backgroundColor = [UIColor whiteColor];
    [self.bottomContainer addSubview:detail];
    
    // 布局视频详情
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomContainer.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(self.bottomContainer.mas_height);
    }];
    
    // 事件
    [detail setCloseCallBack:^(MHYouKuMediaDetail *detail) {
        
        [weakSelf _hideMediaDetail];
    }];
    
}



#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    // 视频评论成功
    [MHNotificationCenter addObserver:self selector:@selector(_commentSuccess:) name:MHCommentSuccessNotification object:nil];
    
    // 视频评论回复成功
    [MHNotificationCenter addObserver:self selector:@selector(_commentReplySuccess:) name:MHCommentReplySuccessNotification object:nil];
    
    // 请求数据成功
    [MHNotificationCenter addObserver:self selector:@selector(_commentRequestDataSuccess:) name:MHCommentRequestDataSuccessNotification object:nil];
    
    // 视频点赞成功
    [MHNotificationCenter addObserver:self selector:@selector(_thumbSuccess:) name:MHThumbSuccessNotification object:nil];
}

#pragma mark - 通知事件处理
// 视频评论成功
- (void)_commentSuccess:(NSNotification *)note
{
    // 获取数据
    MHTopicFrame *topicFrame = [note.userInfo objectForKey:MHCommentSuccessKey];
    
    // 这里需要判断数据 不是同一个视频  直接退出
    if (!(topicFrame.topic.mediabase_id.longLongValue == self.mediabase_id.longLongValue))
    {
        return;
    }
    
    // 修改数据
    self.media.commentNums = self.media.commentNums+1;

    // 存在评论容器
    if ([self.dataSource containsObject:self.commentItem])
    {
        // 获取索引 可能这里需要加锁  防止插入数据异常
        NSInteger index = [self.dataSource indexOfObject:self.commentItem];
        // 安全处理
        if (self.dataSource.count == (index+1)) {
            // 直接添加到后面
            [self.dataSource addObject:topicFrame];
        }else{
            // 插入数据
            [self.dataSource insertObject:topicFrame atIndex:(index+1)];
        }
    }else{
        
        // 不存在评论容器  就添加一个
        
        // 配置一个评论表头的假数据
        [self.dataSource addObject:self.commentItem];
        // 配置评论数据
        [self.dataSource addObject:topicFrame];
    }
    
    // 检测footer
    [self _checkTableViewFooterState:YES];
    
    // 刷新数据
    [self _refreshDataWithMedia:self.media];
    
}
// 视频评论回复成功
- (void)_commentReplySuccess:(NSNotification *)note
{
    MHTopicFrame *topicFrame = [note.userInfo objectForKey:MHCommentReplySuccessKey];
    
    // 这里需要判断数据 不是同一个视频  直接退出
    if (!(topicFrame.topic.mediabase_id.longLongValue == self.mediabase_id.longLongValue))
    {
        return;
    }
    
    if (topicFrame == self.selectedTopicFrame) {
        // 刷新组
        [self _reloadSelectedSectin];
        
    }else
    {
        [self.tableView reloadData];
    }

}
// 请求数据成功
- (void)_commentRequestDataSuccess:(NSNotification *)note
{
    NSArray *topicFrames = [note.userInfo objectForKey:MHCommentRequestDataSuccessKey];
    MHTopicFrame *topicFrame  = topicFrames.firstObject;
    // 这里需要判断数据 不是同一个视频  直接退出
    if (!(topicFrame.topic.mediabase_id.longLongValue == self.mediabase_id.longLongValue))
    {
        return;
    }
    
    //
    if ([self.dataSource containsObject:self.commentItem]) {
        // 包含
        // 安全处理
        // 获取索引 可能这里需要加锁  防止插入数据异常
        NSInteger index = [self.dataSource indexOfObject:self.commentItem];
        
        if (self.dataSource.count == (index+1)) {
            // 直接添加到后面
            [self.dataSource addObjectsFromArray:topicFrames];
        }else{
            // 插入数据
            NSRange range = NSMakeRange(index+1, self.dataSource.count-(1+index));
            [self.dataSource replaceObjectsInRange:range withObjectsFromArray:topicFrames];
        }
        
    }else{
        // 配置一个评论表头的假数据
        [self.dataSource addObject:self.commentItem];
        
        // 配置评论数据
        [self.dataSource addObjectsFromArray:topicFrames];
    }
    
    [self _checkTableViewFooterState:topicFrames.count>0];
    
    // 重新刷新表格
    [self.tableView reloadData];
}

// 话题点赞成功
- (void)_thumbSuccess:(NSNotificationCenter *)note
{
    // 刷新数据
    [self.tableView reloadData];
}

#pragma mark - 点击事件处理
// 返回按钮点击
- (void)_backBtnDidiClicked:(MHButton *)sender
{
    // pop
    [self.navigationController popViewControllerAnimated:YES];
    // 清掉内存缓存
    [self _clearVideoTopicOrCommentCachesData];
}

// bottomToolBar的评论按钮点击
- (void)_commentVideo
{
    // 显示话题控制器
    [self _showTopicComment];
    
}

// tableView的footerBtn被点击
- (void)_commentFooterDidClicked:(UIButton *)sender
{
    // 显示topic
    [self _showTopicComment];
}


#pragma mark - 辅助方法

// 显示话题
- (void)_showTopicComment
{
    // 显示到前面来
    [self.bottomContainer bringSubviewToFront:self.topicContainer];
    //
    [self.topicContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self _updateConstraints];
}

// 隐藏话题
- (void)_hideTopicComment
{
    [self.topicContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(MHMainScreenHeight);
    }];
    
    [self _updateConstraints];
}

// 显示详情
- (void)_showMediaDetail
{
    [self.bottomContainer bringSubviewToFront:self.detail];
    
    [self.detail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self _updateConstraints];
}
// 隐藏详情
- (void)_hideMediaDetail
{
    // 先设置约束  后添加动画
    [self.detail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomContainer.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(self.bottomContainer.mas_height);
    }];
    
    [self _updateConstraints];
}

/** 更新约束 */
- (void)_updateConstraints
{
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/** topic --- topicFrame */
- (MHTopicFrame *)_topicFrameWithTopic:(MHTopic *)topic
{
    MHTopicFrame *topicFrame = [[MHTopicFrame alloc] init];
    // 传递微博模型数据，计算所有子控件的frame
    topicFrame.topic = topic;
    
    return topicFrame;
}

- (void)_refreshDataWithMedia:(MHYouKuMedia *)media
{
    // 刷新简介
    self.summary.media = media;
    
    // 刷新详情
    self.detail.media = media;
    
    // 刷新底部工具条
    self.bottomToolBar.media = media;
    
    // 添加数据
    self.commentItem.commentCount = media.commentNums;
    
    // 刷新表格
    [self.tableView reloadData];
    
    // footer设置数据
    [self.commentFooter setTitle:[NSString stringWithFormat:@"查看全部%@条回复 >" , media.commentNumsString] forState:UIControlStateNormal];
    
    // 刷新topicVC的评论的数据
    [self.topic refreshCommentsWithCommentItem:self.commentItem];
}


/** 清除掉话题评论和评论回复的内存缓存...减少内幕才能开销 */
- (void) _clearVideoTopicOrCommentCachesData
{
    [[MHTopicManager sharedManager].replyDictionary removeAllObjects];
    [[MHTopicManager sharedManager].commentDictionary removeAllObjects];
}


/** 检查状态 */
- (void)_checkTableViewFooterState:(BOOL)state
{
    if (state) {
        self.tableView.tableFooterView = self.commentFooter;
    }else{
        self.tableView.tableFooterView = nil;
    }
}
/** 刷新段  */
- (void)_reloadSelectedSectin
{
    // 获取索引
    [self.tableView beginUpdates];
    NSInteger index = [self.dataSource indexOfObject:self.selectedTopicFrame];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

/** 评论回复 */
- (void)_replyCommentWithCommentReply:(MHCommentReply *)commentReply
{
    // 显示
    MHYouKuInputPanelView *inputPanelView = [MHYouKuInputPanelView inputPanelView];
    inputPanelView.commentReply = commentReply;
    inputPanelView.delegate = self;
    [inputPanelView show];
    
    self.inputPanelView = inputPanelView;
}

//去掉UItableview headerview黏性  ，table滑动到最上端时，header view消失掉。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 66+36.0;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 话题
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        return topicFrame.commentFrames.count;
    }
    return 0;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 话题
        MHCommentCell *cell = [MHCommentCell cellWithTableView:tableView];
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        MHCommentFrame *commentFrame = topicFrame.commentFrames[indexPath.row];
        cell.commentFrame = commentFrame;
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.section];
    if ([model isKindOfClass:[MHTopicFrame class]]) {
        MHTopicFrame *videoTopicFrame = (MHTopicFrame *)model;
        MHCommentFrame *commentFrame = videoTopicFrame.commentFrames[indexPath.row];
        return commentFrame.cellHeight;
    }
    
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 话题
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        return topicFrame.height;
    }
    
    if ([model isKindOfClass:[MHYouKuAnthologyItem class]]) {
        // 选集
        return MHRecommendAnthologyHeaderViewHeight;
    }
    
    if ([model isKindOfClass:[MHYouKuCommentItem class]]) {
        // 评论
        return MHRecommendCommentHeaderViewHeight;
    }
    
    if ([model isKindOfClass:[ClarityView class]]) {
        // 清晰度
        return 85.f;
    }
    return .1f;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 模型
    id model = self.dataSource[section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 数据
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        return topicFrame.commentFrames.count>0? MHTopicVerticalSpace:MHGlobalBottomLineHeight;
    }
    
    // 默认高度
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 话题
        MHTopicHeaderView *headerView = [MHTopicHeaderView headerViewWithTableView:tableView];
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        headerView.topicFrame = topicFrame;
        headerView.delegate = self;
        return headerView;
    }
    
    if ([model isKindOfClass:[MHYouKuAnthologyItem class]]) {
        // 选集
        MHYouKuAnthologyHeaderView *headerView = [MHYouKuAnthologyHeaderView headerViewWithTableView:tableView];
        MHYouKuAnthologyItem *anthologyItem = (MHYouKuAnthologyItem *)model;
        headerView.anthologyItem = anthologyItem;
        headerView.delegate = self;
        self.anthologyHeaderView = headerView;
        return headerView;
    }
    
    if ([model isKindOfClass:[MHYouKuCommentItem class]]) {
        // 评论
        MHYouKuCommentHeaderView *headerView = [MHYouKuCommentHeaderView headerViewWithTableView:tableView];
        MHYouKuCommentItem *commentItem = (MHYouKuCommentItem *)model;
        headerView.commentItem = commentItem;
        headerView.delegate = self;
        return headerView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    
    // 评论
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        MHTopicFooterView *footerView = [MHTopicFooterView footerViewWithTableView:tableView];
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model = self.dataSource[indexPath.section];
    
    // 评论
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        MHCommentFrame *commentFrame = topicFrame.commentFrames[indexPath.row];
        // 选中的栏
        self.selectedTopicFrame = topicFrame;
        
        
        // 判断
        if ([commentFrame.comment.commentId isEqualToString:MHAllCommentsId]) {
            // 跳转到更多评论
            MHYouKuTopicDetailController *topicDetail = [[MHYouKuTopicDetailController alloc] init];
            topicDetail.topicFrame = topicFrame;
            // push
            [self.navigationController pushViewController:topicDetail animated:YES];
            return;
        }
        
        // 这里是回复
        
        // 回复自己则跳过
        if ([commentFrame.comment.fromUser.userId isEqualToString:[AppDelegate sharedDelegate].account.userId]) {
            return;
        }
        
        // 回复评论
        MHCommentReply *commentReply = [[MHTopicManager sharedManager] commentReplyWithModel:commentFrame.comment];
        
        // show
        [self _replyCommentWithCommentReply:commentReply];
    }
}


#pragma mark - MHCommentCellDelegate
- (void)commentCell:(MHCommentCell *)commentCell didClickedUser:(MHUser *)user
{
    MHUserInfoController *userInfo = [[MHUserInfoController alloc] init];
    userInfo.user = user;
    [self.navigationController pushViewController:userInfo animated:YES];
}


#pragma mark - MHYouKuBottomToolBarDelegate
- (void) bottomToolBar:(MHYouKuBottomToolBar *)bottomToolBar didClickedButtonWithType:(MHYouKuBottomToolBarType)type
{   // bottom底部按钮被点击
    switch (type) {
        case MHYouKuBottomToolBarTypeThumb:
        {
            //
            MHLog(@"++ 点赞 ++");
            self.media.thumb = !self.media.isThumb;
            if (self.media.isThumb) {
                self.media.thumbNums+=1;
            }else{
                self.media.thumbNums-=1;
            }
            [self _refreshDataWithMedia:self.media];

        }
            break;
        case MHYouKuBottomToolBarTypeComment:
        {
            // 评论
            MHLog(@"++ 评论 ++");
            [self _commentVideo];
        }
            break;
        case MHYouKuBottomToolBarTypeCollect:
        {
            // 收藏
            MHLog(@"++ 收藏 ++");
        }
            break;
        case MHYouKuBottomToolBarTypeShare:
        {
            // 分享
            MHLog(@"++ 分享 ++");
        }
            break;
        case MHYouKuBottomToolBarTypeDownload:
        {
            // 下载
            MHLog(@"++ 下载 ++");
        }
            break;
            
        case MHYouKuBottomToolBarTypetitle:
        {
            // 详情
            MHLog(@"++ 详情 ++");
            
            // 详情点击事件
            [self _showMediaDetail];
        }
        default:
            break;
    }
}

#pragma mark - MHYouKuTopicControllerDelegate
- (void)topicControllerForCloseAction:(MHYouKuTopicController *)topicController
{
    // 隐藏评论VC
    [self _hideTopicComment];
}

#pragma mark - MHYouKuAnthologyHeaderViewDelegate
- (void) anthologyHeaderViewForMoreButtonAction:(MHYouKuAnthologyHeaderView *)anthologyHeaderView
{
    // 更多按钮被点击
    MHLog(@"+++ 选集更多按钮点击 +++");
    
}

- (void) anthologyHeaderView:(MHYouKuAnthologyHeaderView *)anthologyHeaderView mediaBaseId:(NSString *)mediaBaseId
{
    MHLog(@"anthologyHeaderView.anthologyItem.item== %ld" , (long)anthologyHeaderView.anthologyItem.item);;
    self.xuanjiSelectIndex=anthologyHeaderView.anthologyItem.item;
    [self tempsAction:self.QXDSelectIndex];
    // 选集集数按钮被点击
    MHLog(@" 选集集数按钮点击=== %@" , mediaBaseId);
}

#pragma mark - MHYouKuCommentHeaderViewDelegate
- (void)commentHeaderViewForCommentBtnAction:(MHYouKuCommentHeaderView *)commentHeaderView
{
    // 评论按钮点击
    // 评论框按钮被点击
    MHYouKuCommentController *comment = [[MHYouKuCommentController alloc] init];
    comment.mediabase_id = self.mediabase_id;
    MHNavigationController *nav = [[MHNavigationController alloc] initWithRootViewController:comment];
    [self.parentViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MHTopicHeaderViewDelegate
- (void) topicHeaderViewDidClickedUser:(MHTopicHeaderView *)topicHeaderView
{
    MHUserInfoController *userInfo = [[MHUserInfoController alloc] init];
    userInfo.user = topicHeaderView.topicFrame.topic.user;
    [self.navigationController pushViewController:userInfo animated:YES];
}

- (void) topicHeaderViewForClickedMoreAction:(MHTopicHeaderView *)topicHeaderView
{
    /**
     * 这里点击事件自行根据自己UI处理
     *
     */
    MHLog(@"---点击更多按钮---");
    
}

- (void) topicHeaderViewForClickedThumbAction:(MHTopicHeaderView *)topicHeaderView
{
    /**
     * 这里点击事件自行根据自己UI处理
     *
     */
    MHLog(@"---点击👍按钮---");
    // 修改数据源方法
    MHTopic *topic = topicHeaderView.topicFrame.topic;
    topic.thumb = !topic.isThumb;
    if (topic.isThumb) {
        topic.thumbNums+=1;
    }else{
        topic.thumbNums-=1;
    }
    
    // 刷新数据
    [MHNotificationCenter postNotificationName:MHThumbSuccessNotification object:nil];
    
}

// 话题内容点击
- (void) topicHeaderViewDidClickedTopicContent:(MHTopicHeaderView *)topicHeaderView
{
    // 选中的栏 话题内容自己可以评论
    self.selectedTopicFrame = topicHeaderView.topicFrame;
    
    // 评论跳转到评论
    MHCommentReply *commentReply =  [[MHTopicManager sharedManager] commentReplyWithModel:topicHeaderView.topicFrame.topic];
    
    // 回复
    [self _replyCommentWithCommentReply:commentReply];
}



#pragma mark - MHYouKuInputPanelViewDelegate
- (void) inputPanelView:(MHYouKuInputPanelView *)inputPanelView attributedText:(NSString *)attributedText
{
    // 发送评论 模拟网络发送
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 评论或者回复成功
        MHComment *comment = [[MHComment alloc] init];
        comment.mediabase_id = self.mediabase_id;
        comment.commentId = [NSString stringWithFormat:@"%zd",[NSObject mh_randomNumber:0 to:100]];
        comment.text = attributedText;
        comment.creatTime = [NSDate mh_currentTimestamp];
        
        MHUser *fromUser = [[MHUser alloc] init];
        fromUser.userId = [AppDelegate sharedDelegate].account.userId ;
        fromUser.avatarUrl = [AppDelegate sharedDelegate].account.avatarUrl;
        fromUser.nickname = [AppDelegate sharedDelegate].account.nickname;
        comment.fromUser = fromUser;
        
        
        // 只有回复才会有 toUser
        if (inputPanelView.commentReply.isReply) {
            MHUser *toUser = [[MHUser alloc] init];
            toUser.avatarUrl = inputPanelView.commentReply.user.avatarUrl;
            toUser.userId = inputPanelView.commentReply.user.userId;
            toUser.nickname = inputPanelView.commentReply.user.nickname;
            comment.toUser = toUser;
        }
        
        // 这里需要插入假数据
        MHCommentFrame* newCommentFrame = [[MHTopicManager sharedManager] commentFramesWithComments:@[comment]].lastObject;
        
        // 这里要插入话题数据源中去
        
        // 修改评论回复数目
        self.selectedTopicFrame.topic.commentsCount  =  self.selectedTopicFrame.topic.commentsCount + 1;
        
        // 判断数据
        if (self.selectedTopicFrame.topic.comments.count>2) {
            
            // 有 查看全部xx条回复
            // 插入数据
            NSInteger count = self.selectedTopicFrame.commentFrames.count;
            NSInteger index = count - 1;
            [self.selectedTopicFrame.commentFrames insertObject:newCommentFrame atIndex:index];
            [self.selectedTopicFrame.topic.comments insertObject:comment atIndex:index];
            
            // 取出最后一条数据 就是查看全部xx条回复
            MHComment *lastComment = self.selectedTopicFrame.topic.comments.lastObject;
            lastComment.text = [NSString stringWithFormat:@"查看全部%zd条回复" , self.selectedTopicFrame.topic.commentsCount];
            
        }else {
            
            // 临界点
            if (self.selectedTopicFrame.topic.comments.count == 2)
            {
                // 添加数据源
                [self.selectedTopicFrame.commentFrames addObject:newCommentFrame];
                [self.selectedTopicFrame.topic.comments addObject:comment];
                
                // 设置假数据
                MHComment *lastComment = [[MHComment alloc] init];
                lastComment.commentId = MHAllCommentsId;
                lastComment.text = [NSString stringWithFormat:@"查看全部%zd条回复" , self.selectedTopicFrame.topic.commentsCount];
                MHCommentFrame *lastCommentFrame =  [[MHTopicManager sharedManager] commentFramesWithComments:@[lastComment]].lastObject;
                // 添加假数据
                [self.selectedTopicFrame.commentFrames addObject:lastCommentFrame];
                [self.selectedTopicFrame.topic.comments addObject:lastComment];
            }else{
                // 添加数据源
                [self.selectedTopicFrame.commentFrames addObject:newCommentFrame];
                [self.selectedTopicFrame.topic.comments addObject:comment];
            }
        }
        
        // 发送评论回复成功的通知
        [MHNotificationCenter postNotificationName:MHCommentReplySuccessNotification object:nil userInfo:@{MHCommentReplySuccessKey:self.selectedTopicFrame}];
    });
    
}



#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
