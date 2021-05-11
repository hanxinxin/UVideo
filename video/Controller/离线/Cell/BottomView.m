//
//  BottomView.m
//  pod_test
//
//  Created by YY_ZYQ on 2017/6/23.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.xianlabel];
        [self addSubview:self.allBtnImage];
        [self addSubview:self.allBtn];
//        [self addSubview:self.readBtn];
        [self addSubview:self.deleteBtn];
    }
    return self;
}
//rgba(112, 112, 112, 1)
- (UILabel *)xianlabel{
    if (!_xianlabel) {
        self.xianlabel = [[UILabel alloc] init];
        _xianlabel.frame = CGRectMake(20, 0, self.bounds.size.width-20, 0.5);
        _xianlabel.backgroundColor=RGBA(112, 112, 112,0.5);
    }
    return _xianlabel;
}
- (UIButton *)allBtn{
    if (!_allBtn) {
        self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allBtn.frame = CGRectMake(10+25, 0, 40, self.bounds.size.height);
        _allBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_allBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _allBtn;
}
- (UIButton *)allBtnImage{
    if (!_allBtnImage) {
        self.allBtnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _allBtnImage.frame = CGRectMake(10,(self.bounds.size.height-20)/2, 20, 20);
//        [_allBtnImage setTitle:@"全选" forState:UIControlStateNormal];
        [_allBtnImage setImage:[UIImage imageNamed:@"photo_def"] forState:(UIControlStateNormal)];
        [_allBtnImage setImage:[UIImage imageNamed:@"logup_checkbox_on"] forState:(UIControlStateSelected)];
        [_allBtnImage setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
    }
    return _allBtnImage;
}

- (UIButton *)readBtn{
    if (!_readBtn) {
        self.readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _readBtn.frame = CGRectMake((self.bounds.size.width - 70)/2, 0, 70, self.bounds.size.height);
        _readBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_readBtn setTitle:@"标记已读" forState:UIControlStateNormal];
        [_readBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _readBtn;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.bounds.size.width - 50, 0, 40, self.bounds.size.height);
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

@end
