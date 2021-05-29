//
//  KFView.h
//  video
//
//  Created by nian on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^KFViewindexBlock)(NSInteger Index); //0为取消  1为确定
@interface KFView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *EWMImage;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleTop;
@property (weak, nonatomic) IBOutlet UILabel *titleDown;
@property (nonatomic,copy) KFViewindexBlock touchIndex;
@end

NS_ASSUME_NONNULL_END
