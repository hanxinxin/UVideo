//
//  GGCustomStepper.h
//  GGCustomStepper
//
//  Created by LGQ on 16/3/2.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自定义的加减量控件, 样式仿照京东等商城改变商品数量控件
 */

@class GGCustomStepper;

/// value 改变之后调用 block
typedef void(^GGStepperValueChangeBlock)(double oldValue, double newValue);

@protocol GGCustomStepperDelegate <NSObject>

- (void)customStepper:(GGCustomStepper * _Nonnull)customStepper changeValue:(double)newValue oldValue:(double)oldValue;

@end


@interface GGCustomStepper : UIView

/** 长按是否一直触发变化,默认yes */
@property (nonatomic, assign) BOOL autorepeat;
/** 是否可以手动输入数值,默认yes */
@property (nonatomic, assign) BOOL inputValue;

/** 当前值,默认0.0 */
@property (nonatomic, assign) double value;
/** 最小值, 默认0.0 */
@property (nonatomic, assign) double minimumValue;
/** 最大值, 默认 CGFLOAT_MAX */
@property (nonatomic, assign) double maximumValue;
/** 每次更变值, 默认1.0 */
@property (nonatomic, assign) double stepValue;

/** 每次 value 的值改变时会调用 block 或者代理, 传出旧值和新值
    block的优先级高于代理
 */
@property (nonatomic, copy, nullable) GGStepperValueChangeBlock valueChange;
@property (nonatomic, weak, nullable) id<GGCustomStepperDelegate> delegate;


/** 文本字号 */
@property (nullable, nonatomic, strong) UIFont *textFont;
/** 文本颜色 */
@property (nullable, nonatomic, strong) UIColor *textColor;

/** 显示数量lable宽度占比, 默认 0.4 */
@property (nonatomic, assign) CGFloat amountLabelScale;

/** 线条颜色, 默认lightGrayColor */
@property (nullable, nonatomic, strong) UIColor *lineColor;
/** 线条宽度, 默认0.5 */
@property (nonatomic, assign) CGFloat lineWidth;

/// 统一设置方法
- (void)setTextFont:(nullable UIFont *)textFont textColor:(nullable UIColor *)textColor;


/// 加/减量按钮的背景图
- (void)setBackgroundImageWithColor:(nullable UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundImage:(nullable UIImage*)image forState:(UIControlState)state;
- (nullable UIImage*)backgroundImageForState:(UIControlState)state;

/// 加量按钮的图标
- (void)setIncrementImage:(nullable UIImage *)image forState:(UIControlState)state;
- (nullable UIImage *)incrementImageForState:(UIControlState)state ;

/// 减量按钮的图标
- (void)setDecrementImage:(nullable UIImage *)image forState:(UIControlState)state;
- (nullable UIImage *)decrementImageForState:(UIControlState)state;



@end

