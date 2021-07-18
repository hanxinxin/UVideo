//
//  vipHeaderView.m
//  video
//
//  Created by macbook on 2021/5/10.
//

#import "vipHeaderView.h"

@implementation vipHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)touxiang_touch:(id)sender {
    //取消
    if (self.touchIndex) {
        self.touchIndex(1);
    }
}
- (IBAction)name_touch:(id)sender {
    //取消
    if (self.touchIndex) {
        self.touchIndex(2);
    }
}

@end
