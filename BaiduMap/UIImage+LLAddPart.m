//
//  UIImage+AddPart.m
//  Money
//
//  Created by fan on 16/7/15.
//  Copyright © 2016年 liupeidong. All rights reserved.
//

#import "UIImage+LLAddPart.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (LLAddPart)

#pragma mark - 类方法
+ (UIImage *)ll_imageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)ll_roundImageWithColor:(UIColor*)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)ll_rectImageWithColor:(UIColor*)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)ll_screenImageFromView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)ll_fullResolutionImageFromALAsset:(ALAsset *)asset{
    ALAssetRepresentation *representation = asset.defaultRepresentation;
    CGImageRef imageRef = representation.fullResolutionImage;//fullScreenImage(全屏) fullResolutionImage(高清)
    UIImage *image = [UIImage imageWithCGImage:imageRef
                                         scale:representation.scale//缩放比例
                                   orientation:(UIImageOrientation)representation.orientation];
    return image;
}

+ (UIImage *)ll_imageFromURL:(NSURL *)url{
    __block UIImage *image;
    ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = asset.defaultRepresentation;
        image = [[UIImage alloc] initWithCGImage:representation.fullResolutionImage];
    } failureBlock:^(NSError *error) {
        NSLog(@"图片取出失败");
    }];
    return image;
}

+ (UIImage *)ll_imageFromBase64Str:(NSString *)base64String{
    NSData *decodedImageData;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        decodedImageData = [[NSData alloc] initWithBase64Encoding:base64String];
    }
    else{
        decodedImageData = [[NSData alloc]
                            initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}

+ (UIImage *)ll_animatedImageWithImages:(NSArray *)imageNames duration:(NSTimeInterval)duration{
    NSMutableArray*  imageArr = [NSMutableArray array];
    for (NSString* imageName in imageNames) {
        [imageArr addObject:[UIImage imageNamed:imageName]];
    }
    return  [UIImage animatedImageWithImages:imageArr duration:duration];
}

+ (UIImage *)ll_imageURLString:(NSString *)URLString{
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    return img;
}

+ (void)ll_saveToAlbumName:(NSString *)albumName data:(NSData *)data completion:(void(^)())completion
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group){
            [groups addObject:group];
        }
        else {
            BOOL haveHDRGroup = NO;
            for (ALAssetsGroup *gp in groups) {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                if ([name isEqualToString:albumName]) {//相册已存在
                    haveHDRGroup = YES;
                    break;
                }
            }
            if (haveHDRGroup == NO) {//相册不存在
                [assetsLibrary addAssetsGroupAlbumWithName:albumName
                                               resultBlock:^(ALAssetsGroup *group) {
                                                   [groups addObject:group];
                                               }
                                              failureBlock:nil];
                haveHDRGroup = YES;
            }
        }
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
    [self ll_saveToAlbumWithMetadata:nil
                           imageData:data
                     customAlbumName:albumName
                     completionBlock:^{
                         if (completion) {
                             completion();
                         }
                     }
                        failureBlock:^(NSError *error){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound
                                   ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
                                    //提示授权
                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.localizedDescription message:error.localizedFailureReason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
                                    [alert show];
                                }
                            });
                        }];
}

+ (void)ll_saveToAlbumWithMetadata:(NSDictionary *)metadata
                         imageData:(NSData *)imageData
                   customAlbumName:(NSString *)customAlbumName
                   completionBlock:(void (^)(void))completionBlock
                      failureBlock:(void (^)(NSError *error))failureBlock {
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                }
                else {
                    AddAsset(weakSelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
            }];
        }
        else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

#pragma mark - 实例方法

#define LL_M (1000*1000)
- (UIImage *)ll_scaleImage{
    NSData *imageData = UIImagePNGRepresentation(self);
    UIImage *image = nil;
    while (imageData.length > 10*LL_M) {
        image = [self ll_imageWithScale:.1];
        imageData = UIImagePNGRepresentation(image);
    }
    if (imageData.length > 5*LL_M) {
        image = [self ll_imageWithScale:.2];
        imageData = UIImagePNGRepresentation(image);
    }
    while (imageData.length > 1*LL_M) {
        image = [self ll_imageWithScale:.5];
        imageData = UIImagePNGRepresentation(image);
    }
    return image;
}
#undef LL_M

- (UIImage *)ll_imageWithScale:(float)scale{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scale,self.size.height*scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width*scale, self.size.height*scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)ll_roundImageSize:(CGSize)size radius:(NSInteger)radius{
    int w = size.width;
    int h = size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return img;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight){
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0){
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    //根据圆角路径绘制
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)ll_imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize
{
    //画布大小
    CGSize size=CGSizeMake(self.size.width,self.size.height);
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [self drawAtPoint:CGPointMake(0.0,0.0)];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText=[title boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}context:nil].size;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    //绘制文字
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[ UIColor whiteColor],NSParagraphStyleAttributeName:paragraphStyle}];
    
    //返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)ll_imageWithShadowFrame:(CGRect)shadowFrame hollowFrame:(CGRect)hollowFrame shadowColor:(UIColor *)shadowColor{
    UIGraphicsBeginImageContextWithOptions(shadowFrame.size, NO, 1);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con, shadowColor.CGColor);
    CGContextFillRect(con, shadowFrame);
    //CGContextAddEllipseInRect(con, hollowFrame);//圆形空心
    CGContextAddRect(con, hollowFrame);//矩形空心
    CGContextSetBlendMode(con, kCGBlendModeClear);
    CGContextFillPath(con);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    /* 使用CAShapeLayer设置空心
    CAShapeLayer *markLayer = [[CAShapeLayer alloc] init];
    markLayer.frame = CGRectMake(100, 100, 250, 250);// layer的frame
    markLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;//layer的填充颜色，这里设置了透明度
    markLayer.fillRule = kCAFillRuleEvenOdd; //填充规则，稍后会解释
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, markLayer.bounds);
    CGPathAddRect(path, nil, CGRectMake(0, 0, 100, 100)); //空心的frame
    markLayer.path = path;
    
    [self.view.layer addSublayer:markLayer];
     */
}

- (UIImage *)ll_resizableImageWithName:(NSString *)imageName
{
    // 获取原有图片的宽高的一半
    CGFloat w = self.size.width * 0.4;
    CGFloat h = self.size.width * 0.6;

    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];

    return newImage;
}

- (UIImage *)ll_stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight {
    return [self stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

- (UIColor *)ll_colorAtPixel:(CGPoint)point
{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point))
    {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage *)ll_blurImageWithScale:(CGFloat)scale
{
    if (scale < 0.f || scale > 1.f) {
        scale = 0.5f;
    }
    int boxSize = (int)(scale * 200);
    boxSize = boxSize/2*2 + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL) {
       NSLog(@"No pixelbuffer");
    }
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    return returnImage;
}


- (UIImage *)ll_thumbnailWithSize:(CGSize)asize{
    CGSize oldsize = self.size;
    CGRect rect;
    if (asize.width/asize.height > oldsize.width/oldsize.height) {
        
        rect.size.width = asize.height*oldsize.width/oldsize.height;
        
        rect.size.height = asize.height;
        
        rect.origin.x = (asize.width - rect.size.width)/2;
        
        rect.origin.y = 0;
    }
    else{
        rect.size.width = asize.width;
        
        rect.size.height = asize.width*oldsize.height/oldsize.width;
        
        rect.origin.x = 0;
        
        rect.origin.y = (asize.height - rect.size.height)/2;
    }
    
    UIGraphicsBeginImageContext(asize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    
    UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
    
    [self drawInRect:rect];
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimage;
}

@end
