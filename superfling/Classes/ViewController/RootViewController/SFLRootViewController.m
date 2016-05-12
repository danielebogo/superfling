//
//  SFLRootViewController.m
//  superfling
//
//  Created by Daniele Bogo on 12/05/2016.
//  Copyright © 2016 Daniele Bogo. All rights reserved.
//

#import "SFLRootViewController.h"
#import "SFLContentManager.h"

#import "NSObject+ObjectValidation.h"

@interface SFLRootViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SFLContentManager *contentManager;
@property (nonatomic, strong) NSArray <SFLItem *>*items;

@end


@implementation SFLRootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _contentManager = [SFLContentManager newContentManagerWithNetworkBaseURLString:@"http://challenge.superfling.com/"];
    _items = [NSArray arrayWithArray:[_contentManager savedItems]];
    
    [self sfl_buildUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_items.count <= 0) {
        __weak typeof(self)weakSelf = self;
        
        [_contentManager fetchSaveItemsWithCompletionBlock:^(BOOL success, NSArray<SFLItem *> *items, NSError *error) {
            if (success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([items sfl_isValidObject]) {
                        weakSelf.items = [NSArray arrayWithArray:items];
                    } else {
                        weakSelf.items = [NSArray arrayWithArray:[weakSelf.contentManager savedItems]];
                    }
                    
                    NSLog(@"Items count %li", weakSelf.items.count);
                });
                
            } else {
                NSLog(@"Error %@", error);
            }
        }];
    }
}


#pragma mark - Private methods

- (void)sfl_buildUI
{
    self.navigationItem.title = @"SuperFling";
}

- (void)sfl_loadItems
{
    
}


@end
