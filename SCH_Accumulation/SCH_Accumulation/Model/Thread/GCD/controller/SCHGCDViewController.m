//
//  SCHGCDViewController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/7/30.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHGCDViewController.h"
#import "SCHSingleViewController.h"
@interface SCHGCDViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageGroup;
@property (strong, nonatomic) UIImage *imageGroup1;
@property (strong, nonatomic) UIImage *imageGroup2;

@end

@implementation SCHGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
#pragma mark -- 代理模式
- (IBAction)single:(id)sender {
    SCHSingleViewController *single1 = [[SCHSingleViewController alloc] init];
    single1.name = @"sch";
    SCHSingleViewController *single2 = [[SCHSingleViewController alloc] init];
    SCHSingleViewController *single3 = [[SCHSingleViewController alloc] init];
    NSLog(@"single1=%p,single2=%p,single3=%p",single1,single2,single3);
    NSLog(@"single3.name=%@",single3.name);
    NSLog(@"single11=%p,single12=%p",[SCHSingleViewController shareSCHSingleViewController],[[SCHSingleViewController alloc]init]);
    
}

#pragma mark---快速迭代代码
- (IBAction)dispatch_apply:(id)sender {
    /*
     需求将（测试）fromPath=/Users/sch/Desktop/sch/study-ios/05-多线程/0708GCD单例模式/0708GCD单例模式/资料
     路径下的图片移到 toPath=/Users/sch/Desktop/sch/study-ios/05-多线程/0708GCD单例模式/0708GCD单例模式/资料2
     */
    
    NSString *fromPath = @"/Users/sch/Desktop/sch/study-ios/05-多线程/0708GCD单例模式/0708GCD单例模式/资料";
    NSString *toPath = @"/Users/sch/Desktop/sch/study-ios/05-多线程/0708GCD单例模式/0708GCD单例模式/资料2";
    
    //1.创建文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    //2.根据路径获取文件夹下的所有文件
    NSArray *imageArray = [manager contentsOfDirectoryAtPath:fromPath error:nil];
    NSLog(@"imageArray___%@",imageArray);
    //3.快速迭代（用的是并发）
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(imageArray.count, queue, ^(size_t index) {
        //4.获取每个文件的整体路径
        NSString *oPath = imageArray[index];
        NSString *fromFullPath = [fromPath stringByAppendingPathComponent:oPath];
        NSLog(@"fromFullPath__%@",fromFullPath);
        
        NSString *toFullPath = [toPath stringByAppendingPathComponent:oPath];
        NSLog(@"toFullPath__%@",toFullPath);
        
        //5.从fromPath移动到toPath
        [manager moveItemAtPath:fromFullPath toPath:toFullPath error:nil];
    });
    
    /*
     dispatch_apply对比的for循环的好处：
       dispatch_apply 耗时非常短 在使用异步队列的时候会开启子线程，不会堵塞主线程
     */
    
}
#pragma mark -- 队列组
- (IBAction)dispatch_group:(id)sender {
    /*
     需求 分别下载两张图片，下载完成后将两张合成一张图片
     */
    //1.下载第一张图片
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.imageGroup1 = [UIImage imageWithData:data];
    });
    //2.下载第二张图片
    dispatch_group_async(group, queue, ^{
        NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533633094832&di=66712561e3e59c1d3a35e35746d514f0&imgtype=0&src=http%3A%2F%2Fi5.hexunimg.cn%2F2013-06-25%2F155504368.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.imageGroup2 = [UIImage imageWithData:data];
    });
    //3.全部下载完
    dispatch_group_notify(group, queue, ^{
        //获得上下文
        UIGraphicsBeginImageContext(CGSizeMake(100, 100));
        [self.imageGroup1 drawInRect:CGRectMake(0, 0, 50, 100)];
        [self.imageGroup2 drawInRect:CGRectMake(50,0,50,100)];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageGroup.image = resultingImage;
        });
        
    });
    
    
}
#pragma MARK -- GCD的各种队列
- (IBAction)gcdQueue:(id)sender {
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
#pragma MARK -- GCD间的通信
- (IBAction)gcdCommunication:(id)sender {
   //1.开启新线程，用的全局并行队列
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //图片的网络路径
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        //根据图片的网络路径下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        //生成图片
        UIImage *image = [UIImage imageWithData:data];
        
        //2.回到主线程刷新UI
         /******** 2_1.（用的是异步函数，但是是主队列） ******/
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"------end2------");
            self.imageView.image = image;
        });
         
         /******** 2_2.（用的是异步函数，主队列） ******/
        /*
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"------end2------");
            self.imageView.image = image;
        });
         */
        NSLog(@"------end1------");
        /*
          2_1和2_2 的区别在end1 和 end2的执行顺序
            打印顺序：
                    2_1是 end1-》end2
                    2_2是 end2-》end1
         */
    });
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
    
    NSLog(@"end -- %@",[NSThread currentThread]);
    /* async具有开启新线程能力，但是是在dispatch_get_main_queue主队列中，主队列又在主线程中，所以任务会在主线程执行
     2018-07-31 10:49:56.819458+0800 SCH_Accumulation[7737:475811] 1 -----  <NSThread: 0x604000077040>{number = 1, name = main}
     2018-07-31 10:49:56.819717+0800 SCH_Accumulation[7737:475811] 2 -----  <NSThread: 0x604000077040>{number = 1, name = main}
     2018-07-31 10:49:56.819854+0800 SCH_Accumulation[7737:475811] 3 -----  <NSThread: 0x604000077040>{number = 1, name = main}
     */
    /*
     执行顺序：end-->1-->2-->3
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
    
    NSLog(@"end -- %@",[NSThread currentThread]);
    /*主线程 顺序执行
     2018-07-31 10:43:06.313086+0800 SCH_Accumulation[7611:469721] 1 -----  <NSThread: 0x600000079400>{number = 1, name = main}
     2018-07-31 10:43:06.313368+0800 SCH_Accumulation[7611:469721] 2 -----  <NSThread: 0x600000079400>{number = 1, name = main}
     2018-07-31 10:43:06.313503+0800 SCH_Accumulation[7611:469721] 3 -----  <NSThread: 0x600000079400>{number = 1, name = main}
     */
    /*
     执行顺序：1-->2-->3-->end
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
    
    NSLog(@"end -- %@",[NSThread currentThread]);
    /* 只开了一条线程，因为异步会开启新线程，但任务是串行，执行问一个在执行下一个
     2018-08-02 15:51:55.693282+0800 SCH_Accumulation[3405:179448] end -- <NSThread: 0x600000065300>{number = 1, name = main}
     2018-08-02 15:51:55.693282+0800 SCH_Accumulation[3405:179507] 1 -----  <NSThread: 0x600000279d40>{number = 3, name = (null)}
     2018-08-02 15:51:55.693738+0800 SCH_Accumulation[3405:179507] 2 -----  <NSThread: 0x600000279d40>{number = 3, name = (null)}
     2018-08-02 15:51:55.694221+0800 SCH_Accumulation[3405:179507] 3 -----  <NSThread: 0x600000279d40>{number = 3, name = (null)}


     */
    /*
     执行顺序：end-->1-->2-->3
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
    
    NSLog(@"end -- %@",[NSThread currentThread]);
    /*
     2018-08-02 15:48:35.390797+0800 SCH_Accumulation[3346:176604] 1 -----  <NSThread: 0x60400007ec80>{number = 1, name = main}
     2018-08-02 15:48:35.391324+0800 SCH_Accumulation[3346:176604] 2 -----  <NSThread: 0x60400007ec80>{number = 1, name = main}
     2018-08-02 15:48:35.391691+0800 SCH_Accumulation[3346:176604] 3 -----  <NSThread: 0x60400007ec80>{number = 1, name = main}
     2018-08-02 15:48:35.391982+0800 SCH_Accumulation[3346:176604] end -- <NSThread: 0x60400007ec80>{number = 1, name = main}

     */
    /*
     打印顺序： 1 --》2 --》3--》end
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

    NSLog(@"end -- %@",[NSThread currentThread]);
    
    /* 可以看出开启新线程
     2018-08-02 15:45:51.933435+0800 SCH_Accumulation[3310:174116] end -- <NSThread: 0x60400006a780>{number = 1, name = main}
     2018-08-02 15:45:51.933510+0800 SCH_Accumulation[3310:174173] 1 -----  <NSThread: 0x604000275a00>{number = 3, name = (null)}
     2018-08-02 15:45:51.933556+0800 SCH_Accumulation[3310:174178] 2 -----  <NSThread: 0x6040002759c0>{number = 4, name = (null)}
     2018-08-02 15:45:51.933592+0800 SCH_Accumulation[3310:174172] 3 -----  <NSThread: 0x604000275100>{number = 5, name = (null)}

     */
    /*
     打印顺序 end --》（1.2.3顺序不定）
     */
}
@end
