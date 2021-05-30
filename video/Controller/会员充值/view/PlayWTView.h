//
//  PlayWTView.h
//  video
//
//  Created by macbook on 2021/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PlayWTViewindexBlock)(NSInteger Index); //0为取消  1为返回重新支付 2为支付查询
@interface PlayWTView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (weak, nonatomic) IBOutlet UIButton *playCXBtn;


@property (weak, nonatomic) IBOutlet UIButton *okBtn;


@property (nonatomic,copy) PlayWTViewindexBlock touchIndex;

@end

NS_ASSUME_NONNULL_END
