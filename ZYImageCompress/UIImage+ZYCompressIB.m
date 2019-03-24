//
//  UIImage+ZYCompressIB.m
//  图片压缩，适用于图片浏览器的大图
//
//  图片尺寸的算法参考了鲁班 https://github.com/Curzibn/Luban
//  文件大小的限制算法有差异
//
//  Created by Jerry Hu on 2019/3/20.
//

#import "UIImage+ZYCompressIB.h"
#import "UIImage+Resize.h"

@implementation UIImage (ZYCompressIB)

/**
 图片压缩, 适用于图片浏览器的大图

 @return 压缩后的图片数据, JPEG格式
 */
- (NSData *)zy_compressForImageBrowser {
    // 计算压缩后的图片尺寸
    CGSize newSize = [self zy_computeSizeForImageBrowser:self.size];
    
    // 根据压缩后的图片尺寸/像素，计算图片文件大小的限值
    int maxFileSize = [self zy_computeMaxFileSizeForImageBrowser:newSize];

    // 图片尺寸调整
    UIImage *resizedImage = [self resizedImageToFitInSize:newSize scaleIfSmaller:NO];
    
    // 图片默认压缩率为85%
    double quality = 0.85;
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, quality);

    NSUInteger fileSize = imageData.length;
    // 调整图片压缩率，使图片文件大小符合限值要求
    while(fileSize > maxFileSize * 1024 && quality > 0.2) { // 压缩率不能小于0.2 (20%)
        // 压缩率递减
        if(quality > 0.6){
            quality -= 0.15; // 每次15%递减
        }
        else{
            quality -= 0.05; // 每次5%递减
        }
        
        imageData = UIImageJPEGRepresentation(resizedImage, quality);
        fileSize = imageData.length;
    }

    return imageData;
}

/**
 计算压缩后的图片尺寸
 图片尺寸算法参考 https://github.com/Curzibn/Luban/blob/master/DESCRIPTION.md

 @param size 原图片尺寸
 @return 压缩后的图片尺寸
 */
- (CGSize)zy_computeSizeForImageBrowser:(CGSize)size{
    int n;
    int fileSizeThreshold = 100;
    
    int srcWidth = (int) size.width;
    int srcHeight = (int) size.height;
    
    srcWidth = srcWidth % 2 == 1 ? srcWidth + 1 : srcWidth;
    srcHeight = srcHeight % 2 == 1 ? srcHeight + 1 : srcHeight;
    
    int newW;
    int newH;
    
    int longSide = MAX(srcWidth, srcHeight);
    int shortSide = MIN(srcWidth, srcHeight);
    double scale = ((double)shortSide / (double)longSide);
    if (scale <= 1 && scale > 0.5625) {
        if (longSide < 1664) {
            scale = 1;
            n = 1;
            fileSizeThreshold = 60;
        } else if (longSide < 4990) {
            n = 2;
        } else if (longSide > 4990 && longSide < 10240) {
            n = 4;
        } else {
            n = longSide / 1280 == 0 ? 1 : longSide / 1280;
        }
    } else if (scale <= 0.5625 && scale > 0.5) {
        n = longSide / 1280 == 0 ? 1 : longSide / 1280;
    } else {
        n = (int) ceil((double)longSide / (1280.0 / scale));
    }
    
    newW = srcWidth / n;
    newH = srcHeight / n;
    
    return CGSizeMake(newW, newH);
}


/**
 根据图片尺寸，计算文件大小的限值
 小于50万像素: 最大100KB
 50万 ~ 500万像素区间: 公式 => 图片像素/{1万} * (0.71 + 0.49 * sqrt({500万}/图片像素))
 - 50万像素~= 112KB
 - 100万像素~= 180KB
 - 200万像素~= 296KB
 - 300万像素~= 402KB
 - 400万像素~= 503KB
 - 500万像素~= 600KB
 大于500万像素: 最大650KB

 @param imageSize 图片尺寸
 @return 最大文件大小
 */
- (int)zy_computeMaxFileSizeForImageBrowser:(CGSize)imageSize{
    int maxFileSize;
    double m = 10000.0;
    
    double totalImagePixel = (double)imageSize.width * (double)imageSize.height;
    if(totalImagePixel < (50.0 * m)){
        maxFileSize = 100;
    }
    else if(totalImagePixel > (500.0 * m)){
        maxFileSize = 650;
    }
    else{
        maxFileSize = (int)(totalImagePixel/m * (0.71 + 0.49 * sqrt(500.0 * m/totalImagePixel)));
    }
    
    return maxFileSize;
}


@end
