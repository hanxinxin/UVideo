//
//  FankuiViewController.m
//  video
//
//  Created by macbook on 2021/6/20.
//

#import "FankuiViewController.h"
#import "FKTextTableViewCell.h"
#import "FKnumberTableViewCell.h"
#import "feedbacktypeMode.h"

#define cellID2 @"FKTextTableViewCell"
#define cellID3 @"FKnumberTableViewCell"
@interface FankuiViewController  ()<UITableViewDelegate,UITableViewDataSource,ZGQActionSheetViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
{
    FKTextTableViewCell* cellT;
    FKnumberTableViewCell* cellP;
}
@property(nonatomic,strong)UITableView*downtableview;
@property(nonatomic,strong)NSMutableArray * titleArray;
@property(nonatomic,strong)NSString* tjType;
@property(nonatomic,strong)NSString* tjneirong;
@property(nonatomic,strong)NSString* tjxlfs;
@property(nonatomic,assign)NSInteger selectIndex;
@end

@implementation FankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"反馈菜单";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    self.tjneirong=@"";
    self.tjxlfs=@"";
    self.selectIndex=0;
    self.titleArray=[NSMutableArray arrayWithCapacity:0];
    [self Addtableview];
    // 点击空白处收键盘
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.delegate=self;
        [self.view addGestureRecognizer:singleTap];
        
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getlistData];
}
#pragma mark --收起键盘
// 滑动空白处隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UITableViewCell class]] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] ){
        
        return NO;
    }else{
        return YES;
    }
}
// 点击空白处收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    [self.view endEditing:YES];
}

