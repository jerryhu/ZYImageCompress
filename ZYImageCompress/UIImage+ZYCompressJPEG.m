//
//  UIImage+ZYCompressJPEG.m
//  Example
//
//  Created by Jerry Hu on 2020/6/5.
//  Copyright © 2020 Zhangyin. All rights reserved.
//

#import "UIImage+ZYCompressJPEG.h"

@implementation UIImage (ZYCompressJPEG)

/**
 根据指定最大文件大小压缩图片

 @param maxFileSize 缩略图最大文件大小
 @param initQuality 图片初始压缩质量 0.2~1.0之间的小数 (0.9 = 90%)
 @return 压缩后的缩略图, JPEG格式
 */
- (NSData *)zy_compressWithMaxFileSize:(NSInteger)maxFileSize initQuality:(double)initQuality{
    double quality = initQuality;
    if(quality > 1){
        quality = 1;
    }
    if(quality < 0.2){
        quality = 0.2;
    }
    NSData *imageData = UIImageJPEGRepresentation(self, quality);
    
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
        
        imageData = UIImageJPEGRepresentation(self, quality);
        fileSize = imageData.length;
    }
    
    return imageData;
}

/**
 根据指定最大文件大小压缩图片

 @param maxFileSize 缩略图最大文件大小
 @return 压缩后的缩略图, JPEG格式
 */
- (NSData *)zy_compressWithMaxFileSize:(NSInteger)maxFileSize{
    return [self zy_compressWithMaxFileSize:maxFileSize initQuality:0.85];
}

@end
