//
//  LLUserInfoViewController.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLUserInfoViewController.h"
#import "LLUserInfoTableViewCell.h"

@interface LLUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSArray      *titles;
@property (nonatomic, strong) NSArray      *subTitles;
@property (nonatomic, assign) BOOL         isEditing;
@property (nonatomic, strong) UIButton     *saveBtn;

@end

@implementation LLUserInfoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"个人中心";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titles = @[@"头像:",
                @"昵称:",
                @"性别:",
                @"生日:",
                @"手机:"];
    _subTitles = @[@"http://touxiang.qqzhi.com/uploads/2012-11/1111105304979.jpg",
                @"李逍遥",
                @"男",
                @"1998-08-08",
                @"18888888888"];
    [self creaveViews];
}

- (void)creaveViews {
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    CGRect rect = self.view.bounds;
    rect.origin.y = 64;
    rect.size.height -= 64;
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(15, SCREEN_HEIGHT-50, SCREEN_WIDTH-30, 40);
    _saveBtn.enabled = NO;
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setBackgroundImage:[UIImage ll_imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLUserInfoTableViewCell *cell = (LLUserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (cell == nil) {
        cell = [[LLUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_titles.count > indexPath.row) {
        NSString *title = _titles[indexPath.row];
        NSString *subTitle = _subTitles[indexPath.row];
        BOOL isImage = NO;
        if (indexPath.row == 0) {
            isImage = YES;
        }
        [cell setConfigWithTitle:title subTitle:subTitle isImage:isImage];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEditing == NO) return;
}

- (void)rightBarButtonItemClick:(UIBarButtonItem *)rightBarButtonItem {
    rightBarButtonItem.title = (_isEditing ? @"编辑" : @"完成");
    _saveBtn.enabled = _isEditing;
    _isEditing = !_isEditing;
}

- (void)saveUserInfo:(UIButton *)btn {
    
}

@end
