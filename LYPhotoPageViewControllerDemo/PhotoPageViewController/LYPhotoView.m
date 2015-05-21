//
//  LYPhotoView.m
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-2.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "LYPhotoView.h"

@interface LYPhotoView () <UIScrollViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LYPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(self.frame, frame)) {
        [super setFrame:frame];
        [self adjustImageViewCenter];
    }
}

- (void)adjustImageViewCenter
{
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    frameToCenter.origin.x = (frameToCenter.size.width < boundsSize.width) ? (boundsSize.width - frameToCenter.size.width) / 2 : 0;
    frameToCenter.origin.y = (frameToCenter.size.height < boundsSize.height) ? (boundsSize.height - frameToCenter.size.height) / 2 : 0;
    self.imageView.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)setPhoto:(UIImage *)photo withScale:(CGFloat)scale
{
    [self.imageView removeFromSuperview];
    self.imageView = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, photo.size}];
    [self.imageView setImage:photo];
    self.contentSize = photo.size;
    [self addSubview:self.imageView];
    self.zoomScale = scale;
    self.contentOffset = CGPointMake(0, 0);
    [self adjustImageViewCenter];
}

- (void)setShouldSupportReSize:(BOOL)shouldSupportReSize
{
    if (shouldSupportReSize) {
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapRecognizer];
        self.doubleTapRecognizer = doubleTapRecognizer;
        self.delegate = self;
    } else {
        self.delegate = self;
    }
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    CGPoint location = [recognizer locationInView:self.imageView];
    CGFloat zoomScale = self.zoomScale;
    float newScale;
    if (zoomScale > self.minimumZoomScale) {
        newScale = self.minimumZoomScale;
    } else {
        newScale = self.maximumZoomScale;
    }
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / newScale;
    zoomRect.size.width = self.frame.size.width  / newScale;
    zoomRect.origin.x = location.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = location.y - (zoomRect.size.height / 2.0);
    [self zoomToRect:zoomRect animated:YES];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self adjustImageViewCenter];
}

@end
