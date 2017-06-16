//
//  UIImage+AddPart.h
//  Money
//
//  Created by fan on 16/7/15.
//  Copyright © 2016年 liupeidong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAsset;

@interface UIImage (LLAddPart)

#pragma mark - 类方法
/**
 根据颜色创建image
 */
+ (UIImage *)ll_imageWithColor:(UIColor*) color;

/**
 根据颜色创建image<圆形>
 */
+ (UIImage *)ll_roundImageWithColor:(UIColor*)color size:(CGSize)size;

/**
 根据颜色创建image<矩形>
 */
+ (UIImage *)ll_rectImageWithColor:(UIColor*)color size:(CGSize)size;

/**
 截屏
 */
+ (UIImage*)ll_screenImageFromView:(UIView *)view;

#pragma mark - 实例方法
/**
 压缩图片所占的物理内存大小 100M以内的图片经过三层压缩，<= 1M
 */
- (UIImage *)ll_scaleImage;

/**
 按比例压缩image
 */
- (UIImage *)ll_imageWithScale:(float)scale;


/**
 圆角图片
 */
- (UIImage *)ll_roundImageSize:(CGSize)size radius:(NSInteger)radius;

/**
 图片上绘制文字 写一个UIImage的category
 */
- (UIImage *)ll_imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;

/**
 绘制空心图片
 */
- (UIImage *)ll_imageWithShadowFrame:(CGRect)shadowFrame hollowFrame:(CGRect)hollowFrame shadowColor:(UIColor *)shadowColor;

/**
 拉伸图片
 */
- (UIImage *)ll_resizableImageWithName:(NSString *)imageName;

/**
 聊天对话框拉伸
 */
- (UIImage *)ll_stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;

/**
 取图片某一像素的颜色
 */
- (UIColor *)ll_colorAtPixel:(CGPoint)point;

/**
 模糊图片
 */
- (UIImage *)ll_blurImageWithScale:(CGFloat)scale;

/**
 按比例生成缩略图
 */
- (UIImage *)ll_thumbnailWithSize:(CGSize)asize;

@end
