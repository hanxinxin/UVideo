//
//  LLSearchView.h
//  LLSearchView
//
//  Created by mac on 2021/6/1.
//  Copyright © 2021年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapActionBlock)(NSString *str);
@interface LLSearchView : UIView

@property (nonatomic, copy) TapActionBlock tapAction;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;

@property (nonatomic, strong) UITableView * Downtableview;
- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr;


-(void)updatesearchHistoryView;

@end
