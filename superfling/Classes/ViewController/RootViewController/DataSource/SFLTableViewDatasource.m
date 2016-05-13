//
//  SFLTableViewDatasource.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLTableViewDatasource.h"
#import "SFLItem.h"
#import "SFLTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface SFLTableViewDatasource () <SDWebImageManagerDelegate>

@end

@implementation SFLTableViewDatasource


#pragma mark - UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SFLTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell setTitle:self.items[indexPath.row].title userName:self.items[indexPath.row].userName];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.items[indexPath.row].imagePath]
                                placeholderImage:nil
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                                       }];
    
    return cell;
}

- (UIImage *)resizeImage:(UIImage *)image withMaxDimension:(CGFloat)maxDimension
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
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect:newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    return [self resizeImage:image withMaxDimension:640.0];
}

@end
