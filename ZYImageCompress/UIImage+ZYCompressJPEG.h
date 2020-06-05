//
//  UIImage+ZYCompressJPEG.h
//  Example
//
//  Created by Jerry Hu on 2020/6/5.
//  Copyright © 2020 Zhangyin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZYCompressJPEG)

/**
 根据指定最大文件大小压缩图片

 @param maxFileSize 缩略图最大文件大小
 @param initQuality 图片初始压缩质量 0.2~1.0之间的小数 (0.9 = 90%)
 @return 压缩后的缩略图, JPEG格式
 */
- (NSData *)zy_compressWithMaxFileSize:(NSInteger)maxFileSize initQuality:(double)initQuality;

/**
 根据指定最大文件大小压缩图片

 @param maxFileSize 缩略图最大文件大小
 @return 压缩后的缩略图, JPEG格式
 */
- (NSData *)zy_compressWithMaxFileSize:(NSInteger)maxFileSize;

@end

NS_ASSUME_NONNULL_END
