//
//  menuBJViewController.m
//  video
//
//  Created by nian on 2021/6/4.
//

#import "menuBJViewController.h"
#import "PanView.h"
//头部高度
#define headerHeight 225
@interface menuBJViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView * tableview;
@property(strong,nonatomic)UIView * tittleView;
@property(strong,nonatomic)PanView * subView;
@property(strong,nonatomic)NSMutableDictionary  * dataDic;
@end

@implementation menuBJViewController
{
    CGFloat scrollerToRect;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择菜单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.subView];
    [self.view addSubview:self.tittleView];
    //点击标签后根据标签选择刷新数据
    self.subView.block = ^(NSString *labelText) {
        NSLog(@"====%@",labelText);
    };
}

//点击悬浮框
-(void)tabpAction{
    //滚动到顶部
//    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [UIView animateWithDuration:.5 animations:^{
        self.tittleView.alpha = 0;
        self.subView.frame = CGRectMake(0, 64, self.view.frame.size.width, headerHeight);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"假数据";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, headerHeight+64, self.view.bounds.size.width, self.view.bounds.size.height-(headerHeight+64)) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

//控制头部显示
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.subView.frame = CGRectMake(0,  -scrollerToRect+64, self.view.frame.size.width, headerHeight);
    NSLog(@"%lf",offsetY);
    if (offsetY > 0 && offsetY < headerHeight) {
        scrollerToRect = offsetY;
        self.subView.frame = CGRectMake(0,  -scrollerToRect+64, self.view.frame.size.width, headerHeight);
        self.tableview.frame = CGRectMake(0, headerHeight - offsetY, self.view.bounds.size.width, self.view.bounds.size.height - headerHeight + offsetY);
        if (offsetY>140) {
            if (headerHeight - offsetY  <= 105) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.tittleView.alpha = 1.0 - (headerHeight - offsetY)/105;
                }];
            }else{
                self.tittleView.alpha = 1;
            }
        }
    }else if(offsetY<=0) {
        self.subView.frame = CGRectMake(0, 64, self.view.frame.size.width, headerHeight);
        self.tableview.frame = CGRectMake(0, headerHeight + 64, self.view.bounds.size.width, self.view.bounds.size.height-headerHeight);
        self.tittleView.alpha = 0;
    }else{
        self.tittleView.alpha = 1;
    }
}
-(UIView *)tittleView{
    if (!_tittleView) {
        _tittleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
        _tittleView.backgroundColor = [UIColor grayColor];
        _tittleView.alpha = 0;
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 10, 100, 30)];
        [button setTitle:@"综合排序" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(tabpAction) forControlEvents:UIControlEventTouchUpInside];
        [_tittleView addSubview:button];
    }
    return _tittleView;
}
-(PanView *)subView{
    if (!_subView) {
        _subView = [[PanView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, headerHeight) WithTextDic:self.dataDic];
    }
    return _subView;
}
-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        //制造假数据
        _dataDic = [NSMutableDictionary dictionary];
        [_dataDic setValue:@[@"综合排序",@"热播榜",@"好评榜",@"新上线"] forKey:@"1"];
        [_dataDic setValue:@[@"全部地区",@"华语",@"香港地区",@"美国",@"欧洲",@"韩国",@"日本",@"泰国"] forKey:@"2"];
        [_dataDic setValue:@[@"全部类型",@"喜剧",@"爱情",@"动作",@"抢占",@"犯罪",@"伦理",@"色情"] forKey:@"3"];
        [_dataDic setValue:@[@"全部规格",@"巨制",@"院线",@"独播",@"网络大电影",@"经典",@"杜比",@"电影节目"] forKey:@"4"];
        [_dataDic setValue:@[@"全部年份",@"2019",@"2018",@"2017",@"2016",@"2015",@"2000",@"1900"] forKey:@"5"];
        [_dataDic setValue:@[@"是否付费",@"免费",@"付费"] forKey:@"6"];
    }return _dataDic;
}
@end
