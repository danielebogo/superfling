//
//  DBImage.m
//  DBImageView
//
//  Created by iBo on 25/08/14.
//  Copyright (c) 2014 Daniele Bogo. All rights reserved.
//

#import "DBImage.h"
#import "DBImageRequest.h"


@implementation DBImage


+ (instancetype)imageWithPath:(NSString *)path
{
    return [[DBImage alloc] initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self) {
        _imageURL = [NSURL URLWithString:path];
    }
    
    return self;
}


#pragma mark - Override Getter / Setter

- (DBImageRequest *)imageRequest
{
    return [[DBImageRequest alloc] initWithURLRequest:[NSURLRequest requestWithURL:self.imageURL]];
}


@end