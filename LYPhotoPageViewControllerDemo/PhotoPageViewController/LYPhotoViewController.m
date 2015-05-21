//
//  LYPhotoViewController.m
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-2.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "LYPhotoViewController.h"
#import "LYPhotoView.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"


static CGFloat minZoomScale = 1;
static CGFloat maxZoomScale = 2.5;

@interface RMPhotoViewController ()

@property (nonatomic, strong) LYPhotoView *scrollView;

@end

@implementation RMPhotoViewController

+ (instancetype)viewControllerForImage:(UIImage *)image
{
    RMPhotoViewController *photoViewController = [[self alloc] init];
    [photoViewController loadPhotoWithImage:image];
    photoViewController.shouldSupportReSize = YES;
    return photoViewController;
}

+ (instancetype)viewControllerForimageURL:(NSURL *)imageURL
                         placeholderImage:(UIImage *)image
{
    RMPhotoViewController *photoViewController = [[self alloc] init];
    [photoViewController loadPhotoWithImageURL:imageURL placeholderImage:image];
    photoViewController.shouldSupportReSize = YES;
    return photoViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = [[LYPhotoView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    |UIViewAutoresizingFlexibleWidth
    |UIViewAutoresizingFlexibleRightMargin
    |UIViewAutoresizingFlexibleTopMargin
    |UIViewAutoresizingFlexibleHeight
    |UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    MBProgressHUD *porgressView =  [[MBProgressHUD alloc] initWithView:self.scrollView];
    [self.view addSubview:self.progressView];
    porgressView.mode = MBProgressHUDModeAnnularDeterminate;
    self.progressView = porgressView;
    [porgressView show:YES];
}

- (void)setPhoto:(UIImage *)image
{
    self.progressView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(originScaleOfImageSize:)] && image) {
        self.photoOriginScale = [self.delegate originScaleOfImageSize:image.size];
    } else {
        self.photoOriginScale = 1.0;
    }
    self.image = image;
    [self.scrollView setPhoto:image withScale:self.photoOriginScale];
}

- (void)loadPhotoWithImage:(UIImage *)image
{
    self.loadingPhotoType = LoadingPhotoTypeImage;
    self.image = image;
    self.placeholderImage = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadPhotoData];
    });
}

- (void)loadPhotoWithImageURL:(NSURL *)imageURL
             placeholderImage:(UIImage *)placeholderImage
{
    self.loadingPhotoType = LoadingPhotoTypeURL;
    self.imageURL = imageURL;
    self.placeholderImage = placeholderImage;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadPhotoData];
    });
}

- (void)setPhotoOriginScale:(CGFloat)photoOriginScale
{
    if (self.shouldSupportReSize) {
        if (photoOriginScale > maxZoomScale) {
            self.scrollView.maximumZoomScale = photoOriginScale;
            self.scrollView.minimumZoomScale = minZoomScale;
        } else if (photoOriginScale < minZoomScale) {
            self.scrollView.minimumZoomScale = photoOriginScale;
            self.scrollView.maximumZoomScale = maxZoomScale;
        } else {
            self.scrollView.minimumZoomScale = minZoomScale;
            self.scrollView.maximumZoomScale = maxZoomScale;
        }
    } else {
        self.scrollView.minimumZoomScale = photoOriginScale;
        self.scrollView.maximumZoomScale = photoOriginScale;
    }
    _photoOriginScale = photoOriginScale;
}

- (void)loadPhotoData
{
    self.scrollView.zoomScale = self.photoOriginScale;
    if (self.loadingPhotoType == LoadingPhotoTypeImage) {
        [self setPhoto:self.image];
    } else {
        [self setPhoto:self.placeholderImage];
        [self loadPhotoAsynchronousWithURL:self.imageURL];
    }
}

- (void)loadPhotoAsynchronousWithURL:(NSURL *)photoURL
{
    if (!photoURL) {
        self.progressView.hidden = NO;
        return;
    }
    SDImageCache *imageCache = self.imageCache ? self.imageCache : [SDWebImageManager sharedManager].imageCache;
    NSString *imageKey = photoURL.absoluteString;
    __weak typeof(self) weakSelf = self;
    //
    UIImage *image = [imageCache imageFromMemoryCacheForKey:imageKey];
    if (image) {
        [self setPhoto:image];
    } else if ([imageCache diskImageExistsWithKey:imageKey]) { //否则查磁盘
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *theImage = [imageCache imageFromDiskCacheForKey:imageKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setPhoto:theImage];
            });
        });
    } else {
        //启动下载
        self.progressView.hidden = NO;
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:photoURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.progress = receivedSize / (double)expectedSize;
            });
        } completed:^(UIImage *theImage, NSData *data, NSError *error, BOOL finished) {
            if (!error) {
                [imageCache storeImage:theImage
                  recalculateFromImage:NO
                             imageData:data
                                forKey:imageKey
                                toDisk:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
                if (error) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.scrollView animated:YES];
                    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:weakSelf.scrollView];
                    [weakSelf.scrollView addSubview:hud];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"照片信息加载失败";
                    hud.labelFont = [UIFont boldSystemFontOfSize:18.0f];
                    hud.margin = 10.0f;
                    hud.yOffset = 0.0f;
                    hud.removeFromSuperViewOnHide = YES;
                    [hud show:YES];
                    [hud hide:YES afterDelay:0.8f];
                    return ;
                }
                [weakSelf setPhoto:theImage];
            });
        }];
    }
}

- (void)setProgressView:(UIView *)progressView
{
    [self.progressView removeFromSuperview];
    _progressView = progressView;
    [self.view addSubview:progressView];
}

- (void)showProgressView
{
    self.progressView.hidden = YES;
}

- (void)setProgress:(CGFloat)progress
{
    ((MBProgressHUD *)self.progressView).progress = progress;
}

- (void)setShouldSupportReSize:(BOOL)shouldSupportReSize
{
    _shouldSupportReSize = shouldSupportReSize;
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setShouldSupportReSize:shouldSupportReSize];
    self.doubleTapRecognizer = self.scrollView.doubleTapRecognizer;
}

@end
