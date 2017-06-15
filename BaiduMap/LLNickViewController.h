//
//  LLNickViewController.h
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLNickViewControllerDelegate;

@interface LLNickViewController : UIViewController

@property (nonatomic, weak) id<LLNickViewControllerDelegate> delegate;

@end

@protocol LLNickViewControllerDelegate <NSObject>

@optional
- (void)nickViewController:(LLNickViewController *)nickViewController didFinishWithNick:(NSString *)nick;

@end
