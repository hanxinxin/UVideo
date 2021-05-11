//
//  YJShowAlertView.h
//  YJTool_Demo
//
//  Created by yangjian on 2018/11/27.
//  Copyright © 2018 zhangshuyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YJShowAlertViewStyle) {
    YJShowAlertViewStyleCustom,
    YJShowAlertViewStyleGray
};

@protocol YJShowAlertViewDelegate <NSObject>

-(void)YJShowAlertViewDelegateViewShow;
-(void)YJShowAlertViewDelegateViewDismiss;

@end

@interface YJShowAlertView : UIView

/// 是否禁止点击背景关闭弹框 ：YES:禁止  NO: 可点击取消
@property(nonatomic,assign)BOOL forbitTap;

/**
    需要展示的View
 */
@property (nonatomic,strong)UIView *centerView;

@property(nonatomic,assign)id <YJShowAlertViewDelegate> delegate;


+(void)show;

+(void)showView:(UIView *)centerView withType:(YJShowAlertViewStyle)type;

//自动消失
+(void)showView:(UIView *)centerView withType:(YJShowAlertViewStyle)type dissmissAfter:(CGFloat)time;

+(void)dismiss;


//-(instancetype)initWithFrame:(CGRect)frame;
//-(void)show;
//-(void)close;

@end


