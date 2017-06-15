//
//  LLNickViewController.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLNickViewController.h"

@interface LLNickViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *OKBtn;

@end

@implementation LLNickViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"修改昵称";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:222/255. green:222/255. blue:222/255. alpha:1];
    
    [self createViews];
}

- (void)createViews {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 40)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.placeholder = @"请输入昵称（2-20字符）";
    [_textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textField];
    
    _OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _OKBtn.frame = CGRectMake(10, CGRectGetMaxY(_textField.frame)+20, SCREEN_WIDTH-20, 40);
    _OKBtn.layer.masksToBounds = YES;
    _OKBtn.layer.cornerRadius = 5;
    _OKBtn.enabled = NO;
    [_OKBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_OKBtn setBackgroundImage:[UIImage ll_imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_OKBtn addTarget:self action:@selector(OKBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_OKBtn];
}

- (void)textFieldValueChanged:(UITextField *)textField {
    if (textField.text.length >= 2) {
        _OKBtn.enabled = YES;
    }
    else {
        _OKBtn.enabled = NO;
    }
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
}

- (void)OKBtnClick:(UIButton *)bth {
    [self.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(nickViewController:didFinishWithNick:)]) {
        [self.delegate nickViewController:self didFinishWithNick:_textField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
