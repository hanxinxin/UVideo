//
//  LLSearchView.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchView.h"
#import "WSLWaterFlowLayout.h"
#import "zjssCollectionViewCell.h"

static NSString *reuseId = @"LLSearchViewcell";
static NSString *CollectionCellID=@"zjssCollectionViewCell";
@interface LLSearchView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>



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
    ///清除搜索记录按钮
    UIButton *qcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qcBtn.frame=CGRectMake(titleL.right, 10, 30, 30);
            [qcBtn addTarget:self action:@selector(DeleteQC_touch:) forControlEvents:UIControlEventTouchUpInside];
    [qcBtn setImage:[UIImage imageNamed:@"DetSSJL"] forState:(UIControlStateNormal)];
    [view addSubview:qcBtn];
//    if ([title isEqualToString:@"最近搜索"]) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(SCREEN_WIDTH - 45, 10, 28, 30);
//        [btn setImage:[UIImage imageNamed:@"sort_recycle"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:btn];
//    }
    
    CGFloat y = 10 + 40;
    CGFloat letfWidth = 15;
    CGFloat jc=1;
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 30;
        if (letfWidth + width + 15 > SCREEN_WIDTH) {
            if (y >= 130 && [title isEqualToString:@"最近搜索"]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += 40;
            jc+=1;
            letfWidth = 15;
        }
        letfWidth += width + 10;
    }
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, 30)];
//        label.userInteractionEnabled = YES;
//        label.font = [UIFont systemFontOfSize:12];
//        label.text = text;
//        label.layer.borderWidth = 0.5;
//        label.layer.cornerRadius = 5;
//        label.textAlignment = NSTextAlignmentCenter;
////        if (i % 2 == 0 && [title isEqualToString:@"热门搜索"]) {
////            label.layer.borderColor = RGB(255, 148, 153).CGColor;
////            label.textColor = RGB(255, 148, 153);
////        } else {
////            label.textColor = RGB(111, 111, 111);
////            label.layer.borderColor = RGB(227, 227, 227).CGColor;
////        }
//        label.textColor = RGB(111, 111, 111);
//        label.layer.borderColor=[UIColor colorWithRed:239/255.0 green:248/255.0 blue:253/255.0 alpha:1.0].CGColor;
//        label.backgroundColor=[UIColor colorWithRed:239/255.0 green:248/255.0 blue:253/255.0 alpha:1.0];
//        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
//        [view addSubview:label];
//        letfWidth += width + 10;
//    }
    
    WSLWaterFlowLayout * layout = [[WSLWaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    
//    long aheight = textArr.count/4;
    // 创建瀑布流view
    UICollectionView *collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH-30 ,y-50) collectionViewLayout:layout];
    // 设置数据源
    collectionView1.dataSource = self;
    collectionView1.delegate=self;
    collectionView1.backgroundColor = [UIColor clearColor];
    // 是否滚动//
    collectionView1.scrollEnabled = YES;
    
//        [collectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(@0);
//            make.width.mas_equalTo(self.subView.width);
//            make.height.equalTo(@370);
//        }];
    
    // 注册cell
    [collectionView1 registerNib:[UINib nibWithNibName:NSStringFromClass([zjssCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:CollectionCellID];
    self.collectionView=collectionView1;
    [view addSubview:collectionView1];
    
    
    view.frame = CGRectMake(0, riginY, SCREEN_WIDTH, y + 40+(jc*5));
    self.collectionView.frame=CGRectMake(15, titleL.bottom, SCREEN_WIDTH-30 ,view.height-titleL.top-titleL.height);
    return view;
}
-(void)DeleteQC_touch:(id)sender
{
    NSLog(@"清除搜索记录");
    [self clearnSearchHistory:sender];
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
    self.Downtableview=tableview;
    view.frame = CGRectMake(0, riginY, SCREEN_WIDTH, SCREENH_HEIGHT-riginY);
    return view;
}

- (UIView *)setNoHistoryView
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 30)];
    titleL.text = @"最近搜索";
    [titleL setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
//    titleL.font = [UIFont systemFontOfSize:15];
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
    CGFloat width = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil].size.width;
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

-(void)updatesearchHistoryView
{
    [self.searchHistoryView removeFromSuperview];
    self.searchHistoryView = [self setViewWithOriginY:0 title:@"最近搜索" textArr:self.historyArray];
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
        UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,(cell.height-20)/2, 30, 20)];
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
    VideoRankMode*model=self.hotArray[indexPath.row];
    NSString *text = model.title;
    cell.textLabel.text =[NSString stringWithFormat:@" %@",text];
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
    VideoRankMode*model=self.hotArray[indexPath.row];
    NSString *text = model.title;
    if (self.tapAction) {
        self.tapAction(text);
    }

}


#pragma mark - <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.historyArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    zjssCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
    NSString *text = self.historyArray[indexPath.item];
    cell.titleText.text=text;
    // 返回cell
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index.item== %ld",(long)indexPath.item);
    NSString *text = self.historyArray[indexPath.item];
    if (self.tapAction) {
        self.tapAction(text);
    }
    
}

#pragma mark - WSLWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = self.historyArray[indexPath.item];
    CGFloat width = [self getWidthWithStr:text] + 30;
        return CGSizeMake(width, 30);
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 4;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 10;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
@end
