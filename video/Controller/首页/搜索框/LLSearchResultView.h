//
//  LLSearchResultView.h
//  LLSearchView
//
//  Created by mac on 2021/6/1.
//  Copyright © 2021年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLSearchResultView : UIView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSMutableArray *)dataArr;

- (void)refreshResultViewWithIsDouble:(BOOL)isDouble;

@end
