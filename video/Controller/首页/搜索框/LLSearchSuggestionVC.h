//
//  LLSearchSuggestionVC.h
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuggestSelectBlock)(NSString *searchTest);
@interface LLSearchSuggestionVC : hxViewController

@property (nonatomic, copy) SuggestSelectBlock searchBlock;
@property(strong,nonatomic)NSMutableArray * dataArr;
@property (nonatomic, strong)NSString * keyword;

- (void)searchTestChangeWithTest:(NSString *)test;

@end
