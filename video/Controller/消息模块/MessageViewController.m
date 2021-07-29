//
//  MessageViewController.m
//  video
//
//  Created by nian on 2021/5/11.
//

#import "MessageViewController.h"
#import "BottomView.h"
#import "MsgTableViewCell.h"
#import "MessageInfoMode.h"
#import "msgInfoViewController.h"

#define CellID @"MsgTableViewCell"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*downtableview1;
@property (nonatomic ,strong) NSMutableArray*Listarray1;
@property (nonatomic ,strong) NSMutableArray *deleteArray;//删除的数据

@property(nonatomic,assign)NSInteger page;

@property (nonatomic ,strong) UIButton *btn;//编辑按钮
@property (nonatomic ,assign) BOOL isInsertEdit;//tableview编辑方式的判断
@property (nonatomic ,strong) BottomView *bottom_view;//底部视图

///无内容显示view
@property (strong, nonatomic) UIView *nilView;
@property (strong, nonatomic) UIImageView * nilImageView;
@property (strong, nonatomic) UILabel * nilLabel;

@end

@implementation MessageViewController
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
    self.title=@"通知&公告";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.page=1;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    _isInsertEdit = NO;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];
    
    
    [self initnilView];
    [self Addtableview1];;
    
   
}
///// 加载无内容显示的view
-(void)initnilView
{
    self.nilView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.nilView.backgroundColor=[UIColor whiteColor];
    self.nilImageView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (self.view.height-40-200-kNavBarAndStatusBarHeight)/2, 250, 150)];
    [self.nilImageView setImage:[UIImage imageNamed:@"nilImage"]];
    [self.nilView addSubview:self.nilImageView];
    self.nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.nilImageView.left, self.nilImageView.bottom, self.nilImageView.width, 30)];
    [self.nilLabel setText:@"暂时没有消息和通知"];
    self.nilLabel.textAlignment=NSTextAlignmentCenter;
    [self.nilLabel setTextColor:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0]];
    [self.nilView addSubview:self.nilLabel];
}
//显示
-(void)addnilView
{
    self.nilView.hidden=NO;
    [self.view addSubview:self.nilView];
}
//删除
-(void)removeNilView
{
    self.nilView.hidden=YES;
//    [self.nilView removeFromSuperview];
}

-(void)Addtableview1
{
    Listarray1=[NSMutableArray arrayWithCapacity:0];
//    [Listarray1 addObject:@"播放记录"];
//    [Listarray1 addObject:@"充值记录"];
//    [Listarray1 addObject:@"账户信息"];
//    [Listarray1 addObject:@"帮助中心"];
//    [Listarray1 addObject:@"安全设置"];
//    [Listarray1 addObject:@"清理缓存"];
    self.downtableview1=[[UITableView alloc] init];
    self.downtableview1.frame=CGRectMake(20, 0, SCREEN_WIDTH-40, SCREENH_HEIGHT-kNavBarAndStatusBarHeight);
    self.downtableview1.backgroundColor=[UIColor whiteColor];
    self.downtableview1.delegate=self;
    self.downtableview1.dataSource=self;
    self.downtableview1.tag=10001;
    self.downtableview1.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.downtableview1.tableFooterView = [[UIView alloc]init];
    self.downtableview1.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.downtableview1 registerNib:[UINib nibWithNibName:NSStringFromClass([MsgTableViewCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    [self.view addSubview:self.downtableview1];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.downtableview1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getheaderData];
    }];
    // 第一次进入则自动加载
    [self.downtableview1.mj_header beginRefreshing];
    
    
    self.downtableview1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getfootData];
    }];
}

