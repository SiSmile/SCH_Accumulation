//
//  SCHNSThreadController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/7/26.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHNSThreadController.h"

@interface SCHNSThreadController ()

@end

@implementation SCHNSThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //默认在主线程中执行
    //    [self createThread1];
    //    [self createThread2];
    
    //线程睡眠4s （阻塞4s）
    [NSThread sleepForTimeInterval:4];
    
    //睡眠到什么时候。[NSDate distantFuture]遥远的未来
    [NSThread sleepUntilDate:[NSDate distantFuture]];
    
    //睡眠到从现在算起的2s
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
    [self createThread3];
    
    
}

#pragma mark -- 创建线程3
- (void)createThread3{
    //开启一个后台线程
    [self performSelectorInBackground:@selector(run:) withObject:@"sch"];
}
#pragma mark -- 创建线程2
- (void)createThread2{
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"rose"];
}
#pragma mark -- 创建线程1
- (void)createThread1{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"jack"];
    //启动线程
    thread.name = @"sch创建的第一个线程";
    [thread start];
}
- (void)run:(NSString *)params{
    /*
     1.线程一启动，就会在线程thread中执行self的run方法
     2.该方法执行完 thread自动销毁
     */
    for (int i=0; i<10; i++) {
        NSLog(@"----run -----%d %@ %@",i,params,[NSThread currentThread]);
        
    }
}
@end
