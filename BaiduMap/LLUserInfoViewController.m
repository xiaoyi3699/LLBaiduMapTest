//
//  LLUserInfoViewController.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLUserInfoViewController.h"
#import "LLUserInfoTableViewCell.h"
#import "LLDatePicker.h"

@interface LLUserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,LLDatePickerDelete>

@property (nonatomic, strong) UITableView             *tableView;
@property (nonatomic, strong) NSArray                 *titles;
@property (nonatomic, strong) NSMutableArray          *subTitles;
@property (nonatomic, assign) BOOL                    isEditing;
@property (nonatomic, strong) UIButton                *saveBtn;
@property (nonatomic, strong) UIImagePickerController *imagePC;
@property (nonatomic, strong) LLDatePicker            *datePicker;
@property (nonatomic, strong) NSDateFormatter         *dateFormatter;

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
    _subTitles = [@[@"http://touxiang.qqzhi.com/uploads/2012-11/1111105304979.jpg",
                @"李逍遥",
                @"男",
                @"1998-08-08",
                @"18888888888"] mutableCopy];
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
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.layer.cornerRadius = 5;
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setBackgroundImage:[UIImage ll_imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
}

//初始化imagePickerController
- (UIImagePickerController *)imagePC{
    if (!_imagePC) {
        _imagePC = [[UIImagePickerController alloc] init];
        _imagePC.allowsEditing = YES;
        _imagePC.delegate = self;
    }
    return _imagePC;
}

//初始化datePicker
- (LLDatePicker *)datePicker {
    if (_datePicker == nil) {
        _datePicker = [[LLDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
        _datePicker.delegete = self;
    }
    return _datePicker;
}

//初始化时间格式器
- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
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
    
    if (indexPath.row == 0) {//头像
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action_0 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                self.imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePC animated:YES completion:nil];
            }
            else {
                NSLog(@"相机打开失败");
            }
            
        }];
        UIAlertAction *action_1 = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
                self.imagePC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:self.imagePC animated:YES completion:nil];
            }
            else {
                NSLog(@"相册打开失败");
            }
        }];
        UIAlertAction *action_2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action_0];
        [alertController addAction:action_1];
        [alertController addAction:action_2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (indexPath.row == 1) {//昵称
        
    }
    else if (indexPath.row == 2) {//性别
        
    }
    else if (indexPath.row == 3) {//生日
        [[LLPopupAnimator animator] popUpView:self.datePicker
                               animationStyle:LLAnimationStyleFromDownAnimation
                                     duration:.3
                                   completion:nil];
    }
    else {//手机
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [_subTitles replaceObjectAtIndex:0 withObject:image];
        [_tableView reloadData];
    }];
}

- (void)datePicker:(LLDatePicker *)datePicker didClickOK:(BOOL)OK {
    [[LLPopupAnimator animator] dismiss];
    if (OK) {
        [_subTitles replaceObjectAtIndex:3 withObject:[self.dateFormatter stringFromDate:datePicker.date]];
        [_tableView reloadData];
    }
}

- (void)rightBarButtonItemClick:(UIBarButtonItem *)rightBarButtonItem {
    rightBarButtonItem.title = (_isEditing ? @"编辑" : @"完成");
    _saveBtn.enabled = _isEditing;
    _isEditing = !_isEditing;
}

- (void)saveUserInfo:(UIButton *)btn {
    
}

@end
