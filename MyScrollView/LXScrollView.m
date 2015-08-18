//
//  MyScrollView.m
//
//
//  Created by 刘东旭 on 15/4/16.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "LXScrollView.h"
#import "UIImageView+WebCache.h"

@implementation LXScrollView

/*
 使用时需要在控制器中viewwillapear方法中设置automaticallyAdjustsScrollViewInsets = NO;防止偏移量有问题
 */

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self viewController].automaticallyAdjustsScrollViewInsets = NO;
    [self addNotificationEnterBack];
    [self addNotificationEnterApp];
    k=1;
    return self;
}

- (void)setArrayData:(NSMutableArray *)arrayData{
    _arrayData = arrayData;
//    [self removeFromSuperview];
    if (self.isHave) {
        
    }else{
        [self createUI];
        [self createPage];
    }
    [self setNeedsLayout];
}

- (void)createUI{
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentSize = CGSizeMake(self.frame.size.width*(self.arrayData.count+2), 0);
    self.pagingEnabled = YES;
    [[SDImageCache sharedImageCache] clearDisk];
    for (int i=0; i<self.arrayData.count+2; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        
        if (i==0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.arrayData lastObject]]];
        }else if (i==self.arrayData.count+1){
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.arrayData firstObject]]];
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.arrayData[i-1]]];
        }
        
        [self addSubview:imageView];
    }
    
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
//    启动定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startAction:) userInfo:nil repeats:YES];
    self.isHave = YES;
}
//在此修改page的位置
- (void)createPage{
    page = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-30*self.arrayData.count)/2, self.frame.origin.y+self.frame.size.height-30, 30*self.arrayData.count, 30)];
    page.numberOfPages = self.arrayData.count;
    page.backgroundColor = [UIColor redColor];
    [self.superview addSubview:page];
}

#pragma mark- 轮播图的协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView.tag==1000) {
        if(scrollView.contentOffset.x==0){
            page.currentPage = page.numberOfPages+1;
            k=_arrayData.count;
            scrollView.contentOffset = CGPointMake(self.frame.size.width*(page.numberOfPages), 0);
        }else if(scrollView.contentOffset.x/self.frame.size.width==page.numberOfPages+1){
            page.currentPage = 0;
            k=1;
            scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        }else{
            page.currentPage = (scrollView.contentOffset.x-self.frame.size.width)/self.frame.size.width;
            k=page.currentPage+1;
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        }
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [inTimer invalidate];
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [self startTimer];
    inTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}

- (void)startAction:(NSTimer*)timer{
    k++;
    if (k>self.arrayData.count) {
        [self setContentOffset:CGPointMake(self.frame.size.width*k, 0) animated:YES];
        self.contentOffset = CGPointMake(0, 0);
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        k=1;
        page.currentPage = 0;
    }else{
        [self setContentOffset:CGPointMake(k*self.frame.size.width, 0) animated:YES];
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        page.currentPage = k-1;
    }
    NSLog(@"%ld",k);
}

- (UIViewController *)viewController {
    
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}

- (void)stopTimer{
    [timer setFireDate:[NSDate distantFuture]];
    if (restartTimer.valid) {
        [restartTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)startTimer{
    [timer setFireDate:[NSDate distantPast]];
    if (restartTimer.valid) {
        [restartTimer setFireDate:[NSDate distantPast]];
    }
}

- (void)restartTimer{
    restartTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
}

//添加通知
- (void)addNotificationEnterBack{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopTimer)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)enterBack{
    if (!self.hidden) {
        [self stopTimer];
        [self addNotificationEnterApp];
        [self removeNotificationEnterBack];
    }else{
        [self addNotificationEnterApp];
        [self removeNotificationEnterBack];
    }
    
}

- (void)addNotificationEnterApp{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restartTimer)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)enterApp{
    if(self.hidden){
        [self restartTimer];
        [self addNotificationEnterBack];
        [self removeNotificationEnterApp];
    }else{
        [self addNotificationEnterBack];
        [self removeNotificationEnterApp];
    }
    
}

//移除通知
- (void)removeNotificationEnterBack{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)removeNotificationEnterApp{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
