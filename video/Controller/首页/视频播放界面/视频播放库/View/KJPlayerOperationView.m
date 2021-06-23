//
//  KJPlayerOperationView.m
//  KJPlayerDemo
//
//  Created by 杨科军 on 2021/2/21.
//  Copyright © 2021 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJPlayerDemo

#import "KJPlayerOperationView.h"
#import "KJBasePlayerView.h"
@interface KJPlayerOperationView ()

@end

@implementation KJPlayerOperationView
/* 初始化 */
- (instancetype)initWithFrame:(CGRect)frame OperationType:(KJPlayerOperationViewType)type{
    if (self = [super initWithFrame:frame]) {
        self.lastRect = frame;
        CGFloat height = frame.size.height;
        CGFloat hh=40.f;
        if (type == KJPlayerOperationViewTypeTop) {
            self.backgroundColor = [self kj_gradientColor:[UIColor.blackColor colorWithAlphaComponent:0.8],[UIColor.blackColor colorWithAlphaComponent:0.],nil](CGSizeMake(1, height));
        }else{
            self.backgroundColor = [self kj_gradientColor:[UIColor.blackColor colorWithAlphaComponent:0.],[UIColor.blackColor colorWithAlphaComponent:0.8],nil](CGSizeMake(1, height));
            
            UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-((hh+6)*3), 0, hh, hh)];
            self.msgButton = button1;
            [button1 addTarget:self action:@selector(msgItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [button1 setImage:[UIImage imageNamed:@"pinglun-1"] forState:(UIControlStateNormal)];
            [button1 setImage:[UIImage imageNamed:@"pinglun-1"] forState:(UIControlStateSelected)];
            [button1 setTitleColor:self.mainColor forState:(UIControlStateNormal)];
            button1.titleLabel.font = [UIFont fontWithName:@"KJPlayerfont" size:hh];
            [self addSubview:button1];
            UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-((hh+6)*2), 0, hh, hh)];
            self.ShengyiButton = button2;
            [button2 addTarget:self action:@selector(ShengyiItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setImage:[UIImage imageNamed:@"jingyinno"] forState:(UIControlStateNormal)];
            [button2 setImage:[UIImage imageNamed:@"jingyinselect"] forState:(UIControlStateSelected)];
            [button2 setTitleColor:self.mainColor forState:(UIControlStateNormal)];
            button2.titleLabel.font = [UIFont fontWithName:@"KJPlayerfont" size:hh];
            [self addSubview:button2];
            
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-(hh+6), 0, hh, hh)];
            self.fullButton = button;
            [button addTarget:self action:@selector(fullItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"xuanzhuanno"] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@"xuanzhuanno"] forState:(UIControlStateSelected)];
            [button setTitleColor:self.mainColor forState:(UIControlStateNormal)];
            button.titleLabel.font = [UIFont fontWithName:@"KJPlayerfont" size:hh];
            [self addSubview:button];
        }
        self.layer.zPosition = KJBasePlayerViewLayerZPositionInteraction;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)fullItemClick:(UIButton*)sender{
    
    KJBasePlayerView *view = (KJBasePlayerView*)self.superview;
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"fullItemClick" object:nil userInfo:@{@"full":@(!view.isFullScreen)}]];
    view.isFullScreen = !view.isFullScreen;
   
}
-(void)msgItemClick:(UIButton*)sender
{
    if (self.kVideoOperationViewBtnTouch) {
        self.kVideoOperationViewBtnTouch(1);
    }
}
-(void)ShengyiItemClick:(UIButton*)sender
{
    if (self.kVideoOperationViewBtnTouch) {
        self.kVideoOperationViewBtnTouch(2);
    }
}
-(void)playvideoItemClick:(UIButton*)sender
{
    if (self.kVideoOperationViewBtnTouch) {
        self.kVideoOperationViewBtnTouch(3);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (CGRectEqualToRect(self.lastRect, self.frame)) {
        return;
    }
    self.lastRect = self.frame;
    
    CGFloat height = self.frame.size.height;
    CGFloat hh=40.f;
    if (_msgButton) {
        self.msgButton.frame = CGRectMake(self.frame.size.width-((hh+6)*3), 0, hh, hh);
    }
    if (_ShengyiButton) {
        self.ShengyiButton.frame = CGRectMake(self.frame.size.width-((hh+6)*2), 0, hh, hh);
    }
    if (_fullButton) {
        self.fullButton.frame = CGRectMake(self.frame.size.width-(hh+6), 0, hh, hh);
        self.fullButton.titleLabel.font = [UIFont fontWithName:@"KJPlayerfont" size:hh];
    }
    if (self.kVideoOperationViewChanged) {
        self.kVideoOperationViewChanged(self);
    }
    
    
}
- (UIColor*(^)(CGSize))kj_gradientColor:(UIColor*)color,...{
    NSMutableArray * colors = [NSMutableArray arrayWithObjects:(id)color.CGColor,nil];
    va_list args;UIColor * arg;
    va_start(args, color);
    while ((arg = va_arg(args, UIColor *))) {
        [colors addObject:(id)arg.CGColor];
    }
    va_end(args);
    return ^UIColor*(CGSize size){
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(size.width, size.height), 0);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorspace);
        UIGraphicsEndImageContext();
        return [UIColor colorWithPatternImage:image];
    };
}
@end
