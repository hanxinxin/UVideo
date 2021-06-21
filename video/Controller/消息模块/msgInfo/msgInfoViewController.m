//
//  msgInfoViewController.m
//  video
//
//  Created by nian on 2021/5/11.
//

#import "msgInfoViewController.h"
#import "msgInfoView.h"
@interface msgInfoViewController ()
@property(nonatomic,strong)UIView*InfoView;
@property(nonatomic,strong)msgInfoView*infoViewheader;
@end

@implementation msgInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.title=@"系统公告";
    self.hiddenLeftBtn=YES;
    self.statusBarTextIsWhite=NO;
    self.statusBarBackgroundColor=[UIColor blackColor];
    self.navBarColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:247/255.0 alpha:1];
    
    
    [self addInfoViewA];
    [self AddinfoViewheader];
}

-(void)addInfoViewA
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(16,16,SCREEN_WIDTH-32,SCREENH_HEIGHT-16);
    view.alpha = 1.0;
    view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    view.layer.shadowColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,3);
    view.layer.shadowRadius = 6;
    view.layer.shadowOpacity = 1;
    self.InfoView=view;
    [self.view addSubview:self.InfoView];
}

-(void)AddinfoViewheader
{
    msgInfoView *view = [[[NSBundle mainBundle]loadNibNamed:@"msgInfoView" owner:self options:nil]objectAtIndex:0];
//    view.alpha=0.7;
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, self.InfoView.width, self.InfoView.height);
    [self.InfoView addSubview:view];
    self.infoViewheader=view;
    if(self.model)
    {
        self.infoViewheader.titleLabel.text=_model.title;
        self.infoViewheader.timeLabel.text=[self getTimeFromTimestamp13:@(_model.create_time)];
        self.infoViewheader.miaoshuLabel.text=_model.content;
        if(self.model.read_time==0)
        {
        [self postMSGRead:self.model];
        }
    }
}

-(void)postMSGRead:(MessageInfoMode*)mode
{
//    [UHud showHUDLoading];
    NSDictionary * dict = @{@"id":[NSString stringWithFormat:@"%.f",mode.id]};
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,msgreadurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
//            NSDictionary *dictdata =[dict objectForKey:@"data"];
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
