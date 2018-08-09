//
//  SCHNSOperationController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/8/9.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHNSOperationController.h"
#import "SCHOperation.h"
@interface SCHNSOperationController ()

@end

@implementation SCHNSOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*
     GCD :
     1.并发队列
        1.1.自己创建的
        1.2.全局的
     2.串行队列
        2.1.自己创建的
        2.2.主队列
     */
    /*
     NSOperationQueue:
     1.主队列
        1.1.[NSOperationQueue mainQueue];
        1.2.凡是添加到主队列中的任务(NSOperation)，都会放到主线程中
     2.非主队列（其他队列）
        2.1.[[NSOperationQueue alloc] init]
        2.2.同时包含了串行和并发功能
        2.3.凡是添加到这种队列中的任务(NSOperation)，都会放到子线程中执行
     */
    
    //1.创建任务
     /*
      NSOperation是抽象类，本身不具有操作能力，必须使用它的子类
      子类有三种：
            一.NSBlockOperation;
            二.NSInvocationOperation
            三.自定义子类继承NSOperation，实现内部方法
      */
    NSBlockOperation *opr1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"downLoad1 -- %@",[NSThread currentThread]);
    }];
    NSInvocationOperation *opr2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoad2) object:nil];
    SCHOperation *opr3 = [[SCHOperation alloc] init];
    
    //可以继续添加任务
    [opr1 addExecutionBlock:^{
        
        NSLog(@"downLoad4 -- %@",[NSThread currentThread]);
    }];
    
    //2.将以上任务添加到队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //可以直接在队列中添加任务
    [queue addOperationWithBlock:^{
       NSLog(@"downLoad5 -- %@",[NSThread currentThread]);
    }];
    
    [queue addOperation:opr1];
    [queue addOperation:opr2];
    [queue addOperation:opr3];
    
}
- (void)downLoad2{
    NSLog(@"downLoad2 -- %@",[NSThread currentThread]);
}
@end
