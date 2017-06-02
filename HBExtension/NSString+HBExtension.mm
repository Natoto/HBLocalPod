
#import "NSObject+HBTypeConversion.h"
#import "NSString+HBExtension.h"
#import "NSData+HBExtension.h"
#import <CommonCrypto/CommonCrypto.h>
// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSString(BeeExtension)

@dynamic data;
@dynamic date;

@dynamic MD5;
@dynamic MD5Data;

@dynamic SHA1;

@dynamic APPEND;
@dynamic LINE;
@dynamic REPLACE;

- (NSData *)data
{
	return [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

- (NSDate *)date
{
	NSTimeZone * local = [NSTimeZone localTimeZone];
	
	NSString * format = @"yyyy-MM-dd HH:mm:ss";
	NSString * text = [(NSString *)self substringToIndex:format.length];
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
	[dateFormatter setDateFormat:format];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
							  sinceDate:[dateFormatter dateFromString:text]];
}

- (NSStringAppendBlock)APPEND
{
	NSStringAppendBlock block = ^ NSString * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
				
		NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
		
		NSMutableString * copy = [self mutableCopy];
		[copy appendString:append];

		va_end( args );
		
		return copy ;
	};

	return [block copy] ;
}

- (NSStringAppendBlock)LINE
{
	NSStringAppendBlock block = ^ NSString * ( id first, ... )
	{
		NSMutableString * copy = [self mutableCopy];

		if ( first )
		{
			va_list args;
			va_start( args, first );
			
			NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
			[copy appendString:append];

			va_end( args );
		}

		[copy appendString:@"\n"];

		return copy ;
	};
	
	return [block copy] ;
}

- (NSStringReplaceBlock)REPLACE
{
	NSStringReplaceBlock block = ^ NSString * ( NSString * string1, NSString * string2 )
	{
		return [self stringByReplacingOccurrencesOfString:string1 withString:string2];
	};
	
	return [block copy] ;
}

- (NSArray *)allURLs
{
	NSMutableArray * array = [NSMutableArray array];
	NSCharacterSet * charSet = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_.+!*'():/"] invertedSet];

	NSInteger stringIndex = 0;
	while ( stringIndex < self.length )
	{
		NSRange searchRange = NSMakeRange(stringIndex, self.length - stringIndex);
		NSRange httpRange = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
		NSRange httpsRange = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:searchRange];
		
		NSRange startRange;
		if ( httpRange.location == NSNotFound )
		{
			startRange = httpsRange;
		}
		else if ( httpsRange.location == NSNotFound )
		{
			startRange = httpRange;
		}
		else
		{
			startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
		}
		
		if (startRange.location == NSNotFound)
		{
			break;			
		}
		else
		{
			NSRange beforeRange = NSMakeRange( searchRange.location, startRange.location - searchRange.location );
			if ( beforeRange.length )
			{
				//				NSString * text = [string substringWithRange:beforeRange];
				//				[array addObject:text];
			}

			NSRange subSearchRange = NSMakeRange(startRange.location, self.length - startRange.location);
//			NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
			NSRange endRange = [self rangeOfCharacterFromSet:charSet options:NSCaseInsensitiveSearch range:subSearchRange];
			if ( endRange.location == NSNotFound)
			{
				NSString * url = [self substringWithRange:subSearchRange];
				[array addObject:url];
				break;				
			}
			else
			{
				NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
				NSString * url = [self substringWithRange:URLRange];
				[array addObject:url];
				
				stringIndex = endRange.location;
			}
		}
	}
	
	return array;
}

+(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    } 
    return asciiLength;
}

+(NSString *) subStringByUnicodeIndex:(NSString *) text asciiLength:(NSInteger)asciiIndex {
    NSUInteger index = 0;
    NSUInteger i = 0;
    for (i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        index += isascii(uc) ? 1 : 2;
        if (asciiIndex <= index) {
            break;
        }
    }
    return [text substringToIndex:i];
}

//第index个unicode字符是第几位
+(NSUInteger) unicodeIndexOfString: (NSString *) text index:(NSInteger)index {
    NSUInteger asciiLength = 0;
    NSUInteger i = 0;
    for (i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
        if (asciiLength >= index) {
            break;
        }
    }
    return i;
}


