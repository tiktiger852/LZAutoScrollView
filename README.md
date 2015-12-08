# LZAutoScrollView
![](https://github.com/00o0o/LZAutoScrollView/blob/master/2015-10-27%2017_28_23.gif)


使用说明：
<pre><code>
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
</code></pre>
