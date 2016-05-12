//
//  NSObject+ObjectValidation.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.


#import "NSObject+ObjectValidation.h"


@implementation NSObject (ObjectValidation)

- (BOOL)sfl_isValidObject
{
    return (self && ![self isEqual:[NSNull null]] && [self isKindOfClass:[NSObject class]]);
}

- (BOOL)sfl_isValidString
{
    return ([self sfl_isValidObject] && [self isKindOfClass:[NSString class]] && ![(NSString *)self isEqualToString:@""]);
}

@end