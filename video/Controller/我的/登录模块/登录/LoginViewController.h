//
//  LoginViewController.h
//  video
//
//  Created by nian on 2021/5/13.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : HXBaseViewController

@property(nonatomic,strong)UIImageView * topImageBg;

@property(nonatomic,strong)UIView * centerView;
//@property(nonatomic,strong)UIView * centerView;
@property(nonatomic,strong)UITextField *emailTextfield;
@property(nonatomic,strong)UITextField *passwordTextfield;
@property(nonatomic,strong)UIView *CodeView;
@property(nonatomic,strong)UIButton *TuXingCodeBtn;
@property(nonatomic,strong)UIButton *getCodeBtn;
@property(nonatomic,strong)UITextField *CodeTextfield;


@property(nonatomic,strong)UIButton * backBtn;
@property(nonatomic,strong)UIButton * LoginBtn;

@end

NS_ASSUME_NONNULL_END
