//
//  LLSearchView.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchView.h"
static NSString *reuseId = @"LLSearchViewcell";
@interface LLSearchView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;

@end
@implementation LLSearchView

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.historyArray = historyArr;
        self.hotArray = hotArr;
        [self addSubview:self.searchHistoryView];
        [self addSubview:self.hotSearchView];
    }
    return self;
}


- (UIView *)hotSearchView
{
    if (!_hotSearchView) {
//        self.hotSearchView = [self setViewWithOriginY:CGRectGetHeight(_searchHistoryView.frame) title:@"热门搜索" textArr:self.hotArray];
        self.hotSearchView=[self sethotSearchViewM:CGRectGetHeight(_searchHistoryView.frame) title:@"热门搜索" textArr:self.hotArray];
    }
    return _hotSearchView;
}


- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (_historyArray.count > 0) {
            self.searchHistoryView = [self setViewWithOriginY:0 title:@"最近搜索" textArr:self.historyArray];
        } else {
            self.searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}



- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr
{
    UIView *view = [[UIView alloc] init];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30 - 45, 30)];
    titleL.text = title;
    [titleL setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
//    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
    
    if ([title isEqualToString:@"最近搜索"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH - 45, 10, 28, 30);
        [btn setImage:[UIImage imageNamed:@"sort_recycle"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    CGFloat y = 10 + 40;
    CGFloat letfWidth = 15;
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 30;
        if (letfWidth + width + 15 > SCREEN_WIDTH) {
            if (y >= 130 && [title isEqualToString:@"最近搜索"]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += 40;
            letfWidth = 15;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, 30)];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.text = text;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 5;
        label.textAlignment = NSTextAlignmentCenter;
//        if (i % 2 == 0 && [title isEqualToString:@"热门搜索"]) {
//            label.layer.borderColor = RGB(255, 148, 153).CGColor;
//            label.textColor = RGB(255, 148, 153);
//        } else {
//            label.textColor = RGB(111, 111, 111);
//            label.layer.borderColor = RGB(227, 227, 227).CGColor;
//        }
        label.textColor = RGB(111, 111, 111);
        label.layer.borderColor=[UIColor colorWithRed:239/255.0 green:248/255.0 blue:253/255.0 alpha:1.0].CGColor;
        label.backgroundColor=[UIColor colorWithRed:239/255.0 green:248/255.0 blue:253/255.0 alpha:1.0];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [view addSubview:label];
        letfWidth += width + 10;
    }
    view.frame = CGRectMake(0, riginY, SCREEN_WIDTH, y + 40);
    return view;
}
- (UIView *)sethotSearchViewM:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr
{
    UIView *view = [[UIView alloc] init];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30 - 45, 30)];
    titleL.text = title;
    [titleL setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
//    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
   
    UITableView * tableview = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.dataSource = self;
    tableview.delegate = self;// 22,39,79
    tableview.separatorColor = RGB(22, 39, 79);
    [tableview setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    tableview.estimatedRowHeight = 0;
    tableview.estimatedSectionFooterHeight = 0;
    tableview.estimatedSectionHeaderHeight = 0;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.frame = CGRectMake(15, 40, SCREEN_WIDTH, SCREENH_HEIGHT-riginY- titleL.bottom);
    [view addSubview:tableview];
    view.frame = CGRectMake(0, riginY, SCREEN_WIDTH, SCREENH_HEIGHT-riginY);
    return view;
}

- (UIView *)setNoHistoryView
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 30)];
    titleL.text = @"最近搜索";
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleL.frame) + 10, 100, 20)];
    notextL.text = @"无搜索历史";
    notextL.font = [UIFont systemFontOfSize:12];
    notextL.textColor = [UIColor blackColor];
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}

- (void)tagDidCLick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if (self.tapAction) {
        self.tapAction(label.text);
    }
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}


- (void)clearnSearchHistory:(UIButton *)sender
{
    [self.searchHistoryView removeFromSuperview];
    self.searchHistoryView = [self setNoHistoryView];
    [_historyArray removeAllObjects];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    [self addSubview:self.searchHistoryView];
    CGRect frame = _hotSearchView.frame;
    frame.origin.y = CGRectGetHeight(_searchHistoryView.frame);
    _hotSearchView.frame = frame;
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [NSKeyedArchiver archiveRootObject:testArr toFile:KHistorySearchPath];
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    if(indexPath.row<3)
    {
        UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, (cell.height-20)/2, 20, 20)];
        titleL.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
//        titleL.font = [UIFont systemFontOfSize:18];
        [titleL setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        titleL.textColor = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.layer.borderWidth = 0;
        titleL.layer.cornerRadius = 2;
        titleL.backgroundColor=[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0];
        titleL.layer.borderColor=[UIColor colorWithRed:255/255.0 green:136/255.0 blue:0/255.0 alpha:1.0].CGColor;
        [cell addSubview:titleL];
    }else{
        UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,(cell.height-20)/2, 20, 20)];
        titleL.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
//        titleL.font = [UIFont systemFontOfSize:18];
        [titleL setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        titleL.textColor = [UIColor blackColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.layer.borderWidth = 0;
        titleL.layer.cornerRadius = 2;
        titleL.backgroundColor=[UIColor clearColor];
        titleL.layer.borderColor=[UIColor clearColor].CGColor;
        [cell addSubview:titleL];
    }
    cell.textLabel.text =[NSString stringWithFormat:@" %@",self.hotArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   

}
@end
