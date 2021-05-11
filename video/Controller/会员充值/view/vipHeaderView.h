//
//  vipHeaderView.h
//  video
//
//  Created by macbook on 2021/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface vipHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *txImage;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@end

NS_ASSUME_NONNULL_END
