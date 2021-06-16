//
//  SHeaderView.h
//  video
//
//  Created by nian on 2021/3/11.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^SHeaderViewindexBlock)(NSInteger tag); //0为取消  1为确定
@interface SHeaderView : UICollectionReusableView
@property (nonatomic,strong)UIImageView * leftImage;
@property (nonatomic,strong)UILabel * leftLabel;
@property (nonatomic,strong)UIButton * rightBtn;
@property (nonatomic,strong)UIImageView * rightImage;
-(void)setLeftTitle:(NSString *)Str;
-(void)setRightTitle:(NSString *)Str;

@property (nonatomic,copy) SHeaderViewindexBlock touchIndex;
@end

NS_ASSUME_NONNULL_END