+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    return [self queryStringFromDictionary:dict encoding:YES];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding
{
    NSMutableArray * pairs = [NSMutableArray array];
	for ( NSString * key in dict.allKeys )
	{
		NSString * value = [((NSObject *)[dict objectForKey:key]) asNSString];
		NSString * urlEncoding = encoding ? [value URLEncoding] : value;
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromArray:(NSArray *)array
{
    return [self queryStringFromArray:array encoding:YES];
}

+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding
{
	NSMutableArray *pairs = [NSMutableArray array];
	
	for ( NSUInteger i = 0; i < [array count]; i += 2 )
	{
		NSObject * obj1 = [array objectAtIndex:i];
		NSObject * obj2 = [array objectAtIndex:i + 1];
		
		NSString * key = nil;
		NSString * value = nil;
		
		if ( [obj1 isKindOfClass:[NSNumber class]] )
		{
			key = [(NSNumber *)obj1 stringValue];
		}
		else if ( [obj1 isKindOfClass:[NSString class]] )
		{
			key = (NSString *)obj1;
		}
		else
		{
			continue;
		}
		
		if ( [obj2 isKindOfClass:[NSNumber class]] )
		{
			value = [(NSNumber *)obj2 stringValue];
		}
		else if ( [obj1 isKindOfClass:[NSString class]] )
		{
			value = (NSString *)obj2;
		}
		else
		{
			continue;
		}
		
		NSString * urlEncoding = encoding ? [value URLEncoding] : value;
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromKeyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
		
		[dict setObject:value forKey:key];
	}
	va_end( args );
	return [NSString queryStringFromDictionary:dict];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    return [self urlByAppendingDict:params encoding:YES];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromDictionary:params encoding:encoding];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];	
}

- (NSString *)urlByAppendingArray:(NSArray *)params
{
    return [self urlByAppendingArray:params encoding:YES];
}

- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromArray:params encoding:encoding];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];		
}

- (NSString *)urlByAppendingKeyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;

		[dict setObject:value forKey:key];
	}
    va_end( args );
	return [self urlByAppendingDict:dict];
}

- (BOOL)empty
{
	return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty
{
	return [self length] > 0 ? YES : NO;
}

- (BOOL)eq:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)equal:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)is:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other
{
	return NO == [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
	return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
	NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
	
	for ( NSObject * obj in array )
	{
		if ( NO == [obj isKindOfClass:[NSString class]] )
			continue;
		
		if ( [(NSString *)obj compare:self options:option] )
			return YES;
	}
	
	return NO;
}

- (NSString *)URLEncoding
{  
	NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
																			(CFStringRef)self,
																			NULL,  
																			(CFStringRef)@"!*'();:@&=+$,/?%#[]",  
																			kCFStringEncodingUTF8 ));
	return result ;
} 

- (NSString *)URLDecoding
{
	NSMutableString * string = [NSMutableString stringWithString:self]; 
    [string replaceOccurrencesOfString:@"+"  
							withString:@" "  
							   options:NSLiteralSearch  
								 range:NSMakeRange(0, [string length])];  
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//md5 32位 加密 （小写）
- (NSString*)md532BitLower
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
- (NSString*)md532BitUpper
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

- (NSString *)MD5
{
	NSData * value;
	
	value = [NSData dataWithBytes:[self UTF8String] length:[self length]];
	value = [value MD5];

	if ( value )
	{
		char			tmp[16];
		unsigned char *	hex = (unsigned char *)malloc( 2048 + 1 );
		unsigned char *	bytes = (unsigned char *)[value bytes];
		unsigned long	length = [value length];
		
		hex[0] = '\0';
		
		for ( unsigned long i = 0; i < length; ++i )
		{
			sprintf( tmp, "%02X", bytes[i] );
			strcat( (char *)hex, tmp );
		}
		
		NSString * result = [NSString stringWithUTF8String:(const char *)hex];
		free( hex );
		return result;
	}
	else
	{
		return nil;
	}
}

- (NSData *)MD5Data
{
	// TODO:
	return nil;
}

// thanks to @uxyheaven
- (NSString *)SHA1
{
    const char *	cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *		data = [NSData dataWithBytes:cstr length:self.length];

    uint8_t			digest[CC_SHA1_DIGEST_LENGTH] = { 0 };
	CC_LONG			digestLength = (CC_LONG)data.length;

    CC_SHA1( data.bytes, digestLength, digest );

    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
    for ( int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ )
	{
		[output appendFormat:@"%02x", digest[i]];
	}

    return output;
}


+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
	if ( self.length >= 2 )
	{
		if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}

		if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}
	}

	return self;
}

