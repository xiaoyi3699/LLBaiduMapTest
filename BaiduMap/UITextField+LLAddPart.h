//
//  UITextField+LLAddPart.h
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LLAddPart)

/**
 修改placeholder的字体颜色、大小
 */
- (void)ll_setPlaceholderColor:(UIColor *)color font:(UIFont *)font;

/**
 输入错误，文本框摇一摇
 */
- (void)ll_inputErrorForShake;

/**
 限制小数点位数
 */
- (BOOL)ll_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string pointNums:(NSInteger)pointNums;

/**
 限制输入文本长度
 */
- (void)ll_limitTextFieldLength:(NSInteger)length;

- (void)ll_selectAllText;

- (void)ll_setSelectedRange:(NSRange)range;

- (void)setTextFieldInputAccessoryViewWithText:(NSString *)text message:(NSString *)message;

@end
