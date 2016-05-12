//
//  NSObject+ModelMapping.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "NSObject+ModelMapping.h"


@implementation NSObject (ModelMapping)

+ (NSDictionary *)sfl_objectMapping
{
    return nil;
}

- (instancetype)sfl_setData:(NSDictionary *)dictionary
{
    [[self.class sfl_objectMapping] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if (dictionary[value] && [self respondsToSelector:NSSelectorFromString(key)]) {
            [self setValue:dictionary[value] forKey:key];
        }
    }];
    
    return self;
}

- (NSDictionary *)sfl_inverseMapping
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [[self.class sfl_objectMapping] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([self valueForKey:key] && [self respondsToSelector:NSSelectorFromString(key)]) {
            [dictionary setValue:[self valueForKey:key] forKey:value];
        }
    }];
    
    return [dictionary copy];
}

@end