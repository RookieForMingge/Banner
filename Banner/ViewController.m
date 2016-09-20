//
//  ViewController.m
//  Banner
//
//  Created by mingming on 16/3/1.
//  Copyright © 2016年 mingming. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView                *scroll;
    UIPageControl               *pageControl;
    NSTimer                     *timer;
    int                         currentPage;
    NSMutableArray              *arr_image;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBanner];
}

- (void)setBanner
{
    //scroll
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width,300)];
    [self.view addSubview:scroll];
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;

    arr_image = [NSMutableArray arrayWithObjects:@"p1.jpg",@"p2.jpg",@"p3.jpg",nil];
    for (int i = 0; i < arr_image.count + 2; i++) {
        NSString *str_img = [NSString stringWithFormat:@"%@",[arr_image objectAtIndex:(i + arr_image.count - 1) % arr_image.count]];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:str_img]];
        imageView.frame=CGRectMake(scroll.frame.size.width * i, 0,scroll.frame.size.width,scroll.frame.size.height);
        [scroll addSubview:imageView];
    }
    //设置scroll的contentsize
    scroll.contentSize = CGSizeMake(scroll.frame.size.width * (arr_image.count + 2),scroll.frame.size.height);
    
    //pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, 300 - 10, 100, 10)];
    [self.view addSubview:pageControl];
    [pageControl addTarget:self action:@selector(pageControlChange:) forControlEvents:UIControlEventValueChanged];
    //设置圆点颜色
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.numberOfPages = arr_image.count;
    
    //初始在第二个位置显示第一张
    scroll.contentOffset = CGPointMake(scroll.frame.size.width, 0);
    currentPage = 1;
    
    //创建计时器让其自动跳转
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoChangePc) userInfo:nil repeats:YES];
    //将计时器添加到主线程，拖拽其他控件不会让计时器停止运行
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - scroll delegate

//结束减速回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self changePageControl];
}

- (void)pageControlChange:(UIPageControl *)sender
{
    [scroll setContentOffset:CGPointMake(sender.currentPage * scroll.frame.size.width, 0) animated:YES];
}

//计时器绑定方法
- (void)autoChangePc
{
    currentPage++;
    [scroll setContentOffset:CGPointMake(currentPage * scroll.frame.size.width,0) animated:YES];
}

//动画结束时的回调
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self changePageControl];
}

- (void)changePageControl
{
    int page = scroll.contentOffset.x / scroll.frame.size.width - 1;
    //如果到达最后一页，让其回到第一页重新开始
    if (page == arr_image.count)
    {
        pageControl.currentPage = 0;
        currentPage = 1;
        [scroll setContentOffset:CGPointMake(scroll.frame.size.width, 0) animated:NO];
    }
    //如果是最左侧一页，让其回到最后一页
    else if (page == -1)
    {
        pageControl.currentPage = arr_image.count - 1;
        currentPage = (int)arr_image.count;
        [scroll setContentOffset:CGPointMake(scroll.frame.size.width * arr_image.count, 0) animated:NO];
    }
    else
    {
        pageControl.currentPage = page;
        currentPage = page + 1;
    }
}

@end
