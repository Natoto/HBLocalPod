

#import "UIImage+HBExtension.h"
#import "NSString+HBExtension.h"
#pragma mark -

@interface UIImage(ThemePrivate)
- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context;
@end

#pragma mark -

@implementation UIImage(Theme)

- (UIImage *)transprent
{
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo( self.CGImage );
	
	if ( kCGImageAlphaFirst == alpha ||
		kCGImageAlphaLast == alpha ||
		kCGImageAlphaPremultipliedFirst == alpha ||
		kCGImageAlphaPremultipliedLast == alpha )
	{
		return self;
	}

	CGImageRef	imageRef = self.CGImage;
	size_t		width = CGImageGetWidth(imageRef);
	size_t		height = CGImageGetHeight(imageRef);

	CGContextRef context = CGBitmapContextCreate( NULL, width, height, 8, 0, CGImageGetColorSpace(imageRef), kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedFirst);
	CGContextDrawImage( context, CGRectMake(0, 0, width, height), imageRef );

	CGImageRef	resultRef = CGBitmapContextCreateImage( context );
	UIImage *	result = [UIImage imageWithCGImage:resultRef];

	CGContextRelease( context );
	CGImageRelease( resultRef );

	return result;
}
/**
 * 裁剪成宽高比 ratio 为 W/H 1:2  2:1
 */

-(CGFloat)absolute:(CGFloat)a
{
    return a>0?a:-a;
}
/**
 * 按比例来的
 */
- (UIImage *)cropToRatio:(CGFloat)ratio
{
    
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGFloat newheight = width/ratio;
    if(newheight > height) //新高大于高度则裁剪的起始位置为
    {
        CGFloat newwidth = height * ratio;
        CGFloat px=[self absolute:(newwidth - width)]/2;
        return [self crop:CGRectMake(px, 0, newwidth, height)];
    }
    else
    {
        CGFloat py = [self absolute:(newheight - height)]/2;
       return [self crop:CGRectMake(0, py, width, newheight)];
    }
}
- (UIImage *)cropToSquare
{
    CGImageRef imgRef = self.CGImage; 
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGFloat PXY = fabsf(width - height)/2;
    CGFloat WH = (width>height)?height:width;
    BOOL    WBIGER = width - height;
    if (WBIGER) {//宽大于高度则裁剪的起始位置为 X:PXY Y:0
        return [self crop:CGRectMake(PXY, 0, WH, WH)];
    }
    else
    {
        return [self crop:CGRectMake(0, PXY, WH, WH)];
    }
 }