- (NSString *)repeat:(NSUInteger)count
{
	if ( 0 == count )
		return @"";
	
	NSMutableString * text = [NSMutableString string];
	
	for ( NSUInteger i = 0; i < count; ++i )
	{
		[text appendString:self];
	}
	
	return text;
}

- (NSString *)normalize
{
	return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)isUserName
{
	NSString *		regex = @"(^[A-Za-z0-9]{3,20}$)";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isChineseUserName
{
	NSString *		regex = @"(^[A-Za-z0-9\u4e00-\u9fa5]{3,20}$)";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isQQ {
    NSString   *emailRegex = @"(^[0-9]*$)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPassword
{
	NSString *		regex = @"(^[A-Za-z0-9]{6,20}$)";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [pred evaluateWithObject:self];	
}

- (BOOL)isEmail
{
	NSString *		regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

/**
 *  是否是金额 小数点后面最多两位的
 *
 */
- (BOOL)isMoneyAmount
{
    NSString *regex = @"^\\d+(.\\d{0,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

//判断是否全部是标签
-(BOOL)isallHtmlMark
{
    int leftIndex =0;
    int rightIndex =0;
    BOOL isallmark = NO;
    int repeatCount =0;
    for(;;)
    {
        NSRange leftRange=[self rangeOfString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(leftIndex, self.length - leftIndex)];
        NSRange rightRange =[self rangeOfString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(rightIndex, self.length -rightIndex )];
        
        if (leftRange.location!=NSNotFound) {
             NSRange leftRange2=[self rangeOfString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(leftRange.location+1, self.length - leftRange.location -1)];
            if (rightRange.location!=NSNotFound) {
                if ( leftRange.location ==0 && rightRange.location == self.length -1) {
                    /*<font style='color:rgb(51, 51, 51)'> or 事件</strong>*/
                    isallmark = YES;
                    break;
                }
                if (leftRange2.location == NSNotFound) {/*循环结束条件 */
                    break;
                }
                if ( rightRange.location == self.length -1 && !repeatCount) {
                     isallmark = YES;
                    break;
                }
                repeatCount ++;
                if ((leftRange2.location - rightRange.location)==1) {/*<font ><strong> */
                    isallmark = YES;
                }
                else if ((leftRange2.location - rightRange.location) > 1)
                {
                    isallmark = NO;
                    break;
                }
                rightIndex = leftRange2.location;
                leftIndex = rightIndex +1;
            }
            else
            {
                isallmark = NO;
                break;
            }
        }
        else
        {
            break;
        }
    }
    return isallmark;
}
- (BOOL)isUrl
{
    NSString *		regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isIPAddress
{
	NSArray *			components = [self componentsSeparatedByString:@"."];
	NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
	
	if ( [components count] == 4 )
	{
		NSString *part1 = [components objectAtIndex:0];
		NSString *part2 = [components objectAtIndex:1];
		NSString *part3 = [components objectAtIndex:2];
		NSString *part4 = [components objectAtIndex:3];
		
		if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			 [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			 [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			 [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
		{
			if ( [part1 intValue] < 255 &&
				 [part2 intValue] < 255 &&
				 [part3 intValue] < 255 &&
				 [part4 intValue] < 255 )
			{
				return YES;
			}
		}
	}
	
	return NO;
}

- (BOOL)isNormal
{
	NSString *		regex = @"([^%&',;=!~?$]+)";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

	return [pred evaluateWithObject:self];
}

/**
 *  是否是台湾身份证号
 *（检验非空 & 不多于10位数字+字母）
 */
- (BOOL)isTaiWanIDCard
{///^[0-9a-zA-Z]{1,10}$/
    NSString *		regex = @"^[0-9a-zA-Z]{1,10}$";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|7[0-9]|8[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[12789])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];

    return  [regextestmobile evaluateWithObject:self]   ||
            [regextestphs evaluateWithObject:self]      ||
            [regextestct evaluateWithObject:self]       ||
            [regextestcu evaluateWithObject:self]       ||
            [regextestcm evaluateWithObject:self];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset
{
	return [self substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
	if ( 0 == self.length )
		return nil;
	
	if ( from >= self.length )
		return nil;

	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];

	if ( NSNotFound == range2.location )
	{
		if ( endOffset )
		{
			*endOffset = range.location + range.length;
		}
		
		return [self substringWithRange:range];
	}
	else
	{
		if ( endOffset )
		{
			*endOffset = range2.location + range2.length;
		}

		return [self substringWithRange:NSMakeRange(from, range2.location - from)];
	}
}

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset
{
	if ( 0 == self.length )
		return 0;
	
	if ( from >= self.length )
		return 0;
	
	NSCharacterSet * reversedCharset = [charset invertedSet];

	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfCharacterFromSet:reversedCharset options:NSCaseInsensitiveSearch range:range];

	if ( NSNotFound == range2.location )
	{
		return self.length - from;
	}
	else
	{
		return range2.location - from;		
	}
}

-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width
{
	return [self sizeWithFont:font
			constrainedToSize:CGSizeMake(width, 999999.0f)
                lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height
{
	return [self sizeWithFont:font
			constrainedToSize:CGSizeMake(999999.0f, height)
				lineBreakMode:NSLineBreakByWordWrapping];
}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (NSString *)fromResource:(NSString *)resName
{
	NSString *	extension = [resName pathExtension];
	NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];

	NSString * path = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (BOOL)match:(NSString *)expression
{
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
																			options:NSRegularExpressionCaseInsensitive
																			  error:nil];
	if ( nil == regex )
		return NO;
	
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
														options:0
														  range:NSMakeRange(0, self.length)];
	if ( 0 == numberOfMatches )
		return NO;

	return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
	for ( NSString * str in array )
	{
		if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
		{
			return YES;
		}
	}
	
	return NO;
}

@end

#pragma mark -

@implementation NSMutableString(BeeExtension)

@dynamic APPEND;
@dynamic LINE;
@dynamic REPLACE;

- (NSMutableStringAppendBlock)APPEND
{
	NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * append = [[NSString alloc] initWithFormat:first arguments:args];

		va_end( args );

		if ( NO == [self isKindOfClass:[NSMutableString class]] )
		{
			NSMutableString * copy = [self mutableCopy];
			[copy appendString:append];
			
			return copy;
		}
		else
		{
			[self appendString:append];
		 
			
			return self;
		}
	};
	
	return [block copy] ;
}

- (NSMutableStringAppendBlock)LINE
{
	NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
	{
		NSString * append = nil;
		
		if ( first )
		{
			va_list args;
			va_start( args, first );
			
			append = [[NSString alloc] initWithFormat:first arguments:args];

			va_end( args );
		}

		if ( NO == [self isKindOfClass:[NSMutableString class]] )
		{
			NSMutableString * copy = [self mutableCopy];
			
			if ( append )
			{
				[copy appendString:append];
			}
			
			[copy appendString:@"\n"];
			
			return copy;
		}
		else
		{
			if ( append )
			{
				[self appendString:append];
			}
			
			[self appendString:@"\n"];
			
			return self;
		}

		return self;
	};
	
	return [block copy] ;
}

- (NSMutableStringReplaceBlock)REPLACE
{
	NSMutableStringReplaceBlock block = ^ NSMutableString * ( NSString * string1, NSString * string2 )
	{
		[self replaceOccurrencesOfString:string1
							  withString:string2
								 options:NSCaseInsensitiveSearch
								   range:NSMakeRange(0, self.length)];

		return self;
	};
	
	return [block copy] ;
}



- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

@end




@implementation NSString(AES256)

-(NSString *) aes256_encrypt:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data aes256_encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

-(NSString *) aes256_decrypt:(NSString *)key
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data aes256_decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}
  
-(BOOL)containsString:(NSString *)str{
    if (str && [self rangeOfString:str].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end

