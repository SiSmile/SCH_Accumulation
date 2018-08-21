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
@property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation SCHNSOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    //2.添加任务到队列
    [queue addOperationWithBlock:^{
        NSLog(@"down1 -- %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"down2 -- %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"down3 -- %@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    self.queue = queue;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    //[self operationQueue1];
    //[self operationQueue2];
    //[self operationQueue3];
    //[self operationQueue4];
    //5.挂起（暂停）和取消
    //[self operationQueue5];
    //6.依赖
    //[self operationQueue6];
    //7.监听
    [self operationQueue7];
    
    
    
    
    
}
#pragma mark --创建任务 添加队列
- (void)operationQueue7{
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down-op1-%@",[NSThread currentThread]);
    }];
    //监听线程执行完毕：注意completionBlock是在子线程中完成的，但是不一定和op1任务在同一个线程
    op1.completionBlock = ^{
        NSLog(@"down-op1执行完毕-%@",[NSThread currentThread]);
    };
    [queue addOperation:op1];
}
#pragma mark --创建任务 添加队列
- (void)operationQueue6{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down-op1-%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down-op2-%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down-op3-%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down-op4-%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"down-op5-%@",[NSThread currentThread]);
    }];

    //加入队列 但是要求op1，op2，op4，op5都执行完之后再执行op3
      //1.设置op3的依赖
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    [op3 addDependency:op4];
    [op3 addDependency:op5];
      //2.加入队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
    
    
}
#pragma mark --创建任务 添加队列
- (void)operationQueue5{
    //取消（销毁）任务
    //注意：耗时操作在使用时应该每次都判断是否取消
    [self.queue cancelAllOperations];
}
#pragma mark --创建任务 添加队列
- (void)operationQueue4{
    if (self.queue.isSuspended) {
        //回复队列 继续执行
        self.queue.suspended = NO;
    }else{
        //暂停（挂起）队列，暂停执行（注意：只是暂停，并没有销毁）
        self.queue.suspended = YES;
    }
    
    /*
     常用于 比如正在下载图片 此时用户拖拽滑动，suspended属性可以停止下载图片取滑动 这样就不会有卡顿的情况，优化用户体验
     */
}
#pragma mark --创建任务 添加队列
- (void)operationQueue3{
    /*
     maxConcurrentOperationCount :最大并发数
     maxConcurrentOperationCount = 1;变成了串行队列
     maxConcurrentOperationCount =/（不等于） 1;变成了并行队列
     */
    
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    queue.maxConcurrentOperationCount = 3;
    
    //2.添加任务到队列
    [queue addOperationWithBlock:^{
        NSLog(@"down1 -- %@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"down2 -- %@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"down3 -- %@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"down4 -- %@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"down5 -- %@",[NSThread currentThread]);
    }];
    
}
#pragma mark --创建任务 添加队列
- (void)operationQueue2{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //2.添加任务到队列
    [queue addOperationWithBlock:^{
        NSLog(@"down1 -- %@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"down2 -- %@",[NSThread currentThread]);
    }];
}
#pragma mark --创建任务 添加队列
- (void)operationQueue1{
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
