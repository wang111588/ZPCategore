/*******************************************************************************
 Copyright (C), 2013-2015, ZP
 File name: UIImage+ZPAddition.h
 Author: Joy (曾 平)
 E-mail: joykerl@yahoo.com
 Description:
 分类扩展
 History:
 2015-05-11
 Copyright information:
 Copyright (c) 2015年 ZP. All rights reserved.
 ********************************************************************************/


#import "UIImage+ZPAddition.h"

@implementation UIImage (ZPAddition)

+ (instancetype)imageWithName:(NSString *)imageName
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 7.0) {
        NSString *newName = [imageName stringByAppendingString:@"_ios7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) {
            image = [UIImage imageNamed:imageName];
        }
        
        return image;
    }
    
    // iOS7之前的系统
    return [UIImage imageNamed:imageName];
}

+ (instancetype)resizedImageWithName:(NSString *)imageName
{
    return [self resizedImageWithName:imageName left:0.5 top:0.5];
}

+ (instancetype)resizedImageWithName:(NSString *)imageName left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:imageName];
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

+ (instancetype)captureImageWithViwe:(UIView *)view
{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    // 将view的layer渲染到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  获得给定颜色和大小的图片
 *
 *  @param color 指定的图片颜色
 *  @param size  指定返回的图片大小
 *
 *  @return 返回指定颜色和大小的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0f);
    
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  圆形图片
 *
 *  @param name        待处理的图片名
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return 原型图片
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

///  生成一张新的图片
///
///  @param bgImage 图片的背景
///  @param icon    图片的图标
- (UIImage *)createNewImageWithBg:(UIImage *)bgImage icon:(UIImage *)icon{
    
    UIGraphicsBeginImageContext(bgImage.size);
    
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    CGFloat iconX = (bgImage.size.width - iconW) * 0.5;
    CGFloat iconY = (bgImage.size.height - iconH) * 0.5;
    [icon drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // Build Bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.Save bitmap from Pic
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)imageWithQRCodeImageMessage:(NSString *)string imageSize:(CGFloat)imageSize icon:(NSString *)icon iconSize:(CGSize)iconSize
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [string  dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *image = [filter outputImage];
    UIImage *highImage = [self createNonInterpolatedUIImageFormCIImage:image withSize:imageSize];
    if ([icon isEqualToString: @""] || icon == nil) {
        return highImage;
    }
    UIImage *iconImage = [UIImage imageNamed:icon];
    return [self mergeImageWith:highImage icon:iconImage iconSize:iconSize];
    
}

/**
 * 根据二维码图片和icon图片生成一张二维码图片。
 */
+ (UIImage *)mergeImageWith:(UIImage *)image icon:(UIImage *)icon iconSize:(CGSize)size
{
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGFloat iconW = size.width;
    CGFloat iconH = size.height;
    CGFloat iconX = (image.size.width - iconW) * 0.5;
    CGFloat iconY = (image.size.height - iconH) * 0.5;
    [icon drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    UIImage *mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergeImage;
}

/**
 * 生成一张size尺寸的高清图片。
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



@end
