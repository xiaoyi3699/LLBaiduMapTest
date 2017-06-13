//
//  ViewController.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "LLMapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    NSArray *titles = @[@"百度地图",@"待定"];
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100+i*120, 200, 100, 30);
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        [self.navigationController pushViewController:[LLMapViewController new] animated:YES];
    }
    else {
        
    }
}


@end
