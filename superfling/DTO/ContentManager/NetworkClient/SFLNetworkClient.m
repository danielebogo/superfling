//
//  SFLNetworkClient.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLNetworkClient.h"

#import "NSObject+ObjectValidation.h"


@interface SFLNetworkClient ()

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation SFLNetworkClient {
    NSURL *clientURL_;
}


- (instancetype)initWithBaseURL:(NSString *)baseURL
{
    self = [super init];
    if (self) {
        clientURL_ = [NSURL URLWithString:[baseURL copy]];
    }
    return self;
}


#pragma mark - Public methods

- (void)loadItemsWithCompletionBlock:(void(^)(NSArray <NSDictionary *>*items, NSError *error))completionBlock
{
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:clientURL_
            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                weakSelf.isLoading = NO;
                
                if (!error) {
                    NSError *jsonError;
                    NSArray *filesJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

                    if (!jsonError && [filesJSON sfl_isValidObject]) {
                        if (completionBlock) {
                            completionBlock(filesJSON, nil);
                        }
                    }
                } else {
                    if (completionBlock) {
                        completionBlock(nil, error);
                    }
                }
            }] resume];
}


@end
