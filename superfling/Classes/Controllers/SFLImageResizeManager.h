//
//  SFLImageResizeManager.h
//  superfling
//
//  Created by Daniele Bogo on 13/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

@import UIKit;

#import <SDWebImage/UIImageView+WebCache.h>


@interface SFLImageResizeManager : NSObject <SDWebImageManagerDelegate>

@property (nonatomic, assign) CGFloat maxSize;

- (instancetype)initWithMaxSize:(CGFloat)maxSize;

@end
