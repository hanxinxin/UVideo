//
//  NSString+YJStringExtension.h
//  YJTool_Demo
//
//  Created by yangjian on 2019/2/2.
//  Copyright © 2019 zhangshuyue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NSStringRuleTypeDefault,                    //默认的类型：没有条件限制
    NSStringRuleTypeOnlyChinese,                //仅仅中文  -   模式。
    NSStringRuleTypeOnlyEnglish,                //仅仅英文  -   英文。
    NSStringRuleTypeOnlyNumber,                 //仅仅数字  -   模式
    NSStringRuleTypeChineseEnglish,             //中文 - 英文：模式
    NSStringRuleTypeChineseNumber,              //中文 - 数字：模式
    NSStringRuleTypeEnglishNumber,              //英文 - 数字：模式
    NSStringRuleTypeChineseEnglistNumber,       //中文 - 英文 - 数组：模式
    NSStringRuleTypeEmail,                      //邮箱
} NSStringRuleType;


@interface NSString (YJStringExtension)

#pragma mark - 把基本类型转换为字符串

//把integer类型转换为字符串类型
+ (NSString *)stringWithInteger:(NSInteger)integer;

//把double类型转换为字符串
+ (NSString *)stringWithDouble:(double)doub;

//把bool类型转换为字符串
+ (NSString *)stringWithBool:(BOOL)val;

//把bool类型转换为字符串
+ (NSString *)stringWithBool:(BOOL)val trueVal:(NSString *)trueVal falseVal:(NSString *)falseVal;


#pragma mark - 处理空字符串

//判断字符串是否是空字符：如果是空字符串返回@"",以防止存入字典中为空。
- (NSString *)handleNullString;

//判断是否是空字符串，如果是空字符串，则使用某一个字符串进行替换
- (NSString *)isNullStringWithReplace:(NSString *)replaceString;


#pragma mark --- 判断自负串是否符合某个规则

//根据类型获取对应的正则表达式
+ (NSString *)regularWithRuleType:(NSStringRuleType)ruleType;

//根据规则类型获取正则表达式
+ (NSString *)regularWithRuleType:(NSStringRuleType)ruleType min:(int)min max:(int)max;

//判断字符串是否是某一规则，并且在某一个长度范围内
- (BOOL)isRuleType:(NSStringRuleType)ruleType min:(int)min max:(int)max;


+(NSString *)deleteNullStr:(NSString *)needString DeleteStr:(NSString *)deleteStr;

/**
 处理nil字符串的显示问题(nil、(null)  ->  @"")
 
 @param string 需要处理的字符串
 @return str
 */
+(NSString *)dealNilString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
