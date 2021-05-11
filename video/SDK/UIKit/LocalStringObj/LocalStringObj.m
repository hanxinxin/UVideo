//
//  LocalStringObj.m
//  iSmartHome
//
//  Created by Daqi on 2016/12/5.
//  Copyright © 2016年 crazyit.org. All rights reserved.
//

#import "LocalStringObj.h"
#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])

@implementation LocalStringObj
+ (NSString *)LocalizedString:(NSString *)translation_key
{
//    NSLog(@"CURR_LANG == %@",CURR_LANG);
    NSString * s = NSLocalizedString(translation_key, nil);
    if ([CURR_LANG rangeOfString:@"zh-Hans"].length)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if([CURR_LANG hasPrefix:@"es"]){ //西班牙
        NSString *path = [[NSBundle mainBundle] pathForResource:@"es" ofType:@"lproj"];
        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if([CURR_LANG hasPrefix:@"fr"]){ //法语
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fr" ofType:@"lproj"];
        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }else if([CURR_LANG hasPrefix:@"ru"]){ //俄语
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ru" ofType:@"lproj"];
        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    else
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    return s;

}

+ (NSString *)emailLanguage:(NSString *)req
{
    if ([CURR_LANG rangeOfString:@"zh-Hans"].length)
    {
        req = [req stringByAppendingString:@"zh-cn"];
    }
    else
    {
        req = [req stringByAppendingString:@"en-us"];
    }
    return req;
}


+(NSString *)datePickerLocalString{
    
    NSString *req = nil;
    if ([CURR_LANG rangeOfString:@"zh-Hans"].length)
    {
        req = @"zh_CN";
    }
    else
    {
        req = @"en_US";
    }
    return req;
}
@end
