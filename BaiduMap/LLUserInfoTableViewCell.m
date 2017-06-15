//
//  LLUserInfoTableViewCell.m
//  BaiduMap
//
//  Created by WangZhaomeng on 2017/6/15.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLUserInfoTableViewCell.h"

@implementation LLUserInfoTableViewCell {
    UIImageView *_headerImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 5, 40, 40)];
        _headerImageView.backgroundColor = [UIColor grayColor];
        _headerImageView.hidden = YES;
        [self addSubview:_headerImageView];
    }
    return self;
}

- (void)setConfigWithTitle:(NSString *)title subTitle:(id)subTitle isImage:(BOOL)isImage {
    self.textLabel.text = title;
    if (isImage) {//显示头像的cell
        self.detailTextLabel.text = @"";
        _headerImageView.hidden = NO;
        if ([subTitle isKindOfClass:[UIImage class]]) {
            _headerImageView.image = subTitle;
        }
        else if ([subTitle isKindOfClass:[NSString class]]) {
            NSURL *url = [NSURL URLWithString:subTitle];
            if (url == nil) {
                url = [NSURL URLWithString:[subTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            [_headerImageView sd_setImageWithURL:url placeholderImage:nil];
        }
    }
    else {
        self.detailTextLabel.text = subTitle;
        _headerImageView.image = nil;
        _headerImageView.hidden = YES;
    }
}

@end
