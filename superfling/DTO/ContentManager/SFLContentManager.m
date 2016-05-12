//
//  SFLContentManager.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLContentManager.h"
#import "SFLNetworkClient.h"

#import "SFLDataAccessObject+Item.h"
#import "NSObject+ObjectValidation.h"


@interface SFLContentManager ()

@property (nonatomic, strong) SFLDataAccessObject *dataAccessObject;
@property (nonatomic, strong) SFLNetworkClient *client;

@end

@implementation SFLContentManager

+ (instancetype)newContentManagerWithNetworkBaseURLString:(NSString *)baseURLString
{
    SFLContentManager *contentManager = [SFLContentManager new];
    contentManager.dataAccessObject = [SFLDataAccessObject new];
    contentManager.client = [[SFLNetworkClient alloc] initWithBaseURL:baseURLString];
    return contentManager;
}


#pragma mark - Public methods

- (NSArray <SFLItem *>*)savedItems
{
    return [self.dataAccessObject sfl_fetchSavedItems];
}

- (void)fetchSaveItemsWithCompletionBlock:(void(^)(BOOL success, NSArray <SFLItem *>*items, NSError *error))completionBlock
{
    NSArray <SFLItem *>*items = [self savedItems];
    
    if ([items sfl_isValidObject] && items.count > 0) {
        completionBlock(YES, items, nil);
    } else {
        __weak typeof(self)weakSelf = self;
        
        [self.client loadItemsWithCompletionBlock:^(NSArray<NSDictionary *> *items, NSError *error) {
            if (error) {
                completionBlock(NO, nil, error);
            } else {
                [weakSelf.dataAccessObject sfl_createEntitiesFromArray:items completionBlock:^(BOOL success) {
                    if (success) {
                        completionBlock(YES, nil, nil);
                    } else {
                        completionBlock(NO, nil, nil);
                    }
                }];
            }
        }];
    }
}


@end
