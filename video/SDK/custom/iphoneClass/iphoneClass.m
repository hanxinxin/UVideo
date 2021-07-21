//
//  iphoneClass.m
//  video
//
//  Created by macbook on 2021/6/2.
//

#import "iphoneClass.h"

@implementation iphoneClass


//我们只需要获取屏幕的宽度和高度，取较大的一方比较是否等于 812或者 896,若有一个相等，就是iPhoneX系列的屏幕
+ (BOOL)isiPhoneXByHeight {
    //判断当前设备是否为iPhone  或 iPod touch
//    12mini 780.0f 12 844.0f 12pro 844.0f 12pro max 926.f
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //获取屏幕的宽度和高度， 取较大一方进行比较是否等于 812.0 或者 896.0
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat maxLength = screenWidth > screenHeight ? screenWidth : screenHeight;
        if (maxLength == 780.0f || maxLength == 812.0f || maxLength == 844.0f || maxLength == 896.f || maxLength == 926.f ) {
            return YES;
        }
    }
    return NO;
}
@end
