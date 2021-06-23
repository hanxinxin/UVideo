//
//  LLSearchResultDoubleViewCell.h
//  LLSearchView
//
//  Created by mac on 2021/6/1.
//  Copyright © 2021年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWidth (SCREEN_WIDTH > 375 ? 576/3 : 345/2)
#define kSpace (SCREEN_WIDTH - KWidth * 2) / 3

@interface LLSearchResultDoubleViewCell : UITableViewCell

- (void)configResultDoubleViewCellWithFirstTitle:(NSString *)firstTitle secondTitle:(NSString *)secondTitle;

@end