- (UIImage *)resize:(CGSize)newSize
{
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if ( width > newSize.width || height > newSize.height )
	{
        CGFloat ratio = width/height;
        if ( ratio > 1 )
		{
            bounds.size.width = newSize.width;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
		{
            bounds.size.height = newSize.height;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
	{
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
	{
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage * imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/

- (void)addCircleRectToPath:(CGRect)rect context:(CGContextRef)context
{
    CGContextSaveGState( context );
    CGContextTranslateCTM( context, CGRectGetMinX(rect), CGRectGetMinY(rect) );
	CGContextSetShouldAntialias( context, true );
	CGContextSetAllowsAntialiasing( context, true );
	CGContextAddEllipseInRect( context, rect );
    CGContextClosePath( context );
    if(context)
    CGContextRestoreGState( context );
}

- (UIImage *)rounded
{
    UIImage * image = [self transprent];
	if ( nil == image )
		return nil;
	
	CGSize imageSize = image.size;
	imageSize.width = floorf( imageSize.width );
	imageSize.height = floorf( imageSize.height );
	
	CGFloat imageWidth = fminf(imageSize.width, imageSize.height);
	CGFloat imageHeight = imageWidth;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate( NULL,
												 imageWidth,
												 imageHeight,
												 CGImageGetBitsPerComponent(image.CGImage),
												 imageWidth * 4,
												 colorSpace,
												 CGImageGetBitmapInfo(image.CGImage) );
	
    CGContextBeginPath(context);
	CGRect circleRect;
	circleRect.origin.x = 0;
	circleRect.origin.y = 0;
	circleRect.size.width = imageWidth;
	circleRect.size.height = imageHeight;
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
	CGRect drawRect;
	drawRect.origin.x = 0;
	drawRect.origin.y = 0;
	drawRect.size.width = imageWidth;
	drawRect.size.height = imageHeight;
    CGContextDrawImage(context, drawRect, image.CGImage);
    
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease( colorSpace );
	
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
	
    return roundedImage;
}

- (UIImage *)rounded:(CGRect)circleRect
{
    UIImage * image = [self transprent];
	if ( nil == image )
		return nil;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate( NULL,
												 circleRect.size.width,
												 circleRect.size.height,
												 CGImageGetBitsPerComponent( image.CGImage ),
												 circleRect.size.width * 4,
												 colorSpace,
												 kCGBitmapAlphaInfoMask );
	
    CGContextBeginPath(context);
    [self addCircleRectToPath:circleRect context:context];
    CGContextClosePath(context);
    CGContextClip(context);
	
	CGRect drawRect;
	drawRect.origin.x = 0; //(imageSize.width - imageWidth) / 2.0f;
	drawRect.origin.y = 0; //(imageSize.height - imageHeight) / 2.0f;
	drawRect.size.width = circleRect.size.width;
	drawRect.size.height = circleRect.size.height;
    CGContextDrawImage(context, drawRect, image.CGImage);
	
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
    UIImage * roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

- (UIImage *)stretched
{
	CGFloat leftCap = floorf(self.size.width / 2.0f);
	CGFloat topCap = floorf(self.size.height / 2.0f);
	return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)stretched:(UIEdgeInsets)capInsets
{
    return [self resizableImageWithCapInsets:capInsets];
}

CGFloat IMGROTATE_HBDegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees block:(void(^)(UIImage * img))imageblock
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(IMGROTATE_HBDegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, IMGROTATE_HBDegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, - self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageblock(newImage);
    return newImage;
    
}


- (UIImage *)rotate:(CGFloat)angle
{
	UIImage *	result = nil;
	CGSize		imageSize = self.size;
	CGSize		canvasSize = CGSizeZero;
	
	angle = fmodf( angle, 360 );

	if ( 90 == angle || 270 == angle )
	{
		canvasSize.width = self.size.height;
		canvasSize.height = self.size.width;
	}
	else if ( 0 == angle || 180 == angle )
	{
		canvasSize.width = self.size.width;
		canvasSize.height = self.size.height;
	}
    
    UIGraphicsBeginImageContext( canvasSize );
	
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( bitmap, canvasSize.width / 2, canvasSize.height / 2 );
    CGContextRotateCTM( bitmap, M_PI / 180 * angle );

    CGContextScaleCTM( bitmap, 1.0, -1.0 );
    CGContextDrawImage( bitmap, CGRectMake( -(imageSize.width / 2), -(imageSize.height / 2), imageSize.width, imageSize.height), self.CGImage );
    
	result = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return result;
}

- (UIImage *)rotateCW90
{
	return [self rotate:270];
}

- (UIImage *)rotateCW180
{
	return [self rotate:180];
}

- (UIImage *)rotateCW270
{
	return [self rotate:90];
}

- (UIImage *)grayscale
{
	CGSize size = self.size;
	CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, CGImageGetBitmapInfo(self.CGImage));
	CGColorSpaceRelease(colorSpace);

	if ( context )
	{
		CGContextDrawImage(context, rect, [self CGImage]);
		CGImageRef grayscale = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		
		if ( grayscale )
		{
			UIImage * image = [UIImage imageWithCGImage:grayscale];
			CFRelease(grayscale);
			return image;
		}
	}
	
	return nil;
}

- (UIImage *)crop:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageRef, rect);
	
    UIGraphicsBeginImageContext(rect.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextDrawImage(context, rect, newImageRef);
	
    UIImage * image = [UIImage imageWithCGImage:newImageRef];
	
    UIGraphicsEndImageContext();
	
    CGImageRelease(newImageRef);
	
    return image;
}

- (UIImage *)imageInRect:(CGRect)rect
{
	return [self crop:rect];
}

- (UIColor *)patternColor
{
	return [UIColor colorWithPatternImage:self];
}

+ (UIImage *)imageFromString:(NSString *)name
{
	return [self imageFromString:name atPath:nil];
}


+ (UIImage *)imageFromString:(NSString *)name atPath:(NSString *)path
{
	NSArray *	array = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *	imageName = [array objectAtIndex:0];

	imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
	imageName = imageName.unwrap.trim;

	if ( [imageName hasPrefix:@"url("] && [imageName hasSuffix:@")"] )
	{
		NSRange range = NSMakeRange( 4, imageName.length - 5 );
		imageName = [imageName substringWithRange:range].trim;
	}

	UIImage * image = nil;
	
	if ( NO == [name hasPrefix:@"http://"] && NO == [name hasPrefix:@"https://"] )
	{
		NSString *	extension = [imageName pathExtension];
		NSString *	fullName = [imageName substringToIndex:(imageName.length - extension.length - 1)];

		if ( NSNotFound == [name rangeOfString:@"@"].location )
		{
			NSString *	resPath = nil;
			NSString *	resPath2 = nil;
            
			if ( [UIImage isPhoneRetina4] )
			{
				resPath = [fullName stringByAppendingFormat:@"-568h@2x.%@", extension];
				resPath2 = [fullName stringByAppendingFormat:@"-568h.%@", extension];
			}
			else if ( [UIImage isPhoneRetina35] || [UIImage isPadRetina] )
			{
				resPath = [fullName stringByAppendingFormat:@"@2x.%@", extension];
			}

			if ( path )
			{
				if ( nil == image && resPath )
				{
					NSString * fullPath = [NSString stringWithFormat:@"%@/%@", path, resPath];
					
					if ( [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
					{
						image = [[UIImage alloc] initWithContentsOfFile:fullPath] ;
					}
				}

				if ( nil == image && resPath2 )
				{
					NSString * fullPath = [NSString stringWithFormat:@"%@/%@", path, resPath2];
					
					if ( [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
					{
						image = [[UIImage alloc] initWithContentsOfFile:fullPath] ;
					}
				}
			}

			if ( nil == image && name )
			{
				image = [UIImage imageNamed:name];
			}

			if ( nil == image && resPath2 )
			{
				image = [UIImage imageNamed:resPath2];
			}
		}
	}
	
	if ( nil == image && imageName )
	{
		if ( path )
		{
			NSString * fullPath = [NSString stringWithFormat:@"%@/%@", path, imageName];

			if ( [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
			{
				image = [[UIImage alloc] initWithContentsOfFile:fullPath] ;
			}
		}
		
		if ( nil == image )
		{
			image = [UIImage imageNamed:imageName];
		}
	}
	
	if ( nil == image )
	{
		return nil;
	}

	BOOL grayed = NO;
	BOOL rounded = NO;
	BOOL streched = NO;
	
	if ( array.count > 1 )
	{
		for (__strong NSString * attr in [array subarrayWithRange:NSMakeRange(1, array.count - 1)] )
		{
			attr = attr.trim.unwrap;
			
			if ( NSOrderedSame == [attr compare:@"stretch" options:NSCaseInsensitiveSearch] ||
				NSOrderedSame == [attr compare:@"stretched" options:NSCaseInsensitiveSearch] )
			{
				streched = YES;
			}
			else if ( NSOrderedSame == [attr compare:@"round" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"rounded" options:NSCaseInsensitiveSearch] )
			{
				rounded = YES;
			}
			else if ( NSOrderedSame == [attr compare:@"gray" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"grayed" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"grayScale" options:NSCaseInsensitiveSearch] ||
					 NSOrderedSame == [attr compare:@"gray-scale" options:NSCaseInsensitiveSearch] )
			{
				grayed = YES;
			}
		}
	}
	
	if ( image )
	{
		if ( rounded )
		{
			image = image.rounded;
		}

		if ( grayed )
		{
			image = image.grayscale;
		}

		if ( streched )
		{
			image = image.stretched;
		}
	}

	return image;
}

+ (UIImage *)imageFromString:(NSString *)name stretched:(UIEdgeInsets)capInsets
{
	UIImage * image = [self imageFromString:name];
	if ( nil == image )
		return nil;

	return [image resizableImageWithCapInsets:capInsets];
}

//+ (UIImage *)imageFromVideo:(NSURL *)videoURL atTime:(CMTime)time scale:(CGFloat)scale
//{
//	AVURLAsset * asset = [[[AVURLAsset alloc] initWithURL:videoURL options:nil] autorelease];
//    AVAssetImageGenerator * generater = [[[AVAssetImageGenerator alloc] initWithAsset:asset] autorelease];
//    generater.appliesPreferredTrackTransform = YES;
//	generater.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
//	generater.maximumSize = [UIScreen mainScreen].bounds.size;
//
//    NSError * error = nil;
//	UIImage * thumb = nil;
//	
//    CGImageRef image = [generater copyCGImageAtTime:time actualTime:NULL error:&error];
//	if ( image )
//	{
//		thumb = [[[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp] autorelease];
//		CGImageRelease(image);
//	}
//	
//    return thumb;
//}

+ (UIImage *)merge:(NSArray *)images
{
	UIImage * image = nil;
	
	for ( UIImage * otherImage in images )
	{
		if ( nil == image )
		{
			image = otherImage;
		}
		else
		{
			image = [image merge:otherImage];
		}
	}
	
	return image;
}

- (UIImage *)merge:(UIImage *)image
{
	CGSize canvasSize;
	canvasSize.width = fmaxf( self.size.width, image.size.width );
	canvasSize.height = fmaxf( self.size.height, image.size.height );
	
//	UIGraphicsBeginImageContext( canvasSize );
	UIGraphicsBeginImageContextWithOptions( canvasSize, NO, self.scale );

	CGPoint offset1;
	offset1.x = (canvasSize.width - self.size.width) / 2.0f;
	offset1.y = (canvasSize.height - self.size.height) / 2.0f;

	CGPoint offset2;
	offset2.x = (canvasSize.width - image.size.width) / 2.0f;
	offset2.y = (canvasSize.height - image.size.height) / 2.0f;

	[self drawAtPoint:offset1 blendMode:kCGBlendModeNormal alpha:1.0f];
	[image drawAtPoint:offset2 blendMode:kCGBlendModeNormal alpha:1.0f];

    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)merge:(UIImage *)image targetframe:(CGRect)frame
{
    CGSize canvasSize;
    canvasSize.width = fmaxf( self.size.width, frame.size.width );
    canvasSize.height = fmaxf( self.size.height, frame.size.height );
    
    //	UIGraphicsBeginImageContext( canvasSize );
    UIGraphicsBeginImageContextWithOptions( canvasSize, NO, self.scale );
    
    CGPoint offset1;
    offset1.x = (canvasSize.width - self.size.width) / 2.0f;
    offset1.y = (canvasSize.height - self.size.height) / 2.0f;
    
    //    CGPoint offset2  = frame.origin;
    //    offset2.x = (canvasSize.width - image.size.width) / 2.0f;
    //    offset2.y = (canvasSize.height - image.size.height) / 2.0f;
    
    [self drawAtPoint:offset1 blendMode:kCGBlendModeNormal alpha:1.0f];
    [image drawInRect:frame blendMode:kCGBlendModeNormal alpha:1.0f];
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (NSData *)dataWithExt:(NSString *)ext
{
    if ( [ext compare:@"png" options:NSCaseInsensitiveSearch] )
    {
        return UIImagePNGRepresentation(self);
    }
    else if ( [ext compare:@"jpg" options:NSCaseInsensitiveSearch] )
    {
        return UIImageJPEGRepresentation(self, 0);
    }
    else
    {
        return nil;
    }
}

- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
	
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
	
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
			
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
		default:
			break;
    }
	
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
			
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
		default:
			break;
    }
	
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
			
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
	
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 * 通过颜色生成一种纯色的图片
 */
+(UIImage *)buttonImageFromColor:(UIColor *)color frame:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    if(context)
    CGContextRestoreGState(context);
}

+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedFirst);
    //CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
     addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}
#pragma mark - device 设备相关的



+(BOOL)isScreenSize:(CGSize)size
{
    if ( [UIScreen instancesRespondToSelector:@selector(currentMode)] )
    {
        CGSize size2 = CGSizeMake( size.height, size.width );
        CGSize screenSize = [UIScreen mainScreen].currentMode.size;
        
        if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
        {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)requiresPhoneOS
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [[[NSBundle mainBundle].infoDictionary objectForKey:@"LSRequiresIPhoneOS"] boolValue];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+(BOOL)isPhoneRetina4
{
    NSString * deviceType = [UIDevice currentDevice].model;
    
    if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
    {
        return NO;
    }
    return [UIImage isScreenSize:CGSizeMake(640, 1136)];
    
}

+ (BOOL)isPadRetina
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIImage isScreenSize:CGSizeMake(1536, 2048)];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+(BOOL)isDevicePad
{
    NSString * deviceType = [UIDevice currentDevice].model;
    if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
    {
        return YES;
    }
    return NO;
}
+ (BOOL)isPhoneRetina35
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ( [UIImage isDevicePad] )
    {
        if ( [self requiresPhoneOS] && [UIImage isPadRetina] )
        {
            return YES;
        }
        return NO;
    }
    else
    {
        return [UIImage isScreenSize:CGSizeMake(640, 960)];
    }
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return NO;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}



+(UIImage *)imageFromText:(NSArray*) arrContent withFont: (CGFloat)fontSize
{
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableArray *arrHeight = [[NSMutableArray alloc] initWithCapacity:arrContent.count];
    CGFloat CONTENT_MAX_WIDTH = 200;
    CGFloat CONTENT_MAX_HEIGHT = CONTENT_MAX_WIDTH;
    
    CGFloat fHeight = 0.0f;
    for (NSString *sContent in arrContent) {
        CGSize stringSize = [sContent sizeWithFont:font constrainedToSize:CGSizeMake(CONTENT_MAX_WIDTH, CONTENT_MAX_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
        [arrHeight addObject:[NSNumber numberWithFloat:stringSize.height]];
        
        fHeight += stringSize.height;
    }
    
    
    CGSize newSize = CGSizeMake(CONTENT_MAX_WIDTH+10, fHeight+10);
    
    UIGraphicsBeginImageContextWithOptions(newSize,NO,0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetCharacterSpacing(ctx, 10);
    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
    CGContextSetRGBFillColor (ctx, 0.1, 0.2, 0.3, 1); // 6
    CGContextSetRGBStrokeColor (ctx, 0, 0, 0, 1);
    
    int nIndex = 0;
    CGFloat fPosY = 20.0f;
    for (NSString *sContent in arrContent) {
        NSNumber *numHeight = [arrHeight objectAtIndex:nIndex];
        CGRect rect = CGRectMake(10, fPosY, CONTENT_MAX_WIDTH , [numHeight floatValue]);
        
        
        [sContent drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
        
        fPosY += [numHeight floatValue];
        nIndex++;
    }
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return image;
    
}
@end
