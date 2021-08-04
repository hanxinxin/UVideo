//
//  VideoplaySetView.m
//  video
//
//  Created by nian on 2021/8/4.
//

#import "VideoplaySetView.h"

@implementation VideoplaySetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.hmbl_Label.frame=CGRectMake(20, 5,self.width-20, 26);
        
    self.hmblBtn.frame=CGRectMake(20, self.hmbl_Label.bottom, 60, 26);
    self.hmblBtn.layer.cornerRadius=4;
    self.hmblBtn.layer.borderWidth=1;
    self.hmblBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    self.hmblBtn1.frame=CGRectMake(self.hmblBtn.right+5, self.hmbl_Label.bottom, 60, 26);
    self.hmblBtn1.layer.cornerRadius=4;
    self.hmblBtn1.layer.borderWidth=1;
    self.hmblBtn1.layer.borderColor=[UIColor whiteColor].CGColor;
    self.hmblBtn2.frame=CGRectMake(self.hmblBtn1.right+5, self.hmbl_Label.bottom, 60, 26);
    self.hmblBtn2.layer.cornerRadius=4;
    self.hmblBtn2.layer.borderWidth=1;
    self.hmblBtn2.layer.borderColor=[UIColor whiteColor].CGColor;
    self.zimuKG_Label.frame=CGRectMake(20, self.hmblBtn.bottom, self.width-20, 26);
    self.zimuKG_Label.hidden=YES;
    self.zimuSwitch.frame=CGRectMake(20, self.zimuKG_Label.bottom, 49, 31);
    self.zimuSwitch.hidden=YES;
    self.zimuPY_Label.frame=CGRectMake(20, self.zimuSwitch.bottom, self.width-20, 26);
    self.zimuPY_Label.hidden=YES;
    self.pyJiaBtn.frame=CGRectMake(20, self.zimuPY_Label.bottom, 46, 26);
    self.pyJiaBtn.hidden=YES;
    self.pyJianBtn.frame=CGRectMake(self.pyJiaBtn.right+5,self.zimuPY_Label.bottom, 46, 26);
    self.pyJianBtn.hidden=YES;
//    self.tgPTPW_Label.frame=CGRectMake(20, self.pyJiaBtn.bottom, self.width-20, 26);
    self.tgPTPW_Label.frame=CGRectMake(20, self.hmblBtn.bottom, [self getWidthWithText:@"跳过片头/片尾" height:26 font:14.f], 26);
    self.tgPTPWSwitch.frame=CGRectMake(20, self.tgPTPW_Label.bottom, 49, 31);
    self.tgvipBtn.frame=CGRectMake(self.tgPTPW_Label.right, self.hmblBtn.bottom, 26, 22);
    
    
}


- (IBAction)Hmbl_touch:(id)sender {
}
- (IBAction)Hmbl1_touch:(id)sender {
}
- (IBAction)Hmbl2_touch:(id)sender {
}
- (IBAction)zimu_touch:(id)sender {
}
- (IBAction)zimuJia_touch:(id)sender {
}
- (IBAction)zimuJian_touch:(id)sender {
}
- (IBAction)tgPTPW_touch:(id)sender {
    
    NSNumber * kgnum=tiaoguokaiguan_loca;
    
    if([usertoken isEqualToString:@""])
    {
//        LoginViewController * avc = [[LoginViewController alloc] init];
//        [weakSelf pushRootNav:avc animated:YES];
        if(self.touchIndex)
        {
            self.touchIndex(0);
        }
    }else{
        
    //////会员才能看蓝光
    if([vip_expired_time_loca intValue]!=0)
    {
        NSString * vipStr=[vip_expired_time_loca stringValue];
        NSString * dqStr=[self gs_getCurrentTimeBySecond11];
        NSDate * timeStampToDate1 = [NSDate dateWithTimeIntervalSince1970:[dqStr doubleValue]];
        NSDate * timeStampToDate2 = [NSDate dateWithTimeIntervalSince1970:[vipStr doubleValue]];
        NSLog(@"[self compareOneDay:timeStampToDate1 withAnotherDay:timeStampToDate2]=====   %d",[self compareOneDay11:timeStampToDate1 withAnotherDay:timeStampToDate2]);
        if([self compareOneDay11:timeStampToDate1 withAnotherDay:timeStampToDate2]!=1)/////   时间对比  返回1 - 过期, 0 - 相等, -1 - 没过期
        {
            
            if([kgnum intValue]==0)
            {
                self.tgPTPWSwitch.on=YES;
                [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"tiaoguokaiguan"];
            }else{
                self.tgPTPWSwitch.on=NO;
                [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:@"tiaoguokaiguan"];
            }
        }else{
            if(self.touchIndex)
            {
                self.touchIndex(1);
            }
        }
    }else{
        if(self.touchIndex)
        {
            self.touchIndex(1);
        }
    }
    }
    
}



//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}



/////   10位时间戳
- (NSString *)gs_getCurrentTimeBySecond11 {

    double currentTime =  [[NSDate date] timeIntervalSince1970];

    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];

    return strTime;

}
///   时间对比  返回1 - 过期, 0 - 相等, -1 - 没过期
- (int)compareOneDay11:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}
@end
