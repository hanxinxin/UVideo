//
//  HQCustomButton.m
//  GeneROV
//
//  Created by nian on 2021/2/22.
//  Copyright © 2021 Mileda. All rights reserved.
//

#import "HQCustomButton.h"

@implementation HQCustomButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 修改 title 的 frame */
    // 1.获取 titleLabel 的 frame
    CGRect titleLabelFrame = self.titleLabel.frame;
    // 2.修改 titleLabel 的 frame
    
    
    titleLabelFrame.origin.x = (self.frame.size.width-self.titleLabel.frame.size.width-self.imageView.frame.size.width)/2;
    // 3.重新赋值
    self.titleLabel.frame = titleLabelFrame;
    
    /** 修改 imageView 的 frame */
    // 1.获取 imageView 的 frame
    CGRect imageViewFrame = self.imageView.frame;
    // 2.修改 imageView 的 frame
    imageViewFrame.origin.x = CGRectGetMaxX(self.titleLabel.frame);
    // 3.重新赋值
    self.imageView.frame = imageViewFrame;
}
@end
