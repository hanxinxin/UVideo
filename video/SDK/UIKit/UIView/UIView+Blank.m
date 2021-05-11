//
//  UIView+Blank.m
//

#import "UIView+Blank.h"
#import <objc/runtime.h>
#import "UIView+Frame.h"
#import "Masonry.h"
#import "GlobalConfig.h"

@implementation UIView (Common)
static char BlankViewKey;

-(void)setBlankView:(EaseBlankView *)blankView
{
    [self willChangeValueForKey:@"BlankViewKey"];
    objc_setAssociatedObject(self, &BlankViewKey,
                             blankView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankViewKey"];
}

- (EaseBlankView *)blankView{
    return objc_getAssociatedObject(self, &BlankViewKey);
}

- (void)configBlankPage:(EaseBlankViewType)blankPageType hasData:(BOOL)hasData reloadButtonBlock:(void (^)(id))block{
    [self configBlankPage:blankPageType hasData:hasData offsetY:0 reloadButtonBlock:block];
}

- (void)configBlankPage:(EaseBlankViewType)blankPageType hasData:(BOOL)hasData  offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block
{
    if (hasData)
    {
        if (self.blankView) {
            self.blankView.hidden = YES;
            [self.blankView removeFromSuperview];
        }
    }
    else
    {
        if (!self.blankView) {
            self.blankView = [[EaseBlankView alloc] initWithFrame:self.bounds];
        }
        
        self.blankView.hidden = NO;
        [self.blankPageContainer insertSubview:self.blankView atIndex:0];
        [self.blankView configWithType:blankPageType hasData:hasData  offsetY:offsetY reloadButtonBlock:block];
    }
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}
@end

@implementation EaseBlankView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configWithType:(EaseBlankViewType)blankPageType hasData:(BOOL)hasData  offsetY:(CGFloat)offsetY reloadButtonBlock:(void (^)(id))block
{
    if (hasData)
    {
        [self removeFromSuperview];
        return;
    }
    else
    {
        self.alpha = 1.0;
        //    图片
        if (!_monkeyView)
        {
            _monkeyView = [[UIImageView alloc] initWithFrame:CGRectZero];
            _monkeyView.contentMode = UIViewContentModeScaleAspectFill;
            if (block)
            {
                _monkeyView.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
                [_monkeyView addGestureRecognizer:singleTap];
                  _reloadButtonBlock = block;
            }
            [self addSubview:_monkeyView];
        }
        
        //    标题
        if (!_titleLabel)
        {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.numberOfLines = 0;
            _titleLabel.font = [UIFont systemFontOfSize:12];
            _titleLabel.textColor = [UIColor darkGrayColor];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_titleLabel];
        }
        
        if (blankPageType == EaseBlankNetworkError) {
            _monkeyView.image = [UIImage imageNamed:@"list_emptdata.png"];
            _titleLabel.text = DqLocalizedString(@"device_no_conncet");
        }
        else if(blankPageType == EaseBlankEmptyData)
        {
            _monkeyView.image = [UIImage imageNamed:@"image"];
            _titleLabel.text = DqLocalizedString(@"no_data");
        }
        
        //    布局
        if (ABS(offsetY) > 0) {
            self.frame = CGRectMake(0, offsetY, self.width, self.height);
        }
        
        [_monkeyView mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(self);
            // make.top.equalTo(self.mas_bottom).multipliedBy(0.15);
             make.centerY.equalTo(self).offset(-40);
             make.size.mas_equalTo(CGSizeMake(100, 100));
         }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.top.equalTo(_monkeyView.mas_bottom).offset(20);
        }];
    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_reloadButtonBlock) {
            _reloadButtonBlock(nil);
            _reloadButton = nil;
        }
    });
}
@end

