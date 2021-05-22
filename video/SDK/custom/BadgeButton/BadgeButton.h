//
//  BadgeButton.h
//  S2Maneger
//
//  Created by nian on 2021/5/21.
//  Copyright © 2021 nian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BadgeButton : UIButton
@property (nonatomic) NSInteger badgeValue;

@property (nonatomic, assign) BOOL isRedBall;

@property (nonatomic, strong) UILabel *badgeLab;
@end

NS_ASSUME_NONNULL_END
