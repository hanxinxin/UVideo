//
//  BaseColor.m
//  setDialog
//
//  Created by Daqi on 2018/5/4.
//  Copyright © 2018年 Daqi. All rights reserved.
//

#import "BaseColor.h"
#import "UIColor+HEX.h"
@implementation BaseColor

+(UIColor *)defaultColor
{
   return [self colorWithHexString:@"#313131"];
}

+(UIColor *)tabBarBgColor
{
     return [self colorWithHexString:@"#DCDCDC"];
}

+(UIColor *)selectColor
{
    return [self colorWithHexString:@"#1e2125"];
}

+(UIColor *)backgroundColor
{
     return [self colorWithHexString:@"#EEEEEE"];
}

+(UIColor *)photosBgColor
{
    return [self colorWithHexString:@"#f6f7f9"];
}

+(UIColor *)DarkOrange
{
    return [self colorWithHexString:@"#FF4500"];
}

+(UIColor *)deleteFileColor
{
    return [self colorWithHexString:@"#FDC700"];
}

@end
