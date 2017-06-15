//
//  LLDatePicker.h
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLDatePickerDelete;

@interface LLDatePicker : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) id<LLDatePickerDelete> delegete;

@end

@protocol LLDatePickerDelete <NSObject>

@optional
- (void)datePicker:(LLDatePicker *)datePicker didClickOK:(BOOL)OK;

@end
