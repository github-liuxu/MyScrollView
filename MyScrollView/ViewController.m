//
//  ViewController.m
//  LXScrollView
//
//  Created by leyikao on 15/8/17.
//  Copyright (c) 2015年 leyikao. All rights reserved.
//

#import "ViewController.h"
#import "LXScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    
    LXScrollView *myScrollview = [[LXScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    myScrollview.arrayData = @[@"http://pic1.ooopic.com/uploadfilepic/sheji/2009-08-12/OOOPIC_SHIJUNHONG_2009081248f16747c1659ceb.jpg",@"http://pic1.nipic.com/2008-11-03/200811393332267_2.jpg",@"http://img1.3lian.com/img2008/06/019/13.jpg"];
    [bgView addSubview:myScrollview];
    [self.view addSubview:bgView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
