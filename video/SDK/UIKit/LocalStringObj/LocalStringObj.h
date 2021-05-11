//
//  LocalStringObj.h
//  iSmartHome
//
//  Created by Daqi on 2016/12/5.
//  Copyright © 2016年 crazyit.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStringObj : NSObject
+ (NSString *)LocalizedString:(NSString *)translation_key;
+ (NSString *)emailLanguage:(NSString *)req;
+(NSString *)datePickerLocalString;
@end
