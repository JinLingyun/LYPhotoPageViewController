//
//  LYPhotoView.h
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-2.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPhotoView : UIScrollView

@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, assign) BOOL shouldSupportReSize;

- (void)setPhoto:(UIImage *)photo withScale:(CGFloat)scale;

@end
