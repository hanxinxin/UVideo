//
//  promptbottomView.h
//  video
//
//  Created by macbook on 2021/5/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^promptindexBlock)(NSInteger Index); //0为取消  1为确定
@interface promptbottomView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomview;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleMS;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtnT;


@property (nonatomic,copy) promptindexBlock touchIndex;
@end

NS_ASSUME_NONNULL_END
