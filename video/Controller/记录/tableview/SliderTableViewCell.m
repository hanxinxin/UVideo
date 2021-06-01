//
//  SliderTableViewCell.m
//  video
//
//  Created by nian on 2021/5/10.
//

#import "SliderTableViewCell.h"


@interface SliderTableViewCell ()<HYSliderDelegate>



@end
@implementation SliderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addslider];
}
-(void)addslider
{
    _Slider = [[HYSlider alloc]initWithFrame:CGRectMake(self.leftLabel.left, CGRectGetMaxY(self.leftLabel.frame)+5, self.frame.size.width - self.bfbLabel.width-10, 10)];
    _Slider.layer.cornerRadius = self.frame.size.height/2;
    _Slider.currentValueColor = RGB(234, 158, 57);
    _Slider.maxValue = 255;
    _Slider.currentSliderValue = 200;
    _Slider.showTouchView = YES;
    _Slider.showTextColor = RGB(234, 158, 57);
    _Slider.touchViewColor = RGB(255, 218, 150);
    _Slider.delegate = self;
    [self addSubview:_Slider];
}
- (void)HYSlider:(HYSlider *)hySlider didScrollValue:(CGFloat)value{
    
    NSLog(@"%f",value);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
