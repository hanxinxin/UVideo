//
//  hxplayerDanmuView.m
//  video
//
//  Created by macbook on 2021/6/6.
//

#import "hxplayerDanmuView.h"

@implementation hxplayerDanmuView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder: aDecoder]) {
       
    }
    return self;
}
-(void)awakeFromNib {

    [super awakeFromNib];
}
- (IBAction)ZitiTouch:(id)sender {
    
    if (self.touchIndex) {
        self.touchIndex(0);
    }
}
- (IBAction)SendTouch:(id)sender {
    if (self.touchIndex) {
        self.touchIndex(1);
    }
}



@end
