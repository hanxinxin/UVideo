//
//  OfflineViewController.m
//  video
//
//  Created by nian on 2021/3/10.
//

#import "OfflineViewController.h"
#import "LXTableViewCell.h"
#import "BottomView.h"

#define cellID @"cellID"

@interface OfflineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*downtableview1;
@property (nonatomic ,strong) NSMutableArray*Listarray1;
@property (nonatomic ,strong) NSMutableArray *deleteArray;//删除的数据
@property (nonatomic ,strong) UIButton *btn;//编辑按钮
@property (nonatomic ,assign) BOOL isInsertEdit;//tableview编辑方式的判断
@property (nonatomic ,strong) BottomView *bottom_view;//底部视图

@end

@implementation OfflineViewController
@synthesize Listarray1;

- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        self.deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (UIButton *)btn{
    if (!_btn) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, 50, 44);
        [_btn setTitle:@"编辑" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitleColor:RGB(68,68,68) forState:(UIControlStateNormal)];
        [_btn addTarget:self action:@selector(BianjiBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
- (BottomView *)bottom_view{
    if (!_bottom_view) {
        self.bottom_view = [[BottomView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.width, 50)];
        _bottom_view.backgroundColor = [UIColor whiteColor];
        [_bottom_view.deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        _bottom_view.allBtn.selected=NO;
        [_bottom_view.allBtn addTarget:self action:@selector(tapAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        _bottom_view.allBtnImage.selected=NO;
        [_bottom_view.allBtnImage addTarget:self action:@selector(tapAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottom_view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.title=@"离线缓存";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    _isInsertEdit = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
    
    
    
    [self Addtableview1];;
    
    
}

-(void)Addtableview1
{
    Listarray1=[NSMutableArray arrayWithCapacity:0];
//    [Listarray addObject:[NSArray arrayWithObjects:@"播放记录",@"充值记录",@"账户信息",@"帮助中心",@"安全设置",@"清理缓存",@"退出登录", nil]];
//    [Listarray1 addObject:@"播放记录"];
    self.downtableview1=[[UITableView alloc] init];
    self.downtableview1.frame=CGRectMake(20, 0, SCREEN_WIDTH-40, SCREENH_HEIGHT-kNavBarAndStatusBarHeight-kTabBarHeight);
    self.downtableview1.backgroundColor=[UIColor whiteColor];
    self.downtableview1.delegate=self;
    self.downtableview1.dataSource=self;
    self.downtableview1.tag=10001;
    self.downtableview1.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.downtableview1.tableFooterView = [[UIView alloc]init];
//    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.downtableview1 registerNib:[UINib nibWithNibName:NSStringFromClass([LXTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.downtableview1];
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==10001)
    {
        return 1;
    }else if(tableView.tag==10002)
    {
        return 1;
    }
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag==10001)
    {
        return Listarray1.count;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView.tag==10001)
    {
        LXTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[LXTableViewCell alloc] init];
        }
        //cell选中效果
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //处理选中背景色问题
        UIView *backGroundView = [[UIView alloc]init];
        backGroundView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backGroundView;
        return cell;
    }
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==10001)
    {
        return 163;
    }else if(tableView.tag==10002)
    {
        return 60;
    }
    return 0;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView.tag==10001)
    {
        return 0;
    }else if(tableView.tag==10002)
    {
        return 10.f;
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
        return CGFLOAT_MIN;//最小数，相当于0
    }
    return 0;//机器不可识别，然后自动返回默认高度
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //自定义间隔view，可以不写默认用系统的
    UIView * view_c= [[UIView alloc] init];
    view_c.frame=CGRectMake(0, 0, 0, 0);
//    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    view_c.backgroundColor=[UIColor clearColor];
    return view_c;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //根据不同状态返回不同编辑模式
    if (_isInsertEdit) {
        
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
        
    }else{
        
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    //左滑删除数据方法
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.Listarray1 removeObjectAtIndex: indexPath.row];
        [self.downtableview1 deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.downtableview1 reloadData];
        
    }
}

//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==10001)
    {
        //正常状态下，点击cell进入跳转下一页
        //在编辑模式下点击cell 是选中数据
        if (self.btn.selected) {
             NSLog(@"选中");
            [self.deleteArray addObject:[self.Listarray1 objectAtIndex:indexPath.row]];

        }else{
            NSLog(@"跳转下一页");
        }
    }else if(tableView.tag==10002)
    {
        NSLog(@"10002index == %ld",indexPath.section);
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (self.btn.selected) {
        NSLog(@"撤销");
        [self.deleteArray removeObject:[self.Listarray1 objectAtIndex:indexPath.row]];
        
    }else{
        NSLog(@"取消跳转");
    }

    
}







-(void)BianjiBtn:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
    //点击编辑的时候清空删除数组
        [self.deleteArray removeAllObjects];
        [_btn setTitle:@"完成" forState:UIControlStateNormal];
        _isInsertEdit = YES;//这个时候是全选模式
        [self.downtableview1 setEditing:YES animated:YES];
        
        //如果在全选状态下，点击完成，再次进来的时候需要改变按钮的文字和点击状态
        if (_bottom_view.allBtn.selected) {
            _bottom_view.allBtn.selected = !_bottom_view.allBtn.selected;
            [_bottom_view.allBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        
            //添加底部视图
        CGRect frame = self.bottom_view.frame;
            frame.origin.y -= 45;
            [UIView animateWithDuration:0.5 animations:^{
                self.bottom_view.frame = frame;
                [self.view addSubview:self.bottom_view];
            }];
        
        
        
    }else{
        [_btn setTitle:@"编辑" forState:UIControlStateNormal];
        _isInsertEdit = NO;
        [self.downtableview1 setEditing:NO animated:YES];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint point = self.bottom_view.center;
            point.y      += 45;
            self.bottom_view.center   = point;
            
        } completion:^(BOOL finished) {
            [self.bottom_view removeFromSuperview];
        }];
    }
}

- (void)tapAllBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    _bottom_view.allBtn.selected=btn.selected;
    _bottom_view.allBtnImage.selected=btn.selected;
    if (btn.selected) {
        
        for (int i = 0; i< self.Listarray1.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            //全选实现方法
            [self.downtableview1 selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
        if (self.deleteArray.count >0) {
            [self.deleteArray removeAllObjects];
        }
        [self.deleteArray addObjectsFromArray:self.Listarray1];
        
        [btn setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        
        //取消选中
        for (int i = 0; i< self.Listarray1.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            [self.downtableview1 deselectRowAtIndexPath:indexPath animated:NO];
            
        }
        
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        [self.deleteArray removeAllObjects];
    }
  
  
//    NSLog(@"+++++%ld",self.deleteArray.count);
//    NSLog(@"===%@",self.deleteArray);
    
}
/**
 删除数据方法
 */
- (void)deleteData{
    if (self.deleteArray.count >0) {
        [self.Listarray1 removeObjectsInArray:self.deleteArray];
        [self.downtableview1 reloadData];
    }
    
}


@end
