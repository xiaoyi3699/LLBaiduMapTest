//
//  UITextField+LLAddPart.m
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UITextField+LLAddPart.h"
#import <objc/runtime.h>

@implementation UITextField (LLAddPart)
/*
+ (void)load {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(willMoveToSuperview:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(myWillMoveToSuperview:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}

- (void)myWillMoveToSuperview:(UIView *)newSuperview {
    [self myWillMoveToSuperview:newSuperview];
    if (self) {
        if (self.tag == 666) {
            self.font = [UIFont systemFontOfSize:self.font.pointSize];
        }
        else {
            self.font  = [UIFont WenYueQLTOfSize:self.font.pointSize];
        }
    }
}
*/

- (void)ll_setPlaceholderColor:(UIColor *)color font:(UIFont *)font {
    if (color) {
        [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    }
    if (font) {
        [self setValue:font forKeyPath:@"_placeholderLabel.font"];
    }
}

- (void)ll_inputErrorForShake{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    [self.layer addAnimation:keyAn forKey:@"Shark"];
}

- (BOOL)ll_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string pointNums:(NSInteger)pointNums{
    static BOOL isHaveDian = YES;
    if ([self.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能为0和小数点
            if([self.text length] == 0){
                if(single == '.') {
                    NSLog(@"亲，第一个数字不能为小数点");
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
//                if (single == '0') {
//                    NSLog(@"亲，第一个数字不能为0");
//                    [self.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian){//text中还没有小数点
                    isHaveDian = YES;
                    return YES;
                }
                else{
                    NSLog(@"亲，您已经输入过小数点了");
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [self.text rangeOfString:@"."];
                    if (range.location - ran.location <= pointNums) {
                        return YES;
                    }
                    else{
                        NSLog(@"%@",[NSString stringWithFormat:@"亲，您最多输入%ld位小数",(long)pointNums]);
                        return NO;
                    }
                }
                else{
                    return YES;
                }
            }
        }
        else{//输入的数据格式不正确
            NSLog(@"亲，您输入的格式不正确");
            [self.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else{
        return YES;
    }
}

- (void)ll_limitTextFieldLength:(NSInteger)length{
    if (self.text.length > length) {
        self.text = [self.text substringToIndex:length];
    }
}

- (void)ll_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)ll_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

- (void)setTextFieldInputAccessoryViewWithText:(NSString *)text message:(NSString *)message{
    UIVisualEffectView *toolView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    toolView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    
    if (text.length == 0) {
        text = @"完成";
    }
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:text forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(SCREEN_WIDTH-50, 5, 40, 30);
    if ([self.superview.viewController respondsToSelector:@selector(dealKeyboardHide)]) {
        [doneBtn addTarget:self.superview.viewController action:@selector(dealKeyboardHide) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [doneBtn addTarget:self action:@selector(dealKeyboardHide) forControlEvents:UIControlEventTouchUpInside];
    }
    [toolView.contentView addSubview:doneBtn];
    
    if (message.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, SCREEN_WIDTH-100, 30)];
        label.text = message;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        [toolView.contentView addSubview:label];
    }
    
    [self setInputAccessoryView:toolView];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
}

- (void)dealKeyboardHide {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
