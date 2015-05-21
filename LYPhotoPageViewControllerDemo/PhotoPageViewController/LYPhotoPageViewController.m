//
//  LYPhotoPageViewController.m
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-2.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "LYPhotoPageViewController.h"
#import "LYPhotoViewController.h"

@interface LYPhotoPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, weak) UIViewController *beforeViewController;
@property (nonatomic, weak) UIViewController *afterViewController;
@property (nonatomic, assign) NSUInteger totoNumberOfIndex;

@end

@implementation LYPhotoPageViewController

+ (instancetype)viewController
{
    LYPhotoPageViewController *viewController = [[LYPhotoPageViewController alloc] init];
    return viewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfIndex
{
    return self.totoNumberOfIndex;
}

- (void)reloadData
{
    self.totoNumberOfIndex = [self.dataSource numberOfIndexInPhotoPageViewController:self];
    [self loadPageViewControllerWithIndex:self.currentIndex
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:YES
                               completion:nil];
}

- (UIPageViewController *)creatPageViewController
{
    UIPageViewController *pageViewController =
    [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@(20)}];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    [pageViewController.view setFrame:self.view.bounds];
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    return pageViewController;
}

- (void)loadPageViewControllerWithIndex:(NSUInteger)index
                              direction:(UIPageViewControllerNavigationDirection)direction
                               animated:(BOOL)animated
                             completion:(void (^)(BOOL finished))completion
{
    NSArray *array = nil;
    if (self.totoNumberOfIndex) {
        if (index >= self.totoNumberOfIndex) {
            index = self.totoNumberOfIndex - 1;
        }
        array = @[[self.dataSource photoPageViewController:self atIndex:index]];
        _currentIndex = index;
    }
    [self loadPageViewControllerViewController:array
                                     direction:direction
                                      animated:animated
                                    completion:completion];
}

- (void)loadPageViewControllerViewController:(NSArray *)viewControllers
                                   direction:(UIPageViewControllerNavigationDirection)direction
                                    animated:(BOOL)animated
                                  completion:(void (^)(BOOL finished))completion
{
    self.beforeViewController = nil;
    self.afterViewController = nil;
    if (viewControllers) {
        if (!self.pageViewController) {
            self.pageViewController = [self creatPageViewController];
        }
        [self.pageViewController setViewControllers:viewControllers
                                          direction:direction
                                           animated:animated
                                         completion:completion];
    } else {
        [self.pageViewController.view removeFromSuperview];
        self.pageViewController = nil;
    }
}

- (RMPhotoViewController *)photoViewControllerWithIndex:(NSUInteger)index
{
    if (index == self.currentIndex) {
        return [self.pageViewController.viewControllers firstObject];
    } else if (index == self.currentIndex - 1) {
        return (RMPhotoViewController *)self.beforeViewController;
    } else if (index == self.currentIndex + 1){
        return (RMPhotoViewController *)self.afterViewController;
    }
    return nil;
}

- (void)deletePhotoViewControllerAtIndex:(NSUInteger)index
                         scrollAnimation:(EPhotoPageScrollAnimationDirection)animation
                              completion:(void (^)(BOOL finished))completion
{
    if (index >= self.totoNumberOfIndex) {
        return;
    }
    NSUInteger totoNumber = [self.dataSource numberOfIndexInPhotoPageViewController:self];
    NSAssert(totoNumber < self.totoNumberOfIndex, @"delete error");
    self.totoNumberOfIndex = totoNumber;
    if (self.totoNumberOfIndex == 0) {
        [self loadPageViewControllerWithIndex:self.currentIndex
                                    direction:UIPageViewControllerNavigationDirectionForward
                                     animated:YES
                                   completion:completion];
    } else {
        ///index 计算 和viewcontroller 选取
        UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
        UIViewController *viewController = [self.pageViewController.viewControllers firstObject];
        
        if (self.currentIndex == index) {
            if (self.currentIndex >= self.totoNumberOfIndex) {
                _currentIndex = self.totoNumberOfIndex - 1;
                viewController = self.beforeViewController ?
                self.beforeViewController : [self.dataSource photoPageViewController:self atIndex:self.currentIndex];
                direction = UIPageViewControllerNavigationDirectionReverse;
            } else {
                viewController = self.afterViewController ?
                self.afterViewController : [self.dataSource photoPageViewController:self atIndex:self.currentIndex];
            }
        } else if (self.currentIndex > index) {
            _currentIndex--;
        }

        if (animation != EPhotoPageScrollAnimationDirectionAutomic) {
            direction = [self directionFor:animation];
        }
        [self loadPageViewControllerViewController:viewController ? @[viewController] : nil
                                         direction:direction
                                          animated:animation
                                        completion:completion];
    }
}

