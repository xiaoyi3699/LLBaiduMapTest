//
//  LLDatePicker.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLDatePicker.h"

@implementation LLDatePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:250/255. green:250/255. blue:250/255. alpha:1];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.tag = 0;
        cancelBtn.frame = CGRectMake(0, 0, 60, 30);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        OKBtn.tag = 1;
        OKBtn.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, 30);
        OKBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
        [OKBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [OKBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:OKBtn];
        
        CGRect rect = frame;
        rect.origin.y = 30;
        rect.size.height -= 30;
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];//时间选择
        datePicker.frame = rect;
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; //设置时区,中国在东八区
        datePicker.maximumDate = [NSDate date]; //设置最大时间
        datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:75*366*24*60*60];//设置最小时间
        datePicker.date = [NSDate dateWithTimeIntervalSince1970:631123200]; //设置初始时间(1990-01-01)
        datePicker.datePickerMode = UIDatePickerModeDate; //设置样式
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; //添加监听器
        [self addSubview:datePicker];
        
        _date = datePicker.date;
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    if ([self.delegete respondsToSelector:@selector(datePicker:didClickOK:)]) {
        [self.delegete datePicker:self didClickOK:(BOOL)btn.tag];
    }
}

- (void)datePickerValueChanged:(UIDatePicker *) sender {
    //获取被选中的时间
    _date = [sender date];
}

@end
