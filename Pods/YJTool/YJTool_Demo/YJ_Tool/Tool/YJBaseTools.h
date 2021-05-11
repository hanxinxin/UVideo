//
//  YJBaseTools.h
//  YJTool_Demo
//
//  Created by yangjian on 2019/7/16.
//  Copyright © 2019 zhangshuyue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJBaseTools : NSObject

/*
 弹窗效果
 */
//弹出普通样式的alert 标题为默认的“提示”
+ (void)showAltMsg:(NSString *)msg;


+ (void)showAltView:(UIView *)altView;


@end

NS_ASSUME_NONNULL_END
