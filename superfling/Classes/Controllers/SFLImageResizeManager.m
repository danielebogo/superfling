//
//  SFLImageResizeManager.m
//  superfling
//
//  Created by Daniele Bogo on 13/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLImageResizeManager.h"


@implementation SFLImageResizeManager


- (instancetype)initWithMaxSize:(CGFloat)maxSize
{
    self = [super init];
    if (self) {
        _maxSize = maxSize;
    }
    return self;
}


#pragma mark - Private methods

- (UIImage *)sfl_resizeImage:(UIImage *)image withMaxDimension:(CGFloat)maxDimension
{
    if (fmax(image.size.width, image.size.height) <= maxDimension) {
        return image;
    }
    
    CGFloat aspect = image.size.width / image.size.height;
    CGSize newSize;
    
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(maxDimension, maxDimension / aspect);
    } else {
        newSize = CGSizeMake(maxDimension * aspect, maxDimension);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect:newImageRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - SDWebImageManagerDelegate

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    return [self sfl_resizeImage:image withMaxDimension:_maxSize];
}


@end
