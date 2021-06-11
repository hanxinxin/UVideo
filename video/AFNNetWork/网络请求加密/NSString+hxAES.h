//
//  NSString+hxAES.h
//  video
//
//  Created by nian on 2021/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (hxAES)

/**< 加密方法 */
//- (NSString*)aci_encryptWithAES;
- (NSString*)aci_encryptWithAES:(NSString*)PSW_AES_KEY;
 
/**< 解密方法 */
- (NSString*)aci_decryptWithAES:(NSString*)PSW_AES_KEY;
@end

NS_ASSUME_NONNULL_END
