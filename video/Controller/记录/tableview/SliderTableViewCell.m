//
//  SliderTableViewCell.m
//  video
//
//  Created by nian on 2021/5/10.
//

#import "SliderTableViewCell.h"


@interface SliderTableViewCell ()<YTSliderViewDelegate>



@end
@implementation SliderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addslider];
}
-(void)addslider
{
//    self.backgroundColor=[UIColor lightGrayColor];
    YTSliderSetting *setting_h = [YTSliderSetting defaultSetting];
//    _Slider = [[YTSliderView alloc]initWithFrame:CGRectMake(self.leftLabel.left, self.leftLabel.bottom+5, self.bfbLabel.left-10, 10.0f) setting:setting_h];
    _Slider = [[YTSliderView alloc]initWithFrame:CGRectMake(self.leftLabel.left, self.leftLabel.bottom+5, 300, 10.0f) setting:setting_h];
    _Slider.tag = 2000;
    _Slider.delegate = self;
//    _Slider.anchorPercent=0.2;
    _Slider.currentPercent=0.2;  /// value 百分比
//    _Slider.sumValue=10;
    _Slider.thumbView.userInteractionEnabled=NO;
    [self addSubview:_Slider];
        [_Slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel);
            make.top.equalTo(self.leftLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(self.bfbLabel.left).offset(-10);
            make.height.mas_equalTo(10.0f);
        }];
}
#pragma mark - delegate
- (void)sliderTouchBegin:(float)value {
    NSLog(@"jilu滑杆开始滑动===%f", value);
}

- (void)sliderTouchEnded:(float)value {
    NSLog(@"jilu滑杆结束滑动===%f", value);
}

- (void)sliderValueChanged:(float)value {
    NSLog(@"jilu滑杆滑动中===%f", value);
}

- (void)sliderTapped:(float)value {
    NSLog(@"jilu滑杆点击====%f", value);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
