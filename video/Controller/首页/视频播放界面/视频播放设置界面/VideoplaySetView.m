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
    self.hmbl_Label.frame=CGRectMake(20, 20,self.width-20, 26);
        
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
    self.zimuKG_Label.frame=CGRectMake(20, self.hmblBtn.bottom+10, self.width-20, 26);
    self.zimuSwitch.frame=CGRectMake(20, self.zimuKG_Label.bottom, 49, 31);
    self.zimuPY_Label.frame=CGRectMake(20, self.zimuSwitch.bottom+10, self.width-20, 26);
    self.pyJiaBtn.frame=CGRectMake(20, self.zimuPY_Label.bottom, 46, 26);
    self.pyJianBtn.frame=CGRectMake(20, self.pyJiaBtn.right+5, 46, 26);
    self.tgPTPW_Label.frame=CGRectMake(20, self.pyJiaBtn.bottom+10, self.width-20, 26);
    self.tgPTPWSwitch.frame=CGRectMake(20, self.tgPTPW_Label.bottom, 49, 31);
    
    
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
}

@end
