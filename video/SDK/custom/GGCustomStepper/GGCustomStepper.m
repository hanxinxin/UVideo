//
//  GGCustomStepper.m
//  GGCustomStepper
//
//  Created by LGQ on 16/3/2.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import "GGCustomStepper.h"
#import "GlobalConfig.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#define GGlineColor [UIColor lightGrayColor]
static const double  GGAutorepeatTimeInterval = 0.2;
static const double  GGMinimumValue           = 0.0;
static const double  GGMaximumValue           = CGFLOAT_MAX;
static const double  GGDefaultValue           = GGMinimumValue;
static const double  GGStepValue              = 1.0;
static const CGFloat GGLineWidth              = 0.5;
static const CGFloat GGAmountLabelScale       = 0.4;
static const CGFloat GGCornerRadius           = 4;


@interface GGCustomStepper ()<UITextFieldDelegate>

/** 减量按钮 */
@property (nonatomic, weak) UIButton *decrementButton;
/** 增量按钮 */
@property (nonatomic, weak) UIButton *incrementButton;
/** 显示视图 */
@property (nonatomic, weak) UITextField *amountField;

/** 垂直分割线 */
@property (nonatomic, weak) UIView *leftVerticalLine;
@property (nonatomic, weak) UIView *rightVerticalLine;


@property (nonatomic, strong) NSTimer *timer;
@end

@implementation GGCustomStepper

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return self.inputValue;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length > 0) {
        
        return [self isNumText:string];
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGFloat value = textField.text.integerValue;
    if (value > _maximumValue || value < _minimumValue) {
        value = _value;
        // 数量超出范围~
    }

    self.value = value;
}

