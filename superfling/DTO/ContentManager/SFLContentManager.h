//
//  SFLContentManager.h
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

@import Foundation;

#import "SFLItem.h"


@interface SFLContentManager : NSObject

+ (instancetype)newContentManagerWithNetworkBaseURLString:(NSString *)baseURLString;

- (NSArray <SFLItem *>*)savedItems;
- (void)fetchSaveItemsWithCompletionBlock:(void(^)(BOOL success, NSArray <SFLItem *>*items, NSError *error))completionBlock;

@end
