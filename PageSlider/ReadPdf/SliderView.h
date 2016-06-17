//
//  SliderView.h
//  ReadPdf
//
//  Created by Mac on 16/6/13.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderViewDelegate <NSObject>
- (void)changeValue:(NSInteger)page;
@end

@interface SliderView : UIView
@property (nonatomic, weak) id<SliderViewDelegate> delegate;

/**
 *  传入两个参数, 总页数和当前页数
 *
 *  @param allPage     总页数
 *  @param currentPage 当前页数
 */
- (void)currentPage:(NSInteger)currentPage;

+ (SliderView *)initWithAllPage:(NSInteger)page addDelegate:(id)delegate;

@end
