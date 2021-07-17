//
//  HomeTitleView.m
//  video
//
//  Created by nian on 2021/3/15.
//

#import "HomeTitleView.h"

@implementation HomeTitleView

- (CGSize)intrinsicContentSize{
    return UILayoutFittingExpandedSize;
}

//- (CGSize)intrinsicContentSize{
//return CGSizeMake(SCREEN_WIDTH - (80+40), 30);//自行更改，240可以根据左右两边的按钮数量计算得到，随意修改。
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
