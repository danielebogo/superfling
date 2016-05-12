//
//  SFLDataAccessObject+Item.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLDataAccessObject+Item.h"

#import "SFLItem.h"

#import <MagicalRecord/MagicalRecord.h>


@implementation SFLDataAccessObject (Item)

- (NSArray <SFLItem *>*)sfl_fetchSavedItems
{
    return [SFLItem MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
}

- (void)sfl_createEntitiesFromArray:(NSArray <NSDictionary *>*)items
                    completionBlock:(void(^)(BOOL success))completionBlock
{
    __block BOOL success = YES;
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    dispatch_group_enter(serviceGroup);
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        [items enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SFLItem *item = [SFLItem MR_createEntityInContext:localContext];
            [item sfl_setData:obj];
        }];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        dispatch_group_leave(serviceGroup);
        
        if (error) {
            success = NO;
        }
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        
        if (completionBlock != NULL) {
            completionBlock(success);
        }
    });
}

@end
