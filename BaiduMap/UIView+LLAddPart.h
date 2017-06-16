//
//  UIView+AddPart.h
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Fade                = 1,   //淡入淡出
    Push,                      //推挤
    Reveal,                    //揭开
    MoveIn,                    //覆盖
    Cube,                      //立方体
    SuckEffect,                //吮吸
    OglFlip,                   //翻转
    RippleEffect,              //波纹
    PageCurl,                  //翻页
    PageUnCurl,                //反翻页
    CameraIrisHollowOpen,      //开镜头
    CameraIrisHollowClose,     //关镜头
    CurlDown,                  //下翻页
    CurlUp,                    //上翻页
    FlipFromLeft,              //左翻转
    FlipFromRight,             //右翻转
    
} AnimationType;

typedef void(^completionBlock)();
typedef void(^transformBlock)();

@interface UIView (LLAddPart)

#pragma mark - 追加属性
- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView;
- (UIActivityIndicatorView *)activityIndicatorView;

/**
 获取view所在的ViewController
 */
- (UIViewController *)viewController;

/**
 判断view是不是指定视图的子视图
 */
- (BOOL)ll_isDescendantOfView:(UIView *)otherView;

#pragma mark - 自定义适配
//设置位置(宽和高保持不变)
- (CGFloat)minX;
- (void)setMinX:(CGFloat)minX;

- (CGFloat)maxX;
- (void)setMaxX:(CGFloat)maxX;

- (CGFloat)minY;
- (void)setMinY:(CGFloat)minY;

- (CGFloat)maxY;
- (void)setMaxY:(CGFloat)maxY;

- (CGFloat)LLCenterX;
- (void)setLLCenterX:(CGFloat)LLCenterX;

- (CGFloat)LLCenterY;
- (void)setLLCenterY:(CGFloat)LLCenterY;

- (CGPoint)LLPostion;
- (void)setLLPostion:(CGPoint)LLPostion;

//设置位置(其他顶点保持不变)
- (CGFloat)mutableMinX;
- (void)setMutableMinX:(CGFloat)mutableMinX;

- (CGFloat)mutableMaxX;
- (void)setMutableMaxX:(CGFloat)mutableMaxX;

- (CGFloat)mutableMinY;
- (void)setMutableMinY:(CGFloat)mutableMinY;

- (CGFloat)mutableMaxY;
- (void)setMutableMaxY:(CGFloat)mutableMaxY;

//设置宽和高((位置不变))
- (CGFloat)LLWidth;
- (void)setLLWidth:(CGFloat)LLWidth;

- (CGFloat)LLHeight;
- (void)setLLHeight:(CGFloat)LLHeight;

- (CGSize)LLSize;
- (void)setLLSize:(CGSize)LLSize;

//设置宽和高(中心点不变)
- (CGFloat)center_width;
- (void)setCenter_width:(CGFloat)center_width;

- (CGFloat)center_height;
- (void)setCenter_height:(CGFloat)center_height;

- (CGSize)center_size;
- (void)setCenter_size:(CGSize)center_size;

//设置宽高比例
- (CGFloat)LLScale;
- (void)setScale:(CGFloat)scale x:(CGFloat)x y:(CGFloat)y maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

//设置圆角
- (void)setLLCornerRadius:(float)LLCornerRadius;
- (CGFloat)LLCornerRadius;

/**
 设置圆角、边框、阴影
 */
- (void)setCornerRadius:(float)radius borderWidth:(int)width borderColor:(UIColor *)color isShadow:(BOOL)flag;

/**
 旋转动画(参数axis:坐标轴(x,y或z,小写))
 */
- (void)startRotationAxis:(NSString *)axis duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount;

/**
 alertView弹出动画
 */
- (void)outFromCenterAnimationWithDuration:(NSTimeInterval)duration;

/**
 先放大后缩小的动画
 */
- (void)outAnimation;

/**
 先缩小后放大的动画
 */
- (void)insideAnimation;

#pragma mark - 转场动画
- (void)transitionFromLeftWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(completionBlock)completion;

- (void)transitionFromRightWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(completionBlock)completion;

- (void)transitionFromTopWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(completionBlock)completion;

- (void)transitionFromBottomWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(completionBlock)completion;

/**
 旋转180°缩小到最小,然后再从小到大推出
 */
- (void)transform0:(transformBlock)transform completion:(completionBlock)completion;

/**
 向右旋转45°缩小到最小,然后再从小到大推出
 */
- (void)transform1:(transformBlock)transform completion:(completionBlock)completion;

/**
 添加任意圆角
 */
- (void)LL_addCorners:(UIRectCorner)corner radius:(CGFloat)radius;

@end
