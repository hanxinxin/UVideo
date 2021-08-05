//
//  VideoplaySetView.h
//  video
//
//  Created by nian on 2021/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^VideoplaySetViewBlock)(NSInteger index); //0 没登录 1 不是会员

typedef void(^VideoplaySetViewSwitchBlock)(BOOL SwitchBool);  ///片头片尾开关按钮
typedef void(^VideoplaySetViewHMBLBlock)(NSInteger index); //0 默认 1 4:3 2 16:9
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
@property (nonatomic,copy) VideoplaySetViewSwitchBlock SwitchBlock;
@property (nonatomic,copy) VideoplaySetViewHMBLBlock touchHMBL;
@end

NS_ASSUME_NONNULL_END
