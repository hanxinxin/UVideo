//
//  VideoplaySetView.h
//  video
//
//  Created by nian on 2021/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^VideoplaySetViewBlock)(NSInteger index); //0 没登录 1 不是会员
@interface VideoplaySetView : UIView
@property (weak, nonatomic) IBOutlet UILabel *hmbl_Label;
@property (weak, nonatomic) IBOutlet UIButton *hmblBtn;
@property (weak, nonatomic) IBOutlet UIButton *hmblBtn1;
@property (weak, nonatomic) IBOutlet UIButton *hmblBtn2;
@property (weak, nonatomic) IBOutlet UILabel *zimuKG_Label;
@property (weak, nonatomic) IBOutlet UISwitch *zimuSwitch;
@property (weak, nonatomic) IBOutlet UILabel *zimuPY_Label;
@property (weak, nonatomic) IBOutlet UIButton *pyJiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *pyJianBtn;
@property (weak, nonatomic) IBOutlet UILabel *tgPTPW_Label;
@property (weak, nonatomic) IBOutlet UISwitch *tgPTPWSwitch;
@property (weak, nonatomic) IBOutlet UIButton *tgvipBtn;



@property (nonatomic,copy) VideoplaySetViewBlock touchIndex;
@end

NS_ASSUME_NONNULL_END
