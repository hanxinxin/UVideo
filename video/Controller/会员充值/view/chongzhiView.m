//
//  chongzhiView.m
//  video
//
//  Created by macbook on 2021/5/30.
//

#import "chongzhiView.h"
@interface chongzhiView ()<UIGestureRecognizerDelegate>
@end
@implementation chongzhiView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        
        [self addTapGesture];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder: aDecoder]) {
        [self addTapGesture];
    }
    return self;
}
-(void)awakeFromNib {

    [super awakeFromNib];
}
-(void)addTapGesture
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    //    步骤3：给View添加手势
        tapGesture.delegate=self;
         //设置需要连续点击几次才响应，默认点击1次
         [tapGesture setNumberOfTapsRequired:1];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGesture.cancelsTouchesInView = NO;
         [self addGestureRecognizer:tapGesture];
}
-(void)event:(UITapGestureRecognizer *)gesture
{
     //处理事件
    //取消
    if (self.touchIndex) {
        self.touchIndex(0);
    }
}
- (IBAction)cancel_touch:(id)sender {
    //取消
    if (self.touchIndex) {
        self.touchIndex(0);
    }
}
- (IBAction)ok_touch:(id)sender {
    //取消
    if (self.touchIndex) {
        self.touchIndex(1);
    }
}

@end
