

#import "HBFileCache.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#pragma mark -

@interface HBFileCache()
{
	NSString *	_cachePath;
	NSString *	_cacheUser;
}
@end

#pragma mark -

@implementation HBFileCache

@synthesize cachePath = _cachePath;
@synthesize cacheUser = _cacheUser;

- (instancetype)sharedInstance \
{ \
    return [[self class] sharedInstance]; \
} \
+ (instancetype)sharedInstance \
{ \
    static dispatch_once_t once; \
    static id __singleton__; \
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
    return __singleton__; \
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.cacheUser = @"";
		self.cachePath = [NSString stringWithFormat:@"%@/%@/Cache/", [self libCachePath], @"1.0.1"];
	}
	return self;
}



- (NSString *)libCachePath
{
    if ( nil == _libCachePath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
        
        [self touch:path];
        
        _libCachePath = path;
    }
    
    return _libCachePath;
}

- (BOOL)touch:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}


- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

	self.cachePath = nil;
	self.cacheUser = nil;
}

- (NSString *)fileNameForKey:(NSString *)key
{
	NSString * pathName = nil;
	if ( self.cacheUser && [self.cacheUser length] )
	{
		pathName = [self.cachePath stringByAppendingFormat:@"%@/", self.cacheUser];
	}
	else
	{
		pathName = self.cachePath;
	}
	
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:pathName] )
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:pathName
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
	}

	return [pathName stringByAppendingString:key];
}

- (BOOL)hasObjectForKey:(id)key
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self fileNameForKey:key]];
}

- (id)objectForKey:(id)key
{
	return [NSData dataWithContentsOfFile:[self fileNameForKey:key]];
}

- (void)setObject:(id)object forKey:(id)key
{
	if ( nil == object )
	{
		[self removeObjectForKey:key];
	}
	else
	{
        NSData * data = [self asNSData:object];
		if ( data )
		{
			[data writeToFile:[self fileNameForKey:key]
					  options:NSDataWritingAtomic
						error:NULL];
		}
	}
}


- (void)removeObjectForKey:(NSString *)key
{
	[[NSFileManager defaultManager] removeItemAtPath:[self fileNameForKey:key] error:nil];
}

- (void)removeAllObjects
{
	[[NSFileManager defaultManager] removeItemAtPath:_cachePath error:NULL];
	[[NSFileManager defaultManager] createDirectoryAtPath:_cachePath
							  withIntermediateDirectories:YES
											   attributes:nil
													error:NULL];
}

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}



- (NSData *)asNSData:(id)object
{
    if ( [object isKindOfClass:[NSString class]] )
    {
        return [(NSString *)object dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    }
    else if ( [object isKindOfClass:[NSData class]] )
    {
        return (NSData *)object;
    }
    
    return nil;
}

+(void)RemoveFileWithPath:(NSString *)filePath  complete:(void (^)(void)) complteblock
{
    if (!filePath) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *filePath = [[videoFileURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [fileManager removeItemAtPath:filePath error:&error];
            dispatch_async(dispatch_get_main_queue(), complteblock);
        }
    });
}
@end


