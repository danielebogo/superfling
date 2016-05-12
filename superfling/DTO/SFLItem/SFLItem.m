//
//  SFLItem.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLItem.h"


@implementation SFLItem

@dynamic itemId;
@dynamic imageId;
@dynamic userId;
@dynamic title;
@dynamic userName;

@synthesize imagePath;


+ (NSDictionary *)sfl_objectMapping
{
    return @{ @"itemId":@"ID",
              @"imageId":@"ImageID",
              @"title":@"Title",
              @"userId":@"UserID",
              @"userName":@"UserName" };
}


#pragma mark - Override getter / setter

- (nullable NSString *)imagePath
{
    return [NSString stringWithFormat:@"http://challenge.superfling.com/%@", self.imageId.stringValue];
}

@end
