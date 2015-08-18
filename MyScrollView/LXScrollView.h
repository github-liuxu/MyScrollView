//
//  LXScrollView.h
//  
//
//  Created by 刘东旭 on 15/4/16.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXScrollView : UIScrollView<UIScrollViewDelegate>{
    NSInteger k;
    UIPageControl *page;
    NSTimer *timer,*restartTimer;
    NSTimer *inTimer;
}

@property (nonatomic,strong)NSMutableArray *arrayData;
@property (nonatomic,assign)BOOL isHave;

- (id)initWithFrame:(CGRect)frame;

- (void)stopTimer;

- (void)startTimer;

- (void)restartTimer;

@end
