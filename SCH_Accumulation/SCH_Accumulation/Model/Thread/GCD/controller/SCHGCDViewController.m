//
//  SCHGCDViewController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/7/30.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHGCDViewController.h"

@interface SCHGCDViewController ()

@end

@implementation SCHGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //1.异步函数 + 并发队列
    [self asyncConcurrent];
    
    //2.同步函数 + 并发队列
    //[self syncConcurrent];
    
    //3.异步函数 + 串行队列
    //[self asyncSerial];
    
    //4.同步函数 + 串行队列
    //[self syncSerial];
    
    //5.异步函数 + 主队列
    //[self asyncMain];
    
    //6.同步函数 + 主队列
    //[self syncMain];
}
/**
 同步函数 + 主队列：发生阻塞
 */
- (void)syncMain{
    NSLog(@"begin");
    
    //1.获得主队列
    dispatch_queue_t  queue = dispatch_get_main_queue();
    //2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1 -----  %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2 -----  %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3 -----  %@",[NSThread currentThread]);
    });
    /*
     发生阻塞，sync幢上dispatch_get_main_queue主队列(串行队列)要立马执行，但是主线程也在执行，所以阻塞
     */
    
    //以下代码也会发生堵塞，你等我我等你
    dispatch_queue_t queue1 = dispatch_queue_create("堵塞", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue1, ^{
        NSLog(@"1 -----  %@",[NSThread currentThread]);
        
        dispatch_sync(queue1, ^{
            NSLog(@"2 -----  %@",[NSThread currentThread]);
        });
    });
    
}


/**
 异步函数 + 主队列：是一种特殊的串行队列，只在主线程中执行，主队列队列优先级高
 */
- (void)asyncMain{
    //1.获得主队列
    dispatch_queue_t  queue = dispatch_get_main_queue();
    //2.将任务加入队列
    dispatch_async(queue, ^{
        NSLog(@"1 -----  %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2 -----  %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3 -----  %@",[NSThread currentThread]);
    });
    /* async具有开启新线程能力，但是是在dispatch_get_main_queue主队列中，主队列又在主线程中，所以任务会在主线程执行
     2018-07-31 10:49:56.819458+0800 SCH_Accumulation[7737:475811] 1 -----  <NSThread: 0x604000077040>{number = 1, name = main}
     2018-07-31 10:49:56.819717+0800 SCH_Accumulation[7737:475811] 2 -----  <NSThread: 0x604000077040>{number = 1, name = main}
     2018-07-31 10:49:56.819854+0800 SCH_Accumulation[7737:475811] 3 -----  <NSThread: 0x604000077040>{number = 1, name = main}
     */
}
/**
 同步函数+ 串行队列:主线程 顺序执行
 */
- (void)syncSerial{
    //1.创建串行队列
    dispatch_queue_t  queue = dispatch_queue_create("同步串行", DISPATCH_QUEUE_SERIAL);
    //2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1 -----  %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2 -----  %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3 -----  %@",[NSThread currentThread]);
    });
    /*主线程 顺序执行
     2018-07-31 10:43:06.313086+0800 SCH_Accumulation[7611:469721] 1 -----  <NSThread: 0x600000079400>{number = 1, name = main}
     2018-07-31 10:43:06.313368+0800 SCH_Accumulation[7611:469721] 2 -----  <NSThread: 0x600000079400>{number = 1, name = main}
     2018-07-31 10:43:06.313503+0800 SCH_Accumulation[7611:469721] 3 -----  <NSThread: 0x600000079400>{number = 1, name = main}
     */
}
/**
 异步函数 + 串行队列：会开启新线程，但任务是串行，执行问一个，再执行下一个
 */
