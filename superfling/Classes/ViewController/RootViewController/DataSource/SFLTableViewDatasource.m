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
#import "SFLImageResizeManager.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface SFLTableViewDatasource () <SDWebImageManagerDelegate>

@property (nonatomic, strong) SFLImageResizeManager *imageResizeManager;

@end

@implementation SFLTableViewDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageResizeManager = [SFLImageResizeManager new];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        manager.delegate = _imageResizeManager;
    }
    return self;
}


#pragma mark - UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.imageResizeManager.maxSize = CGRectGetWidth(tableView.frame);
    
    SFLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SFLTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell setTitle:self.items[indexPath.row].title userName:self.items[indexPath.row].userName];
    
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.items[indexPath.row].imagePath]
                                placeholderImage:nil
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                                       }];
    
    return cell;
}


@end
