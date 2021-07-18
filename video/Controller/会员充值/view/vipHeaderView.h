//
//  vipHeaderView.h
//  video
//
//  Created by macbook on 2021/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^vipHeaderViewindexBlock)(NSInteger Index); //1为头像  2为name
@interface vipHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *txImage;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;


@property (nonatomic,copy) vipHeaderViewindexBlock touchIndex;
@end

NS_ASSUME_NONNULL_END
