//
//  chongzhiView.h
//  video
//
//  Created by macbook on 2021/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^chongzhiViewindexBlock)(NSInteger Index); //0为取消  1为确定
@interface chongzhiView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic,copy) chongzhiViewindexBlock touchIndex;
@end

NS_ASSUME_NONNULL_END
