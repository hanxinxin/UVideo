//
//  NewFAQViewController.m
//  video
//
//  Created by macbook on 2021/6/21.
//

#import "NewFAQViewController.h"
#import "lxkfViewController.h"

#import "SCJTableViewCell.h"
#import "SliderTableViewCell.h"
#import "FAQTableViewCell.h"
#import "KFView.h"
#import "WSLWaterFlowLayout.h"
#import "PanCollectionViewCell.h"

#import "customerInfoMode.h"

#define cellID @"cellID"
#define cellID2 @"SliderTableViewCell"
#define cellID3 @"FAQTableViewCell"

#define collcellID @"PanCollectionViewCell"


@implementation faqcategorymodel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
  return @{@"Id" : @"id"};
}
@end

@implementation faqListInfomodel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
  return @{@"Id" : @"id"};
}
@end


@interface NewFAQViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,YTSliderViewDelegate,CAAnimationDelegate>
@property(nonatomic,strong)UIView*topView;
@property(nonatomic,strong)UICollectionView*topcollectionview;
@property (nonatomic ,strong)NSMutableArray*FAQListArray;
@property(nonatomic,strong)UITableView*downtableview1;
@property (nonatomic ,strong)NSMutableArray*Listarray1;
@property (nonatomic ,assign)NSInteger indexItem;

@property(nonatomic,strong)CAGradientLayer *gl1n;
@property(nonatomic,strong)CAGradientLayer *gl1y;
///无内容显示view
@property (strong, nonatomic) UIView *nilView;
@property (strong, nonatomic) UIImageView * nilImageView;
@property (strong, nonatomic) UILabel * nilLabel;


///客服view
@property (strong, nonatomic) KFView*kfView;

@property (nonatomic ,strong)NSMutableArray*kefuArray;
@end

@implementation NewFAQViewController
@synthesize topView,Listarray1;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title=@"常见问题";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    self.kefuArray=[NSMutableArray arrayWithCapacity:0];
    self.FAQListArray=[NSMutableArray arrayWithCapacity:0];
    Listarray1=[NSMutableArray arrayWithCapacity:0];
    self.indexItem=0;
    //下载按钮
    UIButton *rightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 25)];
    [rightItem setTitle:@" 联系客服" forState:(UIControlStateNormal)];
    [rightItem setTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0]];
    [rightItem setImage:[UIImage imageNamed:@"helpimage"] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(right_touch:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtnV=rightItem;
    
    [self addtopview];
    [self Addtableview1];
    [self initnilView];
    [self addPWViewM];
    [self getFAQData];
    [self getcustomerServicelistData];
}

-(void)right_touch:(id)sender
{
//    lxkfViewController * avc = [[UIStoryboard storyboardWithName: @"Main" bundle: nil] instantiateViewControllerWithIdentifier: @"lxkfViewController"];
//    [self pushRootNav:avc animated:YES];
    
    if(self.kefuArray.count>0)
    {
        customerInfoMode*model=self.kefuArray[0];
        [self.kfView.EWMImage sd_setImageWithURL:[NSURL URLWithString:model.wechat_qrcode]];
    }
    [self showkfView];
}

-(void)getFAQData
{
    
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,postfaqcategoryurl] Dictionary:nil success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            
            NSArray* faq_category_list=[dictdata objectForKey:@"faq_category_list"];
            if(![faq_category_list isKindOfClass:[NSNull class]]){
            if(faq_category_list.count>=0)
            {
                [self.FAQListArray removeAllObjects];
                for (int i=0; i<faq_category_list.count; i++) {
                    faqcategorymodel*model=[faqcategorymodel yy_modelWithDictionary:faq_category_list[i]];
                    [self.FAQListArray addObject:model];
                }
                
            
            }
            }
            faqcategorymodel * model=self.FAQListArray[self.indexItem];
            [self getFAQListData:model];
            [self.topcollectionview reloadData];
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
-(void)getFAQListData:(faqcategorymodel*)model
{
    
    NSDictionary* dict=@{@"category_id":[NSString stringWithFormat:@"%.f",model.id]};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,postfaqlisturl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            
            NSArray* faq_list=[dictdata objectForKey:@"faq_list"];
            if(![faq_list isKindOfClass:[NSNull class]]){
            if(faq_list.count>=0)
            {
                [self.Listarray1 removeAllObjects];
                for (int i=0; i<faq_list.count; i++) {
                    faqListInfomodel*model=[faqListInfomodel yy_modelWithDictionary:faq_list[i]];
                    [self.Listarray1 addObject:model];
                }
                
            
            }
            }
            [self.downtableview1 reloadData];
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

///// 加载无内容显示的view
-(void)initnilView
{
    self.nilView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height-40)];
    self.nilView.backgroundColor=[UIColor whiteColor];
    self.nilImageView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (self.view.height-40-200-kNavBarAndStatusBarHeight)/2, 250, 150)];
    [self.nilImageView setImage:[UIImage imageNamed:@"nilImage"]];
    [self.nilView addSubview:self.nilImageView];
    self.nilLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.nilImageView.left, self.nilImageView.bottom, self.nilImageView.width, 30)];
    [self.nilLabel setText:@"暂无记录"];
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

