#import "NSString+MD5HexDigest.h"

@implementation NSString (md5)

- (NSString *)md5HexDigest {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)improveMD5 {
    char hexDigits[]={'0', 'z', 'f', '3', 'x', '5', '6', '7', 'p', '9', 'a', 'b', '2', 'd', 'e', 'g'};
    const char *original_str = [self UTF8String];
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, original_str, [self cStringLength]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSMutableString *result = [NSMutableString string];
    for (NSInteger idx = 0; idx != CC_MD5_DIGEST_LENGTH; ++idx) {
        char byte = digest[idx];
        [result appendFormat:@"%c", hexDigits[(byte >> 5) & 0xf]];
        [result appendFormat:@"%c", hexDigits[byte & 0xf]];
    }
    
    return result;
    
//    char hexDigits[]={'0', 'z', 'f', '3', 'x', '5', '6', '7', 'p', '9', 'a', 'b', '2', 'd', 'e', 'g'};
//    const char *original_str = [self UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
//    
//    NSMutableString *hash = [NSMutableString string];
//    for (NSInteger idx = 0; idx != CC_MD5_DIGEST_LENGTH; ++idx) {
//        char byte = original_str[idx];
//        [hash appendFormat:@"%c", hexDigits[(byte >> 5) & 0xf]];
//        [hash appendFormat:@"%c", hexDigits[byte & 0xf]];
//    }
//    
//    return hash;
}

@end
