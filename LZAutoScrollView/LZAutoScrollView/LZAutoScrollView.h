//
//  LZAutoScrollView.h
//  LZAutoScrollView
//
//  Created by mac on 10/23/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageControlAligment) {
    PageControlAligmentCenter = 0,
    PageControlAligmentRight = 1
};

typedef void(^LoadImageBlock)(NSString *urlString, UIImageView *imageView);
typedef void(^ItemClicked)(int index);

@interface LZAutoScrollView : UIView

@property (nonatomic, strong) NSArray *images; /**<图片*/
@property (nonatomic, strong) UIImage *placeHolder; /**<占位图片*/
@property (nonatomic, strong) NSArray *titles; /**<标题*/

@property (nonatomic, assign) NSTimeInterval interval; /**<间隔时间*/
@property (nonatomic, assign) PageControlAligment pageControlAligment; /**<PageControl位置*/
@property (nonatomic, strong) ItemClicked itemClicked; /**<当前图片点击block*/

@end
