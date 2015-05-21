//
//  LYPhotoItem.h
//  LYPhotoPageViewControllerDemo
//
//  Created by Jin Lingyun on 15-3-3.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYPhotoItem : NSObject

@property (nonatomic, copy) NSNumber *photoID;
@property (nonatomic, copy) NSURL *tinyURL;
@property (nonatomic, copy) NSURL *headURL;
@property (nonatomic, copy) NSURL *mainURL;
@property (nonatomic, copy) NSURL *largeURL;

@end
