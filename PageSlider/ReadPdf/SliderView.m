//
//  SliderView.m
//  ReadPdf
//
//  Created by Mac on 16/6/13.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "SliderView.h"
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:0.5]

@interface SliderView()
{
    NSInteger _stringLength;
}

@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UILabel *pageLabel;
@end

@implementation SliderView

// 记录总页数
static CGFloat _allPage;
static CGFloat _maximumValue;
static NSMutableArray *_array;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 左右轨的图片
        UIImage *stetchLeftTrack= [UIImage imageNamed:@"sliderPageControlBgRed"];
        UIImage *stetchRightTrack = [UIImage imageNamed:@"sliderPageControlBg"];
        
        // 滑块图片
        UIImage *thumbImage = [UIImage imageNamed:@"slider"];
        UISlider *sliderA=[[UISlider alloc] init];
        sliderA.backgroundColor = [UIColor clearColor];
        sliderA.value=0.0f;
        sliderA.minimumValue=0.0f;
        sliderA.maximumValue=_maximumValue;
        [sliderA setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [sliderA setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        
        // 注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [sliderA setThumbImage:thumbImage forState:UIControlStateHighlighted];
        [sliderA setThumbImage:thumbImage forState:UIControlStateNormal];
        
        // 滑块拖动时的事件
        [sliderA addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        // 滑动拖动后的事件
        [sliderA addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sliderA];
        self.slider = sliderA;
        
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.hidden = YES;
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.backgroundColor = JMColor(106, 116, 98);
        pageLabel.textColor = [UIColor whiteColor];
        [self addSubview:pageLabel];
        self.pageLabel = pageLabel;
        
        _stringLength = [NSString stringWithFormat:@"%ld", (NSInteger)_allPage].length;
    }
    return self;
}

// 滑动结束
- (void)sliderDragUp:(UISlider *)slider{
    
    // 标记最小值和取到的y
    CGFloat min1 = 0.0;
    CGFloat minY = 0.0;
    
    int i = 0;
    CGFloat y  = slider.value;
    for (NSNumber *num in _array) {
        
        CGFloat cgf = num.floatValue;
        CGFloat y1 = fabs(cgf - y);
        
        if (i == 0) min1 = y1;

        if (min1 > y1) {
            
            min1 = y1;
            minY = cgf;
        }
        
        i ++;
    }
    
    slider.value = minY;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.pageLabel.hidden = YES;
    });

}

// 滑动时调用代理方法
- (void)sliderValueChanged:(UISlider *)slider{
    
    if ([self.delegate respondsToSelector:@selector(changeValue:)]) {
        
        // 取出当前值
        CGFloat cgf = slider.value*_allPage;
        NSInteger page = cgf;
        CGFloat max = (CGFloat)(page+1);
        
        // 比较当前值距离page和max绝对值的大小, 距离那个近取哪个值
        CGFloat absfMin = fabs(cgf - page);
        CGFloat absfMax = fabs(cgf - max);
        
        if (absfMax>absfMin) {
            
            [self.delegate changeValue:page];
            self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", 1+page, (NSInteger)_allPage];
        }else{
            self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", 1+(NSInteger)max, (NSInteger)_allPage];
            [self.delegate changeValue:(NSInteger)max];
        }
    }
    
    self.pageLabel.hidden = NO;
}

// 设置slider显示的页数
- (void)currentPage:(NSInteger)currentPage
{
    self.pageLabel.hidden = NO;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", 1+currentPage, (NSInteger)_allPage];
    [self.slider setValue:[_array[currentPage] floatValue] animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.pageLabel.hidden = YES;
    });
}

+ (SliderView *)initWithAllPage:(NSInteger)page addDelegate:(id)delegate
{
    _allPage = (CGFloat)page;
    _array = [NSMutableArray array];
    
    // 根据总页数计算节点
    for (int i = 0; i < _allPage; i ++) {
        
        CGFloat cgfloat = (CGFloat)((1.0f/_allPage)*i);
        NSNumber *number = [NSNumber numberWithFloat:cgfloat];
        [_array addObject:number];
    }
    _maximumValue = [_array.lastObject floatValue];
    SliderView *sliderView = [[SliderView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 20)];
    sliderView.delegate = delegate;
    return sliderView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.slider.frame = self.bounds;
    if (_stringLength == 3) {self.pageLabel.frame = CGRectMake(0, 0, 66, 28);}
    else if (_stringLength == 2){self.pageLabel.frame = CGRectMake(0, 0, 50, 28);}
    else{self.pageLabel.frame = CGRectMake(0, 0, 35, 28);}
    self.pageLabel.center = CGPointMake(self.bounds.size.width/2, CGRectGetMaxY(self.slider.frame)-28);
}

@end

