//
//  LZAutoScrollView.m
//  LZAutoScrollView
//
//  Created by mac on 10/23/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "LZAutoScrollView.h"
#import <CommonCrypto/CommonDigest.h>

@interface LZLabel : UILabel

@property (nonatomic) UIEdgeInsets insets;

- (instancetype)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;
@end

@implementation LZLabel

- (instancetype)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self) {
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end

@interface NSString (MD5)

- (NSString *)md5;
@end

@implementation NSString (MD5)

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
        result[0], result[1], result[2], result[3],
        result[4], result[5], result[6], result[7],
        result[8], result[9], result[10], result[11],
        result[12], result[13], result[14], result[15]
        ];
}

@end

@interface LZAutoScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *previousImageView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) LZLabel *titleLabel;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSUInteger previousImageIndex;
@property (nonatomic, assign) NSUInteger currentImageIndex;
@property (nonatomic, assign) NSUInteger nextImageIndex;
@end

@implementation LZAutoScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.currentImageIndex = 0;
        self.interval = 3.0;
        self.pageControlAligment = PageControlAligmentRight;
    }
    return self;
}

- (void)createViews {
    NSAssert(self.images.count > 0, @"images must set.");
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame));
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    self.previousImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.scrollView addSubview:self.previousImageView];
    
    self.currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.currentImageView.userInteractionEnabled = YES;
    [self.currentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)]];
    [self.scrollView addSubview:self.currentImageView];
    
    self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)*2, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.scrollView addSubview:self.nextImageView];
    
    if(self.placeHolder) {
        self.previousImageView.image = self.placeHolder;
        self.currentImageView.image = self.placeHolder;
        self.nextImageView.image = self.placeHolder;
    }
    
    [self addSubview:self.scrollView];
    if(self.titles) {
        self.titleLabel = [[LZLabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-24, CGRectGetWidth(self.frame), 24) andInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        self.titleLabel.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:0.25];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:self.titleLabel];
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-20*self.images.count, CGRectGetHeight(self.frame)-24, 20*self.images.count, 24)];
    if(self.pageControlAligment == PageControlAligmentCenter) {
        self.pageControl.center = CGPointMake(self.center.x, self.pageControl.center.y);
    }
    self.pageControl.currentPage = self.currentImageIndex;
    self.pageControl.numberOfPages = self.images.count;
    [self addSubview:self.pageControl];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
    [self ajustImageViewContent];
    
}

- (NSUInteger)previousImageIndex {
    if(self.currentImageIndex == 0) {
        return self.images.count-1;
    }
    return self.currentImageIndex-1;
}


- (NSUInteger)nextImageIndex {
    if(self.currentImageIndex < (self.images.count-1)) {
        return self.currentImageIndex+1;
    }
    return 0;
}

- (void)ajustImageViewContent {
    [self loadImageWithURLString:self.images[self.previousImageIndex] andImageView:self.previousImageView];
    [self loadImageWithURLString:self.images[self.currentImageIndex] andImageView:self.currentImageView];
    [self loadImageWithURLString:self.images[self.nextImageIndex] andImageView:self.nextImageView];
    
    if(self.titles) {
        self.titleLabel.text = self.titles[self.currentImageIndex];
    }
    self.pageControl.currentPage = self.currentImageIndex;
}

- (void)autoScroll {
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame)*2, 0) animated:YES];
}

/**
 * 图片点击事件
 */
- (void)imageTap {
    if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(imageClicked:)]) {
        [self.delegate imageClicked:self.currentImageIndex];
    }
}

/**
 * 加载远程图片
 */
- (void)loadImageWithURLString:(NSString *)urlString andImageView:(UIImageView *)imageView {
    if(self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(loadImageWithURLString:andImageView:)]) {
        [self.delegate loadImageWithURLString:urlString andImageView:imageView];
        return;
    }
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dir = [path stringByAppendingPathComponent:@"autoScrollView"];
    
    BOOL isDir = FALSE;
    BOOL isDirExist = [manager fileExistsAtPath:dir isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        [manager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path2 = [path stringByAppendingString:[NSString stringWithFormat:@"%@", [urlString md5]]];
    NSData *data = [NSData dataWithContentsOfFile:path2];
    if(data != nil) {
        imageView.image = [UIImage imageWithData:data];
    }else {
        imageView.image = self.placeHolder;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            [data writeToFile:path2 atomically:YES];
        });
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int offset = floor(scrollView.contentOffset.x);
    if(offset == 0) {
        self.currentImageIndex = self.previousImageIndex;
    }else if(offset == CGRectGetWidth(scrollView.frame)*2) {
        self.currentImageIndex = self.nextImageIndex;
    }
    [self ajustImageViewContent];
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:NO];
    
    if(self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
