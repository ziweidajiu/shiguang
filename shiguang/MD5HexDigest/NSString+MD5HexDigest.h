/**
 * @file
 * @author 单宝华
 * @date 2013-02-16
 */
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

/**
 * @category NSString(MD5)
 * @brief 字符串MD5加密类
 * @author 单宝华
 * @date 2013-02-16
 */
@interface NSString(MD5)

/// @brief 返回一个字符串加密过的MD5编码，原字符串不发生改变
- (NSString *)md5HexDigest;

- (NSString *)improveMD5;

@end
