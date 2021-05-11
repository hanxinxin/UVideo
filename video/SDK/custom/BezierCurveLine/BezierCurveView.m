//
//  BezierCurveView.m
//  BezierCurveLineDemo
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 xiayuanquan. All rights reserved.
//


#import "BezierCurveView.h"
#import "leftView.h"
#import "GlobalConfig.h"
static CGRect myFrame;

@interface BezierCurveView ()
{
    float height;
    float Ypoint;
}
@property(nonatomic,strong)leftView *leftSlideImageView;
@end

@implementation BezierCurveView

//初始化画布
+(instancetype)initWithFrame:(CGRect)frame{
    BezierCurveView *bezierCurveView = [[NSBundle mainBundle] loadNibNamed:@"BezierCurveView" owner:self options:nil].firstObject;
    bezierCurveView.frame = frame;
    //背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    NSLog(@"backView.frame = %@",NSStringFromCGRect(backView.frame));
    [bezierCurveView addSubview:backView];
    myFrame = frame;
    return bezierCurveView;
}


/**
 *  画坐标轴
 */
-(void)drawXYLine
{
     [[UIColor whiteColor]set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:50.0];
   
    
    height = CGRectGetHeight(myFrame)-MARGIN;
    
    //1.Y轴的直线
    [path moveToPoint:CGPointMake(MARGIN, height)];
    float line = height-LINE_LEIHGT-MARGIN;
    Ypoint = MARGIN+line;
    [path addLineToPoint:CGPointMake(MARGIN, Ypoint)];
    
    //3.添加索引格
    //Y轴（实际长度为200,此处比例缩小一倍使用）
    for (int i=0; i<6; i++)
    {
        CGPoint xpoint = CGPointZero;
        CGPoint ypoint = CGPointZero;
        CGFloat Y = height-Y_EVERY_MARGIN*i;
        if (i == 0)
        {
             xpoint = CGPointMake(MARGIN-5,Y);
             ypoint = CGPointMake(xpoint.x+10, xpoint.y);
        }
        else if(i == 5)
        {
            xpoint = CGPointMake(MARGIN-5,Y);
            ypoint = CGPointMake(xpoint.x+10, xpoint.y);
        }
        else
        {
            xpoint = CGPointMake(MARGIN-3,Y);
            ypoint = CGPointMake(xpoint.x+6, xpoint.y);
        }
        [path moveToPoint:xpoint];
        NSLog(@"point = %@,height = %f",NSStringFromCGPoint(xpoint),height);
        [path addLineToPoint:ypoint];
    }
    
    //Y轴
    for (int i=0; i<6; i++)
    {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
        int temp = 40;
        if (IS_IPAD) {
            temp = 45;
        }
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN-temp, Y-5, MARGIN, 10)];
        textLabel.text = [NSString stringWithFormat:@"%d",LINE_LEIHGT-Y_EVERY_MARGIN*i];
        if (IS_IPAD) {
            textLabel.font = [UIFont systemFontOfSize:10];
        }
        else
        {
            textLabel.font = [UIFont systemFontOfSize:8];
        }
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor whiteColor];
        [self addSubview:textLabel];
    }
    
    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 10.0;
    shapeLayer.lineDashPattern = @[@4, @1];
    [self.subviews[0].layer addSublayer:shapeLayer];
    
    //左滑块
    self.leftSlideImageView = [leftView initWithFrame:CGRectMake(MARGIN+20, height, 60, 18)];
    [self addSubview:self.leftSlideImageView];
    
    if (IS_IPAD) {
        self.leftSlideImageView.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    
    //左滑块添加滑动手势
    UIPanGestureRecognizer *leftPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftSliderMove:)];
    [leftPanRecognizer setMinimumNumberOfTouches:1];
    [leftPanRecognizer setMaximumNumberOfTouches:1];
    [self.leftSlideImageView setUserInteractionEnabled:YES];
    [self.leftSlideImageView addGestureRecognizer:leftPanRecognizer];
    [self setSlideValue:0.01];

    [path stroke];
}

-(void)setSlideValue:(float)value
{
    float y = value-(LINE_LEIHGT-height);
    self.leftSlideImageView.center = CGPointMake(MARGIN+30, y);
    self.leftSlideImageView.titleLabel.text = [NSString stringWithFormat:@"%.2fm",value];
}

-(void)leftSliderMove:(UIPanGestureRecognizer *)pan
{
//    CGPoint point = [pan translationInView:self.leftSlideImageView];
//    float y = self.leftSlideImageView.center.y + point.y;
//    if (y <= Ypoint) {
//        y = Ypoint;
//    }
//    else if(y >= height)
//    {
//        y = height;
//    }
//    self.leftSlideImageView.center = CGPointMake( self.leftSlideImageView.center.x, ceilf(y));
//    int value = height - (int)y ;
//    self.leftSlideImageView.titleLabel.text = [NSString stringWithFormat:@"%dm",value];
//    [pan setTranslation:CGPointZero inView:self];
}
@end
