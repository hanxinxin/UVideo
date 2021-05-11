//
//  leftView.m
//  BezierCurveLineDemo
//
//  Created by Daqi on 2018/5/7.
//  Copyright © 2018年 xiayuanquan. All rights reserved.
//

#import "leftView.h"

@implementation leftView

//初始化画布
+(instancetype)initWithFrame:(CGRect)frame
{
    leftView *bezierCurveView = [[NSBundle mainBundle] loadNibNamed:@"BezierCurveView" owner:self options:nil].lastObject;
    bezierCurveView.frame = frame;
    return bezierCurveView;
}

@end
