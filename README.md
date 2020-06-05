# ZYImageCompress

 ZYImageCompress是UIImage的一个扩展，支持图片压缩和缩略图。
 图片压缩的算法参考了 [Luban鲁班](https://github.com/Curzibn/Luban)

## 安装
### CocoaPods

 `pod 'ZYImageCompress'`

### 手动导入

1. 下载 ZYImageCompress 文件夹所有内容并且拖入你的工程中。
2. 导入 ZYImageCompress.h`

## 使用
### 方法列表
方法|描述
---|---
(NSData *)zy_compressForImageBrowser;|图片压缩, 适用于图片浏览器。图片尺寸的算法参考了Luban(鲁班)，文件大小的算法有差异
(NSData *)zy_compressForMoments;|图片压缩, 适用于朋友圈。图片尺寸和文件大小的算法都参照Luban(鲁班)
(UIImage *)zy_thumbWithSize:(CGSize)size|生成指定尺寸的缩略图
(NSData *)zy_thumbAndCompressWithSize:(CGSize)size|生成指定尺寸的缩略图，并且压缩图片
(NSData *)zy_thumbAndCompressWithSize:(CGSize)size maxFileSize:(NSInteger)maxFileSize|生成指定尺寸的缩略图，并按照指定文件大小的限值压缩图片
(NSData *)zy_thumbAndCompressWithSize:(CGSize)size maxFileSize:(NSInteger)maxFileSize|生成指定尺寸的缩略图，并按照指定文件大小的限值压缩图片
(NSData *)zy_compressWithMaxFileSize:(NSInteger)maxFileSize initQuality:(double)initQuality|根据指定最大文件大小压缩图片

