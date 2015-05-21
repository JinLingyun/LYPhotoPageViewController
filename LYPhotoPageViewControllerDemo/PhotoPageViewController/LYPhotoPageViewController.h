//
//  LYPhotoPageViewController.h
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-2.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LYPhotoViewController.h"

typedef NS_ENUM(NSUInteger, EPhotoPageScrollAnimationDirection) {
    EPhotoPageScrollAnimationDirectionNone = 0,
    EPhotoPageScrollAnimationDirectionBefore = 1,
    EPhotoPageScrollAnimationDirectionAfter = 2,
    EPhotoPageScrollAnimationDirectionAutomic = 3,
};

@class LYPhotoPageViewController;

@protocol RMPhotoPageViewControllerDelegate <NSObject>

@optional

- (void)photoPageViewController:(LYPhotoPageViewController *)photoPageViewController
              willScorllToIndex:(NSUInteger)index;
- (void)photoPageViewController:(LYPhotoPageViewController *)photoPageViewController
               didScorllToIndex:(NSUInteger)index;
@end

@protocol RMPhotoPageViewControllerDataSource <NSObject>

@required
- (NSUInteger)numberOfIndexInPhotoPageViewController:(LYPhotoPageViewController *)photoPageViewController;
- (RMPhotoViewController *)photoPageViewController:(LYPhotoPageViewController *)photoPageViewController
                                           atIndex:(NSUInteger)index;
@end


@interface LYPhotoPageViewController : UIViewController

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, weak) id<RMPhotoPageViewControllerDelegate> delegate;
@property (nonatomic, weak) id<RMPhotoPageViewControllerDataSource> dataSource;

+ (instancetype)viewController;

- (void)reloadData;

- (NSUInteger)numberOfIndex;

- (void)setCurrentIndex:(NSUInteger)currentIndex
        scrollAnimation:(EPhotoPageScrollAnimationDirection)animation
             completion:(void (^)(BOOL finished))completion;

- (void)deletePhotoViewControllerAtIndex:(NSUInteger)index
                         scrollAnimation:(EPhotoPageScrollAnimationDirection)animation
                              completion:(void (^)(BOOL finished))completion;

- (RMPhotoViewController *)photoViewControllerWithIndex:(NSUInteger)index;

@end
