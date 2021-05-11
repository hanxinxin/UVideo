//
//  UIView+YJExtension.h
//  YJTool_Demo
//
//  Created by yangjian on 2019/2/2.
//  Copyright © 2019 zhangshuyue. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (YJExtension)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

@property (assign, nonatomic) CGFloat max_Y;
@property (assign, nonatomic) CGFloat max_X;
@property(nonatomic, assign)CGFloat centerX;
@property(nonatomic, assign)CGFloat centerY;


/**
 *  等比例拉伸视图
 *
 *  @param width 目标宽
 *
 *  @return 目标高
 */
- (CGFloat)autoresizeHeightToWidth:(CGFloat)width;
/**
 *  等比例拉伸视图
 *
 *  @param height 目标高
 *
 *  @return 目标宽
 */
- (CGFloat)autoresizeWidthToHeight:(CGFloat)height;
@end


