//
//  LYPhotoViewController.h
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-2.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDImageCache;

typedef enum {
    LoadingPhotoTypeImage = 0,
    LoadingPhotoTypeURL
}LoadingPhotoTypeEnum;

typedef enum {
    progressViewTypeCustom = 0
}LoadingProgressViewType;

@protocol RMPhotoViewControllerDelegate <NSObject>

- (CGFloat)originScaleOfImageSize:(CGSize)size;

@end

@interface RMPhotoViewController : UIViewController

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;

@property (nonatomic, assign) BOOL shouldSupportReSize;
@property (nonatomic, assign) LoadingPhotoTypeEnum loadingPhotoType;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGFloat photoOriginScale;
@property (nonatomic, weak) id<RMPhotoViewControllerDelegate> delegate;
@property (nonatomic, strong) SDImageCache *imageCache;

/* 子类可以更改这个View，自定义progressView，自定义后，必须重写，
 setProgress:(CGFloat)progress 方法， 并且不能调用父类方法*/

+ (instancetype)viewControllerForImage:(UIImage *)image;
+ (instancetype)viewControllerForimageURL:(NSURL *)imageURL
                         placeholderImage:(UIImage *)image;

- (void)setProgress:(CGFloat)progress;
- (void)loadPhotoWithImage:(UIImage *)image;
- (void)loadPhotoWithImageURL:(NSURL *)imageURL
             placeholderImage:(UIImage *)placeholderImage;


@end