- (UIPageViewControllerNavigationDirection)directionFor:(EPhotoPageScrollAnimationDirection)animationDirection
{
    switch (animationDirection) {
        case EPhotoPageScrollAnimationDirectionAfter:
            return UIPageViewControllerNavigationDirectionForward;
            break;
        case EPhotoPageScrollAnimationDirectionBefore:
            return UIPageViewControllerNavigationDirectionReverse;
            break;
        default:
            return UIPageViewControllerNavigationDirectionForward;
            break;
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    [self setCurrentIndex:currentIndex
          scrollAnimation:EPhotoPageScrollAnimationDirectionNone
               completion:nil];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
        scrollAnimation:(EPhotoPageScrollAnimationDirection)animation
             completion:(void (^)(BOOL finished))completion
{
    self.totoNumberOfIndex = [self.dataSource numberOfIndexInPhotoPageViewController:self];
    if (currentIndex >= self.totoNumberOfIndex) {
        return;
    }
    UIViewController *viewController;
    if (self.pageViewController.viewControllers.count) {
        if (self.currentIndex == currentIndex) {
            viewController = [self.pageViewController.viewControllers firstObject];
        } else if (self.currentIndex + 1 == currentIndex) {
            viewController = self.afterViewController ? self.afterViewController : [self.dataSource photoPageViewController:self atIndex:currentIndex];
        } else if (self.currentIndex - 1 == currentIndex) {
            viewController = self.beforeViewController ? self.beforeViewController : [self.dataSource photoPageViewController:self atIndex:currentIndex];
        }
    } else {
        viewController = [self.dataSource photoPageViewController:self atIndex:currentIndex];
    }
    [self loadPageViewControllerWithIndex:currentIndex
                                direction:[self directionFor:animation]
                                 animated:animation == EPhotoPageScrollAnimationDirectionNone ? NO : YES
                               completion:completion];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = self.currentIndex;
    if (index == NSNotFound || index - 1 < 0) {
        self.beforeViewController = nil;
        return nil;
    }
    index--;
    self.beforeViewController = [self.dataSource photoPageViewController:self atIndex:index];
    return self.beforeViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = self.currentIndex;
    if (index == NSNotFound || index + 1 >= self.totoNumberOfIndex) {
        self.afterViewController = nil;
        return nil;
    }
    index++;
    self.afterViewController = [self.dataSource photoPageViewController:self atIndex:index];
    return self.afterViewController;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    RMPhotoViewController *pendingViewContrller = [pendingViewControllers firstObject];
    NSUInteger index = 0;
    if (self.beforeViewController == pendingViewContrller) {
        index = self.currentIndex - 1;
    } else if (self.afterViewController == pendingViewContrller) {
        index = self.currentIndex + 1;
    }
    
    if ([self.delegate respondsToSelector:@selector(photoPageViewController:willScorllToIndex:)]) {
        [self.delegate photoPageViewController:self willScorllToIndex:index];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    RMPhotoViewController *previousViewContrller = [previousViewControllers firstObject];
    RMPhotoViewController *viewController = [self.pageViewController.viewControllers firstObject];
    NSUInteger previousIndex;
    previousIndex = self.currentIndex;
    if (self.beforeViewController == viewController) {
        _currentIndex--;
        self.afterViewController = previousViewContrller;
    } else if (self.afterViewController == viewController) {
        _currentIndex++;
        self.beforeViewController = previousViewContrller;
    }
    
    if ([self.delegate respondsToSelector:@selector(photoPageViewController:didScorllToIndex:)]) {
        [self.delegate photoPageViewController:self didScorllToIndex:self.currentIndex];
    }
}

@end
