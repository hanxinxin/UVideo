//
//  hometableHeaderView.m
//  video
//
//  Created by macbook on 2021/7/23.
//

#import "hometableHeaderView.h"
@interface hometableHeaderView ()<MSCycleScrollViewDelegate>
@end
@implementation hometableHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier

{

    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          [self addScrollviewLB];
    
            });
        [self getGuanggao_data];

    }

    return self;

}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          [self addScrollviewLB];
    
            });
        [self getGuanggao_data];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder: aDecoder]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          [self addScrollviewLB];
    
            });
        [self getGuanggao_data];
    }
    return self;
}
-(void)awakeFromNib {

    [super awakeFromNib];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          [self addScrollviewLB];
    
            });
    [self getGuanggao_data];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setGuanggaoModeA:(GuanggaoMode *)GuanggaoModeA
{
    _GuanggaoModeA=GuanggaoModeA;
    self.guanggaoImageView.yy_imageURL=[NSURL URLWithString:_GuanggaoModeA.source];
}
-(void)setBannerimagesURL:(NSMutableArray *)bannerimagesURL
{
    _bannerimagesURL=bannerimagesURL;
    
    self.cycleScrollView.imageUrls = _bannerimagesURL;
}


-(void)addScrollviewLB
{
    // 网络加载 --- 创建带标题的图片轮播器
    MSCycleScrollView *cycleScrollView7 = [MSCycleScrollView cycleViewWithFrame:CGRectMake(15, 5, self.width-30, 160) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView7.pageDotColor = [UIColor whiteColor];
    cycleScrollView7.currentPageDotColor = [UIColor purpleColor];
    cycleScrollView7.dotBorderWidth = 1;
    cycleScrollView7.dotBorderColor = [UIColor whiteColor];
    cycleScrollView7.currentDotBorderColor =RGB(0, 174, 232);
    cycleScrollView7.currentDotBorderWidth = 5;
    cycleScrollView7.dotsIsSquare = NO;
    cycleScrollView7.spacingBetweenDots=4;
    cycleScrollView7.pageControlRightOffset=-(cycleScrollView7.width-250);
    cycleScrollView7.pageControlDotSize = CGSizeMake(8, 8);
    cycleScrollView7.backgroundColor=[UIColor clearColor];
    [self addSubview:cycleScrollView7];
    self.cycleScrollView =cycleScrollView7;
    
    cycleScrollView7.imageUrls = self.bannerimagesURL;
    
    /*
     block监听点击方式
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
     NSLog(@">>>>>  %ld", (long)index);
     };
     */
    YYAnimatedImageView * imageview = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(15, self.cycleScrollView.bottom+10, self.width-30, 60)];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius=8;
    if(self.GuanggaoModeA==nil)
    {
        [imageview setImage:[UIImage imageNamed:@"kthuiyuan"]];
    }
    
    imageview.userInteractionEnabled = YES;//打开用户交互
    //创建手势识别器对象
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];

    //设置手势识别器对象的具体属性
    // 连续敲击2次
    tap.numberOfTapsRequired = 1;
    // 需要2根手指一起敲击
    tap.numberOfTouchesRequired = 1;

    //添加手势识别器到对应的view上
    [imageview addGestureRecognizer:tap];

    //监听手势的触发
    [tap addTarget:self action:@selector(postWebView:)];
    self.guanggaoImageView=imageview;
    [self addSubview:imageview];
    
}
-(void)postWebView:(UITapGestureRecognizer*)tap
{
    if(self.GuanggaoModeA)
    {
//        TestWebViewController *webVC = [[TestWebViewController alloc] initWithURLString:self.GuanggaoModeA.url];
////        [self.navigationController pushViewController:webVC animated:YES];
//        [self pushRootNav:webVC animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.GuanggaoModeA.url]];

        
    }
}

-(void)getGuanggao_data
{
    NSDictionary *dict =@{
        @"symbol":@"mobile-home-banner-below",
        @"result":@"1",
    };
    
    [[HttpManagement shareManager] PostNewWork:[NSString stringWithFormat:@"%@%@",FWQURL,guanggaoGDurl] Dictionary:dict success:^(id  _Nullable responseObject) {
//        NSLog(@"post responseObject == %@",responseObject);
        [UHud hideLoadHud];
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSNumber * code = [dict objectForKey:@"error"];
        if([code intValue]==0)
        {
            NSDictionary * datadict = [dict objectForKey:@"data"];
            NSDictionary * dataAD = [datadict objectForKey:@"ad"];
//            [DYModelMaker DY_makeModelWithDictionary:dataAD modelKeyword:@"Guanggao" modelName:@"Mode"];
            self.GuanggaoModeA=[GuanggaoMode yy_modelWithDictionary:dataAD];
//            NSString * urlstr = [dataAD objectForKey:@"source"];
            
            if(self.GuanggaoModeA)
            {
                self.guanggaoImageView.yy_imageURL=[NSURL URLWithString:self.GuanggaoModeA.source];
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
        [UHud showTXTWithStatus:@"网络错误" delay:2.f];
    }];
    
    
}
@end
