//
//  SCHSingleViewController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/8/7.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHSingleViewController.h"

@interface SCHSingleViewController ()<NSCopying>

@end

@implementation SCHSingleViewController

static SCHSingleViewController *_schSingle = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _schSingle = [super allocWithZone:zone];
    });
    return _schSingle;
}
- (id)copyWithZone:(NSZone *)zone{
    return _schSingle;
}
#pragma mark -- 方便的类方法
+(instancetype)shareSingle{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _schSingle = [[super alloc]init];
    });
    return _schSingle;
}
@end
