//
//  LYPhotoGalleryViewController.m
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-3.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "LYPhotoGalleryViewController.h"
#import "LYPhotoPageViewController.h"
#import "LYPhotoViewController.h"
#import "LYPhotoItem.h"

@interface LYPhotoGalleryViewController () <RMPhotoPageViewControllerDelegate, UIActionSheetDelegate, RMPhotoPageViewControllerDataSource, RMPhotoPageViewControllerDelegate,RMPhotoViewControllerDelegate>

@property (nonatomic, strong) LYPhotoPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation LYPhotoGalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageViewController = [LYPhotoPageViewController viewController];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    self.pageViewController.view.frame = self.view.bounds;
    UIImage *image = [self.backButton imageForState:UIControlStateNormal];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setImage:image forState:UIControlStateNormal];
    self.backButton.tintColor = [UIColor whiteColor];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    [self addChildViewController:self.pageViewController];
    [self loadPageViewControllerData];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)loadPageViewControllerData
{
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.currentIndex + 1).stringValue,@(self.photoList.count).stringValue];
    [self.pageViewController setCurrentIndex:self.currentIndex scrollAnimation:EPhotoPageScrollAnimationDirectionAfter completion:nil];
}

- (IBAction)handleTapGesture
{
    self.topView.hidden = !self.topView.hidden;
}

- (IBAction)didTappedDeleteButton:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"删除照片"
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (IBAction)didTappedBackButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSMutableArray *photoList = [NSMutableArray arrayWithArray:self.photoList];
        [photoList removeObjectAtIndex:self.currentIndex];
        if (!photoList.count) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            self.photoList = photoList;
            [self.pageViewController deletePhotoViewControllerAtIndex:self.currentIndex scrollAnimation:EPhotoPageScrollAnimationDirectionAutomic completion:^(BOOL finished) {
                self.currentIndex = self.pageViewController.currentIndex;
                self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.currentIndex + 1).stringValue,@(self.photoList.count).stringValue];
            }];
        }
    }
}

#pragma mark -

- (NSUInteger)numberOfIndexInPhotoPageViewController:(LYPhotoPageViewController *)photoPageViewController
{
    return self.photoList.count;
}

- (RMPhotoViewController *)photoPageViewController:(LYPhotoPageViewController *)photoPageViewController atIndex:(NSUInteger)index
{
    LYPhotoItem *photoItem = self.photoList[index];
    RMPhotoViewController *photoViewController = [RMPhotoViewController viewControllerForimageURL:photoItem.largeURL placeholderImage:nil];
    photoViewController.delegate = self;
    [self.tapGestureRecognizer requireGestureRecognizerToFail:photoViewController.doubleTapRecognizer];
    return photoViewController;
}

#pragma mark-RMPhotoPageViewControllerDelegate

- (void)photoPageViewController:(LYPhotoPageViewController *)photoPageViewController didScorllToIndex:(NSUInteger)index
{
    self.indexLabel.text = [NSString stringWithFormat:@"%@/%@",@(index + 1).stringValue,@(self.photoList.count).stringValue];
    self.currentIndex = index;
}

- (CGFloat)originScaleOfImageSize:(CGSize)size
{
    return self.view.frame.size.width / size.width;
}

@end
