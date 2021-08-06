//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLCardCell.h"
#import "XLCardModel.h"

@interface XLCardCell ()
@property (nonatomic, strong) UILabel*toptitle;

@property (nonatomic, strong) UIView*centerView;
@property (nonatomic, strong) UIImageView *BGimageView;
@property (nonatomic, strong) UILabel *CTimeLabel;
@property (nonatomic, strong) UILabel *CYJpriceLabel;
@property (nonatomic, strong) UILabel *CXJpriceLabel;
@end

@implementation XLCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor clearColor];
    
//    CGFloat labelHeight = self.bounds.size.height * 0.20f;
//    CGFloat imageViewHeight = self.bounds.size.height - labelHeight;
    
    self.toptitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    self.toptitle.textColor = RGBA(155, 96, 57, 1);
    self.toptitle.font = [UIFont systemFontOfSize:18.f];
    self.toptitle.textAlignment = NSTextAlignmentCenter;
    self.toptitle.adjustsFontSizeToFitWidth = true;
    [self addSubview:self.toptitle];
    self.centerView=[[UIView alloc] init];
    self.centerView.frame=CGRectMake(0, self.toptitle.bottom, self.bounds.size.width, self.bounds.size.height-20);
//    self.centerView.backgroundColor=[UIColor clearColor];
    self.centerView.backgroundColor=RGBA(208, 164, 135, 1);
    self.centerView.layer.cornerRadius=8;
    [self addSubview:self.centerView];
    
    
    self.BGimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.centerView.height-50)/2, self.centerView.width, 50)];
//    self.BGimageView.backgroundColor=RGBA(208, 164, 135, 1);
    self.BGimageView.contentMode = UIViewContentModeScaleToFill;
    [self.BGimageView setImage:[UIImage imageNamed:@"menberVipBG"]];
    self.BGimageView.layer.masksToBounds = true;
    self.BGimageView.layer.cornerRadius=8;
    [self.centerView addSubview:self.BGimageView];
    

    self.CTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 25)];
    self.CTimeLabel.textColor = RGBA(155, 96, 57, 1);
    self.CTimeLabel.font = [UIFont boldSystemFontOfSize:22.f];
    self.CTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.CTimeLabel.adjustsFontSizeToFitWidth = true;
    [self.centerView addSubview:self.CTimeLabel];
    self.CYJpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.CTimeLabel.bottom, self.bounds.size.width, 20)];
    self.CYJpriceLabel.textColor = RGBA(155, 96, 57, 1);
    self.CYJpriceLabel.font = [UIFont systemFontOfSize:14.f];
    self.CYJpriceLabel.textAlignment = NSTextAlignmentCenter;
    self.CYJpriceLabel.adjustsFontSizeToFitWidth = true;
    [self.centerView addSubview:self.CYJpriceLabel];
    self.CXJpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.CYJpriceLabel.bottom+10, self.bounds.size.width, 25)];
    self.CXJpriceLabel.textColor = RGBA(155, 96, 57, 1);
    self.CXJpriceLabel.font = [UIFont boldSystemFontOfSize:22.f];
    self.CXJpriceLabel.textAlignment = NSTextAlignmentCenter;
    self.CXJpriceLabel.adjustsFontSizeToFitWidth = true;
    [self.centerView addSubview:self.CXJpriceLabel];
}

