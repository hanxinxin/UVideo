//
//  LoginViewController.h
//  video
//
//  Created by nian on 2021/5/13.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : HXBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;



@property (weak, nonatomic) IBOutlet UIButton *ZC_btn;
@property (weak, nonatomic) IBOutlet UIButton *DL_Btn;
@property (weak, nonatomic) IBOutlet UIButton *WJMM_btn;

@end

NS_ASSUME_NONNULL_END
