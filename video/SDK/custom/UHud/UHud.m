//
//  RovHud.m
//  GeneROV
//
//  Created by nian on 2019/1/10.
//  Copyright © 2019 Mileda. All rights reserved.
//

#import "UHud.h"
#import "MBProgressHUD.h"
@implementation UHud
+(void)showHudWithStatus:(NSString *)status
{
    [SVProgressHUD showSuccessWithStatus:status];
}
+(void)showHudWithStatus:(NSString *)status delay:(CGFloat)time
{
    [SVProgressHUD showInfoWithStatus:status];
    [SVProgressHUD dismissWithDelay:time];
}
+(void)showSuccessWithStatus:(NSString *)status delay:(CGFloat)time
{
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:time];
}

+(void)showTXTWithStatus:(NSString *)status delay:(CGFloat)time
{
    [SVProgressHUD showSuccessWithStatus:status iamge:[UIImage imageNamed:@""]];
    [SVProgressHUD dismissWithDelay:time];
}
+ (void)showHUDToView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil)
    {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        return;
    }
//    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
}


+ (void)showHUDLoading
{
    UIView*view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil)
    {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        return;
    }
//    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
}
+(void)showHUDToView:(UIView *)view text:(NSString *)text
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil)
    {
     hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        [view sendSubviewToBack:hud];
    }else{
        hud.labelText = text;
        [view sendSubviewToBack:hud];
        return;
    }
    hud.labelText = text;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
}
+(BOOL)hideLoadHudForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    return [MBProgressHUD hideAllHUDsForView:view animated:NO];
}
+(BOOL)hideLoadHud
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    return [MBProgressHUD hideAllHUDsForView:view animated:NO];
}


+(BOOL)hudForView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud != nil)
    {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        return YES;
    }
    return NO;
}
@end
