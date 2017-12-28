//
//  HelpViewController.m
//  lottery86
//
//  Created by ArrQ on 2017/11/24.
//  Copyright © 2017年 付宝网络. All rights reserved.
//

#import "HelpViewController.h"
#import <WebKit/WebKit.h>

@interface HelpViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progress;

@end

@implementation HelpViewController

- (void)viewWillAppear:(BOOL)animated{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@",self.typeStr];
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:self.typeStr withExtension:nil];
    
    //    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"bjpk_yxgz.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    [self.wkWebView loadRequest:request];
    
    //，获得页面title和加载进度值
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    


}

#pragma mark 加载进度条
- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, Frank_StatusAndNavBar_Height, SCREEN_WIDTH, 2)];
        _progress.tintColor = [UIColor blueColor];
        _progress.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}



- (WKWebView *)wkWebView{
    
    
    if (_wkWebView == nil)
    {
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, Frank_StatusAndNavBar_Height, SCREEN_WIDTH, SCREEN_HEIGHT-Frank_StatusAndNavBar_Height)];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
    
  
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];



}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.wkWebView)
        {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.wkWebView.estimatedProgress animated:YES];
            if(self.wkWebView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView)
        {
            self.title = self.wkWebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 移除观察者
- (void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}
@end


