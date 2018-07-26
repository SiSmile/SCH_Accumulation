//
//  SCHThreadViewController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/7/26.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHThreadViewController.h"
#import "SCHViewCell.h"
#import "SCHNSThreadController.h"

@interface SCHThreadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *dataSource;
@end

@implementation SCHThreadViewController
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"NSThread",@"GCD"];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[SCHViewCell class] forCellReuseIdentifier:@"SCHViewCell"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCHViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCHViewCell"];
    cell.name = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[SCHNSThreadController alloc] init] animated:YES];
            break;
            
        default:
            break;
    }
}

@end