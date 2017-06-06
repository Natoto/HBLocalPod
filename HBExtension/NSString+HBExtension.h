
#import <Foundation/Foundation.h>
#define STRING_(OBJ) [NSString stringWithFormat:@"%@",OBJ?OBJ:@""]
#define STRING_FORMAT_(FORMAT,...) [NSString stringWithFormat:FORMAT,__VA_ARGS__]

#define NUMBER_(OBJ) [NSNumber numberWithLongLong:OBJ.longLongValue]


#pragma mark -

typedef NSString *			(^NSStringAppendBlock)( id format, ... );
typedef NSString *			(^NSStringReplaceBlock)( NSString * string, NSString * string2 );

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
typedef NSMutableString *	(^NSMutableStringReplaceBlock)( NSString * string, NSString * string2 );

#pragma mark -

@interface NSString(BeeExtension)

@property (nonatomic, readonly) NSStringAppendBlock		APPEND;
@property (nonatomic, readonly) NSStringAppendBlock		LINE;
@property (nonatomic, readonly) NSStringReplaceBlock	REPLACE;

@property (nonatomic, readonly) NSData *				data;
@property (nonatomic, readonly) NSDate *				date;

@property (nonatomic, readonly) NSString *				MD5;
@property (nonatomic, readonly) NSData *				MD5Data;

// thanks to @uxyheaven
@property (nonatomic, readonly) NSString *				SHA1;

-(BOOL)containsString:(NSString *)str;

- (NSString*)md532BitLower;
- (NSString*)md532BitUpper;
- (NSArray *)allURLs;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingArray:(NSArray *)params;
- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;

+ (NSRegularExpression *)regexAt;
- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

- (NSString *)trim;
- (NSString *)unwrap;
- (NSString *)repeat:(NSUInteger)count;
- (NSString *)normalize;

- (BOOL)match:(NSString *)expression;
- (BOOL)matchAnyOf:(NSArray *)array;

- (BOOL)empty;
- (BOOL)notEmpty;

- (BOOL)eq:(NSString *)other;
- (BOOL)equal:(NSString *)other;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (BOOL)isNormal;		// thanks to @uxyheaven
- (BOOL)isTelephone;
- (BOOL)isUserName;
- (BOOL)isChineseUserName;
- (BOOL)isChinese;
- (BOOL)isPassword;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isIPAddress;
- (BOOL)isQQ;
/**
 *  是否是金额 小数点后面最多两位的
 *
 */
- (BOOL)isMoneyAmount;

/**
 *  是否是台湾身份证号
 *
 */
- (BOOL)isTaiWanIDCard;

-(BOOL)isallHtmlMark;
+(NSUInteger) unicodeLengthOfString: (NSString *) text;
+(NSUInteger) unicodeIndexOfString: (NSString *) text index:(NSInteger)index;
+(NSString *) subStringByUnicodeIndex:(NSString *) text asciiLength:(NSInteger)asciiIndex;

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset;

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (NSString *)fromResource:(NSString *)resName;


- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
@end

#pragma mark -

@interface NSMutableString(BeeExtension)

@property (nonatomic, readonly) NSMutableStringAppendBlock	APPEND;
@property (nonatomic, readonly) NSMutableStringAppendBlock	LINE;
@property (nonatomic, readonly) NSMutableStringReplaceBlock	REPLACE;

@end

@interface NSString(AES256)

-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;

@end
