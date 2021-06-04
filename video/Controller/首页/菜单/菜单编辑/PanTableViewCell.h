//
//  PanTableViewCell.h
//  PanYuanFeng
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019 lianzhonghulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectWhichlabelDelegete <NSObject>

-(void)SelectWhichlabel:(NSString *)labelText;

@end

@interface PanTableViewCell : UITableViewCell
@property(strong,nonatomic)NSArray * dataArr;

@property(weak,nonatomic)id<SelectWhichlabelDelegete>deleget;


@end
