//
//  SCHCommunicationController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/7/30.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHCommunicationController.h"

@interface SCHCommunicationController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SCHCommunicationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /********** 主线程 *************/
    //创建子线程
    [self performSelectorInBackground:@selector(downLoad) withObject:nil];
}
#pragma mark -- 子线程中处理图片
- (void)downLoad{
    //图片的网络路径
    NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
    //根据图片的网络路径下载图片
    NSData *data = [NSData dataWithContentsOfURL:url];
    //生成图片
    UIImage *image = [UIImage imageWithData:data];
    
    /******** 回到主线程 -- 显示图片 *******/
    
      //方法一
    //[self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:YES];
   
      //方法二
     //[self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
      //方法三
    [self.imageView performSelector:@selector(setImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
    
     /*
      waitUntilDone:YES/NO
      YES：等@selector方法执行完再往下执行
      NO：直接往下同时进行
      */
}
#pragma mark -- 主线程
- (void)showImage:(UIImage *)image{
     self.imageView.image = image;
}
/*
 测试耗时时间
 //方法一
 //开始时间
 NSDate *beginDate = [NSDate date];
 //测试代码
 //结束时间
 NSDate *endDate = [NSDate date];
 NSLog(@"%f",[endDate timeIntervalSinceDate:beginDate]);
 
 //方法二
 
 CFTimeInterval beginTime =  CFAbsoluteTimeGetCurrent();
 
 //测试代码
 
 CFTimeInterval endTime = CFAbsoluteTimeGetCurrent();
 
 NSLog(@"%f",endTime - beginTime);
 
 */
@end
