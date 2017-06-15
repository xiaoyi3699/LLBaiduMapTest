//
//  LLPhoneViewController.h
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLPhoneViewControllerDelegate;

@interface LLPhoneViewController : UIViewController

@property (nonatomic, weak) id<LLPhoneViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *originalPhone;

@end

@protocol LLPhoneViewControllerDelegate <NSObject>

@optional
- (void)phoneViewController:(LLPhoneViewController *)phoneViewController didFinishWithPhone:(NSString *)phone;

@end
