//
//  KMPlayView.h
//  video
//
//  Created by macbook on 2021/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^KMPlayViewindexBlock)(NSInteger Index,NSString * pwStr); //0为取消  1为确定
@interface KMPlayView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *PWText;
@property (weak, nonatomic) IBOutlet UIButton *okPlayBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic,copy) KMPlayViewindexBlock touchIndex;

@end

NS_ASSUME_NONNULL_END
