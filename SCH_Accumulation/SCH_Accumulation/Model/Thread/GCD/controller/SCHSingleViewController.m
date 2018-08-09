//
//  SCHSingleViewController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/8/7.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHSingleViewController.h"

@interface SCHSingleViewController ()

@end

@implementation SCHSingleViewController

SCHSingletonM(SCHSingleViewController)
//一旦这个对象设置为代理，说明整个程序运行过程中，该对象将永远不会死，即该控制器一直不会死
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
