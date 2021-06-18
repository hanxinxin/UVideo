//
//  chongzhiListViewController.m
//  video
//
//  Created by macbook on 2021/5/11.
//

#import "chongzhiListViewController.h"

@interface chongzhiListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*downtableview;
@property(nonatomic,strong)NSMutableArray*arrtitle;
@property(nonatomic,strong)NSMutableArray*Darray;
@property(nonatomic,assign)NSInteger page;
@end

@implementation chongzhiListViewController
@synthesize arrtitle,Darray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navBarColor=[UIColor whiteColor];
//    self.hiddenLeftBtn=YES;
    self.title=@"充值记录";
    self.page=1;
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    [self Addtableview];
}

-(void)Addtableview
{
    arrtitle=[NSMutableArray arrayWithCapacity:0];
//    [arrtitle addObject:[NSArray arrayWithObjects:@"2021-10-22 19:32",@"2021-10-23 19:32",@"2021-10-24 19:32",@"2021-10-27 19:32", nil]];
    Darray=[NSMutableArray arrayWithCapacity:0];
//    [Darray addObject:[NSArray arrayWithObjects:@"会员年卡 99$",@"会员月卡 9.99$",@"会员月卡 9.99$",@"会员月卡 9.99$", nil]];
    self.downtableview=[[UITableView alloc] init];
    self.downtableview.frame=CGRectMake(20, 0, SCREEN_WIDTH-40, SCREENH_HEIGHT);
    self.downtableview.backgroundColor=[UIColor clearColor];
    self.downtableview.delegate=self;
    self.downtableview.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.downtableview];
    // 为瀑布流控件添加下拉加载和上拉加载
    self.downtableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getheaderData];
    }];
    // 第一次进入则自动加载
    [self.downtableview.mj_header beginRefreshing];
    
    
    self.downtableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getfootData];
    }];
}

-(void)getheaderData
{
    
    
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page],@"pagesize":@"50"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,rechargeRecordurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview.mj_header endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            
            NSNumber* recharge_record_total=[dictdata objectForKey:@"recharge_record_total"];
            if([recharge_record_total intValue]==0)
            {
                [UHud showTXTWithStatus:@"没有充值记录" delay:2.f];
            }else
            {
                
            }
        }else if([code intValue]==20){
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            [UHud showTXTWithStatus:message delay:2.f];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [self.downtableview.mj_header endRefreshing];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}
-(void)getfootData
{
    
    
    NSDictionary * dict = @{@"page":[NSString stringWithFormat:@"%ld",self.page+1],@"pagesize":@"50"};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,rechargeRecordurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        [self.downtableview.mj_footer endRefreshing];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            self.page+=1;
            
            NSNumber* recharge_record_total=[dictdata objectForKey:@"recharge_record_total"];
            if([recharge_record_total intValue]==0)
            {
                [UHud showTXTWithStatus:@"没有更多记录" delay:2.f];
            }else
            {
                
            }
            
        }else if([code intValue]==20){
            NSString * message = [dict objectForKey:@"message"];
//            [UHud showHUDToView:self.view text:message];
//            [SVProgressHUD mh_showAlertViewWithTitle:@"提示" message:message confirmTitle:@"确认"];
            [UHud showTXTWithStatus:message delay:2.f];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [self.downtableview.mj_footer endRefreshing];
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];

}



#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrtitle.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(arrtitle.count>0)
    {
        NSArray * arr = arrtitle[0];
        return arr.count;
    }else{
        return 0;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
//    NSLog(@"self.topView.bottom = %f , self.topView.height = %f",self.topView.bottom,self.topView.height);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray  * titleT=arrtitle[0];
    cell.textLabel.text = [titleT objectAtIndex:indexPath.section];
    NSArray  * titleI=Darray[0];
//    cell.imageView.image=[UIImage imageNamed:[titleI objectAtIndex:indexPath.section]];
    cell.detailTextLabel.text=[titleI objectAtIndex:indexPath.section];
    NSLog(@"section==== %ld",(long)indexPath.section);
    
    cell.backgroundColor = [UIColor whiteColor];

//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
 
    cell.textLabel.textColor = [UIColor darkGrayColor];
    //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
    cell.layer.borderWidth = 1;
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    cell.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2,3);
    cell.layer.shadowRadius = 6;
    cell.layer.shadowOpacity = 1;
    cell.layer.cornerRadius = 8;
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 10.f;
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
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index == %ld",indexPath.section);
}
@end
