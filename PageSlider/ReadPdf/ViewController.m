//
//  ViewController.m
//  ReadPdf
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "ViewController.h"
#import "SliderView.h"
#import "PageSlider.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kImageCount 16

@interface ViewController ()<UIScrollViewDelegate, SliderViewDelegate>
@property (nonatomic, strong) UIPageControl *pageContorl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak)  PageSlider *slider;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) BOOL isSuccess;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureScrollView];
    [self configurePageControl];
    
    
    PageSlider *sliderView = [PageSlider initWithAllPage:kImageCount addDelegate:self];
    [self.view addSubview:sliderView];
    self.slider = sliderView;
}

// 配置滚动视图
- (void)configureScrollView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.backgroundColor = [UIColor yellowColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(kImageCount * kScreenWidth, 0);
    [self.view addSubview:_scrollView];
    
    // 设置代理
    self.scrollView.delegate = self;
    
    // 向_scrollView添加image对象
    for (int i = 0; i < kImageCount; i ++) {
        
        NSInteger num = arc4random_uniform(6)+1;
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"v6_guide_%ld", num]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight);
        [_scrollView addSubview:imageView];
    }
}

- (void)configurePageControl{
    
    self.pageContorl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 30)];
    _pageContorl.numberOfPages = kImageCount;
    _pageContorl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageContorl.pageIndicatorTintColor = [UIColor greenColor];
    [_pageContorl addTarget:self action:@selector(handlePageControl:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:_pageContorl];
}

- (void)handlePageControl:(UIPageControl *)sender{
    
    // 取出当前分页
    NSInteger number = sender.currentPage;
    
    // 通过分页控制scrollview的偏移量
    _scrollView.contentOffset = CGPointMake(number * kScreenWidth, 0);
}

#pragma UISlider使用方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 结束减速时的偏移量
    CGPoint offSet = scrollView.contentOffset;
    CGFloat number = offSet.x / kScreenWidth;
    self.pageNum = (NSInteger)number;
    _pageContorl.currentPage = _pageNum;
    
    // 当前页数
    [self.slider currentPage:self.pageNum];
}

#pragma mark --- 代理方法
- (void)changeValue:(NSInteger)page
{
   
    
    _pageContorl.currentPage = page-1;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollView.contentOffset = CGPointMake((page)*kScreenWidth, 0);
    }];
    
    NSLog(@"currentPage == %ld", page);
    NSLog(@"%f--%ld", page*kScreenWidth, _pageContorl.currentPage);
}


@end
