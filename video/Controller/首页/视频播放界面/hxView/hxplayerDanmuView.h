//
//  hxplayerDanmuView.h
//  video
//
//  Created by macbook on 2021/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^hxplayerDanmuViewBlock)(NSInteger Index); //0为字体view  1为消息发送按钮
@interface hxplayerDanmuView : UIView
@property (weak, nonatomic) IBOutlet UITextField *centerTextfield;
@property (weak, nonatomic) IBOutlet UIButton *ZitiBtn;
@property (weak, nonatomic) IBOutlet UIButton *SendBtn;

@property (nonatomic,copy) hxplayerDanmuViewBlock touchIndex;
@end

NS_ASSUME_NONNULL_END
