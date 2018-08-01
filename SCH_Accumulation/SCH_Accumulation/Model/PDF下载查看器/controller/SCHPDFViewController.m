//
//  SCHPDFViewController.m
//  SCH_Accumulation
//
//  Created by yunzhihui on 2018/8/1.
//  Copyright © 2018年 sch. All rights reserved.
//

#import "SCHPDFViewController.h"

@interface SCHPDFViewController ()

@property (nonatomic, strong) NSString *cachesPath;
@property (nonatomic, strong) NSFileManager *fileManager;
@end

@implementation SCHPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.初始化存储对像
    _cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    _fileManager = [NSFileManager defaultManager];
    
    //2.查看文件
    [self LookDocument:@"http://10.113.9.49/group1/M00/00/19/CnEJMVte3nKAH3GlAALX3038JCQ909.pdf"];
}
#pragma mark -- 1. 通过文件路径查看文件
- (void)LookDocument:(NSString *)pathUrl{
    //1.从字符/中分隔成多个元素的数组
    NSArray *array = [pathUrl componentsSeparatedByString:@"/"];
    //2.得到文件名
    NSString *file = [array lastObject];
    //3.判断该文件是否缓存过
    if ([self isFileExist:file]) {
        //4.缓存过，直接获取
        [SVProgressHUD showWithStatus:@"文件已缓存"];
        _cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fullPath = [_cachesPath stringByAppendingPathComponent:file];
        //根据路径加载文件
        [self loadDocument:fullPath];
    }else{
        //5.没有缓存过，从网络下载
        [self downloadFile:pathUrl];
    }
}

#pragma mark--  2. 判断沙盒中是否存在此文件
-(BOOL) isFileExist:(NSString *)fileName
{
    //文件路径
    _cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [_cachesPath stringByAppendingPathComponent:fileName];
    _fileManager = [NSFileManager defaultManager];
    BOOL result = [_fileManager fileExistsAtPath:fullPath];
    NSLog(@"这个文件是否已经存在：%@",result?@"存在":@"不存在");
    return result;
}
#pragma mark -- 3.下载文件
- (void)downloadFile:(NSString *)downLoadUrl{
    // 创建会话管理者
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:downLoadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 下载文件
    [SVProgressHUD showWithStatus:@"正在下载文件"];
    [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        weakSelf.cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fullPath = [weakSelf.cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        // 返回一个URL, 返回的这个URL就是文件的位置的完整路径
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"filePath path == %@",[filePath path]);
        
        [weakSelf loadDocument:[filePath path]];
    }] resume];
}
#pragma mark -- 4.用webview显示文件
-(void)loadDocument:(NSString *)documentName
{
    
    [SVProgressHUD dismissWithDelay:2];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, CWScreenWidth, CWScreenHeight)];
    [self.view addSubview:webView];
    NSURL *url = [NSURL fileURLWithPath:documentName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}
@end
