//
//  SHeaderView.m
//  video
//
//  Created by nian on 2021/3/11.
//

#import "SHeaderView.h"

@implementation SHeaderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.95];
        [self createLab];
    }
    return self;
}
- (void)createLab{

    self.leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [self.leftImage setImage:[UIImage imageNamed:@"homeimage"]];
    [self addSubview:self.leftImage];
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.width/2-40, 30)];
    [self.leftLabel setText:@"电视剧"];
    [self.leftLabel setTextColor:[UIColor blackColor]];
    [self.leftLabel setFont:[UIFont systemFontOfSize:17.f]];
    [self addSubview:self.leftLabel];
    
    UIButton * button1 =[[UIButton alloc] initWithFrame:CGRectMake(self.width/2, 0, self.width/2-15, 30)];
    [button1 setBackgroundColor:[UIColor whiteColor]];
    [button1 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    button1.layer.cornerRadius=4;
    [button1 setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button1 setTitle:@"更多" forState:(UIControlStateNormal)];
    [button1 setImage:[UIImage imageNamed:@"playerRecommend_rightArrow"] forState:(UIControlStateNormal)];
    [button1 addTarget:self action:@selector(Btn_Touch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button1];
    self.rightBtn = button1;
    
//    self.rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.rightBtn.right, 0, 20, 20)];
//    [self.rightImage setImage:[UIImage imageNamed:@"playerRecommend_rightArrow"]];
//    [self addSubview:self.rightImage];
    
}
-(void)Btn_Touch:(id)sender
{
    NSLog(@"BtnTouch");
}
-(void)setLeftTitle:(NSString *)Str
{
    [self.leftLabel setText:Str];
}
-(void)setRightTitle:(NSString *)Str
{
    [self.rightBtn setTitle:Str forState:(UIControlStateNormal)];
}

@end
