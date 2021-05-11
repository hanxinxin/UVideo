//
//  UILabel+YJChangeLineSpaceAndWordSpace.h
//  YJTool_Demo
//
//  Created by yangjian on 2019/2/12.
//  Copyright © 2019 zhangshuyue. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UILabel (YJChangeLineSpaceAndWordSpace)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;



@end


