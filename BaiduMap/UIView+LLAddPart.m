//
//  UIView+AddPart.m
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIView+LLAddPart.h"
#import <objc/runtime.h>
//UIActivityIndicatorView *activity
@implementation UIView (LLAddPart)
/*
 追加属性
 */
static UIActivityIndicatorView *_activityIndicatorView;
- (void)setIndicatorView:(UIActivityIndicatorView *)activityIndicatorView{
    activityIndicatorView.hidesWhenStopped = YES;
    objc_setAssociatedObject(self, &_activityIndicatorView, activityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicatorView{
    return objc_getAssociatedObject(self, &_activityIndicatorView);
}

- (UIViewController *)viewController{
    UIResponder *next = [self nextResponder];
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next);
    return nil;
}

- (BOOL)ll_isDescendantOfView:(UIView *)otherView {
    return [self isDescendantOfView:otherView];
}

#pragma - mark 自定义适配
//设置位置(宽和高保持不变)
- (CGFloat)minX{
    return CGRectGetMinX(self.frame);
}

- (void)setMinX:(CGFloat)minX{
    self.frame = CGRectMake(minX, self.minY, self.LLWidth, self.LLHeight);
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxX:(CGFloat)maxX{
    self.frame = CGRectMake(maxX-self.LLWidth, self.minY, self.LLWidth, self.LLHeight);
}

- (CGFloat)minY{
    return CGRectGetMinY(self.frame);
}

- (void)setMinY:(CGFloat)minY{
    self.frame = CGRectMake(self.minX, minY, self.LLWidth, self.LLHeight);
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (void)setMaxY:(CGFloat)maxY{
    self.frame = CGRectMake(self.minX, maxY-self.LLHeight, self.LLWidth, self.LLHeight);
}

- (CGFloat)LLCenterX{
    return CGRectGetMidX(self.frame);
}

- (void)setLLCenterX:(CGFloat)LLCenterX{
    self.center = CGPointMake(LLCenterX, self.LLCenterY);
}

- (CGFloat)LLCenterY{
    return CGRectGetMidY(self.frame);
}

- (void)setLLCenterY:(CGFloat)LLCenterY{
    self.center = CGPointMake(self.LLCenterX, LLCenterY);
}

- (CGPoint)LLPostion{
    return CGPointMake(self.minX, self.minY);
}

- (void)setLLPostion:(CGPoint)LLPostion{
    self.frame = CGRectMake(LLPostion.x, LLPostion.y, self.LLWidth, self.LLHeight);
}

//设置位置(其他顶点保持不变)
- (CGFloat)mutableMinX{
    return self.minX;
}

- (void)setMutableMinX:(CGFloat)mutableMinX{
    self.frame = CGRectMake(mutableMinX, self.minY, self.maxX-mutableMinX, self.LLHeight);
}

- (CGFloat)mutableMaxX{
    return self.maxX;
}

- (void)setMutableMaxX:(CGFloat)mutableMaxX{
    self.frame = CGRectMake(self.minX, self.minY, mutableMaxX-self.minX, self.LLHeight);
}

- (CGFloat)mutableMinY{
    return self.minY;
}

- (void)setMutableMinY:(CGFloat)mutableMinY{
    self.frame = CGRectMake(self.minX, mutableMinY, self.LLWidth, self.maxY-mutableMinY);
}

- (CGFloat)mutableMaxY{
    return self.maxY;
}

- (void)setMutableMaxY:(CGFloat)mutableMaxY{
    self.frame = CGRectMake(self.minX, self.minY, self.LLWidth, mutableMaxY-self.minY);
}

//设置宽和高(位置不变)
- (CGFloat)LLWidth{
    return CGRectGetWidth(self.frame);
}

- (void)setLLWidth:(CGFloat)LLWidth{
    self.frame = CGRectMake(self.minX, self.minY, LLWidth, self.LLHeight);
}

- (CGFloat)LLHeight{
    return CGRectGetHeight(self.frame);
}

- (void)setLLHeight:(CGFloat)LLHeight{
    self.frame = CGRectMake(self.minX, self.minY, self.LLWidth, LLHeight);
}

- (CGSize)LLSize{
    return CGSizeMake(self.LLWidth, self.LLHeight);
}

- (void)setLLSize:(CGSize)LLSize{
    self.frame = CGRectMake(self.minX, self.minY, LLSize.width, LLSize.height);
}

//设置宽和高(中心点不变)
- (CGFloat)center_width{
    return CGRectGetWidth(self.frame);
}

- (void)setCenter_width:(CGFloat)center_width{
    CGFloat dx = (center_width-self.LLWidth)/2.0;
    self.frame = CGRectMake(self.minX-dx, self.minY, center_width, self.LLHeight);
}

- (CGFloat)center_height{
    return CGRectGetHeight(self.frame);
}

- (void)setCenter_height:(CGFloat)center_height{
    CGFloat dy = (center_height-self.LLHeight)/2.0;
    self.frame = CGRectMake(self.minX, self.minY-dy, self.LLWidth, center_height);
}

- (CGSize)center_size{
    return CGSizeMake(self.LLWidth, self.LLHeight);
}

- (void)setCenter_size:(CGSize)center_size{
    CGFloat dx = (center_size.width-self.LLWidth)/2.0;
    CGFloat dy = (center_size.height-self.LLHeight)/2.0;
    self.frame = CGRectMake(self.minX-dx, self.minY-dy, center_size.width, center_size.height);
}

//设置宽高比例
- (CGFloat)LLScale{
    if (self.LLHeight != 0) {
        return self.LLWidth/self.LLHeight;
    }
    return -404;
}

- (void)setScale:(CGFloat)scale x:(CGFloat)x y:(CGFloat)y maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight{
    CGFloat width = maxWidth;
    CGFloat height = width/scale;
    if (height > maxHeight) {
        height = maxHeight;
        width = height*scale;
    }
    self.frame = CGRectMake(x, y, width, height);
}

- (void)setLLCornerRadius:(float)LLCornerRadius{
    self.layer.cornerRadius = LLCornerRadius;
    self.layer.masksToBounds = YES;
    //self.layer.shouldRasterize = YES;
}

- (CGFloat)LLCornerRadius{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(float)radius borderWidth:(int)width borderColor:(UIColor *)color isShadow:(BOOL)flag{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
    self.layer.shouldRasterize = YES;
    if (flag) {
        //添加四个边阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        self.layer.shadowOpacity = 0.5;//不透明度
        self.layer.shadowRadius = 10.0;//半径
        //添加两个边阴影
//        self.layer.shadowColor = [UIColor blueColor].CGColor;//阴影颜色
//        self.layer.shadowOffset = CGSizeMake(4, 4);//偏移距离
//        self.layer.shadowOpacity = 0.5;//不透明度
//        self.layer.shadowRadius = 2.0;//半径
    }
}

- (void)startRotationAxis:(NSString *)axis duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount{
    NSString *transformName = [NSString stringWithFormat:@"transform.rotation.%@",axis];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:transformName];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}

- (void)outFromCenterAnimationWithDuration:(NSTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [self.layer addAnimation:animation forKey:@"LLAlertAnimation"];
}

- (void)outAnimation{
    [UIView animateWithDuration:1.0 animations:^{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@(0.1),@(1.0),@(1.5)];
        animation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        animation.calculationMode = kCAAnimationLinear;
        [self.layer addAnimation:animation forKey:@"SHOW"];
    } completion:^(BOOL finished){
    }];
}

- (void)insideAnimation{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);
     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
          } completion:^(BOOL finished){//do other thing
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
               } completion:^(BOOL finished){//do other thing
               }];
          }];
     }];
}

