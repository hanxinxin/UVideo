//
//  LLSearchResultViewController.h
//  LLSearchView
//
//  Created by mac on 2021/6/1.
//  Copyright © 2021年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLSearchResultViewController : UIViewController

@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;

@end
