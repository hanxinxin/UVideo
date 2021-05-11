//
//  YJShowAlertView.m
//  YJTool_Demo
//
//  Created by yangjian on 2018/11/27.
//  Copyright © 2018 zhangshuyue. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "YJShowAlertView.h"
#import "UIView+YJExtension.h"

@interface YJShowAlertView()<UIGestureRecognizerDelegate>

@property (nonatomic,weak)UIView *blackView;

@property (nonatomic,weak)UIView *contView;

@property (nonatomic,strong)NSTimer * timer;
@end

@implementation YJShowAlertView

+ (YJShowAlertView *)shareInstance {
    static dispatch_once_t once;
    static YJShowAlertView *shareView;
    dispatch_once(&once, ^{
        shareView = [[self alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    });
    return shareView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc]initWithFrame:frame];
        bgView.tag = 10;
        bgView.backgroundColor = [UIColor colorWithRed: 0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [bgView addGestureRecognizer:tap];
        
        [self addSubview:bgView];
        self.blackView = bgView;
    }
    return self;
}

+(void)show{
    [[self shareInstance]show];
}

+(void)showView:(UIView *)centerView withType:(YJShowAlertViewStyle)type{
    [self showView:centerView withType:type dissmissAfter:0];
}

+(void)showView:(UIView *)centerView withType:(YJShowAlertViewStyle)type dissmissAfter:(CGFloat)time{
    [[self shareInstance] showView:centerView withType:type dissmissAfter:time];
}

- (void)showView:(UIView *)centerView withType:(YJShowAlertViewStyle)maskType dissmissAfter:(CGFloat)time{
    if (self.centerView) {
        return;
    }
    self.centerView = centerView;
    if (maskType == YJShowAlertViewStyleGray) {
        self.blackView.backgroundColor = [UIColor colorWithRed: 0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    }else if (maskType == YJShowAlertViewStyleCustom){
        self.blackView.backgroundColor = [UIColor clearColor];
    }
    if (time) {
        self.timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    [self show];
}


#pragma mark - setData
-(void)setCenterView:(UIView *)centerView{
    if (self.centerView) {
        return;
    }
    self.contView = centerView;
    [self.blackView addSubview:self.contView];
    self.contView.centerX = self.blackView.width *0.5;
    self.contView.centerY = self.blackView.height *0.5;
}

-(void)setForbitTap:(BOOL)forbitTap{
    _forbitTap = forbitTap;
}

#pragma mark - ViewMethod
-(void)show{
    self.blackView.alpha = 0;
    self.contView.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView animateWithDuration:0.3 animations:^{
        self.contView.transform = CGAffineTransformMakeScale(1.1,1.1);
        self.blackView.alpha = 1;
    } completion:^(BOOL finished) {
        self.contView.transform = CGAffineTransformMakeScale(1,1);
    }];
    
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self];
    
    if (_delegate && [_delegate respondsToSelector:@selector(YJShowAlertViewDelegateViewShow)]) {
        [_delegate YJShowAlertViewDelegateViewShow];
    }
}

+(void)dismiss{
    [[self shareInstance] dismiss];
}

-(void)dismiss{
    [self.timer invalidate];
    self.timer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.contView.transform = CGAffineTransformMakeScale(0.1,0.1);
        self.blackView.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.centerView) {
            [self.centerView removeFromSuperview];
            self.centerView = nil;
        }
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(YJShowAlertViewDelegateViewDismiss)]) {
        [_delegate YJShowAlertViewDelegateViewDismiss];
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (_forbitTap) {
        return NO;
    }
    if (gestureRecognizer.view.tag != 10) {
        return NO;
    }
    return YES;
}


@end
