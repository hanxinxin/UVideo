//
//  LLSearchSuggestionVC.h
//  LLSearchView
//
//  Created by mac on 2021/6/1.
//  Copyright © 2021年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuggestSelectBlock)(NSString *searchTest);
@interface LLSearchSuggestionVC : hxViewController

@property (nonatomic, copy) SuggestSelectBlock searchBlock;
@property(strong,nonatomic)NSMutableArray * dataArr;
@property (nonatomic, strong)NSString * keyword;

- (void)searchTestChangeWithTest:(NSString *)test;

@end