-(void)Addtableview
{

    self.downtableview=[[UITableView alloc] init];
    self.downtableview.frame=CGRectMake(20, 0, SCREEN_WIDTH-40, SCREENH_HEIGHT-kNavBarAndStatusBarHeight);
    self.downtableview.backgroundColor=[UIColor clearColor];
    self.downtableview.delegate=self;
    self.downtableview.dataSource=self;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.downtableview];
    [self.downtableview registerNib:[UINib nibWithNibName:NSStringFromClass([FKTextTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID2];
    [self.downtableview registerNib:[UINib nibWithNibName:NSStringFromClass([FKnumberTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID3];
    
    self.XGBtn= [[UIButton alloc] init];
    self.XGBtn.frame = CGRectMake(0,self.downtableview.height-90,self.downtableview.width,50);
    self.XGBtn.alpha = 1;
    self.XGBtn.layer.cornerRadius = 10;
    self.XGBtn.backgroundColor=RGBA(20, 155, 236, 1);
    [self.XGBtn setTitle:@"提交反馈" forState:(UIControlStateNormal)];
    [self.XGBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [button1.layer insertSublayer:[self selectLayer:CGRectMake(0, 0, button1.width, button1.height)]atIndex:0];
    [self.XGBtn addTarget:self action:@selector(XG_touch:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.downtableview addSubview:self.XGBtn];
    
}

-(void)XG_touch:(id)sender
{
    self.tjneirong=cellT.NeiRongTextView.text;
    self.tjxlfs=cellP.right_textfield.text;
//    if(self.typeInt==1001)
//    {
//        self.tjType=self.titleArray[0];
//    }else if(self.typeInt==1002)
//    {
//        self.tjType=self.titleArray[1];
//    }
    if(self.tjneirong.length>1)
    {
        feedbacktypeMode*mode=self.titleArray[self.selectIndex];
        NSDictionary * dict=@{@"category_id":[NSString stringWithFormat:@"%ld",(long)mode.id],
                              @"content":self.tjneirong
        };
        [self postFankui:dict];
    }else{
        [UHud showTXTWithStatus:@"请输入反馈内容" delay:2.f];
    }
}

-(void)postFankui:(NSDictionary*)dict
{
    [UHud showHUDLoading];
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,postfeedbackdurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
//            NSDictionary *dictdata =[dict objectForKey:@"data"];
            
            [UHud showTXTWithStatus:@"提交成功" delay:2.f];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showTXTWithStatus:message delay:2.f];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
}
-(void)getlistData
{
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,postfeedbackcategoryurl] Dictionary:nil success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            [self.titleArray removeAllObjects];
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            NSArray * feedback_category_list=[dictdata objectForKey:@"feedback_category_list"];
            if(![feedback_category_list isKindOfClass:[NSNull class]]){
            for (int i =0; i<feedback_category_list.count; i++) {
                NSDictionary * modeDict=feedback_category_list[i];
                feedbacktypeMode*mode=[feedbacktypeMode yy_modelWithDictionary:modeDict];
                [self.titleArray addObject:mode];
            }
            
            }
            [self.downtableview reloadData];
        }else{
            NSString * message = [dict objectForKey:@"message"];
            [UHud showTXTWithStatus:message delay:2.f];
        }

    } failure:^(NSError * _Nullable error) {
        [UHud hideLoadHud];
        NSLog(@"shareManager error == %@",error);
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        }
        UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
        lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
        lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [cell.contentView addSubview:lbl];
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"section==== %ld",(long)indexPath.section);
        cell.textLabel.text=@"问题分类";
        if(self.titleArray.count>0)
        {
            if(self.typeInt==1001)
            {
                for (int i =0; i<self.titleArray.count; i++) {
                    feedbacktypeMode*mode=self.titleArray[i];
                    if([mode.name isEqual:@"求片"])
                    {
                        cell.detailTextLabel.text=mode.name;
                    }
                }
            }else if(self.typeInt==1002)
            {
                for (int i =0; i<self.titleArray.count; i++) {
                    feedbacktypeMode*mode=self.titleArray[i];
                    if([mode.name isEqual:@"BUG报错"])
                    {
                        cell.detailTextLabel.text=mode.name;
                    }
                }
            }
//            feedbacktypeMode*mode=self.titleArray[self.selectIndex];
//            cell.detailTextLabel.text=mode.name;
        }
        cell.backgroundColor = [UIColor whiteColor];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
     
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
    }else if(indexPath.section==1)
    {
         cellT = [tableView dequeueReusableCellWithIdentifier:cellID2];
    if (cellT == nil) {
        cellT = [[FKTextTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID2];
    }
    //cell选中效果
        cellT.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"section==== %ld",(long)indexPath.section);
//        cellT.NeiRongTextView.delegate=self;
        cellT.backgroundColor = [UIColor whiteColor];
        cellT.NeiRongTextView.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        cellT.NeiRongTextView.layer.borderWidth = 1;
        cellT.NeiRongTextView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        cellT.NeiRongTextView.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
        cellT.NeiRongTextView.layer.shadowOffset = CGSizeMake(2,3);
        cellT.NeiRongTextView.layer.shadowRadius = 6;
        cellT.NeiRongTextView.layer.shadowOpacity = 1;
        cellT.NeiRongTextView.layer.cornerRadius = 8;
        
    return cellT;
    }else if(indexPath.section==2)
    {
    cellP = [tableView dequeueReusableCellWithIdentifier:cellID3];
    if (cellP == nil) {
        cellP = [[FKnumberTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID3];
    }
    //cell选中效果
        cellP.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"section==== %ld",(long)indexPath.section);
    
        cellP.backgroundColor = [UIColor whiteColor];
        cellP.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
        cellP.layer.borderWidth = 1;
        cellP.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        cellP.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:0.30].CGColor;
        cellP.layer.shadowOffset = CGSizeMake(2,3);
        cellP.layer.shadowRadius = 6;
        cellP.layer.shadowOpacity = 1;
        cellP.layer.cornerRadius = 8;
        
    return cellP;
    }
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 50;
    }else if(indexPath.section==1)
    {
        return 290;
    }else if(indexPath.section==2)
    {
        return 50;
    }
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
    if(indexPath.section==0)
    {
        [self ShowProfilePhoto:self.titleArray];
    }
}

-(void)ShowProfilePhoto:(NSArray *)array
{
    
    NSMutableArray * arrtitle=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<array.count; i++) {
        feedbacktypeMode*mode=array[i];
        [arrtitle addObject:mode.name];
    }
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:arrtitle];
    sheetView.tag=101;
    sheetView.delegate = self;
    [sheetView show];
}
- (void)ZGQActionSheetView:(ZGQActionSheetView *)sheetView didSelectRowAtIndex:(NSInteger)index text:(NSString *)text {
    NSLog(@"%zd,%@",index,text);
    if(sheetView.tag==101)
    {
            self.selectIndex=index;
        
        [self.downtableview reloadData];
    }
   
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range

 replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {

        [textView resignFirstResponder];

        return NO;

    }

    return YES;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
@end
