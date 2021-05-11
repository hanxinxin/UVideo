//
//  NSString+YJStringExtension.m
//  YJTool_Demo
//
//  Created by yangjian on 2019/2/2.
//  Copyright © 2019 zhangshuyue. All rights reserved.
//

#import "NSString+YJStringExtension.h"

@implementation NSString (YJStringExtension)

#pragma mark - 处理Null 字符串
- (NSString *)handleNullString {
    return [self isNullStringWithReplace:@""];
}

- (NSString *)isNullStringWithReplace:(NSString *)replaceString {
    return self.length == 0 ? replaceString : self;
}


#pragma mark - 把基本类型转换为字符串

//把inter类型转换为字符串类型
+ (NSString *)stringWithInteger:(NSInteger)integer {
    return [NSString stringWithFormat:@"%@",@(integer)];
}

//把double类型转换为字符串
+ (NSString *)stringWithDouble:(double)doub {
    return [NSString stringWithFormat:@"%@",@(doub)];
}

//把bool类型转换为字符串
+ (NSString *)stringWithBool:(BOOL)val {
    return [NSString stringWithBool:val trueVal:@"YES" falseVal:@"NO"];
}

//把bool转换为字符串
+ (NSString *)stringWithBool:(BOOL)val trueVal:(NSString *)trueVal falseVal:(NSString *)falseVal {
    return val == YES ? trueVal : falseVal;
}



#pragma mark --- 判断字符串是否符合某个规则

+ (NSString *)regularWithRuleType:(NSStringRuleType)ruleType
{
    switch (ruleType) {
        case NSStringRuleTypeDefault:
            return nil;
            break;
        case NSStringRuleTypeOnlyChinese:
            return @"[\u4e00-\\u9fa5]";
            break;
        case NSStringRuleTypeOnlyEnglish:
            return @"[a-zA-Z]";
            break;
        case NSStringRuleTypeOnlyNumber:
            return @"[0-9]";
            break;
        case NSStringRuleTypeChineseEnglish:
            return @"[a-zA-Z\\u4e00-\\u9fa5]";
            break;
        case NSStringRuleTypeChineseNumber:
            return @"[0-9\\u4e00-\\u9fa5]";
            break;
        case NSStringRuleTypeEnglishNumber:
            return @"[a-zA-Z0-9]";
            break;
        case NSStringRuleTypeChineseEnglistNumber:
            return @"[0-9a-zA-Z\\u4e00-\\u9fa5]";
            break;
        default:
            break;
    }
    return nil;
}

//根据规则类型获取正则表达式
+ (NSString *)regularWithRuleType:(NSStringRuleType)ruleType min:(int)min max:(int)max
{
    NSString *regular = [NSString regularWithRuleType:ruleType];
    NSString *rule  = [NSString stringWithFormat:@"%@{%d,%d}",regular,min,max];
    return rule;
}

//判断字符串是否是某一规则，并且在某一个长度范围内
- (BOOL)isRuleType:(NSStringRuleType)ruleType min:(int)min max:(int)max
{
    if (ruleType == NSStringRuleTypeDefault) {
        return YES;
    }
    NSString *regular = [NSString regularWithRuleType:ruleType min:min max:max];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self MATCHES %@",regular];
    return [predicate evaluateWithObject:self];
}

+(NSString *)deleteNullStr:(NSString *)needString DeleteStr:(NSString *)deleteStr{
    NSString *newString = [needString stringByReplacingOccurrencesOfString:deleteStr withString:@""];
    return newString;
}

+(NSString *)DealNilString:(NSString *)string{
    if (!string) {
        return @"";
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] ||[string isEqualToString:@"null"] || [string isEqualToString:@"（null）"]) {
            return @"";
        }
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmedStr = [string stringByTrimmingCharactersInSet:set];
        if (!trimmedStr.length) {
            return @"";
        }
    }
    return string;
}

/**
 判断字符串是否为空
 @param aStr 需要判断的字符串
 @return  空：YES   不空：NO
 */
-(BOOL)isNullString:(NSString *)aStr{
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSString class]]) {
        if ([aStr isEqualToString:@"(null)"] || [aStr isEqualToString:@"<null>"] ||[aStr isEqualToString:@"null"] || [aStr isEqualToString:@"（null）"]) {
            return YES;
        }
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
        if (!trimmedStr.length) {
            return YES;
        }
    }
    return NO;
}

@end
