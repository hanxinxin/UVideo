//
//  LLSearchResultDoubleViewCell.h
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWidth (SCREEN_WIDTH > 375 ? 576/3 : 345/2)
#define kSpace (SCREEN_WIDTH - KWidth * 2) / 3

@interface LLSearchResultDoubleViewCell : UITableViewCell

- (void)configResultDoubleViewCellWithFirstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle;

@end
