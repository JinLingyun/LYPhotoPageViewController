//
//  ViewController.m
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-2.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "ViewController.h"
#import "LYPhotoItem.h"
#import "LYPhotoGalleryViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *photoList;

@end

@implementation ViewController

static NSString * const kSegueIdentifierPresentToPageGalleryViewController = @"SegueIdentifierPresentToPageGalleryViewController";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.photoList = [NSMutableArray array];
    LYPhotoItem *photoItem1 = [[LYPhotoItem alloc] init];
    photoItem1.largeURL = [NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/pic/item/0dd7912397dda144a30205bbb0b7d0a20cf486ab.jpg"];
    [self.photoList addObject:photoItem1];
    
    LYPhotoItem *photoItem2 = [[LYPhotoItem alloc] init];
    photoItem2.largeURL = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/b3119313b07eca806c0e50ee932397dda14483ab.jpg"];
    [self.photoList addObject:photoItem2];
    
    LYPhotoItem *photoItem3 = [[LYPhotoItem alloc] init];
    photoItem3.largeURL = [NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/342ac65c10385343ffc4ee289113b07eca8088ab.jpg"];
    [self.photoList addObject:photoItem3];
    
    LYPhotoItem *photoItem4 = [[LYPhotoItem alloc] init];
    photoItem4.largeURL = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/7aec54e736d12f2e401c1c694dc2d5628535689a.jpg"];
    [self.photoList addObject:photoItem4];
    
    LYPhotoItem *photoItem5 = [[LYPhotoItem alloc] init];
    photoItem5.largeURL = [NSURL URLWithString:@"http://a.hiphotos.baidu.com/image/pic/item/d8f9d72a6059252d1c07af0d369b033b5bb5b9a3.jpg"];
    [self.photoList addObject:photoItem5];
    
    LYPhotoItem *photoItem6 = [[LYPhotoItem alloc] init];
    photoItem6.largeURL = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/35a85edf8db1cb13f087ecabdc54564e93584b98.jpg"];
    [self.photoList addObject:photoItem6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueIdentifierPresentToPageGalleryViewController]) {
        LYPhotoGalleryViewController *viewController = segue.destinationViewController;
        viewController.photoList = self.photoList;
    }
}

@end
