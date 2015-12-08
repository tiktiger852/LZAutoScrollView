//
//  ViewController.m
//  LZAutoScrollView
//
//  Created by mac on 10/23/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "ViewController.h"
#import "LZAutoScrollView.h"

@interface ViewController ()<LZAutoScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LZAutoScrollView *autoScrollView = [[LZAutoScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 150)];
    autoScrollView.delegate = self;
    autoScrollView.titles = @[@"一", @"二", @"三"];
    autoScrollView.placeHolder = [UIImage imageNamed:@"place.jpg"];
    autoScrollView.pageControlAligment = PageControlAligmentCenter;
    autoScrollView.images = @[
                              @"http://img2.3lian.com/2014/f7/5/d/22.jpg",
                              @"http://image.tianjimedia.com/uploadImages/2011/327/1VPRY46Q4GB7.jpg",
                              @"http://img6.faloo.com/Picture/0x0/0/747/747488.jpg"
                              ];
     
    autoScrollView.itemClicked = ^(int index) {
        NSLog(@"index: %d", index);
    };
    [self.view addSubview:autoScrollView];
}

- (void)imageClicked:(NSInteger)index {
    NSLog(@"index: %ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
