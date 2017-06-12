
#import <Foundation/Foundation.h>
#import "HBCacheProtocol.h"
#pragma mark -


#pragma mark -

@interface HBFileCache : NSObject<HBCacheProtocol>

@property (nonatomic, retain) NSString *	cachePath;
@property (nonatomic, retain) NSString *	cacheUser;
@property (nonatomic, retain) NSString *    libCachePath;
- (instancetype)sharedInstance;
+ (instancetype)sharedInstance;

- (NSString *)fileNameForKey:(NSString *)key;

+(void)RemoveFileWithPath:(NSString *)filePath  complete:(void (^)(void)) complteblock;

- (id)objectForKey:(id)key;

- (void)setObject:(id)object forKey:(id)key;
 
@end
