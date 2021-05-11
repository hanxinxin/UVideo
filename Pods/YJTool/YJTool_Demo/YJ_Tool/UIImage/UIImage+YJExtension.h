//
//  UIImage+YJExtension.h
//  YJTool_Demo
//
//  Created by yangjian on 2019/2/2.
//  Copyright © 2019 zhangshuyue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YJExtension)

/**
 生成毛玻璃图片
 
 @param theImage 需要改变的图片
 @return 毛玻璃图
 */
+ (UIImage *)createBlurImage:(UIImage *)theImage;

/**
 从图片中间抠出指定大小的图片
 
 @param image 原图
 @param centerSize 需要的大小
 @return 抠出来的图
 */
+(UIImage*)createNewImageFromRectangleImage:(UIImage *)image withNeedSize:(CGSize)centerSize;

@end

NS_ASSUME_NONNULL_END
