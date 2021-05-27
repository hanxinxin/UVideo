//
//  KJDetailPlayerVC.h
//  KJPlayerDemo
//
//  Created by 杨科军 on 2021/2/9.
//  Copyright © 2021 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJPlayerDemo

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJDetailPlayerVC : UIViewController
@property(nonatomic,strong)KJBasePlayer *player;
@property(nonatomic,strong)CALayer *layer;
@property(nonatomic,copy,readwrite)void(^kBackBlock)(void);

@end

NS_ASSUME_NONNULL_END
