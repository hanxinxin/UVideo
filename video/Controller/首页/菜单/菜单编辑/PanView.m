//
//  PanView.m
//  PanYuanFeng
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 lianzhonghulian. All rights reserved.
//

#import "PanView.h"
#import "PanTableViewCell.h"
#define KWidth [UIScreen mainScreen].bounds.size.width
@interface PanView()<UITableViewDelegate,UITableViewDataSource,SelectWhichlabelDelegete>

@property(strong,nonatomic)UITableView * mainView;
@property(strong,nonatomic)NSDictionary * dataDic;

@end

@implementation PanView

-(instancetype)initWithFrame:(CGRect)frame WithTextDic:(NSDictionary *)textDic{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingNone;
        self.dataDic = textDic;
        [self.mainView reloadData];
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews{
    self.mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 220) style:UITableViewStylePlain];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainView.scrollEnabled = NO;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self addSubview:self.mainView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataDic allKeys].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"PanTableViewCell";
    PanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.deleget = self;
    cell.dataArr = [self.dataDic valueForKey:@(indexPath.row+1).description];
    return cell;
}

//点击选择的某个标签
-(void)SelectWhichlabel:(NSString *)labelText{
    if (self.block) {
        self.block(labelText);
    }
}

@end
