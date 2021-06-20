//
//  MHYouKuBottomToolBar.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHYouKuVerticalSeparateButton.h"
#import "MHYouKuMedia.h"

@class MHYouKuBottomToolBar,MHYouKuMedia;

typedef NS_ENUM(NSUInteger, MHYouKuBottomToolBarType) {
    MHYouKuBottomToolBarTypeThumb = 10, // 点赞
    MHYouKuBottomToolBarTypeThumbCai = 100, // 踩
    MHYouKuBottomToolBarTypeComment,   // 评论
    MHYouKuBottomToolBarTypeCollect,   // 收藏
    MHYouKuBottomToolBarTypeDownload,  // 下载
    MHYouKuBottomToolBarTypeShare,      // 分享
    MHYouKuBottomToolBarTypetitle,      // 标题
    MHYouKuBottomToolBarTypeFankui      // 反馈
    
};


@protocol MHYouKuBottomToolBarDelegate <NSObject>

@optional
- (void)bottomToolBar:(MHYouKuBottomToolBar *)bottomToolBar didClickedButtonWithType:(MHYouKuBottomToolBarType)type;

@end


@interface MHYouKuBottomToolBar : UIView


/** 代理 */
@property (nonatomic , weak) id <MHYouKuBottomToolBarDelegate> delegate;

/** 模型 */
@property (nonatomic , strong) MHYouKuMedia *media;
/** 名字 **/
@property (nonatomic , strong) MHYouKuVerticalSeparateButton *NameBtn;


/** 点赞 */
@property (nonatomic , weak) MHYouKuVerticalSeparateButton * thumbBtn;

/** 评论 **/
//@property (nonatomic , weak) MHYouKuVerticalSeparateButton *commentBtn;
/** 反馈 */
@property (nonatomic , weak) MHYouKuVerticalSeparateButton * fankuiBtn;
/** 倒彩 */
@property (nonatomic , weak) MHYouKuVerticalSeparateButton * daocaiBtn;

/** 下载 **/
//@property (nonatomic , weak) MHYouKuVerticalSeparateButton *downloadBtn;

/** 分享 */
@property (nonatomic , weak) MHYouKuVerticalSeparateButton * shareBtn;
/** 收藏 */
@property (nonatomic , weak) MHYouKuVerticalSeparateButton * shoucangBtn;

/** 分割线 **/
@property (nonatomic , weak) MHImageView *separate ;


/** 按钮数组 **/
@property (nonatomic,strong) NSMutableArray  *buttons;
@end
