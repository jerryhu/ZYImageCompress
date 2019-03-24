//
//  UIImage+ZYCompressThumb.m
//  图片生成缩略图，并压缩文件大小
//
//  Created by Jerry Hu on 2019/3/24.
//

#import "UIImage+ZYCompressThumb.h"

@implementation UIImage (ZYCompressThumb)

/**
 根据指定尺寸获取缩略图，并压缩图片

 @param size 缩略图尺寸
 @return 压缩后的缩略图, JPEG格式
 */
- (NSData *)zy_thumbAndCompressWithSize:(CGSize)size{
    // 根据压缩后的图片尺寸/像素，计算图片文件大小的限值
    int maxFileSize = [self zy_computeMaxFileSizeForThumb:size];
    
    return [self zy_thumbAndCompressWithSize:size maxFileSize:maxFileSize];
}

/**
 根据指定尺寸获取缩略图，并按照指定最大文件大小压缩图片

 @param size 缩略图尺寸
 @param maxFileSize 缩略图最大文件大小
 @return 压缩后的缩略图, JPEG格式
 */
- (NSData *)zy_thumbAndCompressWithSize:(CGSize)size maxFileSize:(NSInteger)maxFileSize{
    UIImage *thumbImage = [self zy_thumbWithSize:size];
    
    // 图片默认压缩率为85%
    double quality = 0.85;
    NSData *imageData = UIImageJPEGRepresentation(thumbImage, quality);
    
    NSUInteger fileSize = imageData.length;
    // 调整图片压缩率，使图片文件大小符合限值要求
    while(fileSize > maxFileSize * 1024 && quality > 0.2) { // 压缩率不能小于0.2 (20%)
        // 压缩率递减
        if(quality > 0.6){
            quality -= 0.15; // 每次15%递减
        }
        else{
            quality -= 0.1; // 每次10%递减
        }
        
        imageData = UIImageJPEGRepresentation(thumbImage, quality);
        fileSize = imageData.length;
    }
    
    return imageData;
}

/**
 根据指定尺寸获取缩略图

 @param size 缩略图尺寸
 @return 缩略图
 */
- (UIImage *)zy_thumbWithSize:(CGSize)size{
    CGFloat srcWidth = self.size.width;
    CGFloat srcHeight = self.size.height;
    
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(self.size, size) == NO){
        CGFloat widthFactor = targetWidth / srcWidth;
        CGFloat heightFactor = targetHeight / srcHeight;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = srcWidth * scaleFactor;
        scaledHeight = srcHeight * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIImage *thumbImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbImage;
}

/**
 根据图片尺寸，计算缩略图最大文件大小
 公式 => 图片像素/{1万} * 4KB
 
 @param imageSize 图片尺寸
 @return 缩略图最大文件大小
 */
- (int)zy_computeMaxFileSizeForThumb:(CGSize)imageSize{
    double m = 10000.0;
    
    double totalImagePixel = (double)imageSize.width * (double)imageSize.height;
    int maxFileSize = (int)(totalImagePixel/m * 4.0);
    
    return maxFileSize;
}

@end