-(void)getheaderData
{
    
    
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page],@"pagesize":@"10"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,msgListurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview1.mj_header endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            NSNumber* message_total=[dictdata objectForKey:@"message_total"];
            NSArray* message_list=[dictdata objectForKey:@"message_list"];

            if([message_total intValue]==0)
            {
                ////显示无内容的view
                [self addnilView];
            }else
            {
                if(![message_list isKindOfClass:[NSNull class]]){
                    [self->Listarray1 removeAllObjects];
                    for (int i=0; i<message_list.count; i++) {
//                        [DYModelMaker DY_makeModelWithDictionary:message_list[i] modelKeyword:@"Message" modelName:@"infoMode"];
                        MessageInfoMode* mode=[MessageInfoMode yy_modelWithDictionary:message_list[i]];
                        [self->Listarray1 addObject:mode];
                    }
                    [self.downtableview1 reloadData];
                }
                
            }
        }else{
            ////显示无内容的view
            [self addnilView];
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            NSNumber * error = [dict objectForKey:@"error"];
            if([error intValue]!=21)
            {
                [UHud showTXTWithStatus:message delay:2.f];
            }else
            {
                if(![usertoken isEqualToString:@""])
                {
                    [UHud showTXTWithStatus:message delay:2.f];
                }
            }
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        ////显示无内容的view
        [self addnilView];
        [self.downtableview1.mj_header endRefreshing];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}
-(void)getfootData
{
    
    
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page+1],@"pagesize":@"50"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,msgListurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview1.mj_footer endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            NSNumber* message_total=[dictdata objectForKey:@"message_total"];
            NSArray* message_list=[dictdata objectForKey:@"message_list"];

            if([message_total intValue]==0)
            {
                
            }else
            {
                if(![message_list isKindOfClass:[NSNull class]]){
                    self.page+=1;
                    for (int i=0; i<message_list.count; i++) {
//                        [DYModelMaker DY_makeModelWithDictionary:message_list[i] modelKeyword:@"Message" modelName:@"infoMode"];
                        MessageInfoMode* mode=[MessageInfoMode yy_modelWithDictionary:message_list[i]];
                        [self->Listarray1 addObject:mode];
                    }
                    [self.downtableview1 reloadData];
                }
                
            }
        }else{
            NSString * message = [dict objectForKey:@"message"];
            NSNumber * error = [dict objectForKey:@"error"];
            if([error intValue]!=21)
            {
                [UHud showTXTWithStatus:message delay:2.f];
            }else
            {
                if(![usertoken isEqualToString:@""])
                {
                    [UHud showTXTWithStatus:message delay:2.f];
                }
            }
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [self.downtableview1.mj_footer endRefreshing];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

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
        MsgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[MsgTableViewCell alloc] init];
        }
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        //处理选中背景色问题
//        UIView *backGroundView = [[UIView alloc]init];
//        backGroundView.backgroundColor = [UIColor clearColor];
//        cell.selectedBackgroundView = backGroundView;
        
        cell.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth = 1;
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        cell.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
        cell.layer.shadowOffset = CGSizeMake(2,3);
        cell.layer.shadowRadius = 6;
        cell.layer.shadowOpacity = 1;
        cell.layer.cornerRadius = 8;
//        cell.readRedLabel.layer.cornerRadius=4;
        MessageInfoMode*model=Listarray1[indexPath.section];;
        cell.titleLabel.text=model.title;
        cell.miaoshuLabel.text=model.content;
        if(model.type == 1)
        {
            [cell.leftImage setImage:[UIImage imageNamed:@"xitongMsg"]];
        }else{
            [cell.leftImage setImage:[UIImage imageNamed:@"msgImage"]];
        }
        if(model.read_time==0)
        {
            cell.readRedLabel.hidden=NO;
        }else{
            cell.readRedLabel.hidden=YES;
        }
        
        
        return cell;
    }
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==10001)
    {
        return 70;
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
        return 10;
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
            MessageInfoMode*model=Listarray1[indexPath.section];
    //        msgInfoViewController*avc= [[msgInfoViewController alloc] init];
            msgInfoViewController * avc = [[UIStoryboard storyboardWithName: @"Main" bundle: nil] instantiateViewControllerWithIdentifier: @"msgInfoViewController"];
            avc.model=model;
            [self pushRootNav:avc animated:YES];
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
            frame.origin.y -= 50;
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
            point.y      += 50;
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
