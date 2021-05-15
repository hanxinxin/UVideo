//
//  RovHud.h
//  GeneROV
//
//  Created by nian on 2019/1/10.
//  Copyright © 2019 Mileda. All rights reserved.
//  提示

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN

@interface UHud : NSObject
+(void)showHudWithStatus:(NSString *)status;// 默认时间消失
+(void)showHudWithStatus:(NSString *)status delay:(CGFloat)time;
+(void)showSuccessWithStatus:(NSString *)status delay:(CGFloat)time;

+(void)showTXTWithStatus:(NSString *)status delay:(CGFloat)time;

+(void)showHUDToView:(UIView *)view;
+(void)showHUDToView:(UIView *)view text:(NSString *)text;

+(BOOL)hideLoadHudForView:(UIView *)view;
+(BOOL)hudForView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