-(void)addPWViewM{
    KFView *view = [[[NSBundle mainBundle]loadNibNamed:@"KFView" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.8];
    view.hidden=YES;
    view.alpha=0.0;
    view.frame=CGRectMake(0, 0, 0, SCREENH_HEIGHT);
//    view.bottomView.layer.cornerRadius=10;
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft;
    [view.bottomView setBorderWithCornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor] type:corners];
    view.bottomView.frame=CGRectMake(0, 0, 0, 360);
    [self.view addSubview:view];
    self.kfView=view;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        view.bottomView.frame=CGRectMake(0, self.kfView.height-360, 0, 360);
        self.kfView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavBarAndStatusBarHeight);
        self.kfView.bottomView.frame=CGRectMake(0, self.kfView.height-360, SCREEN_WIDTH, 360);
        });
    __weak NewFAQViewController * weakSelf = self;
    self.kfView.touchIndex = ^(NSInteger Index) {
        
        NSLog(@"prompt idnex ==== %ld",Index);
        if(Index==0)
        {
            
        }else{
            
        }
        [weakSelf HidkfView];
    };
}

-(void)showkfView
{
    
    [UIView animateWithDuration:0.5 animations:^{
//        self.kfView.bottomView.hidden=NO;
//        self.kfView.hidden=NO;
//        self.kfView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT-kNavBarAndStatusBarHeight);
//        self.kfView.bottomView.frame=CGRectMake(0, self.kfView.height-360, SCREEN_WIDTH, 360);
        self.kfView.hidden=NO;
        self.kfView.alpha=1.0;
    } completion:^(BOOL finished) {
        self.kfView.alpha=1.0;
    }];
    
   
    
}
-(void)HidkfView
{
    
    [UIView animateWithDuration:0.5 animations:^{
//        self.kfView.bottomView.hidden=YES;
//        self.kfView.frame=CGRectMake(0, 0, 0,SCREENH_HEIGHT );
//        self.kfView.bottomView.frame=CGRectMake(0, self.kfView.height-360, 0, 360);
//        self.kfView.hidden=YES;
        self.kfView.alpha=0.0;
    } completion:^(BOOL finished) {
        self.kfView.hidden=YES;
    }];
        
}