#pragma mark - personal
- (void)initialization {
    
    self.backgroundColor    = [UIColor whiteColor];
    self.layer.cornerRadius = GGCornerRadius;
    self.clipsToBounds      = YES;
    self.inputValue         = YES;
    self.autorepeat         = YES;
    self.minimumValue       = GGMinimumValue;
    self.maximumValue       = GGMaximumValue;
    self.value              = GGDefaultValue;
    self.lineColor          = GGlineColor;
    self.lineWidth          = GGLineWidth;
    self.stepValue          = GGStepValue;
    self.amountLabelScale   = GGAmountLabelScale;
    self.textColor          = self.amountField.textColor;
    self.textFont           = self.amountField.font;
    
    [self setDecrementImage:[UIImage imageNamed:@"GGCustomStepper.bundle/Images/btn_jian_n1.png"] forState:UIControlStateNormal];
    [self setDecrementImage:[UIImage imageNamed:@"GGCustomStepper.bundle/Images/btn_jian_d.png"] forState:UIControlStateDisabled];
    [self setIncrementImage:[UIImage imageNamed:@"GGCustomStepper.bundle/Images/btn_add_n1.png"] forState:UIControlStateNormal];
    [self setIncrementImage:[UIImage imageNamed:@"GGCustomStepper.bundle/Images/btn_add_d.png"] forState:UIControlStateDisabled];
    
    [self setBackgroundImageWithColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self setBackgroundImageWithColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

// 布局
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    CGFloat lineWidth = self.lineWidth;
    CGFloat labelWidth = width * self.amountLabelScale;
    CGFloat buttonWidth =(width - labelWidth) * 0.5;
    
    CGFloat decrementButtonX = 0;
    CGFloat labelX = decrementButtonX + buttonWidth;
    CGFloat incrementButtonX = labelX + labelWidth;
    
    CGFloat leftLineX = labelX - lineWidth;
    CGFloat rightLineX = incrementButtonX;
    
    self.decrementButton.frame = CGRectMake(decrementButtonX, 0, buttonWidth, height);
    self.amountField.frame = CGRectMake(labelX, 0, labelWidth, height);
    self.incrementButton.frame = CGRectMake(incrementButtonX, 0, buttonWidth, height);
    
    self.leftVerticalLine.frame = CGRectMake(leftLineX, 0, lineWidth, height);
    self.rightVerticalLine.frame = CGRectMake(rightLineX, 0, lineWidth, height);
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)isNumText:(NSString *)str{
    
    NSScanner* scan = [NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

- (UIToolbar *)addInputAccessoryView {
    /** ToolBar */
    UIToolbar *tool = [[UIToolbar alloc] init];
    tool.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:DqLocalizedString(@"完成") style:UIBarButtonItemStylePlain target:self action:@selector(toolbarDoneClicked)];
    tool.items = @[flexSpace, item];
    return tool;
    
}
#pragma mark - action
// 减量
- (void)decrement {
    double value = self.value - self.stepValue;
    if (value >= self.minimumValue) {
        self.value = value;
    }
}

// 加量
- (void)increment {
    double value = self.value + self.stepValue;
    if (value <= self.maximumValue) {
        self.value = value;
    }
}

// 长按减量
- (void)decrementButtonLongPress:(UILongPressGestureRecognizer *)longPress {
    
    [self changeAmountWithLongPress:longPress selector:@selector(decrement)];
}

// 长按加量
- (void)incrementButtonLongPress:(UILongPressGestureRecognizer *)longPress {
    
    [self changeAmountWithLongPress:longPress selector:@selector(increment)];
}

// 长按操作
- (void)changeAmountWithLongPress:(UIGestureRecognizer *)longPress selector:(SEL)selector {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        if (self.autorepeat == NO) {
            return;
        }
        
        self.timer = [NSTimer timerWithTimeInterval:GGAutorepeatTimeInterval target:self selector:selector userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self.timer fire];
        
    } else if ((longPress.state == UIGestureRecognizerStateEnded) ||
               (longPress.state == UIGestureRecognizerStateFailed) ||
               (longPress.state == UIGestureRecognizerStateCancelled)) {
        if (selector) {
            [self performSelector:selector];
        }
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)toolbarDoneClicked {
    [self.amountField resignFirstResponder];
}

- (void)tapAction {
    
}


#pragma mark - setter

- (void)setMinimumValue:(double)minimumValue {
    _minimumValue = minimumValue;
    
    if (self.value < minimumValue) {
        self.value = minimumValue;
    }
}

- (void)setMaximumValue:(double)maximumValue {
    _maximumValue = maximumValue;
    if (self.value > maximumValue) {
        self.value = maximumValue;
    }
}

- (void)setValue:(double)value {

    if (self.valueChange) {
        self.valueChange(_value, value);
    } else if ([self.delegate respondsToSelector:@selector(customStepper:changeValue:oldValue:)]) {
        [self.delegate customStepper:self changeValue:value oldValue:_value];
    }
    
    _value = value;
    
    self.amountField.text = [NSString stringWithFormat:@"%.0f", value];
    self.decrementButton.enabled = value - self.stepValue >= self.minimumValue;
    self.incrementButton.enabled = value + self.stepValue <= self.maximumValue;
}

- (void)setStepValue:(double)stepValue {
    _stepValue = stepValue;
    
    self.decrementButton.enabled = self.value - stepValue >= self.minimumValue;
    self.incrementButton.enabled = self.value + stepValue <= self.maximumValue;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.layer.borderColor = lineColor.CGColor;
    self.leftVerticalLine.backgroundColor = lineColor;
    self.rightVerticalLine.backgroundColor = lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.layer.borderWidth = lineWidth;
    
    CGRect frame = self.leftVerticalLine.frame;
    frame.size.width = lineWidth;
    self.leftVerticalLine.frame = frame;
    
    frame = self.rightVerticalLine.frame;
    frame.size.width = lineWidth;
    self.leftVerticalLine.frame = frame;
    
    [self layoutSubviews];
}

- (void)setAmountLabelScale:(CGFloat)amountLabelScale {
    _amountLabelScale = amountLabelScale;
    
    [self layoutSubviews];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.amountField.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.amountField.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont textColor:(UIColor *)textColor {
    self.textColor = textColor;
    self.textFont = textFont;
}

- (void)setDecrementImage:(UIImage *)image forState:(UIControlState)state {
    [self.decrementButton setImage:image forState:state];
}

- (void)setIncrementImage:(UIImage *)image forState:(UIControlState)state {
    [self.incrementButton setImage:image forState:state];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.decrementButton setBackgroundImage:image forState:state];
    [self.incrementButton setBackgroundImage:image forState:state];
}

- (void)setBackgroundImageWithColor:(UIColor *)color forState:(UIControlState)state {
    
    UIImage *backgroundImage = [self imageWithColor:color size:CGSizeMake(1, 1)];
    [self setBackgroundImage:backgroundImage forState:state];
}

#pragma mark - getter
- (UITextField *)amountField {
    if (_amountField == nil) {
        UITextField *amountLabel = [[UITextField alloc] init];
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.delegate = self;
        amountLabel.keyboardType = UIKeyboardTypeNumberPad;
        amountLabel.inputAccessoryView = [self addInputAccessoryView];
        [self addSubview:amountLabel];
        _amountField = amountLabel;
    }
    return _amountField;
}

- (UIButton *)decrementButton {
    if (_decrementButton == nil) {
        UIButton *button = [[UIButton alloc] init];
    
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(decrementButtonLongPress:)];
        [button addGestureRecognizer:longPress];
        
        [button addTarget:self action:@selector(decrement) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _decrementButton = button;
    }
    return _decrementButton;
}

- (UIButton *)incrementButton {
    if (_incrementButton == nil) {
        UIButton *button = [[UIButton alloc] init];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(incrementButtonLongPress:)];
        [button addGestureRecognizer:longPress];
        
        [button addTarget:self action:@selector(increment) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _incrementButton = button;
    }
    return _incrementButton;
}

- (UIView *)leftVerticalLine {
    if (_leftVerticalLine == nil) {
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        _leftVerticalLine = line;
    }
    return _leftVerticalLine;
}

- (UIView *)rightVerticalLine {
    if (_rightVerticalLine == nil) {
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        _rightVerticalLine = line;
    }
    return _rightVerticalLine;
}

- (UIImage *)backgroundImageForState:(UIControlState)state {
    return [self.decrementButton backgroundImageForState:state];
}

- (UIImage *)decrementImageForState:(UIControlState)state {
    return [self.decrementButton imageForState:state];
}

- (UIImage *)incrementImageForState:(UIControlState)state {
    return [self.incrementButton imageForState:state];
}

@end

#pragma clang diagnostic pop
