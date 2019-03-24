/***********************************************************************************
 * MIT License
 *
 * Copyright (c) 2019 Jerry Hu
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 ***********************************************************************************/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZYCompressThumb)

/**
 根据指定尺寸获取缩略图，并压缩图片
 
 @param size 缩略图尺寸
 @return 压缩后的缩略图
 */
- (NSData *)zy_thumbAndCompressWithSize:(CGSize)size;

/**
 根据指定尺寸获取缩略图，并按照指定最大文件大小压缩图片
 
 @param size 缩略图尺寸
 @param maxFileSize 缩略图最大文件大小
 @return 压缩后的缩略图
 */
- (NSData *)zy_thumbAndCompressWithSize:(CGSize)size maxFileSize:(NSInteger)maxFileSize;

/**
 根据指定尺寸获取缩略图
 
 @param size 缩略图尺寸
 @return 缩略图
 */
- (UIImage *)zy_thumbWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