-(void)addtopview
{
    topView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 60)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 5);
    self.topcollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, topView.bounds.size.width, 50) collectionViewLayout:flowLayout];
    [self.topcollectionview registerNib:[UINib nibWithNibName:@"PanCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PanCollectionViewCell"];
    
    self.topcollectionview.backgroundColor = [UIColor whiteColor];
    self.topcollectionview.delegate = self;
    self.topcollectionview.dataSource = self;
    self.topcollectionview.showsHorizontalScrollIndicator = NO;
    [self.topView addSubview:self.topcollectionview];
    
//    _gl1y=[self selectLayer:CGRectMake(0, 0, ((SCREEN_WIDTH-40-16)/3), 40)];
//    _gl1n=[self NormalLayer:CGRectMake(0, 0, ((SCREEN_WIDTH-40-16)/3), 40)];
}
-(void)Addtableview1
{
    

    self.downtableview1=[[UITableView alloc] init];
    self.downtableview1.frame=CGRectMake(0, topView.bottom, self.view.width, SCREENH_HEIGHT-topView.bottom-kNavBarAndStatusBarHeight-10);
    self.downtableview1.backgroundColor=[UIColor whiteColor];
    self.downtableview1.delegate=self;
    self.downtableview1.dataSource=self;
    self.downtableview1.tag=10001;
    self.downtableview1.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.downtableview1.tableFooterView = [[UIView alloc]init];
//    self.downtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.downtableview1 registerNib:[UINib nibWithNibName:NSStringFromClass([FAQTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID3];
    [self.view addSubview:self.downtableview1];
}
-(CAGradientLayer*)selectLayer:(CGRect)frame
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = frame;
    gl.cornerRadius=10;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:20/255.0 green:155/255.0 blue:236/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    return gl;
}
-(CAGradientLayer*)NormalLayer:(CGRect)frame
{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = frame;
    gl.cornerRadius=10;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    return gl;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.FAQListArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(((SCREEN_WIDTH-40-16)/3), 40) ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PanCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"PanCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
//    if(indexPath.row==0)
//    {
//        if(self.tag==1)
//        {
//            cell.showLabel.text =@"地区";
//        }else if(self.tag==2)
//        {
//            cell.showLabel.text =@"语言";
//        }else if(self.tag==3)
//        {
//            cell.showLabel.text =@"状态";
//        }else if(self.tag==4)
//        {
//            cell.showLabel.text =@"年份";
//        }
//
//    }else{
    faqcategorymodel* model=self.FAQListArray[indexPath.item];
    cell.showLabel.text =model.name;
//    }
//    [cell.layer addSublayer:_gl1n];
//    [cell.layer addSublayer:_gl1y];
    ;
    if (self.indexItem == indexPath.item) {
        
        cell.showLabel.textColor = RGBA(20, 155, 236, 1);
        [cell.showLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        cell.backgroundColor=RGBA(183, 224, 248, 1);
//        [cell.layer insertSublayer:_gl1y above:_gl1n];
    }else{
        cell.showLabel.textColor = RGBA(153, 153, 153, 1);
        cell.backgroundColor=RGBA(232, 232, 232, 1);
        [cell.showLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
//        [cell.layer insertSublayer:_gl1n above:_gl1y];
    }
    cell.layer.cornerRadius=10;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.indexItem  = indexPath.item;
    faqcategorymodel * model=self.FAQListArray[self.indexItem];
    [self getFAQListData:model];
    [self.topcollectionview reloadData];
}
//计算文字宽度
-(CGFloat)calculateRowWidth:(NSString*)string {
    NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30)/*计算宽度时要确定高度*/options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
//计算文字高度
-(CGFloat)calculateRowHeight:(NSString*)string {
    NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-80, 0)/*计算高度时要确定宽度*/options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==10001)
    {
        return 1;
    }else if(tableView.tag==10002)
    {
        return 1;
    }else if(tableView.tag==10003)
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
    }else if(tableView.tag==10002)
    {
        return 0;
    }else if(tableView.tag==10003)
    {
        return 0;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tableView.tag==10001)
    {
        FAQTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if (cell == nil) {
            cell = [[FAQTableViewCell alloc] init];
        }
        faqListInfomodel*model=self.Listarray1[indexPath.section];
        cell.titleLabel.text=model.title;
        cell.infoLabel.text=model.content;
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return nil;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==10001)
    {
        faqListInfomodel*model=self.Listarray1[indexPath.section];
        CGFloat floatH=[self calculateRowHeight:model.content];
        return floatH+80;
    }else if(tableView.tag==10002)
    {
        return 155;
    }else if(tableView.tag==10003)
    {
        return 155;
    }
    return 0;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView.tag==10001)
    {
        return 10.f;
    }else if(tableView.tag==10002)
    {
        return 10.f;
    }else if(tableView.tag==10003)
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
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==10001)
    {
        NSLog(@"10001index == %ld",indexPath.section);
    }else if(tableView.tag==10002)
    {
        NSLog(@"10002index == %ld",indexPath.section);
    }else if(tableView.tag==10003)
    {
        NSLog(@"10002index == %ld",indexPath.section);
    }
    
    
}











-(void)getcustomerServicelistData
{
    
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,postcustomerServicelisturl] Dictionary:nil success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            
            NSArray* customer_service_list=[dictdata objectForKey:@"customer_service_list"];
            if(![customer_service_list isKindOfClass:[NSNull class]]){
            if(customer_service_list.count>=0)
            {
                [self.kefuArray removeAllObjects];
                for (int i=0; i<customer_service_list.count; i++) {
//                    [DYModelMaker DY_makeModelWithDictionary:customer_service_list[i] modelKeyword:@"customer" modelName:@"InfoMode"];
                    customerInfoMode*model=[customerInfoMode yy_modelWithDictionary:customer_service_list[i]];
                    if([model.symbol isEqualToString:@"faq"])
                    [self.kefuArray addObject:model];
                }
                
            
            }
            }
            
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
-(void)getcustomerinfoData:(NSString*)string
{
    
    NSDictionary* dict=@{@"symbol":[NSString stringWithFormat:@"%@",string]};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,postcustomerServiceinfourl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary *dictdata =[dict objectForKey:@"data"];
            
            NSArray* faq_list=[dictdata objectForKey:@"faq_list"];
            if(![faq_list isKindOfClass:[NSNull class]]){
            if(faq_list.count>=0)
            {
                [self.Listarray1 removeAllObjects];
                for (int i=0; i<faq_list.count; i++) {
                    faqListInfomodel*model=[faqListInfomodel yy_modelWithDictionary:faq_list[i]];
                    [self.Listarray1 addObject:model];
                }
                
            
            }
            }
            [self.downtableview1 reloadData];
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






@end
