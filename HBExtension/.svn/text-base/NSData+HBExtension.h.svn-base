
#import <Foundation/Foundation.h>

#pragma mark -

@interface NSData(HBExtension)

@property (nonatomic, readonly) NSData *	MD5;
@property (nonatomic, readonly) NSString *	MD5String;

+ (NSString *)fromResource:(NSString *)resName;

@end


@interface NSData(AES256)
-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;
@end