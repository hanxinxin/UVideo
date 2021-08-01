//
//  EmailBDViewController.h
//  video
//
//  Created by macbook on 2021/8/1.
//

#import <UIKit/UIKit.h>
#import "HXBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface EmailBDViewController : HXBaseViewController

@property(nonatomic,strong)UIImageView * topImageBg;

@property(nonatomic,strong)UIView * centerView;

@property(nonatomic,strong)UITextField *emailTextfield;
@property(nonatomic,strong)UITextField *passwordTextfield;
@property(nonatomic,strong)UIView *CodeView;
@property(nonatomic,strong)UIButton *getCodeBtn;
@property(nonatomic,strong)UITextField *CodeTextfield;


@property(nonatomic,strong)UIButton * backBtn;
@property(nonatomic,strong)UIButton * ZCBtn;
@property(nonatomic,strong)UIButton * XGBtn;


@end

NS_ASSUME_NONNULL_END
