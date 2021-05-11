//
//  UIImage+YJExtension.m
//  YJTool_Demo
//
//  Created by yangjian on 2019/2/2.
//  Copyright © 2019 zhangshuyue. All rights reserved.
//

#import "UIImage+YJExtension.h"

@implementation UIImage (YJExtension)

//毛玻璃
+(UIImage *)createBlurImage:(UIImage *)theImage{
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:20.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}

/**
 从图片中间抠出指定大小的图片
 
 @param image 原图
 @param centerSize 需要的大小
 @return 抠出来的图
 */
+(UIImage*)createNewImageFromRectangleImage:(UIImage *)image withNeedSize:(CGSize)centerSize{
    float imgWidth = image.size.width;
    float imgHeight = image.size.height;
    float viewWidth ;
    float viewHidth ;
    viewWidth = centerSize.width;
    viewHidth = centerSize.height;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake((imgWidth-viewWidth)/2*scale, (imgHeight-viewHidth)/2*scale, viewWidth*scale, viewHidth*scale);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
