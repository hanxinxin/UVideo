//
//  KJPlayerSystemLayer.h
//  video
//
//  Created by nian on 2021/7/29.
//

#import <QuartzCore/QuartzCore.h>
#import "KJPlayerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface KJPlayerSystemLayer : CALayer
@property (nonatomic,strong) UIColor *mainColor;
@property (nonatomic,strong) UIColor *viceColor;
@property (nonatomic,assign) BOOL isBrightness;
@property (nonatomic,assign) float value;

@end

NS_ASSUME_NONNULL_END
