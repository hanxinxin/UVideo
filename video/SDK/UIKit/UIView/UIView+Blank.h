//
//  UIView+ Blank.h
//

#import <UIKit/UIKit.h>
#import<QuartzCore/QuartzCore.h>

@class EaseBlankView;
typedef NS_ENUM(NSInteger, EaseBlankViewType)
{
    EaseBlankNetworkError,
    EaseBlankEmptyData,
};

@interface UIView (Common)
@property (strong, nonatomic) EaseBlankView *blankView;

/**
 

 @param blankPageType 显示emtpyt类型
 @param hasData YES:销毁emptyView,NO:显示empthView
 @param block NO的情况才会回调，
 */
- (void)configBlankPage:(EaseBlankViewType)blankPageType hasData:(BOOL)hasData reloadButtonBlock:(void(^)(id sender))block;
- (void)configBlankPage:(EaseBlankViewType)blankPageType hasData:(BOOL)hasData offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block;
@end

@interface EaseBlankView : UIView
@property (strong, nonatomic) UIImageView *monkeyView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *reloadButton, *actionButton;
@property (assign, nonatomic) EaseBlankViewType curType;
@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);
@property (copy, nonatomic) void(^loadAndShowStatusBlock)();
@property (copy, nonatomic) void(^clickButtonBlock)(EaseBlankViewType curType);
- (void)configWithType:(EaseBlankViewType)blankPageType hasData:(BOOL)hasData offsetY:(CGFloat)offsetY reloadButtonBlock:(void(^)(id sender))block;
@end

