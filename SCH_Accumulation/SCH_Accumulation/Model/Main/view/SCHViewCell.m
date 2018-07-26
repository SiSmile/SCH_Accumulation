//
//  SCHViewCell.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/7/26.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHViewCell.h"

@interface SCHViewCell()
@property (strong, nonatomic) UILabel *nameL;
@end

@implementation SCHViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
#pragma mark -- 标题头
- (void)setName:(NSString *)name{
    _name = name;
    _nameL.text = name;
}
- (void)createUI{
    _nameL = [[UILabel alloc] init];
    _nameL.textColor = [UIColor grayColor];
    _nameL.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameL];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.bottom.equalTo(self.contentView);
    }];
}
@end
