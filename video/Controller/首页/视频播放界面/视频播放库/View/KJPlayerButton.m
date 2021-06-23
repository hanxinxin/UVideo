//
//  KJPlayerButton.m
//  KJPlayerDemo
//
//  Created by 杨科军 on 2021/2/21.
//  Copyright © 2021 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJPlayerDemo

#import "KJPlayerButton.h"
#import "KJBasePlayerView.h"
#import <objc/runtime.h>
@interface UIButton (KJPlayerAreaInsets)
/// 设置按钮额外热区
@property(nonatomic,assign)UIEdgeInsets touchAreaInsets;
@end
@implementation KJPlayerButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self setTitleColor:self.mainColor forState:(UIControlStateNormal)];
        self.layer.zPosition = KJBasePlayerViewLayerZPositionButton;
    }
    return self;
}
- (void)buttonAction:(KJPlayerButton*)sender{
    sender.selected = !sender.selected;
    KJBasePlayerView *baseView = (KJBasePlayerView*)self.superview;
    if (baseView == nil) return;
    if (_type == KJPlayerButtonTypeBack) {
        if (baseView.screenState == KJPlayerVideoScreenStateFullScreen) {
            baseView.isFullScreen = NO;
        }
        if (baseView.kVideoClickButtonBack) {
            baseView.kVideoClickButtonBack(baseView);
        }
    }else if (_type == KJPlayerButtonTypeLock) {
        self.isLocked = sender.selected;
        if (self.isLocked) {
            baseView.topView.hidden = YES;
            baseView.bottomView.hidden = YES;
            if (baseView.screenState == KJPlayerVideoScreenStateFullScreen) {
                baseView.backButton.hidden = YES;
            }
            [self kj_hiddenLockButton];
        }else{
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(kj_lockButton) object:nil];
            [KJRotateManager kj_operationViewDisplayBasePlayerView:baseView];
        }
    }else if (_type == KJPlayerButtonTypeCenterPlay) {
        
        if (baseView.kVideoPlayButtonBack) {
            baseView.kVideoPlayButtonBack(baseView);
        }
    }
    if ([baseView.delegate respondsToSelector:@selector(kj_basePlayerView:PlayerButton:)]) {
        [baseView.delegate kj_basePlayerView:baseView PlayerButton:sender];
    }
}



/* 隐藏锁屏按钮 */
- (void)kj_hiddenLockButton{
    self.hidden = NO;
    self.alpha = 1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(kj_lockButton) object:nil];
    [self performSelector:@selector(kj_lockButton) withObject:nil afterDelay:1.];
}
- (void)kj_lockButton{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
    }];
}

- (void)setType:(KJPlayerButtonType)type{
    _type = type;
    if (type == KJPlayerButtonTypeBack) {
//        self.layer.cornerRadius = self.frame.size.width/2;
        self.backgroundColor = [UIColor clearColor];
//        [self setTitle:@"\U0000e697" forState:(UIControlStateNormal)];
//        self.titleLabel.font = [UIFont fontWithName:@"KJPlayerfont" size:self.frame.size.width/4*3];
        [self setImage:[UIImage imageNamed:@"whiteBack"] forState:(UIControlStateNormal)];
//        [self setTitle:@" 我们的世界第一集" forState:(UIControlStateNormal)];
        [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [self setImage:[UIImage imageNamed:@"zanting"] forState:(UIControlStateSelected)];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }else if (type == KJPlayerButtonTypeLock) {
        self.hidden = YES;
        self.layer.cornerRadius = self.frame.size.width/2;
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        [self setTitle:@"\U0000e82b" forState:(UIControlStateNormal)];
        [self setTitle:@"\U0000e832" forState:(UIControlStateSelected)];
        self.titleLabel.font = [UIFont fontWithName:@"KJPlayerfont" size:self.frame.size.width/5*3];
        self.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }else if (type == KJPlayerButtonTypeCenterPlay) {
        self.hidden = YES;
//        [self setTitle:@"\U0000e719" forState:(UIControlStateNormal)];
//        [self setTitle:@"\U0000e71a" forState:(UIControlStateSelected)];
//        self.titleLabel.font = [UIFont fontWithName:@"KJPlayerfont" size:self.frame.size.width/5*3];Image("")
        [self setImage:[UIImage imageNamed:@"MMVideoPreviewPlay"] forState:(UIControlStateNormal)];
        [self setImage:[UIImage imageNamed:@"zanting"] forState:(UIControlStateSelected)];
    }
}

@end

@implementation UIButton (KJPlayerAreaInsets)
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left, bounds.origin.y - touchAreaInsets.top, bounds.size.width + touchAreaInsets.left + touchAreaInsets.right, bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}
#pragma mark - associated
- (UIEdgeInsets)touchAreaInsets{
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}
- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
