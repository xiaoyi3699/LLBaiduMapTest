//
//  LLSexView.h
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLSexViewDelegete;

@interface LLSexView : UIView

@property (nonatomic, weak) id<LLSexViewDelegete> delegate;

@end

@protocol LLSexViewDelegete <NSObject>

@optional
- (void)sexView:(LLSexView *)sexView selectedSex:(NSString *)sex;

@end
