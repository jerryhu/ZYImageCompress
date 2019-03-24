//
//  UIImage+ZYCompressMoments.m
//  图片压缩，适用于朋友圈的图片
//  参考了鲁班的算法 https://github.com/Curzibn/Luban
//
//  Created by Jerry Hu on 2019/3/24.
//

#import "UIImage+ZYCompressMoments.h"
#import "UIImage+Resize.h"

@implementation UIImage (ZYCompressMoments)

typedef struct {
    CGSize newSize;
    NSInteger maxFileSize;
} LubanComputeResult;

/**
 图片压缩, 适用于朋友圈
 图片压缩算法参考 => https://github.com/Curzibn/Luban/blob/master/DESCRIPTION.md
 
 @return 压缩后的图片数据, JPEG格式
 */
- (NSData *)zy_compressForMoments {
    // 计算压缩后的图片尺寸
    LubanComputeResult computeResult = [self zy_computeSizeForMoments:self.size];
    
    // 图片尺寸调整
    UIImage *resizedImage = [self resizedImageToFitInSize:computeResult.newSize scaleIfSmaller:NO];
    
    // 图片默认压缩率为85%
    double quality = 0.85;
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, quality);
    
    NSUInteger fileSize = imageData.length;
    // 调整图片压缩率，使图片文件大小符合限值要求
    while(fileSize > computeResult.maxFileSize * 1024 && quality > 0.2) { // 压缩率不能小于0.2 (20%)
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
 计算压缩后的图片尺寸和文件大小的限制

 @param size 原图尺寸
 @return 压缩后的图片尺寸和文件大小限制
 */
- (LubanComputeResult)zy_computeSizeForMoments:(CGSize)size{
    int maxFileSize;
    int n;
    int m;
    int fileSizeThreshold = 100;
    
    LubanComputeResult mLubanComputeResult;
    
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
            m = 500;
            fileSizeThreshold = 60;
            newW = srcWidth / n;
            newH = srcHeight / n;
            maxFileSize = (int)((double)newW * (double)newH) / pow(1664.0, 2.0) * (double)m;
        } else if (longSide < 4990) {
            n = 2;
            m = 800;
            newW = srcWidth / n;
            newH = srcHeight / n;
            maxFileSize = (int)((double)newW * (double)newH) / pow(4990.0, 2.0) * (double)m;
        } else if (longSide > 4990 && longSide < 10240) {
            n = 4;
            m = 800;
            newW = srcWidth / n;
            newH = srcHeight / n;
            maxFileSize = (int)((double)newW * (double)newH) / pow(1280.0 * n, 2.0) * (double)m;
        } else {
            n = longSide / 1280 == 0 ? 1 : longSide / 1280;
            m = 800;
            newW = srcWidth / n;
            newH = srcHeight / n;
            maxFileSize = (int)((double)newW * (double)newH) / pow(1280.0 * n, 2.0) * (double)m;
        }
    } else if (scale <= 0.5625 && scale > 0.5) {
        n = longSide / 1280 == 0 ? 1 : longSide / 1280;
        m = 500;
        newW = srcWidth / n;
        newH = srcHeight / n;
        maxFileSize = (int)((double)newW * (double)newH) / (1440.0 * 2560.0) * (double)m;
    } else {
        n = (int) ceil((double)longSide / (1280.0 / scale));
        m = 500;
        newW = srcWidth / n;
        newH = srcHeight / n;
        maxFileSize = (int)((double)newW * (double)newH) / (1280.0 * (1280.0 / scale)) * (double)m;
    }
    
    maxFileSize = maxFileSize < fileSizeThreshold ? fileSizeThreshold : maxFileSize;
    
    mLubanComputeResult.newSize = CGSizeMake(newW, newH);
    mLubanComputeResult.maxFileSize = maxFileSize;
    
    return mLubanComputeResult;
}

@end
