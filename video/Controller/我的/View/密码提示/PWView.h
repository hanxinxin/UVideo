//
//  PWView.h
//  video
//
//  Created by nian on 2021/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PWViewindexBlock)(NSInteger Index); //0为取消  1为确定
@interface PWView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *topimage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (nonatomic,copy) PWViewindexBlock touchIndex;
@end

NS_ASSUME_NONNULL_END
