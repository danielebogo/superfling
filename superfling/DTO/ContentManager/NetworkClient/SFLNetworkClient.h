//
//  SFLNetworkClient.h
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

@import Foundation;

@interface SFLNetworkClient : NSObject

- (instancetype)initWithBaseURL:(NSString *)baseURL;

- (void)loadItemsWithCompletionBlock:(void(^)(NSArray <NSDictionary *>*items, NSError *error))completionBlock;

@end