- (void)asyncSerial{
    //1.创建串行队列
    dispatch_queue_t  queue = dispatch_queue_create("异步串行", DISPATCH_QUEUE_SERIAL);
    //2.将任务加入队列
    dispatch_async(queue, ^{
        NSLog(@"1 -----  %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2 -----  %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3 -----  %@",[NSThread currentThread]);
    });
    /* 只开了一条线程，因为异步会开启新线程，但任务是串行，执行问一个在执行下一个
     2018-07-31 10:39:43.038044+0800 SCH_Accumulation[7536:466335] 1 -----  <NSThread: 0x60000047ae80>{number = 3, name = (null)}
     2018-07-31 10:39:43.038250+0800 SCH_Accumulation[7536:466335] 2 -----  <NSThread: 0x60000047ae80>{number = 3, name = (null)}
     2018-07-31 10:39:43.038788+0800 SCH_Accumulation[7536:466335] 3 -----  <NSThread: 0x60000047ae80>{number = 3, name = (null)}

     */
}
/**
 同步函数 + 并发队列：因为当前线程在主线程 又因为dispatch_sync在当前线程执行，所以在主线程执行，同步不会开启新线程
 */
- (void)syncConcurrent{
    //1.获得全局的并发队列 -- 常用(只要是全局的就是并发队列)
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.将任务加入队列
    dispatch_sync(queue, ^{
         NSLog(@"1 -----  %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2 -----  %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3 -----  %@",[NSThread currentThread]);
    });
    /*
     2018-07-31 10:36:13.653765+0800 SCH_Accumulation[7463:462963] 1 -----  <NSThread: 0x604000063e00>{number = 1, name = main}
     2018-07-31 10:36:13.654044+0800 SCH_Accumulation[7463:462963] 2 -----  <NSThread: 0x604000063e00>{number = 1, name = main}
     2018-07-31 10:36:13.654166+0800 SCH_Accumulation[7463:462963] 3 -----  <NSThread: 0x604000063e00>{number = 1, name = main}
     */
}
/**
 异步函数 + 并发队列：可以同时开启多条线程
 */
- (void)asyncConcurrent{
    
    /**
     gcd
     dispatch_queue_t  _Nonnull queue 队列
     <#^(void)block#> 要执行的任务
     */
    //1.手动创建
    //dispatch_queue_t  queue = dispatch_queue_create("异步并发", DISPATCH_QUEUE_CONCURRENT);
    //2.获得全局的并发队列 -- 常用(只要是全局的就是并发队列)
    //long identifier 优先级
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i=0; i<10; i++) {
            NSLog(@"1 -----  %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i=0; i<10; i++) {
            NSLog(@"2 -----  %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i=0; i<10; i++) {
            NSLog(@"3 -----  %@",[NSThread currentThread]);
        }
    });
    /* 可以看出开启新线程 同时执行任务
     2018-07-31 10:06:53.785045+0800 SCH_Accumulation[7102:439771] 2 -----  <NSThread: 0x60400066ad00>{number = 4, name = (null)}
     2018-07-31 10:06:53.785045+0800 SCH_Accumulation[7102:439770] 1 -----  <NSThread: 0x6000004684c0>{number = 3, name = (null)}
     2018-07-31 10:06:53.785086+0800 SCH_Accumulation[7102:439766] 3 -----  <NSThread: 0x60400066a780>{number = 5, name = (null)}
     2018-07-31 10:06:53.785268+0800 SCH_Accumulation[7102:439771] 2 -----  <NSThread: 0x60400066ad00>{number = 4, name = (null)}
     2018-07-31 10:06:53.785724+0800 SCH_Accumulation[7102:439770] 1 -----  <NSThread: 0x6000004684c0>{number = 3, name = (null)}
     2018-07-31 10:06:53.785794+0800 SCH_Accumulation[7102:439766] 3 -----  <NSThread: 0x60400066a780>{number = 5, name = (null)}
     2018-07-31 10:06:53.786072+0800 SCH_Accumulation[7102:439770] 1 -----  <NSThread: 0x6000004684c0>{number = 3, name = (null)}
     2018-07-31 10:06:53.786120+0800 SCH_Accumulation[7102:439771] 2 -----  <NSThread: 0x60400066ad00>{number = 4, name = (null)}
     */
}
@end
