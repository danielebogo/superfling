//
//  SFLDataAccessObject+Item.h
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

@import Foundation;

#import "SFLDataAccessObject.h"
#import "SFLItem.h"


@interface SFLDataAccessObject (Item)

- (NSArray <SFLItem *>*)sfl_fetchSavedItems;
- (void)sfl_createEntitiesFromArray:(NSArray <NSDictionary *>*)items
                    completionBlock:(void(^)(BOOL success))completionBlock;

@end