- (void)setModel:(vipcardcategorylistModel *)model {
//    self.imageView.image = [UIImage imageNamed:model.imageName];
//    self.textLabel.text = model.title;
    _model=model;
    self.toptitle.text=model.name;
    self.CTimeLabel.text=[NSString stringWithFormat:@"%.f天",model.period];
    if([model.currency isEqualToString:@"USD"])
    {
        self.CYJpriceLabel.text=[NSString stringWithFormat:@"原价$%@",model.price];
    }else{
        self.CYJpriceLabel.text=[NSString stringWithFormat:@"原价¥%@",model.price];
    }
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
       NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.CYJpriceLabel.text attributes:attribtDic];
       // 赋值
       self.CYJpriceLabel.attributedText = attribtStr;

    self.CXJpriceLabel.text=[NSString stringWithFormat:@"$%@",model.discounted_price];
    
        if ([model.name isEqualToString:@"月卡"]) {
            self.centerView.backgroundColor=RGBA(218, 177, 111, 1);
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = self.centerView.bounds;
            gl.cornerRadius = 8;
            gl.startPoint = CGPointMake(0.1508081704378128, 0.05238793417811394);
            gl.endPoint = CGPointMake(0.7005797028541565, 1);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:241/255.0 green:222/255.0 blue:175/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:218/255.0 green:177/255.0 blue:111/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0),@(1.0f)];
            [self.centerView.layer insertSublayer:gl atIndex:0];
            self.CTimeLabel.textColor=rgba(141, 107, 54, 1);
            self.CYJpriceLabel.textColor=rgba(141, 107, 54, 1);
            self.CXJpriceLabel.textColor=rgba(141, 107, 54, 1);
        }else if ([model.name isEqualToString:@"季卡"]) {
            self.centerView.backgroundColor=RGBA(208, 164, 135, 1);
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = self.centerView.bounds;
            gl.cornerRadius = 8;
            gl.startPoint = CGPointMake(0.1508081704378128, 0.05238793417811394);
            gl.endPoint = CGPointMake(0.7005797028541565, 1);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:243/255.0 green:231/255.0 blue:227/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:208/255.0 green:164/255.0 blue:135/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0),@(1.0f)];
            [self.centerView.layer insertSublayer:gl atIndex:0];
            self.CTimeLabel.textColor=rgba(155, 96, 57, 1);
            self.CYJpriceLabel.textColor=rgba(155, 96, 57, 1);
            self.CXJpriceLabel.textColor=rgba(155, 96, 57, 1);
        }else if ([model.name isEqualToString:@"年卡"]) {
            self.centerView.backgroundColor=RGBA(208, 164, 135, 1);
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = self.centerView.bounds;
            gl.cornerRadius = 8;
            gl.startPoint = CGPointMake(0.1508081704378128, 0.05238793417811394);
            gl.endPoint = CGPointMake(0.7005797028541565, 1);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:243/255.0 green:231/255.0 blue:227/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:208/255.0 green:164/255.0 blue:135/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0),@(1.0f)];
            [self.centerView.layer insertSublayer:gl atIndex:0];
            self.CTimeLabel.textColor=rgba(155, 96, 57, 1);
            self.CYJpriceLabel.textColor=rgba(155, 96, 57, 1);
            self.CXJpriceLabel.textColor=rgba(155, 96, 57, 1);
        }else if ([model.name isEqualToString:@"情侣季卡"]) {
            self.centerView.backgroundColor=RGBA(35, 35, 35, 1);
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = self.centerView.bounds;
            gl.cornerRadius = 8;
            gl.startPoint = CGPointMake(0.1508081704378128, 0.05238793417811394);
            gl.endPoint = CGPointMake(0.7005797028541565, 1);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:116/255.0 green:115/255.0 blue:115/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0),@(1.0f)];
            [self.centerView.layer insertSublayer:gl atIndex:0];
            self.CTimeLabel.textColor=RGBA(227, 195, 136, 1);
            self.CYJpriceLabel.textColor=RGBA(227, 195, 136, 1);
            self.CXJpriceLabel.textColor=RGBA(227, 195, 136, 1);
        }else if ([model.name isEqualToString:@"情侣年卡"]) {
            self.centerView.backgroundColor=RGBA(35, 35, 35, 1);
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = self.centerView.bounds;
            gl.cornerRadius = 8;
            gl.startPoint = CGPointMake(0.1508081704378128, 0.05238793417811394);
            gl.endPoint = CGPointMake(0.7005797028541565, 1);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:116/255.0 green:115/255.0 blue:115/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0),@(1.0f)];
            [self.centerView.layer insertSublayer:gl atIndex:0];
            self.CTimeLabel.textColor=RGBA(227, 195, 136, 1);
            self.CYJpriceLabel.textColor=RGBA(227, 195, 136, 1);
            self.CXJpriceLabel.textColor=RGBA(227, 195, 136, 1);
        }else if ([model.name isEqualToString:@"家庭年卡"]) {
            self.centerView.backgroundColor=RGBA(35, 35, 35, 1);
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = self.centerView.bounds;
            gl.cornerRadius = 8;
            gl.startPoint = CGPointMake(0.1508081704378128, 0.05238793417811394);
            gl.endPoint = CGPointMake(0.7005797028541565, 1);
            gl.colors = @[(__bridge id)[UIColor colorWithRed:243/255.0 green:231/255.0 blue:227/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:208/255.0 green:164/255.0 blue:135/255.0 alpha:1.0].CGColor];
            gl.locations = @[@(0),@(1.0f)];
            [self.centerView.layer insertSublayer:gl atIndex:0];
            self.CTimeLabel.textColor=rgba(155, 96, 57, 1);
            self.CYJpriceLabel.textColor=rgba(155, 96, 57, 1);
            self.CXJpriceLabel.textColor=rgba(155, 96, 57, 1);
        }
    
    self.centerView.layer.cornerRadius=8;
}



//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}
@end
