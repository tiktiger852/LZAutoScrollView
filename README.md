# LZAutoScrollView
![](https://github.com/00o0o/LZAutoScrollView/blob/master/2015-10-27%2012_50_51.gif)


使用说明：
LZAutoScrollView *autoScrollView = [[LZAutoScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 150)];
autoScrollView.delegate = self;
autoScrollView.titles = @[@"一", @"二", @"三"];
autoScrollView.images = @[
                          @"http://img2.3lian.com/2014/f7/5/d/22.jpg",
                          @"http://image.tianjimedia.com/uploadImages/2011/327/1VPRY46Q4GB7.jpg",
                          @"http://img6.faloo.com/Picture/0x0/0/747/747488.jpg"
                          ];
autoScrollView.placeHolder = [UIImage imageNamed:@"place.jpg"]; //图片占位
[autoScrollView createViews];
[self.view addSubview:autoScrollView];

如需自己实现图片加载 和图片点击事件 只要实现LZAutoScrollViewDelegate 里面的 imageClicked:(NSInteger)index方法 和 loadImageWithURLString:(NSString *)urlString andImageView:(UIImageView *)imageView; 就可以了
