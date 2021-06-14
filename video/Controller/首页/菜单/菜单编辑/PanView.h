//
//  PanView.h
//  PanYuanFeng
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 lianzhonghulian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^selectBock)(NSString *labelText,NSIndexPath*indexPath,NSInteger celltag);

@interface PanView : UIView
@property(strong,nonatomic)UITableView * mainView;
@property(strong,nonatomic)NSDictionary * dataDic;
-(instancetype)initWithFrame:(CGRect)frame WithTextDic:(NSDictionary *)textDic;
@property(copy,nonatomic)selectBock block;

@end

