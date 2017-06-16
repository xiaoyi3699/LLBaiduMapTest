//
//  LLPhoneViewController.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLPhoneViewController.h"

@interface LLPhoneViewController (){
    NSTimer     *_timer;
    UIButton    *_codeBtn;
    UIButton    *_OKBtn;
    NSInteger   _remainingTime;
    UITextField *_phoneTextField;
    UITextField *_codeTextField;
}

@end

@implementation LLPhoneViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"更换手机号";
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:222/255. green:222/255. blue:222/255. alpha:1];
    [self createViews];
}

- (void)createViews {
    
    UILabel *originalPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 40)];
    originalPhoneLabel.text = [NSString stringWithFormat:@"旧手机号码：%@",[self handlePhone:_originalPhone]];
    originalPhoneLabel.textColor = [UIColor darkGrayColor];
    originalPhoneLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:originalPhoneLabel];
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(originalPhoneLabel.frame)+10, SCREEN_WIDTH, 101)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(inputView.frame)-100, 30)];
    _phoneTextField.placeholder = @"手机号";
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:_phoneTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_phoneTextField.frame)+10, SCREEN_WIDTH-20, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:222/255. green:222/255. blue:222/255. alpha:1];
    [inputView addSubview:lineView];
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+10, CGRectGetWidth(inputView.frame)-20, 30)];
    _codeTextField.placeholder = @"验证码";
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_codeTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [inputView addSubview:_codeTextField];
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.tag = 0;
    _codeBtn.frame = CGRectMake(SCREEN_WIDTH-100, 12.5, 80, 25);
    _codeBtn.layer.masksToBounds = YES;
    _codeBtn.layer.cornerRadius = 5;
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeBtn setBackgroundImage:[UIImage ll_imageWithColor:[UIColor colorWithRed:60/255. green:170/255. blue:70/255. alpha:1]] forState:UIControlStateNormal];
    _codeBtn.enabled = NO;
    [_codeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:_codeBtn];
    
    _OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _OKBtn.tag = 1;
    _OKBtn.frame = CGRectMake(10, CGRectGetMaxY(inputView.frame)+20, SCREEN_WIDTH-20, 40);
    _OKBtn.layer.masksToBounds = YES;
    _OKBtn.layer.cornerRadius = 5;
    _OKBtn.enabled = NO;
    [_OKBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_OKBtn setBackgroundImage:[UIImage ll_imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_OKBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_OKBtn];
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {//发送验证码
        btn.enabled = NO;
        _phoneTextField.enabled = NO;
        _remainingTime = 59;
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        }
    }
    else {//确定
        
    }
}

- (void)textFieldValueChanged:(UITextField *)textField {
    
    if (_phoneTextField.text.length >= 11 && _codeTextField.text.length >= 6) {
        _OKBtn.enabled = YES;
    }
    else {
        _OKBtn.enabled = NO;
    }
    
    if (textField ==_phoneTextField) {//手机号
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
            _codeBtn.enabled = YES;
        }
        else {
            _codeBtn.enabled = NO;
        }
    }
    else {//验证码
        if (textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)timerRun {
    if (_remainingTime > 0) {
        NSString *remainingTimeStr = [NSString stringWithFormat:@"%lds",(long)_remainingTime];
        [_codeBtn setTitle:remainingTimeStr forState:UIControlStateNormal];
    }
    else {
        _codeBtn.enabled = YES;
        _phoneTextField.enabled = YES;
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    _remainingTime --;
}

- (NSString *)handlePhone:(NSString *)phone {
    if (phone.length == 11) {
        return [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return phone;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)dealloc {
    NSLog(@"%@释放",NSStringFromClass([self class]));
}

@end