- (void)transitionFromLeftWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(completionBlock)completion{
    [UIView animateWithDuration:duration animations:^{
        CATransition *animation = [CATransition animation];
        animation.type = [self getType:type];
        animation.subtype = kCATransitionFromLeft;
        animation.duration = duration;
        animation.startProgress = 0.0;
        animation.endProgress = 1.0;
        [self.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)transitionFromRightWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(completionBlock)completion{
    [UIView animateWithDuration:duration animations:^{
        CATransition *animation = [CATransition animation];
        animation.type = [self getType:type];
        animation.subtype = kCATransitionFromRight;
        animation.duration = duration;
        animation.startProgress = 0.0;
        animation.endProgress = 1.0;
        [self.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)transitionFromTopWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(completionBlock)completion{
    [UIView animateWithDuration:duration animations:^{
        CATransition *animation = [CATransition animation];
        animation.type = [self getType:type];
        animation.subtype = kCATransitionFromTop;
        animation.duration = duration;
        animation.startProgress = 0.0;
        animation.endProgress = 1.0;
        [self.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)transitionFromBottomWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(completionBlock)completion{
    [UIView animateWithDuration:duration animations:^{
        CATransition *animation = [CATransition animation];
        animation.type = [self getType:type];
        animation.subtype = kCATransitionFromBottom;
        animation.duration = duration;
        animation.startProgress = 0.0;
        animation.endProgress = 1.0;
        [self.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

//旋转180°缩小到最小,然后再从小到大推出
- (void)transform0:(transformBlock)transform completion:(completionBlock)completion{
    [UIView animateWithDuration:0.35f animations:^  {
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.1, 0.2, 0.2)];
        animation.duration = 0.35f;
        animation.repeatCount = 1;
        [self.layer addAnimation:animation forKey:nil];
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.35f animations:^  {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            if (transform) {
                transform();
            }
        }completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }];
}

//向右旋转45°缩小到最小,然后再从小到大推出
- (void)transform1:(transformBlock)transform completion:(completionBlock)completion{
    [UIView animateWithDuration:0.35f animations:^  {
         self.transform = CGAffineTransformMakeScale(0.001, 0.001);
         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
         animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.70, 0.40, 0.80)];
         animation.duration = 0.35f;
         animation.repeatCount = 1;  
         [self.layer addAnimation:animation forKey:nil];
     }completion:^(BOOL finished){
         [UIView animateWithDuration:0.35f animations:^  {
              self.transform = CGAffineTransformMakeScale(1.0, 1.0);
             if (transform) {
                 transform();
             }
          }completion:^(BOOL finished) {
              if (completion) {
                  completion();
              }
          }];
     }];
}

- (void)LL_addCorners:(UIRectCorner)corner radius:(CGFloat)radius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - private
- (NSString *)getType:(AnimationType)type{
    switch (type) {
        case 1:  return @"fade";
        case 2:  return @"push";
        case 3:  return @"reveal";
        case 4:  return @"moveIn";
        case 5:  return @"cube";
        case 6:  return @"suckEffect";
        case 7:  return @"oglFlip";
        case 8:  return @"rippleEffect";
        case 9:  return @"pageCurl";
        case 10: return @"pageUnCurl";
        case 11: return @"cameraIrisHollowOpen";
        case 12: return @"cameraIrisHollowClose";
        case 13: return @"curlDown";
        case 14: return @"curlUp";
        case 15: return @"flipFromLeft";
        case 16: return @"flipFromRight";
        default: break;
    }
}

@end
