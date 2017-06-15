//
//  LLSexView.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLSexView.h"

@implementation LLSexView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat height = (frame.size.height-2)/3.0;
        NSArray *sexs = @[@"男",@"女",@"保密"];
        for (NSInteger i = 0; i < sexs.count; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i*(height+1), SCREEN_WIDTH, height)];
            label.text = sexs[i];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.userInteractionEnabled = YES;
            [self addSubview:label];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedLabel:)];
            [label addGestureRecognizer:tap];
            
            if (i != sexs.count-1) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), SCREEN_WIDTH, 1)];
                lineView.backgroundColor = [UIColor colorWithRed:222/255. green:222/255. blue:222/255. alpha:1];
                [self addSubview:lineView];
            }
        }
    }
    return self;
}

- (void)selectedLabel:(UITapGestureRecognizer *)recognizer {
    UILabel *label = (UILabel *)recognizer.view;
    if ([self.delegate respondsToSelector:@selector(sexView:selectedSex:)]) {
        [self.delegate sexView:self selectedSex:label.text];
    }
}

@end
